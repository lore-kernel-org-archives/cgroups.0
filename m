From: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 04/11] ath11: Wstringop-overread warning
Date: Mon, 22 Mar 2021 17:02:42 +0100
Message-ID: <20210322160253.4032422-5-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429056;
        bh=n4YjjyF/BQX1oLI53brWrn/ZFErJefAlbdz/B6a/LhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJL0qpPDqSs2z7UPLYK5QVJo9sc76O7NWlWo5JPHSsPqGyDVDF4pF7hWXIkB1JA75
         QpQt35+7BgO8L8Mn3URqgy3oEgZ8mXFVdUTizaV6t4aX9h9ExQGoEX/rwcyz2jamB2
         scTuPUkDJISJZufdWGtFTIeZztxCxD3lXQOLujQyrS4sySOSS+Y/vZY+qg8LWnqJQL
         I/Aimz84KOYue+E+Dz/GzEJ2kjYrLgh/PeozYrKn1GELVG7ePD4iEbNB0WU3el9Rvz
         crDXO284w80Ehtcr/BjQheDrwVIVIOc3LE73CNZdbBcsVLFqijc8sIiXIjFKbmSQwm
         LtmW3NkvnLTfA==
In-Reply-To: <20210322160253.4032422-1-arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, ath11k-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Carl Huang <cjhuang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Maharaja Kennadyrajan <mkenna-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

gcc-11 with the kernel address sanitizer prints a warning for this
driver:

In function 'ath11k_peer_assoc_h_vht',
    inlined from 'ath11k_peer_assoc_prepare' at drivers/net/wireless/ath/ath11k/mac.c:1632:2:
drivers/net/wireless/ath/ath11k/mac.c:1164:13: error: 'ath11k_peer_assoc_h_vht_masked' reading 16 bytes from a region of size 4 [-Werror=stringop-overread]
 1164 |         if (ath11k_peer_assoc_h_vht_masked(vht_mcs_mask))
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
drivers/net/wireless/ath/ath11k/mac.c:1164:13: note: referencing argument 1 of type 'const u16 *' {aka 'const short unsigned int *'}
drivers/net/wireless/ath/ath11k/mac.c:969:1: note: in a call to function 'ath11k_peer_assoc_h_vht_masked'
  969 | ath11k_peer_assoc_h_vht_masked(const u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

According to analysis from gcc developers, this is a glitch in the
way gcc tracks the size of struct members. This should really get
fixed in gcc, but it's also easy to work around this instance
by changing the function prototype to no include the length of
the array.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99673
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index b391169576e2..5cb7ed53f3c4 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -966,7 +966,7 @@ ath11k_peer_assoc_h_ht_masked(const u8 ht_mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
 }
 
 static bool
-ath11k_peer_assoc_h_vht_masked(const u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
+ath11k_peer_assoc_h_vht_masked(const u16 vht_mcs_mask[])
 {
 	int nss;
 
-- 
2.29.2

