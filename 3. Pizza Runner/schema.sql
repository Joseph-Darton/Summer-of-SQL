TABLE runners {
  "runner_id" INTEGER
  "registration_date" DATE
}

TABLE customer_orders {
  "order_id" INTEGER
  "customer_id" INTEGER
  "pizza_id" INTEGER
  "exclusions" VARCHAR(4)
  "extras" VARCHAR(4)
  "order_date" TIMESTAMP
}

TABLE runner_orders {
  "order_id" INTEGER
  "runner_id" INTEGER
  "pickup_time" VARCHAR(19)
  "distance" VARCHAR(7)
  "duration" VARCHAR(10)
  "cancellation" VARCHAR(23)
}

TABLE pizza_recipes {
  "pizza_id" INTEGER
  "toppings" TEXT
}

TABLE pizza_toppings {
  "topping_id" INTEGER
  "topping_name" TEXT
}

TABLE pizza_names {
  "pizza_id" INTEGER
  "pizza_name" TEXT
}

Ref: "runners"."runner_id" < "runner_orders"."runner_id"

Ref: "runner_orders"."order_id" < "customer_orders"."order_id"

Ref: "pizza_names"."pizza_id" < "customer_orders"."pizza_id"

Ref: "pizza_recipes"."pizza_id" < "customer_orders"."pizza_id"
