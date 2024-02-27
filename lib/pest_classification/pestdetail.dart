import 'package:flutter/material.dart';

List<Detail> details = [
   Detail(
    photo: Image.network(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh7qy62pNgdDuH4MlX7RrcK6TkVBxsPM9h1w&usqp=CAU"),
    title: 'Aphids',
    about:
        'Aphids are small insects that feed on the sap of plants, often causing damage to crops by sucking out plant juices. They reproduce quickly and can cause curling, yellowing, or distortion of leaves, as well as stunted growth. Aphids also secrete honeydew, which can attract other pests and promote the growth of sooty mold.',
    methods: '''
    - Neonicotinoids (e.g., imidacloprid)
    - Pyrethroids (e.g., lambda-cyhalothrin)
    - Organophosphates (e.g., malathion)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvApwKc8rWzozJf_zYsXVhHWHQ0jYJb21NbA&usqp=CAU"),
    title: 'Armyworm',
    about:
        'Armyworms are caterpillars of several moth species that feed on grasses, crops, and other plants. They are named for their behavior of traveling in large numbers and "marching" across fields, consuming vegetation as they go. Armyworm infestations can cause significant damage to crops, leading to reduced yields or complete loss of plants.',
    methods: '''
    - Pyrethroids (e.g., bifenthrin)
    - Spinosad
    - Bacillus thuringiensis (Bt)
    ''',
  ),
 Detail(
    photo: Image.network(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLTrJAC9l5Xot_2qDI0r3efO44OjuGvFgvNQ&usqp=CAU"),
    title: 'Beetle',
    about:
        'Beetles are a diverse group of insects that can cause damage to crops by feeding on leaves, stems, roots, and fruits. Some beetles also transmit diseases to plants. Beetle infestations can result in reduced crop yields and quality, as well as cosmetic damage to fruits and vegetables.',
    methods: '''
    - Neonicotinoids (e.g., acetamiprid)
    - Organophosphates (e.g., chlorpyrifos)
    - Pyrethroids (e.g., cypermethrin)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTdUKhfpR0Qors5-T7ag7TTWvfAOlGcHUh7Q&usqp=CAU"),
    title: 'Bollworm',
    about:
        'Bollworms are the larvae of several moth species that feed on the reproductive structures (bolls) of plants in the cotton and other crop families. They can cause significant damage to crops by consuming seeds, damaging flowers, and reducing yields. Bollworm infestations are a major concern for cotton farmers, as they can lead to economic losses and decreased crop quality.',
    methods: '''
    - Bacillus thuringiensis (Bt)
    - Pyrethroids (e.g., permethrin)
    - Insect growth regulators (e.g., methoxyfenozide)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YjxESDGXSQ7wGb99sdoMVTcK2hkE3XMBFw&usqp=CAU"),
    title: 'Grasshopper',
    about:
        'Grasshoppers are herbivorous insects that can cause significant damage to crops by feeding on leaves, stems, and fruits. They are known for their ability to consume large amounts of vegetation, leading to reduced crop yields and economic losses for farmers. Grasshopper infestations are particularly problematic in areas with dry or drought-like conditions, as grasshoppers thrive in warm and arid environments.',
    methods: '''
    - Pyrethroids (e.g., deltamethrin)
    - Neonicotinoids (e.g., imidacloprid)
    - Biological control (e.g., parasitic wasps)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://c8.alamy.com/comp/2RD8HCA/tetranychus-urticae-red-spider-mite-or-two-spotted-spider-mite-is-a-species-of-plant-feeding-mite-a-pest-of-many-plants-mite-grouping-on-sugar-beet-2RD8HCA.jpg"),
    title: 'Mites',
    about:
        'Mites are tiny arachnids that can cause damage to crops by feeding on plant tissues and transmitting plant diseases. They are often found on the undersides of leaves and in the crevices of plants, where they feed on sap and other plant fluids. Mite infestations can result in reduced crop yields, stunted growth, and cosmetic damage to fruits and vegetables.',
    methods: '''
    - Acaricides (e.g., abamectin)
    - Sulfur-based products
    - Biological control (e.g., predatory mites)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://c8.alamy.com/comp/KCMR99/spraying-aerosol-on-the-mosquito-sitting-on-the-net-closeupinsecticide-KCMR99.jpg"),
    title: 'Mosquito',
    about:
        'Mosquitoes are small flying insects that feed on the blood of humans and animals, often transmitting diseases such as malaria, dengue fever, Zika virus, and West Nile virus. They breed in stagnant water and are most active during dawn and dusk. Mosquito control is essential for preventing the spread of mosquito-borne diseases and protecting public health.',
    methods: '''
    - Insect growth regulators (e.g., methoprene)
    - Larvicides (e.g., Bacillus thuringiensis israelensis)
    - Adulticides (e.g., pyrethroids)
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://c8.alamy.com/comp/2PWB84G/elm-sawfly-caterpillar-cimbex-americanus-eating-an-elm-leaf-during-the-night-in-houston-tx-they-are-the-largest-species-of-sawfly-in-the-usa-2PWB84G.jpg"),
    title: 'Sawfly',
    about:
        'Sawflies are related to wasps and bees and are known for their saw-like ovipositor, which they use to lay eggs in plant tissues. The larvae of sawflies feed on leaves and stems of various plants, often causing damage to crops by defoliating plants and reducing yields. Sawfly infestations can be particularly problematic in orchards and forests, where they can cause significant damage to fruit trees and timber crops.',
    methods: '''
    - Insecticidal soaps and oils
    - Bacillus thuringiensis (Bt)
    - Spinosad
    ''',
  ),
  Detail(
    photo: Image.network(
        "https://c8.alamy.com/comp/2KYDXDM/corn-worm-caterpillar-corn-borer-important-pest-of-corn-crop-agricultural-problems-pest-and-plant-disease-concept-2KYDXDM.jpg"),
    title: 'Stem borer',
    about:
        'Stem borers are a group of insects that bore into the stems and stalks of plants, causing damage to vascular tissues and reducing plant growth and yields. They are particularly problematic in cereal crops such as rice, maize, and sugarcane, where they can cause significant economic losses. Stem borer infestations are often difficult to detect and control, as the larvae feed inside the plant tissues, making them less susceptible to insecticides and other control measures.',
    methods: '''
    - Cultural control (e.g., crop rotation)
    - Biological control (e.g., parasitoid wasps)
    - Chemical control (e.g., synthetic pyrethroids)
    ''',
  ),
];


class Detail {
  final Image photo;
  final String title;
  final String about;
  final String methods;

  Detail({
    required this.photo,
    required this.title,
    required this.about,
    required this.methods,
  });
}
