From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 6/8 v2] mm: memcontrol: move kmem accounting code to
 CONFIG_MEMCG
Date: Thu, 10 Dec 2015 15:50:11 -0500
Message-ID: <20151210205011.GA4967@cmpxchg.org>
References: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
 <1449599665-18047-7-git-send-email-hannes@cmpxchg.org>
 <20151210202244.GA4809@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151210202244.GA4809-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Narf. Almost there...

From db4522b2b3e6ca8ce5f6e673948772bcd8fdd298 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date: Thu, 10 Dec 2015 15:42:54 -0500
Subject: [PATCH] mm: memcontrol: move kmem accounting code to CONFIG_MEMCG fix

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 include/linux/slab.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 3ffee74..3627d5c 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -86,7 +86,7 @@
 #else
 # define SLAB_FAILSLAB		0x00000000UL
 #endif
-#ifdef CONFIG_MEMCG_KMEM
+#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 # define SLAB_ACCOUNT		0x04000000UL	/* Account to memcg */
 #else
 # define SLAB_ACCOUNT		0x00000000UL
-- 
2.6.3
