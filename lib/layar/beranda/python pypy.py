from ortools.constraint_solver import routing_enums_pb2
from ortools.constraint_solver import pywrapcp

# =========================
# DATA PENELITIAN
# =========================

def create_data_model():
    data = {}

    # Matriks jarak antar lokasi
    data['distance_matrix'] = [
        [0, 5, 7, 9, 6, 8],
        [5, 0, 4, 6, 5, 7],
        [7, 4, 0, 3, 6, 5],
        [9, 6, 3, 0, 4, 2],
        [6, 5, 6, 4, 0, 3],
        [8, 7, 5, 2, 3, 0],
    ]

    # Permintaan pelanggan
    data['demands'] = [0, 20, 15, 25, 10, 30]

    # Kapasitas kendaraan
    data['vehicle_capacities'] = [100]

    # Jumlah kendaraan
    data['num_vehicles'] = 1

    # Gudang utama
    data['depot'] = 0

    return data


# =========================
# MENAMPILKAN HASIL
# =========================

def print_solution(data, manager, routing, solution):
    total_distance = 0
    total_load = 0

    for vehicle_id in range(data['num_vehicles']):
        index = routing.Start(vehicle_id)
        plan_output = 'Rute kendaraan:\n'
        route_distance = 0
        route_load = 0

        while not routing.IsEnd(index):
            node_index = manager.IndexToNode(index)
            route_load += data['demands'][node_index]
            plan_output += f'Lokasi {node_index} -> '
            previous_index = index
            index = solution.Value(routing.NextVar(index))
            route_distance += routing.GetArcCostForVehicle(
                previous_index, index, vehicle_id)

        plan_output += 'Kembali ke Gudang\n'
        plan_output += f'Total jarak: {route_distance} km\n'
        plan_output += f'Total muatan: {route_load} box ikan\n'

        print(plan_output)

        total_distance += route_distance
        total_load += route_load

    print('=============================')
    print(f'Total seluruh jarak: {total_distance} km')
    print(f'Total seluruh muatan: {total_load} box ikan')


# =========================
# PROGRAM UTAMA
# =========================

def main():
    data = create_data_model()

    # Membuat index manager
    manager = pywrapcp.RoutingIndexManager(
        len(data['distance_matrix']),
        data['num_vehicles'],
        data['depot'])

    # Membuat routing model
    routing = pywrapcp.RoutingModel(manager)

    # Fungsi jarak
    def distance_callback(from_index, to_index):
        from_node = manager.IndexToNode(from_index)
        to_node = manager.IndexToNode(to_index)
        return data['distance_matrix'][from_node][to_node]

    transit_callback_index = routing.RegisterTransitCallback(distance_callback)

    routing.SetArcCostEvaluatorOfAllVehicles(transit_callback_index)

    # Fungsi permintaan
    def demand_callback(from_index):
        from_node = manager.IndexToNode(from_index)
        return data['demands'][from_node]

    demand_callback_index = routing.RegisterUnaryTransitCallback(
        demand_callback)

    routing.AddDimensionWithVehicleCapacity(
        demand_callback_index,
        0,
        data['vehicle_capacities'],
        True,
        'Capacity')

    # Parameter pencarian solusi
    search_parameters = pywrapcp.DefaultRoutingSearchParameters()

    search_parameters.first_solution_strategy = (
        routing_enums_pb2.FirstSolutionStrategy.PATH_CHEAPEST_ARC)

    # Menjalankan program
    solution = routing.SolveWithParameters(search_parameters)

    # Menampilkan hasil
    if solution:
        print_solution(data, manager, routing, solution)
    else:
        print('Solusi tidak ditemukan')


if __name__ == '__main__':
    main()
