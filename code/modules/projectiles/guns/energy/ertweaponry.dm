/obj/item/weapon/gun/energy/rifle/laser/ertrifle
	name = "ERR40"
	desc = "The Emergency Response Rifle Model 40 is an advanced directed energy weapon capable of emitting highly focused energy which can kill or wound a human being."
	icon_state = "laser"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BACK
	w_class = 4
	matter = list("metal" = 2000)
	charge_cost = 25 //odd numbers due to a requirement to have 20 shots. Easiest way.
	origin_tech = "combat=3;magnets=2"
	projectile_type = "/obj/item/projectile/beam"
	fire_delay_wielded = 0
	fire_delay_unwielded = 6
	force_wielded = 10 //10 is amped force, due to better grip
	force_unwielded = 5 //5 is normal force
	rangedrop = -5
	var/mode = 1
	projectiles_per_shot = 1

	attack_self(mob/living/user as mob)
		switch(mode)
			if(0)
				mode = 1
				charge_cost = 100
				fire_sound = 'sound/weapons/Laser.ogg'
				user << "\red [src.name] is now set to kill."
				projectile_type = "/obj/item/projectile/beam"
				modifystate = "energykill"
			if(1)
				mode = 0
				charge_cost = 100
				fire_sound = 'sound/weapons/Taser.ogg'
				user << "\red [src.name] is now set to stun."
				projectile_type = "/obj/item/projectile/energy/electrode"
				modifystate = "energystun"
		update_icon()
/obj/item/weapon/gun/energy/rifle/laser/ertrifle/verb/toggle_burst()
	set name = "Toggle Burst"
	set category = "Object"

	if (projectiles_per_shot == 3)
		loc << "\red [src.name] is now set to single shot."
		projectiles_per_shot = 1
		fire_cooldown = 0
	else
		loc << "\red [src.name] is now set to fire in bursts."
		projectiles_per_shot = 3
		fire_cooldown = 1
	update_icon()