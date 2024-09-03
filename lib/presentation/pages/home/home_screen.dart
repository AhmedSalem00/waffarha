import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waffarha/presentation/pages/home/cubit/product_cubit.dart';
import 'package:waffarha/presentation/pages/home/cubit/product_state.dart';
import 'package:waffarha/presentation/widgets/home_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              final state = cubit.state;
              cubit.updateSortOrder(
                state is ProductLoadedState && state.sortBy == 'title'
                    ? 'albumId'
                    : 'title',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final result = await showDialog<int>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Filter by Album ID'),
                    content: TextField(
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        Navigator.of(context).pop(int.tryParse(value));
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
              cubit.updateFilter(result);
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductStates>(
        builder: (context, state) {
          if (state is ProductLoadingState && !(state is ProductLoadedState)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductErrorState) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is ProductLoadedState) {
            final products = state.products;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return HomeWidget(photo: product);
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  ),
                  if (state is ProductLoadingState)
                    const Center(child: CircularProgressIndicator()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        cubit.loadMore();
                      },
                      child: const Text('Load More'),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No Data Available'));
        },
      ),
    );
  }
}