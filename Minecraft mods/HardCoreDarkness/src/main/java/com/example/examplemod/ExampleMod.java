package com.example.examplemod;

import java.util.Collection;

import net.minecraft.client.Minecraft;
import net.minecraft.client.entity.EntityPlayerSP;
import net.minecraft.init.Blocks;
import net.minecraft.potion.PotionEffect;
import net.minecraft.util.text.TextComponentTranslation;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.common.Mod.EventHandler;
import net.minecraftforge.fml.common.event.FMLInitializationEvent;

@Mod(modid = ExampleMod.MODID, version = ExampleMod.VERSION)
public class ExampleMod
{
    public static final String MODID = "examplemod";
    public static final String VERSION = "1.0";
    
    @EventHandler
    public void init(FMLInitializationEvent event)
    {
        // some example code
        System.out.println("DIRT BLOCK >> "+Blocks.DIRT.getUnlocalizedName());
        

		EntityPlayerSP player = Minecraft.getMinecraft().player;

		Collection<PotionEffect> effects = player.getActivePotionEffects();
		
		boolean pass = true;
		
        for (PotionEffect potionEffect : effects) {
        	if(potionEffect.getEffectName().equals("Night Vision")) {
        		pass = false;
        		break;
        	}
		}
        
        
    }
}
