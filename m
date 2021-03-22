From: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 01/11] x86: compressed: avoid gcc-11 -Wstringop-overread warning
Date: Mon, 22 Mar 2021 17:02:39 +0100
Message-ID: <20210322160253.4032422-2-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429000;
        bh=3vH1tW/3dz/29rKeu66QIybhctPu7u2aaTt+yHw+ixQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRbsfgY+z8kWvWs+txugnu/XzSTF1os4UBObTbMaVvuShG2tPdw5ChRNTsdoitI1c
         Os5gXEmTV19Hh0dH4sglqm/fSEpSE1o+cdD5mtmVZ292EJ017mpHo8q2zl1C63RDvy
         9IP52tHZwWSskub+gnvqqJxnuA90avLg12n2yst/hTpywQNyH7pGS5SlpLOCg1l1zv
         SC2S1tGwIlfSqI7YXPTsk7il0mAFtLumFo7AO2H+payHYwT3xe1jEFpNJbjQ5KEMrV
         fL6MEJv6J7008Lwon/8167XZUtB/IGdDaiFW7a3KldjWew3Xisi5j0MtsrpiR6liOq
         jy3MXhpKCZK+w==
In-Reply-To: <20210322160253.4032422-1-arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, ath11k-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

gcc gets confused by the comparison of a pointer to an integer listeral,
with the assumption that this is an offset from a NULL pointer and that
dereferencing it is invalid:

In file included from arch/x86/boot/compressed/misc.c:18:
In function ‘parse_elf’,
    inlined from ‘extract_kernel’ at arch/x86/boot/compressed/misc.c:442:2:
arch/x86/boot/compressed/../string.h:15:23: error: ‘__builtin_memcpy’ reading 64 bytes from a region of size 0 [-Werror=stringop-overread]
   15 | #define memcpy(d,s,l) __builtin_memcpy(d,s,l)
      |                       ^~~~~~~~~~~~~~~~~~~~~~~
arch/x86/boot/compressed/misc.c:283:9: note: in expansion of macro ‘memcpy’
  283 |         memcpy(&ehdr, output, sizeof(ehdr));
      |         ^~~~~~

I could not find any good workaround for this, but as this is only
a warning for a failure during early boot, removing the line entirely
works around the warning.

This should probably get addressed in gcc instead, before 11.1 gets
released.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 arch/x86/boot/compressed/misc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 3a214cc3239f..9ada64e66cb7 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -430,8 +430,6 @@ asmlinkage __visible void *extract_kernel(void *rmode, memptr heap,
 		error("Destination address too large");
 #endif
 #ifndef CONFIG_RELOCATABLE
-	if ((unsigned long)output != LOAD_PHYSICAL_ADDR)
-		error("Destination address does not match LOAD_PHYSICAL_ADDR");
 	if (virt_addr != LOAD_PHYSICAL_ADDR)
 		error("Destination virtual address changed when not relocatable");
 #endif
-- 
2.29.2

