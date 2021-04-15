import Config


config :elevator_project,
    #System settings
    number_of_elevators: 3, #Changes on runtime, this is a dummy variable, 1-indexed
    top_floor: 3,   #Floors are 0-indexed

    #Elevator settings
    elevator_number: 1, #Changes on runtime, this is a dummy variable, 1-indexed
    door_timer_interval: 2_000,

    #Order settings
    stop_cost: 1,
    travel_cost: 1,
    order_penalty: 10,
    multi_call_timeout: 100,
    initialization_time: 1_000,
    check_for_orders_interval: 100,

    #Watchdog settings
    order_timeout: 10_000,

    #IO
    polling_interval: 100,
    lights_update_interval: 100,

    #Network
    ping_interval: 1000,
    node_ips: [:"1@10.24.35.90", :"2@10.24.39.216"]

config :logger,
    level: :debug
