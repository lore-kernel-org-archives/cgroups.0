From: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 07/11] ARM: sharpsl_param: work around -Wstringop-overread warning
Date: Mon, 22 Mar 2021 17:02:45 +0100
Message-ID: <20210322160253.4032422-8-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429094;
        bh=xAtyylaIqASvvaS85ZKuu0hXHauLkQxCojv0RLX/Mb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qF3TQ/qAB99dHQJQ17LkEWSGHzxXaa6ah0V394Zl3kvv8RzfyZLGR5LrTvWyC7H1A
         Y/FGboTYdhxs+1JdIoA84vXMKDdcAhTrEkBBb0UQUQKweCwvIzhlEQaLj3V5+EtINN
         TkIcf5XVjUiGPrExh51GxNaO8HstdwbBZt6yPypCRTLZ7dgkDLCsQKmQNcTUMokkXV
         S8QQatAQDJMuuHsGK0sG76w09rCi8u76J/NCDygW1XdPiFPESnsqpJ4LRffqASyFiK
         CjWew/HiP9HZ5pWACV/kafDp0YkSlO5krvl5NtQtLs6m/hkRHKNSKqc2U8LuhcidQu
         4FzJ0OAQMgZGg==
In-Reply-To: <20210322160253.4032422-1-arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, ath11k-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>

From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

gcc warns that accessing a pointer based on a numeric constant may
be an offset into a NULL pointer, and would therefore has zero
accessible bytes:

arch/arm/common/sharpsl_param.c: In function ‘sharpsl_save_param’:
arch/arm/common/sharpsl_param.c:43:9: error: ‘memcpy’ reading 64 bytes from a region of size 0 [-Werror=stringop-overread]
   43 |         memcpy(&sharpsl_param, param_start(PARAM_BASE), sizeof(struct sharpsl_param_info));
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this particular case, the warning is bogus since this is the actual
pointer, not an offset on a NULL pointer. Add a local variable to shut
up the warning and hope it doesn't come back.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99578
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 arch/arm/common/sharpsl_param.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/sharpsl_param.c b/arch/arm/common/sharpsl_param.c
index efeb5724d9e9..6237ede2f0c7 100644
--- a/arch/arm/common/sharpsl_param.c
+++ b/arch/arm/common/sharpsl_param.c
@@ -40,7 +40,9 @@ EXPORT_SYMBOL(sharpsl_param);
 
 void sharpsl_save_param(void)
 {
-	memcpy(&sharpsl_param, param_start(PARAM_BASE), sizeof(struct sharpsl_param_info));
+	struct sharpsl_param_info *params = param_start(PARAM_BASE);
+
+	memcpy(&sharpsl_param, params, sizeof(*params));
 
 	if (sharpsl_param.comadj_keyword != COMADJ_MAGIC)
 		sharpsl_param.comadj=-1;
-- 
2.29.2

