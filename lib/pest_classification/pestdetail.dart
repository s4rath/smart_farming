import 'package:flutter/material.dart';

List<Detail> details = [
   Detail(
    photo: Image.network(
        "https://www.conserve-energy-future.com/wp-content/uploads/2016/02/battery-recycling.jpg"),
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
        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fcelitron.com%2Fen%2Fbiomedical-waste-management-disposal-methods&psig=AOvVaw3XS9sOk-GeKnhTknRnMe9d&ust=1649673997323000&source=images&cd=vfe&ved=0CAoQjRxqFwoTCLCEmd6oifcCFQAAAAAdAAAAABAD"),
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
        "https://www.pdsigns.ie/contentFiles/productImages/Large/RWSW3.jpg"),
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
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZtaxt_hNYcRJbl9Vd4if7bmy3jwy8eDnWD96pEkMEy8ja64IpxdPtUul625T3eltkR7g&usqp=CAU"),
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
        "https://in.apparelresources.com/wp-content/uploads/sites/3/2021/08/unnamed.jpg"),
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
        "https://thumbs.dreamstime.com/b/bunch-empty-green-glass-bottles-collected-recycling-sale-waste-management-concept-180815991.jpg"),
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
        "https://www.recyclingdepotadelaide.com.au/wp-content/uploads/2015/04/scrap-metal-recycling-process.jpg"),
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
        "https://img2.exportersindia.com/product_images/bc-full/dir_180/5379364/paper-waste-1512642370-3503613.jpeg"),
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
        "https://marketresearch.biz/wp-content/uploads/2019/01/plastic-waste-management-market.jpg"),
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
