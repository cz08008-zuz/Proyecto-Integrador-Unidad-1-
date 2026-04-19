# Proyecto-Integrador-Unidad-1-
Este simulador permite comprender cómo los sistemas operativos gestionan la memoria y cómo diferentes estrategias afectan el rendimiento.

	Descripción del sistema
  
Este proyecto simula el funcionamiento de una Unidad de Gestión de Memoria (MMU) utilizando:

•	Paginación 

•	Tabla de páginas

•	Traducción de direcciones 

•	Algoritmos de reemplazo 


Objetivo

Analizar cómo se gestionan las direcciones en memoria y evaluar el impacto de diferentes algoritmos de reemplazo.


	Funcionamiento general
  
1.	Se ingresan direcciones lógicas
   
2.	Se dividen en:
   
o	Página 

o	Offset 

4.	Se verifica si la página está en RAM
   
5.	Si no está:
   
o	Se produce un fallo de página 

o	Se aplica FIFO 

7.	Se traduce la dirección
   
8.	Se muestra el estado de memoria
    
	Resultados obtenidos
  
El sistema muestra:

•	Fallos totales en la simulación MMU 

•	Fallos usando FIFO 

•	Fallos usando OPT 


Análisis

•	FIFO presenta más fallos debido a su naturaleza secuencial. 

•	OPT obtiene el mejor rendimiento porque toma decisiones óptimas. 

•	La MMU depende fuertemente del algoritmo de reemplazo para su eficiencia. 


Conclusión

El simulador demuestra que la gestión de memoria es un proceso crítico en los sistemas operativos. La traducción de direcciones permite ejecutar programas eficientemente, pero el rendimiento depende directamente del algoritmo de reemplazo utilizado. Mientras FIFO es sencillo, OPT ofrece el mejor desempeño teórico, evidenciando la importancia de estrategias inteligentes en la administración de memoria.

