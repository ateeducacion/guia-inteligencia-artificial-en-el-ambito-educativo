# 3. ¿Qué tipos de IA existen?

A grandes rasgos, y dependiendo de la capacidad para resolver tareas o alcance, la inteligencia artificial se puede clasificar en dos tipos: **IA general (fuerte)** e **IA débil (restringida o estrecha)** [@briva-iglesias_inteligencia_2023, p. 11].

La **IA general** es aquella que tendría la capacidad de entender, aprender y aplicar su inteligencia a cualquier problema, de forma similar a como lo hacemos los seres humanos. Esta clase de IA no existe en la actualidad, pero es el objetivo a largo plazo de muchas investigaciones.

La **IA débil** es aquella cuyos sistemas han sido diseñados y entrenados para realizar una tarea específica. Actualmente disponemos de esta IA, por ejemplo, en asistentes virtuales como Siri o Alexa, en sistemas de recomendación como los que podemos encontrar en plataformas de cine o de compras en línea, e incluso en los sistemas de detección de fraudes bancarios.

| IA general (fuerte) | IA débil (restringida) |
|---|---|
| Entiende y aprende cualquier problema. | Especializada en tareas específicas. |
| Similar a la inteligencia humana. | Ejemplos: Siri, Alexa, sistemas de recomendación. |
| No existe actualmente. | Ampliamente utilizada hoy en día. |

## Técnicas de la IA débil

Según la UNESCO [-@unesco_inteligencia_2021], las principales técnicas de la IA débil son:

**IA clásica.** A pesar de abarcar distintas técnicas, suele caracterizarse por el uso de un sistema experto compuesto por un algoritmo fijo (motor de inferencias) que encadena lógicamente una serie de reglas («si… entonces…») extraídas a partir de conocimiento experto y, por tanto, dependientes de la naturaleza del problema a resolver (sistemas de diagnóstico médico, de clasificación taxonómica, etc.).

::: {.definicion}
**IA clásica — ¿qué hace?** Funciona con reglas fijas como «si pasa esto, entonces haz eso». **Uso común:** diagnósticos médicos.
:::

**Aprendizaje automático** (*machine learning*), basado en algoritmos de base matemática que analizan grandes cantidades de datos, identificando patrones y construyendo un modelo que puede predecir valores futuros o clasificar nuevos datos de entrada. Como desventaja y potencial fuente de sesgos, hay que destacar que su rendimiento depende totalmente de la calidad de los datos introducidos para entrenar al algoritmo que proporciona dicho modelo. No obstante, como ventaja, hay que subrayar la capacidad de estos algoritmos para encontrar la solución de problemas difícilmente abordables por la IA clásica.

::: {.definicion}
**Aprendizaje automático — ¿qué hace?** Aprende de grandes cantidades de datos para hacer predicciones o clasificaciones. **Importante:** necesita datos de buena calidad para funcionar bien.
:::

::: {.definicion}
**Sesgo:** condicionamiento en la respuesta del sistema de IA debido a la naturaleza y calidad de los datos de entrenamiento, ya que, como norma general, la IA reproducirá cualquier tipo de trato discriminatorio representado en ellos (por razón de raza, género, orientación sexual, etc.). De igual forma, una población infrarrepresentada o sobrerrepresentada en la muestra de datos también impactará en las estimaciones y clasificaciones realizadas por el sistema.
:::

```{=latex}
\begin{figure}[ht]\centering
\begin{tikzpicture}[>=Stealth]
  \node[ball,minimum size=2.9cm,font=\small](a){Ejemplos\\(entrenamiento\\y validación)};
  \node[ball,minimum size=2.9cm,font=\small,right=0.9cm of a](b){algoritmo de\\aprendizaje\\automático\\(modelo)};
  \node[ball,minimum size=2.9cm,font=\small,right=0.9cm of b](c){Modelo\\entrenado};
  \draw[conn](a)--(b);\draw[conn](b)--(c);
\end{tikzpicture}
\caption{Fase de entrenamiento de un sistema de aprendizaje automático: el algoritmo de aprendizaje entrena o ajusta un modelo base a partir de los datos de entrenamiento y evalúa su rendimiento con los datos de validación. Si el rendimiento es adecuado, genera y acepta el modelo entrenado.}
\end{figure}

\begin{figure}[ht]\centering
\begin{tikzpicture}[>=Stealth]
  \node[ball,minimum size=2.7cm](u){usuario\\o usuaria};
  \node[ball,minimum size=2.7cm,right=2.0cm of u](m){Modelo\\entrenado};
  \draw[conn](u.north east)--(m.north west) node[midway,above,lbl]{Resultado};
  \draw[conn](u.south east)--(m.south west) node[midway,below,lbl]{DATOS};
\end{tikzpicture}
\caption{Fase de producción de un sistema de aprendizaje automático estático, es decir, que no usa los datos de la usuaria o el usuario para mejorar su propio rendimiento.}
\end{figure}

\begin{figure}[ht]\centering
\begin{tikzpicture}[>=Stealth]
  \node[ball,minimum size=2.7cm,font=\small](alg){algoritmo de\\aprendizaje\\automático\\(modelo)};
  \node[ball,minimum size=2.7cm,right=1.5cm of alg](u){usuario\\o usuaria};
  \node[ball,minimum size=2.7cm,font=\small,right=1.5cm of u](m){Modelo\\entrenado};
  \draw[conn](alg)--(u) node[midway,above,lbl]{DATOS};
  \draw[conn](u)--(m) node[midway,above,lbl]{Resultado};
  \draw[conn](alg.south) -- ++(0,-0.7) -| (m.south) node[pos=0.5,below,lbl]{DATOS};
\end{tikzpicture}
\caption{Fase de producción de un sistema de aprendizaje automático que mejora su propio rendimiento a partir de los datos de interacción de la usuaria o el usuario.}
\end{figure}
```

**Redes neuronales artificiales** (RNA), inspiradas en las redes neuronales biológicas descubiertas por D. Santiago Ramón y Cajal, se organizan en tres tipos de capas interconectadas de neuronas artificiales: una capa de entrada que capta la entrada de la usuaria o el usuario, una o varias capas intermedias u ocultas que combinan matemáticamente la información anterior, y una capa de salida que proporciona el resultado. La limitación de las RNA se debe a la extrema dificultad a la hora de interpretar el aprendizaje (modificación de las conexiones entre neuronas) producido en las capas ocultas de la red y, por tanto, a la ausencia de «explicabilidad» en el proceso de obtención de la solución, así como a un aumento considerable del conjunto de datos necesario para realizar la tarea con respecto a otras técnicas de aprendizaje automático. No obstante, las redes neuronales y sus diseños derivados han sido los protagonistas de la actual revolución del campo.

::: {.definicion}
**Redes neuronales artificiales — ¿qué hace?** Imita cómo funciona el cerebro humano con capas de «neuronas» digitales. **Reto:** es difícil entender cómo llega a sus conclusiones.
:::

```{=latex}
\begin{figure}[ht]\centering
\begin{tikzpicture}[>=Stealth,x=1.3cm,y=1.2cm]
  \node[lbl,align=center] at (0,0.8){CAPA DE\\ENTRADA};
  \node[lbl,align=center] at (3,0.8){CAPA\\OCULTA};
  \node[lbl,align=center] at (6,0.8){CAPA DE\\SALIDA};
  \foreach \lab/\y in {1/-0.7,2/-1.8,3/-2.9,n/-4.6}{\node[neuron](I\lab) at (0,\y){\lab};\node[left=0.3cm of I\lab,lbl]{ENTRADA \lab};}
  \node[nblue] at (0,-3.75){\bfseries$\vdots$};
  \foreach \lab/\y in {1/-1.3,2/-2.4,m/-4.1}{\node[neuron](H\lab) at (3,\y){\lab};}
  \node[nblue] at (3,-3.25){\bfseries$\vdots$};
  \node[neuron](O) at (6,-2.6){1};\node[right=0.35cm of O,lbl]{SALIDA};
  \foreach \i in {1,2,3,n}\foreach \h in {1,2,m}\draw[black!50](I\i)--(H\h);
  \foreach \h in {1,2,m}\draw[black!50](H\h)--(O);
\end{tikzpicture}
\caption{Red neuronal artificial con una capa de entrada de «n» neuronas, una capa oculta de «m» neuronas y una capa de salida con una sola neurona. Gengiskanhg, Wikipedia en español, CC BY-SA 3.0.}
\end{figure}
```

**Aprendizaje profundo** (*deep learning*), compuesto por RNA de decenas, cientos o incluso miles de capas ocultas, está considerado como la más potente de las técnicas de IA, habiendo mejorado de forma muy significativa la totalidad de las aplicaciones de la IA. Así, a pesar de heredar las dificultades de las RNA, el *deep learning* constituye la base de la actual revolución tecnológica, conformando el corazón del procesamiento del lenguaje natural, el reconocimiento del habla y de imágenes e, incluso, la inteligencia artificial generativa (IAG).

::: {.definicion}
**Aprendizaje profundo — ¿qué hace?** Versión avanzada de las redes neuronales con muchas más capas. **Uso común:** tecnologías como el reconocimiento de voz e imagen.
:::

En conjunto, todas las técnicas de inteligencia artificial descritas anteriormente han dado lugar a una serie de herramientas que se ofrecen como servicios en distintas plataformas tecnológicas.

Entre estas técnicas destaca la **inteligencia artificial generativa (IAG)** que, basada en aprendizaje profundo y especialmente en el modelo de transformador [@vaswani_attention_2023], tiene la capacidad de generar contenidos prácticamente indistinguibles de los creados por los humanos a partir del entrenamiento con grandes cantidades de datos. Sin embargo, los resultados pueden ser inexactos y poco fiables, ya que las herramientas basadas en IAG no comprenden las instrucciones ni el resultado que generan y dependen de los datos con los que hayan sido entrenadas.
