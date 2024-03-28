# Projet-Modelisation
## Modifications apportees depuis l'oral
Nous avons constaté pendant l'oral de mardi que l'estimation de l'axe médian n'était pas parfaite. En effet, celui-ci contenait des cycles, ce qui est impossible car un axe median est sensé être un arbre.

Nous avons donc complétement repris le script d'estimation de l'axe médian (voir fonction `skeleton_extraction_v2.m`) et cette fois-ci estimé l'axe médian en suivant l'énoncé du TP, c'est à dire via une matrice d'adjacence. Les résultats sont satisfaisant et aucun cycle n'est présent. Il reste cependant encore améliorable.

## Voies d'amélioration
Comme vu précedemment, l'axe médian n'est toujours pas parfait. En effet, on constate de nombreuses pérturbations dû aux bordures pixélisées de l'image binaire. Pour pouvoir y remedier, il serait donc possible de lisser l'image, par exemple avec un flou gaussien, ou encore avec des techniques d'érosions et de dilatations. 


## A quoi correspondent les scripts et fonctions.
### Scripts : 
- Le script `PROJET_P1.m` correspond à la partie de la sur-segmentation de l'image ainsi qu'a la classification binaire, mais aussi de l'extraction de l'axe médian.

- Le script `compute_masks.m` sers à calculer les masques des 36 images, utilisés dans la partie suivante.

- Le script `PROJET_P2.m` correspond a la triangulation ainsi que l'elimination des tétraèdres superflus.

- Le script `PROJET_P3.m` correspond au maillage

### Fonctions :
- La fonction `init_centers.m` permet de ...
- La fonction `plusProcheCentre.m` permet de ...
- La fonction `get_initial_point.m` permet de trouver un point initial pour pouvoir calculer le contour de l'image binaire. 
- Les fonctions `skeleton_extraction.m` et `skeleton_extraction_v2.m` representent nos deux implémentations du calcul de l'axe médian (la version 2 étant celle marchant le mieux)
