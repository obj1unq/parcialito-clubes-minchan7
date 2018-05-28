
class Socio {
	
}

class Jugador inherits Socio{
	
	var property valorPase = 0
}

class Club{
	
	var property valorConfigurable = 0
	
	method esEstrella(club,socio){
		return socio.antiguedad()> 20 || socio.partidosJugados() >50 || club.requerimientosEspeciales(socio)
	}
	method requerimientosEspeciales(socio)
}

class ClubProfesional inherits Club {
	
	override method requerimientosEspeciales(socio){
		return socio.valorPase()>self.valorConfigurable()
	}
}

class ClubComunitario inherits Club {
	
}

class ClubTradicional inherits Club {
	
}