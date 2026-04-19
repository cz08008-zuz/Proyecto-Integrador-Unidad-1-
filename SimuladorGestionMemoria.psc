// =========================================================
// ?? SUBPROCESO: MOSTRAR MAPA DE BITS
// REQUERIMIENTO:
// - Mostrar qué marcos están libres (0) u ocupados (1)
// =========================================================
SubProceso MostrarMapaBits(ocupado, NUM_MARCOS)
    Definir i Como Entero
    Escribir "Mapa de bits (0=Libre, 1=Ocupado):"
    Para i <- 1 Hasta NUM_MARCOS
        Escribir "Marco ", i, ": ", ocupado[i]
    FinPara
FinSubProceso


// =========================================================
// ?? SUBPROCESO: TRADUCIR DIRECCIÓN
// REQUERIMIENTO:
// - Convertir dirección lógica ? física
// - Detectar fallo de página
// =========================================================
SubProceso TraducirDireccion(pagina, offset, paginaPresente, paginaMarco, TAM_MARCO, direccionFisica Por Referencia)
	
    Definir marco Como Entero
	
    Si paginaPresente[pagina] = 0 Entonces
        direccionFisica <- -1   // Indica fallo
    Sino
        marco <- paginaMarco[pagina]
        direccionFisica <- (marco - 1) * TAM_MARCO + offset
    FinSi
	
FinSubProceso


// =========================================================
// ?? SUBPROCESO: FIFO
// REQUERIMIENTO:
// - Usar cola
// - Expulsar la página más antigua
// =========================================================
SubProceso SimularFIFO(fallosFIFO Por Referencia)
	
    Definir Referencias, Marcos, Ocupado Como Entero
    Dimension Referencias[12]
    Dimension Marcos[3]
    Dimension Ocupado[3]
	
    Definir i, t, pag, libre, puntero Como Entero
	
    // Secuencia solicitada
    Referencias[1] <- 1
    Referencias[2] <- 2
    Referencias[3] <- 3
    Referencias[4] <- 4
    Referencias[5] <- 1
    Referencias[6] <- 2
    Referencias[7] <- 5
    Referencias[8] <- 1
    Referencias[9] <- 2
    Referencias[10] <- 3
    Referencias[11] <- 4
    Referencias[12] <- 5
	
    Para i <- 1 Hasta 3
        Ocupado[i] <- 0
        Marcos[i] <- -1
    FinPara
	
    fallosFIFO <- 0
    puntero <- 1
	
    Para t <- 1 Hasta 12
        pag <- Referencias[t]
        libre <- -1
		
        // HIT
        Para i <- 1 Hasta 3
            Si Ocupado[i] = 1 Y Marcos[i] = pag Entonces
                libre <- i
            FinSi
        FinPara
		
        // FALLO
        Si libre = -1 Entonces
            fallosFIFO <- fallosFIFO + 1
			
            // Buscar libre
            Para i <- 1 Hasta 3
                Si Ocupado[i] = 0 Entonces
                    libre <- i
                FinSi
            FinPara
			
            Si libre <> -1 Entonces
                Ocupado[libre] <- 1
                Marcos[libre] <- pag
            Sino
                // Reemplazo FIFO
                Marcos[puntero] <- pag
                puntero <- puntero + 1
                Si puntero > 3 Entonces
                    puntero <- 1
                FinSi
            FinSi
        FinSi
    FinPara
	
FinSubProceso


// =========================================================
// ?? SUBPROCESO: OPT (ÓPTIMO)
// REQUERIMIENTO:
// - Expulsar la página que se usará más tarde
// =========================================================
SubProceso SimularOPT(fallosOPT Por Referencia)
	
    Definir Referencias, Marcos, Ocupado Como Entero
    Dimension Referencias[12]
    Dimension Marcos[3]
    Dimension Ocupado[3]
	
    Definir i, k, t, pag, libre Como Entero
    Definir mayorDist, dist, mejorMarco Como Entero
	
    // Secuencia
    Referencias[1] <- 1
    Referencias[2] <- 2
    Referencias[3] <- 3
    Referencias[4] <- 4
    Referencias[5] <- 1
    Referencias[6] <- 2
    Referencias[7] <- 5
    Referencias[8] <- 1
    Referencias[9] <- 2
    Referencias[10] <- 3
    Referencias[11] <- 4
    Referencias[12] <- 5
	
    Para i <- 1 Hasta 3
        Ocupado[i] <- 0
        Marcos[i] <- -1
    FinPara
	
    fallosOPT <- 0
	
    Para t <- 1 Hasta 12
        pag <- Referencias[t]
        libre <- -1
		
        // HIT
        Para i <- 1 Hasta 3
            Si Ocupado[i] = 1 Y Marcos[i] = pag Entonces
                libre <- i
            FinSi
        FinPara
		
        // FALLO
        Si libre = -1 Entonces
            fallosOPT <- fallosOPT + 1
			
            // Buscar libre
            Para i <- 1 Hasta 3
                Si Ocupado[i] = 0 Entonces
                    libre <- i
                FinSi
            FinPara
			
            Si libre <> -1 Entonces
                Ocupado[libre] <- 1
                Marcos[libre] <- pag
            Sino
                // OPT
                mayorDist <- -1
                mejorMarco <- 1
				
                Para i <- 1 Hasta 3
                    dist <- 9999
					
                    Para k <- t + 1 Hasta 12
                        Si Referencias[k] = Marcos[i] Entonces
                            dist <- k - t
                            k <- 12
                        FinSi
                    FinPara
					
                    Si dist > mayorDist Entonces
                        mayorDist <- dist
                        mejorMarco <- i
                    FinSi
                FinPara
				
                Marcos[mejorMarco] <- pag
            FinSi
        FinSi
    FinPara
	
FinSubProceso


// =========================================================
// ?? PROGRAMA PRINCIPAL: SIMULADOR MMU
// =========================================================
Algoritmo SimuladorMMU_10Paginas
	
    // =====================================================
    // ?? FASE 1: CONFIGURACIÓN DE MEMORIA
    // =====================================================
    Definir TAM_MARCO, NUM_MARCOS, NUM_PAGINAS Como Entero
    TAM_MARCO <- 4096        // 4KB
    NUM_MARCOS <- 4          // 16KB RAM
    NUM_PAGINAS <- 10        // Memoria virtual
	
    // RAM y mapa de bits
    Definir RAM, ocupado Como Entero
    Dimension RAM[4]
    Dimension ocupado[4]
	
    // Tabla de páginas
    Definir paginaMarco, paginaPresente Como Entero
    Dimension paginaMarco[10]
    Dimension paginaPresente[10]
	
    // FIFO
    Definir colaFIFO Como Entero
    Dimension colaFIFO[4]
	
    Definir inicio, ultimo Como Entero
	
    // Direcciones
    Definir direccionesLogicas Como Entero
    Dimension direccionesLogicas[10]
	
    Definir i, j, pagina, marco, offset, direccionFisica Como Entero
    Definir paginaEliminar, fallos Como Entero
	
    Definir fFIFO, fOPT Como Entero
	
    // Inicialización
    Para i <- 1 Hasta NUM_MARCOS
        RAM[i] <- -1
        ocupado[i] <- 0
    FinPara
	
    Para i <- 1 Hasta NUM_PAGINAS
        paginaMarco[i] <- -1
        paginaPresente[i] <- 0
    FinPara
	
    inicio <- 1
    ultimo <- 0
    fallos <- 0
	
    // =====================================================
    // ?? FASE 2: ENTRADA DE DATOS
    // =====================================================
	Escribir "Ingrese 10 direcciones lógicas (0 a ", (NUM_PAGINAS*TAM_MARCO)-1, "):"
	
    Para i <- 1 Hasta 10
        Repetir
            Escribir "Dirección ", i, ": "
            Leer direccionesLogicas[i]
        Hasta Que direccionesLogicas[i] >= 0 Y direccionesLogicas[i] < (NUM_PAGINAS * TAM_MARCO)
		
	FinPara
	
    // =====================================================
    // ?? FASE 3: SIMULACIÓN MMU + FIFO
    // =====================================================
    Para i <- 1 Hasta 10
		
        Escribir "----------------------"
		
        // División dirección
        pagina <- Trunc(direccionesLogicas[i] / TAM_MARCO) + 1
        offset <- direccionesLogicas[i] MOD TAM_MARCO
		
		Escribir "Direccion logica: ", direccionesLogicas[i]
        Escribir "Pagina: ", pagina
        Escribir "Offset: ", offset
		
        Si paginaPresente[pagina] = 1 Entonces
            Escribir "ACIERTO (HIT)"
            marco <- paginaMarco[pagina]
        Sino
            Escribir "FALLO DE PAGINA"
            fallos <- fallos + 1
            marco <- -1
			
            // Buscar libre
            Para j <- 1 Hasta NUM_MARCOS
                Si ocupado[j] = 0 Entonces
                    marco <- j
                    ocupado[j] <- 1
                    j <- NUM_MARCOS
                FinSi
            FinPara
			
            // FIFO
            Si marco = -1 Entonces
                paginaEliminar <- colaFIFO[inicio]
				
                inicio <- inicio + 1
                Si inicio > NUM_MARCOS Entonces
                    inicio <- 1
                FinSi
				
                marco <- paginaMarco[paginaEliminar]
                paginaPresente[paginaEliminar] <- 0
				
                Escribir "Reemplazo FIFO, sale pagina: ", paginaEliminar
            FinSi
			
            // Cargar página
            RAM[marco] <- pagina
            paginaMarco[pagina] <- marco
            paginaPresente[pagina] <- 1
			
            ultimo <- ultimo + 1
            Si ultimo > NUM_MARCOS Entonces
                ultimo <- 1
            FinSi
			
            colaFIFO[ultimo] <- pagina
        FinSi
		
        // Traducción
        TraducirDireccion(pagina, offset, paginaPresente, paginaMarco, TAM_MARCO, direccionFisica)
		
        Escribir "Marco: ", marco
        Escribir "Direccion fisica: ", direccionFisica
		
        // Estado RAM
        Escribir "Estado RAM:"
        Para j <- 1 Hasta NUM_MARCOS
            Escribir "M", j, ": ", RAM[j]
        FinPara
		
        // Mapa de bits
        MostrarMapaBits(ocupado, NUM_MARCOS)
		
    FinPara
	
    // =====================================================
    // ?? FASE 4: RESULTADOS
    // =====================================================
    Escribir "===================="
    Escribir "FALLOS MMU: ", fallos
	
    SimularFIFO(fFIFO)
    SimularOPT(fOPT)
	
	Escribir "===================="
    Escribir "FALLOS FIFO: ", fFIFO
    Escribir "FALLOS OPT: ", fOPT

FinAlgoritmo