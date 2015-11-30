From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] MAINTAINERS: make Vladimir co-maintainer of the memory controller
Date: Mon, 30 Nov 2015 13:29:30 -0500
Message-ID: <1448908170-2990-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Vladimir architected and authored much of the current state of the
memcg's slab memory accounting and tracking. Make sure he gets CC'd
on bug reports ;-)

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ea17512..f97f17f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2973,6 +2973,7 @@ F:	kernel/cpuset.c
 CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
 M:	Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
 M:	Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
+M:	Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
 L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 L:	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
 S:	Maintained
-- 
2.6.2
