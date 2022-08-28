/datum/surgery/mcomp_wounds
	name = "Tend Damage (Brute/Burn)"
	possible_locs = ALL_LIMBS
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	required_surgery_skill = SKILL_SURGERY_YAUTJA // Only predators can do this
	pain_reduction_required = 0
	steps = list(
		/datum/surgery_step/mstabilize_wounds,
		/datum/surgery_step/mtend_wounds,
		/datum/surgery_step/cauterize/mclamp_wound,
				)
	lying_required = FALSE
	self_operable = TRUE

/datum/surgery/mcomp_wounds/can_start(mob/living/carbon/human/user, mob/living/carbon/human/patient, var/obj/limb/L, obj/item/tool)
	if((istype(user) && HAS_TRAIT(user, TRAIT_YAUTJA_TECH)) && (patient.getBruteLoss() || patient.getFireLoss()))
		return TRUE
	return FALSE

//For closing an open incision first.
/datum/surgery/mcomp_wounds/open
	invasiveness = list(SURGERY_DEPTH_SHALLOW)
	steps = list(
		/datum/surgery_step/mtend_wounds,
		/datum/surgery_step/cauterize/mclamp_wound
				)

//------------------------------------

/datum/surgery_step/mstabilize_wounds
	name = "stabilize wounds"
	desc = "stabilize the wounds"
	tools = SURGERY_TOOLS_MEDICOMP_STABILIZE_WOUND
	time = 5 SECONDS

/datum/surgery_step/mstabilize_wounds/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You begin to stabilize your wounds with \the [tool]."),
		SPAN_NOTICE("[user] begins to stabilize your wounds with \the [tool]."),
		SPAN_NOTICE("[user] begins to stabilize [target]'s wounds with \the [tool]."))

	target.custom_pain("It feels like your body is being stabbed with needles - because it is!")
	log_interact(user, target, "[key_name(user)] began to stabilizing wounds on [key_name(target)] with \the [tool], starting [surgery].")

/datum/surgery_step/mstabilize_wounds/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	target.heal_overall_damage(25,25)
	playsound(target, 'sound/misc/wound_stabilize.ogg',25)

	if(isSpeciesYautja(target))
		target.emote("click2")
	else
		target.emote("pain")

	if(!target.getBruteLoss() && !target.getFireLoss())
		user.affected_message(target,
			SPAN_NOTICE("you finish stabilizing your wounds."),
			SPAN_NOTICE("[user] finishes stabilizing your wounds."),
			SPAN_NOTICE("[user] finishes stabilizing the [target]'s wounds."))

		log_interact(user, target, "[key_name(user)] finished stabilizing [key_name(target)]'s wounds with \the [tool], ending [surgery].")
	else
		user.affected_message(target,
			SPAN_NOTICE("you finish stabilize your injuries."),
			SPAN_NOTICE("[user] finishes stabilizing some of your injuries on [target]."),
			SPAN_NOTICE("[user] finishes stabilizing some of [target]'s injuries."))

		log_interact(user, target, "[key_name(user)] stabilized some of [key_name(target)]'s wounds with \the [tool].")

/datum/surgery_step/mstabilize_wounds/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to stabilize [key_name(target)]'s wounds with \the [tool], possibly ending [surgery].")
	return FALSE

/datum/surgery_step/mtend_wounds
	name = "Tend Wounds"
	desc = "tend the wounds"
	tools = SURGERY_TOOLS_MEDICOMP_MEND_WOUND
	time = 15 SECONDS

/datum/surgery_step/mtend_wounds/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("you begin to tend your stabilized wounds with \the [tool]."),
		SPAN_NOTICE("[user] begins to tend your stabilized wounds with \the [tool]."),
		SPAN_NOTICE("[user] begins to suture and tend [target]'s stabilized wounds with \the [tool]."))
	playsound(target, 'sound/misc/heal_gun.ogg',25)

	target.custom_pain("It feels like your body is being stabbed with needles - because it is!")
	log_interact(user, target, "[key_name(user)] began tending wounds on [key_name(target)] with \the [tool], starting [surgery].")

/datum/surgery_step/mtend_wounds/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	target.heal_overall_damage(60,60)

	if(isSpeciesYautja(target))
		target.emote("click")
	else
		target.emote("pain")

	if(!target.getBruteLoss() && !target.getFireLoss())
		user.affected_message(target,
			SPAN_NOTICE("you finish treating your stabilized wounds."),
			SPAN_NOTICE("[user] finishes treating your stabilized wounds."),
			SPAN_NOTICE("[user] finishes treating the [target]'s stabilized wounds."))

		log_interact(user, target, "[key_name(user)] finished tending [key_name(target)]'s wounds with \the [tool], ending [surgery].")
	else
		user.affected_message(target,
			SPAN_NOTICE("you finish treating your stabilized injuries."),
			SPAN_NOTICE("[user] finishes treating your stabilized injuries."),
			SPAN_NOTICE("[user] finishes treating [target]'s stabilized injuries."))

		log_interact(user, target, "[key_name(user)] tended some of [key_name(target)]'s wounds with \the [tool].")

/datum/surgery_step/mtend_wounds/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to tend [key_name(target)]'s wounds with \the [tool], possibly ending [surgery].")
	return FALSE


/datum/surgery_step/cauterize/mclamp_wound
	name = "clamp wounds"
	desc = "clamp the wounds"
	tools = SURGERY_TOOLS_MEDICOMP_CLAMP_WOUND
	time = 10 SECONDS

/datum/surgery_step/cauterize/mclamp_wound/tool_check(mob/user, obj/item/tool, datum/surgery/surgery)
	. = ..()
	if((. in tools_lit) && !tool.heat_source)
		return FALSE

/datum/surgery_step/cauterize/mclamp_wound/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.affected_message(target,
		SPAN_NOTICE("You prepair yourself for the pain of closing your wounds with \the [tool]s."),
		SPAN_NOTICE("[user] begins to clamp your wounds with \the [tool]."),
		SPAN_NOTICE("[user] begins to clamp [target]'s wounds with \the [tool]."))

/datum/surgery_step/cauterize/mclamp_wound/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	target.heal_overall_damage(150,150) //makes sure that all damage is healed if they have no damage at this stage they will not loud roar

	if(!target.getBruteLoss() && !target.getFireLoss())
		user.affected_message(target,
		SPAN_DANGER("You clamp your wounds OH THE PAIN!."),
		SPAN_DANGER("[user] clamps your wounds with \the [tool]."),
		SPAN_NOTICE("[user] clamps the [target]'s wounds."))

	if(isYautja(target))
		target.emote("loudroar")
	else
		target.emote("pain")

	target.incision_depths[target_zone] = SURGERY_DEPTH_SURFACE
	target.pain.recalculate_pain()
	log_interact(user, target, "[key_name(user)] clamed a wound in [key_name(target)]'s [surgery.affected_limb.display_name], ending [surgery].")

/datum/surgery_step/cauterize/mclamp_wound/failure(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	log_interact(user, target, "[key_name(user)] failed to tend [key_name(target)]'s wounds with \the [tool], possibly ending [surgery].")
	return FALSE

