From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH net] net-memcg: avoid stalls when under memory pressure
Date: Fri, 21 Oct 2022 09:03:04 -0700
Message-ID: <20221021160304.1362511-1-kuba@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666368189;
        bh=mjKnHfLQjBlbvgpLol/1LWK9s0GkVbW/aDGXHQEartA=;
        h=From:To:Cc:Subject:Date:From;
        b=XwJkqipGOdIzv7igVzFUFb0oRs0SN7Oy/WNGfjSG7Nyufm4DwZbVC8uVwdaiT0QbV
         HSvXPxYzFs0wTZ53rAeJzTn90EyU4h0pBxrE58kmtE1x0b0sgEo5i08Jsd6rXDYbTI
         2ryzmWiShlJjaKfopjbGSkkbFlk82w1AGiN/CrA/pEeehc3DHDdZ1/z7wMmRFamxJ7
         UY3J49us43UayMH8+uo5hXHFlUYWJ0aLfke8c52A0co7OHmAH6IzGdaer30GdKIfGd
         QgT+deK1VRhkWBpIaLqCv75oVS3Q1LxCT4HKbmPfI6MieWIJLtBytUBrWD30NFEGjR
         T+PCH4ctByqxQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ncardwell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ycheng-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

As Shakeel explains the commit under Fixes had the unintended
side-effect of no longer pre-loading the cached memory allowance.
Even tho we previously dropped the first packet received when
over memory limit - the consecutive ones would get thru by using
the cache. The charging was happening in batches of 128kB, so
we'd let in 128kB (truesize) worth of packets per one drop.

After the change we no longer force charge, there will be no
cache filling side effects. This causes significant drops and
connection stalls for workloads which use a lot of page cache,
since we can't reclaim page cache under GFP_NOWAIT.

Some of the latency can be recovered by improving SACK reneg
handling but nowhere near enough to get back to the pre-5.15
performance (the application I'm experimenting with still
sees 5-10x worst latency).

Apply the suggested workaround of using GFP_ATOMIC. We will now
be more permissive than previously as we'll drop _no_ packets
in softirq when under pressure. But I can't think of any good
and simple way to address that within networking.

Link: https://lore.kernel.org/all/20221012163300.795e7b86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
Suggested-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Fixes: 4b1327be9fe5 ("net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()")
Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
CC: weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
CC: shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
CC: ncardwell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
CC: ycheng-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 9e464f6409a7..22f8bab583dd 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2585,7 +2585,7 @@ static inline gfp_t gfp_any(void)
 
 static inline gfp_t gfp_memcg_charge(void)
 {
-	return in_softirq() ? GFP_NOWAIT : GFP_KERNEL;
+	return in_softirq() ? GFP_ATOMIC : GFP_KERNEL;
 }
 
 static inline long sock_rcvtimeo(const struct sock *sk, bool noblock)
-- 
2.37.3

