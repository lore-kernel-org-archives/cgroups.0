From: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 11/11] [RFC] drm/i915/dp: fix array overflow warning
Date: Mon, 22 Mar 2021 17:02:49 +0100
Message-ID: <20210322160253.4032422-12-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429143;
        bh=ppc9fZupOrjA6hpvzPGCige1HMZi82rKq0OzuPiwp30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfNQhB8I6TCilI9rWZIUvrD60VxxXK7zzzf2CzYQVcPCX4dTFC+5vrq57/HXue9eN
         7bPBi+K09Uuo8FgLHJN5cLADDDnPtd+D6sEhJhO/VLvKBoLaRa1BESfKHtMpZuvnwh
         D3Vc4uZU9Dcg74j9eeiZa4qkcbeOz2ZvcezhMcicUmJ4FzCGExiFKR4ER32CvaOaWV
         akMTcdJNfGrFGH5JvGZ7qns0oNxpRTzGH0qZ76EqyoQfhjLJvxqyHurET1PBvf6svb
         dBMESSwDo3iJsmPDGBQ1mVtfw03/ahNqDciEznfWOfvZZJNzU8YYxi4I1doMFPdTRo
         oo8eGNoKcMUqQ==
In-Reply-To: <20210322160253.4032422-1-arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, ath11k-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Manasi

From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

gcc-11 warns that intel_dp_check_mst_status() has a local array of
fourteen bytes and passes the last four bytes into a function that
expects a six-byte array:

drivers/gpu/drm/i915/display/intel_dp.c: In function ‘intel_dp_check_mst_status’:
drivers/gpu/drm/i915/display/intel_dp.c:4556:22: error: ‘drm_dp_channel_eq_ok’ reading 6 bytes from a region of size 4 [-Werror=stringop-overread]
 4556 |                     !drm_dp_channel_eq_ok(&esi[10], intel_dp->lane_count)) {
      |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/display/intel_dp.c:4556:22: note: referencing argument 1 of type ‘const u8 *’ {aka ‘const unsigned char *’}
In file included from drivers/gpu/drm/i915/display/intel_dp.c:38:
include/drm/drm_dp_helper.h:1459:6: note: in a call to function ‘drm_dp_channel_eq_ok’
 1459 | bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
      |      ^~~~~~~~~~~~~~~~~~~~

Clearly something is wrong here, but I can't quite figure out what.
Changing the array size to 16 bytes avoids the warning, but is
probably the wrong solution here.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 8c12d5375607..830e2515f119 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -65,7 +65,7 @@
 #include "intel_vdsc.h"
 #include "intel_vrr.h"
 
-#define DP_DPRX_ESI_LEN 14
+#define DP_DPRX_ESI_LEN 16
 
 /* DP DSC throughput values used for slice count calculations KPixels/s */
 #define DP_DSC_PEAK_PIXEL_RATE			2720000
-- 
2.29.2

