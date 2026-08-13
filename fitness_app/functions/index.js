const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");

const FATSECRET_CLIENT_ID = defineSecret("FATSECRET_CLIENT_ID");
const FATSECRET_CLIENT_SECRET = defineSecret("FATSECRET_CLIENT_SECRET");
const USDA_API_KEY = defineSecret("USDA_API_KEY");
const API_NINJAS_KEY = defineSecret("API_NINJAS_KEY");

//
// ============================================================
// FOOD SEARCH
// ============================================================
//

exports.searchFood = onRequest(
    {
        region: "europe-west1",
        secrets: [
            FATSECRET_CLIENT_ID,
            FATSECRET_CLIENT_SECRET,
            USDA_API_KEY,
        ],
    },
    async (req, res) => {
        res.set("Access-Control-Allow-Origin", "*");

        if (req.method === "OPTIONS") {
            res.set("Access-Control-Allow-Methods", "GET");
            res.set("Access-Control-Allow-Headers", "Content-Type");
            return res.status(204).send("");
        }

        try {
            const query = (req.query.q || "").toString().trim();

            if (query.length < 2) {
                return res.status(400).json({
                    error: "Query must contain at least 2 characters.",
                });
            }

            const [fatSecretFoods, usdaFoods, openFoodFactsFoods] =
                await Promise.all([
                    searchFatSecret(query),
                    searchUsda(query),
                    searchOpenFoodFacts(query),
                ]);

            const combined = [
                ...fatSecretFoods,
                ...usdaFoods,
                ...openFoodFactsFoods,
            ];

            const uniqueFoods = removeDuplicates(combined);

            return res.json({
                query,
                count: uniqueFoods.length,
                sources: {
                    fatSecret: fatSecretFoods.length,
                    usda: usdaFoods.length,
                    openFoodFacts: openFoodFactsFoods.length,
                },
                foods: uniqueFoods,
            });
        } catch (error) {
            console.error("searchFood error:", error);

            return res.status(500).json({
                error: "Unexpected server error.",
            });
        }
    }
);

//
// ============================================================
// WORKOUT / ACTIVITY SEARCH
// ============================================================
//

exports.searchActivities = onRequest(
    {
        region: "europe-west1",
        secrets: [API_NINJAS_KEY],
    },
    async (req, res) => {
        res.set("Access-Control-Allow-Origin", "*");

        if (req.method === "OPTIONS") {
            res.set("Access-Control-Allow-Methods", "GET");
            res.set("Access-Control-Allow-Headers", "Content-Type");
            return res.status(204).send("");
        }

        try {
            const activity = (req.query.activity || "")
                .toString()
                .trim();

            const weightKg = Number(req.query.weightKg || 70);
            const durationMinutes = Number(
                req.query.durationMinutes || 60
            );

            if (activity.length < 2) {
                return res.status(400).json({
                    error: "Activity must contain at least 2 characters.",
                });
            }

            if (!Number.isFinite(weightKg) || weightKg <= 0) {
                return res.status(400).json({
                    error: "Invalid weight.",
                });
            }

            if (
                !Number.isFinite(durationMinutes) ||
                durationMinutes <= 0
            ) {
                return res.status(400).json({
                    error: "Invalid duration.",
                });
            }

            const apiKey = API_NINJAS_KEY.value();

            if (!apiKey) {
                return res.status(500).json({
                    error: "API Ninjas key missing.",
                });
            }

            const url = new URL(
                "https://api.api-ninjas.com/v1/caloriesburned"
            );

            url.searchParams.set("activity", activity);
            url.searchParams.set("weight", weightKg.toString());
            url.searchParams.set(
                "duration",
                durationMinutes.toString()
            );

            const response = await fetch(url, {
                headers: {
                    "X-Api-Key": apiKey,
                },
            });

            if (!response.ok) {
                const errorText = await response.text();

                console.error(
                    "API Ninjas error:",
                    errorText
                );

                return res.status(response.status).json({
                    error: "Workout search failed.",
                    details: errorText,
                });
            }

            const data = await response.json();

            const rawActivities = Array.isArray(data)
                ? data
                : [];

            const activities = rawActivities
                .map((item, index) => {
                    const caloriesPerHour = number(
                        item.calories_per_hour
                    );

                    const totalCalories = number(
                        item.total_calories
                    );

                    const duration = number(
                        item.duration_minutes
                    );

                    return {
                        id: `activity_${index}_${normalize(
                            item.name || activity
                        )}`,
                        name: item.name || activity,
                        caloriesPerHour,
                        durationMinutes:
                            duration || durationMinutes,
                        totalCalories,
                        weightKg,
                        source: "API Ninjas",
                    };
                })
                .filter(
                    (item) =>
                        item.name.trim().length > 0
                );

            return res.json({
                query: activity,
                weightKg,
                durationMinutes,
                count: activities.length,
                activities,
            });
        } catch (error) {
            console.error(
                "searchActivities error:",
                error
            );

            return res.status(500).json({
                error: "Unexpected server error.",
            });
        }
    }
);

//
// ============================================================
// FATSECRET
// ============================================================
//

async function searchFatSecret(query) {
    try {
        const clientId = FATSECRET_CLIENT_ID.value();
        const clientSecret = FATSECRET_CLIENT_SECRET.value();

        if (!clientId || !clientSecret) {
            return [];
        }

        const tokenResponse = await fetch(
            "https://oauth.fatsecret.com/connect/token",
            {
                method: "POST",
                headers: {
                    Authorization:
                        "Basic " +
                        Buffer.from(
                            `${clientId}:${clientSecret}`
                        ).toString("base64"),

                    "Content-Type":
                        "application/x-www-form-urlencoded",
                },

                body:
                    "grant_type=client_credentials&scope=premier",
            }
        );

        if (!tokenResponse.ok) {
            const errorText =
                await tokenResponse.text();

            console.log(
                "FatSecret currently unavailable:",
                errorText
            );

            return [];
        }

        const tokenData =
            await tokenResponse.json();

        const accessToken =
            tokenData.access_token;

        const url = new URL(
            "https://platform.fatsecret.com/rest/server.api"
        );

        url.searchParams.set(
            "method",
            "foods.search.v5"
        );

        url.searchParams.set(
            "search_expression",
            query
        );

        url.searchParams.set(
            "format",
            "json"
        );

        url.searchParams.set(
            "max_results",
            "30"
        );

        const response = await fetch(url, {
            headers: {
                Authorization:
                    `Bearer ${accessToken}`,
            },
        });

        if (!response.ok) {
            console.log(
                "FatSecret search failed:",
                await response.text()
            );

            return [];
        }

        const data =
            await response.json();

        const rawFoods =
            data?.foods?.food ?? [];

        const foods =
            Array.isArray(rawFoods)
                ? rawFoods
                : [rawFoods];

        return foods
            .map((food) => {
                const serving =
                    extractFatSecretServing(food);

                return {
                    id:
                        `fatsecret_${food.food_id || ""}`,

                    externalId:
                        food.food_id?.toString() || "",

                    source: "FatSecret",

                    name:
                        food.food_name || "",

                    brand:
                        food.brand_name || "",

                    type:
                        food.food_type || "Food",

                    imageUrl:
                        food.food_image || "",

                    calories:
                        serving.calories,

                    protein:
                        serving.protein,

                    carbs:
                        serving.carbs,

                    fat:
                        serving.fat,

                    fiber:
                        serving.fiber,

                    sugar:
                        serving.sugar,

                    sodium:
                        serving.sodium,

                    servingDescription:
                        serving.servingDescription,

                    servingAmount:
                        serving.servingAmount,

                    servingUnit:
                        serving.servingUnit,
                };
            })
            .filter(
                (food) =>
                    food.name.trim().length > 0
            );
    } catch (error) {
        console.log(
            "FatSecret error:",
            error
        );

        return [];
    }
}

function extractFatSecretServing(food) {
    try {
        let servings =
            food.servings?.serving ??
            food.serving ??
            [];

        if (!Array.isArray(servings)) {
            servings = [servings];
        }

        if (servings.length === 0) {
            return {
                calories: 0,
                protein: 0,
                carbs: 0,
                fat: 0,
                fiber: 0,
                sugar: 0,
                sodium: 0,
                servingDescription:
                    "100 g",
                servingAmount: 100,
                servingUnit: "g",
            };
        }

        let serving =
            servings.find((item) => {
                return (
                    item.metric_serving_unit === "g" &&
                    Number(
                        item.metric_serving_amount
                    ) === 100
                );
            });

        serving =
            serving || servings[0];

        return {
            calories:
                number(
                    serving.calories
                ),

            protein:
                number(
                    serving.protein
                ),

            carbs:
                number(
                    serving.carbohydrate
                ),

            fat:
                number(
                    serving.fat
                ),

            fiber:
                number(
                    serving.fiber
                ),

            sugar:
                number(
                    serving.sugar
                ),

            sodium:
                number(
                    serving.sodium
                ),

            servingDescription:
                serving.serving_description ||
                "Serving",

            servingAmount:
                number(
                    serving.metric_serving_amount
                ) || 100,

            servingUnit:
                serving.metric_serving_unit ||
                "g",
        };
    } catch (_) {
        return {
            calories: 0,
            protein: 0,
            carbs: 0,
            fat: 0,
            fiber: 0,
            sugar: 0,
            sodium: 0,
            servingDescription:
                "100 g",
            servingAmount: 100,
            servingUnit: "g",
        };
    }
}

//
// ============================================================
// USDA
// ============================================================
//

async function searchUsda(query) {
    try {
        const apiKey =
            USDA_API_KEY.value();

        if (!apiKey) {
            return [];
        }

        const url = new URL(
            "https://api.nal.usda.gov/fdc/v1/foods/search"
        );

        url.searchParams.set(
            "api_key",
            apiKey
        );

        url.searchParams.set(
            "query",
            query
        );

        url.searchParams.set(
            "pageSize",
            "30"
        );

        const response =
            await fetch(url);

        if (!response.ok) {
            console.log(
                "USDA failed:",
                await response.text()
            );

            return [];
        }

        const data =
            await response.json();

        const foods =
            data.foods || [];

        return foods
            .map((food) => {
                const nutrients =
                    food.foodNutrients || [];

                return {
                    id:
                        `usda_${food.fdcId}`,

                    externalId:
                        food.fdcId?.toString() || "",

                    source:
                        "USDA",

                    name:
                        food.description || "",

                    brand:
                        food.brandOwner ||
                        food.brandName ||
                        "",

                    type:
                        food.dataType || "Food",

                    imageUrl: "",

                    calories:
                        getUsdaNutrient(
                            nutrients,
                            ["Energy"],
                            ["KCAL"]
                        ),

                    protein:
                        getUsdaNutrient(
                            nutrients,
                            ["Protein"]
                        ),

                    carbs:
                        getUsdaNutrient(
                            nutrients,
                            [
                                "Carbohydrate, by difference",
                                "Carbohydrate",
                            ]
                        ),

                    fat:
                        getUsdaNutrient(
                            nutrients,
                            [
                                "Total lipid (fat)",
                                "Total lipid",
                            ]
                        ),

                    fiber:
                        getUsdaNutrient(
                            nutrients,
                            [
                                "Fiber, total dietary",
                                "Fiber",
                            ]
                        ),

                    sugar:
                        getUsdaNutrient(
                            nutrients,
                            [
                                "Sugars, total including NLEA",
                                "Total Sugars",
                                "Sugars",
                            ]
                        ),

                    sodium:
                        getUsdaNutrient(
                            nutrients,
                            ["Sodium, Na"]
                        ),

                    servingDescription:
                        "100 g",

                    servingAmount: 100,
                    servingUnit: "g",
                };
            })
            .filter(
                (food) =>
                    food.name.trim().length > 0
            );
    } catch (error) {
        console.log(
            "USDA error:",
            error
        );

        return [];
    }
}

function getUsdaNutrient(
    nutrients,
    names,
    units = null
) {
    for (const name of names) {
        const found =
            nutrients.find((nutrient) => {
                const nutrientName =
                    (
                        nutrient.nutrientName ||
                        nutrient.name ||
                        ""
                    )
                        .toLowerCase()
                        .trim();

                const target =
                    name.toLowerCase().trim();

                if (
                    nutrientName !== target &&
                    !nutrientName.includes(target)
                ) {
                    return false;
                }

                if (units) {
                    const unit =
                        (
                            nutrient.unitName ||
                            nutrient.unit ||
                            ""
                        )
                            .toUpperCase();

                    return units.includes(unit);
                }

                return true;
            });

        if (found) {
            return number(
                found.value ??
                found.amount
            );
        }
    }

    return 0;
}

//
// ============================================================
// OPEN FOOD FACTS
// ============================================================
//

async function searchOpenFoodFacts(query) {
    try {
        const url = new URL(
            "https://world.openfoodfacts.org/cgi/search.pl"
        );

        url.searchParams.set(
            "search_terms",
            query
        );

        url.searchParams.set(
            "search_simple",
            "1"
        );

        url.searchParams.set(
            "action",
            "process"
        );

        url.searchParams.set(
            "json",
            "1"
        );

        url.searchParams.set(
            "page_size",
            "30"
        );

        url.searchParams.set(
            "fields",
            [
                "code",
                "product_name",
                "brands",
                "nutriments",
                "image_front_small_url",
                "serving_size",
            ].join(",")
        );

        const response =
            await fetch(url, {
                headers: {
                    "User-Agent":
                        "FitnessApp/1.0",
                },
            });

        if (!response.ok) {
            console.log(
                "OpenFoodFacts failed:",
                await response.text()
            );

            return [];
        }

        const data =
            await response.json();

        const products =
            data.products || [];

        return products
            .map((product) => {
                const n =
                    product.nutriments || {};

                return {
                    id:
                        `off_${product.code || ""}`,

                    externalId:
                        product.code || "",

                    source:
                        "Open Food Facts",

                    name:
                        product.product_name || "",

                    brand:
                        product.brands || "",

                    type:
                        "Product",

                    imageUrl:
                        product.image_front_small_url ||
                        "",

                    calories:
                        number(
                            n["energy-kcal_100g"]
                        ),

                    protein:
                        number(
                            n["proteins_100g"]
                        ),

                    carbs:
                        number(
                            n["carbohydrates_100g"]
                        ),

                    fat:
                        number(
                            n["fat_100g"]
                        ),

                    fiber:
                        number(
                            n["fiber_100g"]
                        ),

                    sugar:
                        number(
                            n["sugars_100g"]
                        ),

                    sodium:
                        number(
                            n["sodium_100g"]
                        ),

                    servingDescription:
                        product.serving_size ||
                        "100 g",

                    servingAmount: 100,
                    servingUnit: "g",
                };
            })
            .filter((food) => {
                return (
                    food.name.trim().length > 0 &&
                    (
                        food.calories > 0 ||
                        food.protein > 0 ||
                        food.carbs > 0 ||
                        food.fat > 0
                    )
                );
            });
    } catch (error) {
        console.log(
            "OpenFoodFacts error:",
            error
        );

        return [];
    }
}

//
// ============================================================
// HELPERS
// ============================================================
//

function removeDuplicates(foods) {
    const seen = new Set();
    const unique = [];

    for (const food of foods) {
        const key = [
            normalize(food.name),
            normalize(food.brand),
        ].join("|");

        if (!food.name) {
            continue;
        }

        if (seen.has(key)) {
            continue;
        }

        seen.add(key);
        unique.push(food);
    }

    return unique;
}

function normalize(value) {
    return (
        value
            ?.toString()
            .toLowerCase()
            .replace(
                /[^a-z0-9äöüß]+/g,
                " "
            )
            .trim() || ""
    );
}

function number(value) {
    if (
        value === null ||
        value === undefined
    ) {
        return 0;
    }

    const parsed =
        Number(value);

    if (Number.isNaN(parsed)) {
        return 0;
    }

    return Math.round(
        parsed * 100
    ) / 100;
}