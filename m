From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] update memory cgroup maintainer
Date: Thu, 24 Nov 2011 09:38:57 +0900
Message-ID: <20111124093857.c350d90f.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Daisuke Nishimura <nishmura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From 4bd0eecce89671dc379c17d66e010ce97d4bcba5 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Thu, 24 Nov 2011 09:41:31 +0900
Subject: [PATCH] update memory cgroup maintainer.

More players joined to memory cgroup developments and Johannes'
great work changed internal design of memory cgroup dramatically.
And he will do more works. Michal Hokko did many bug fixes and
know memory cgroup very well. Daisuke Nishimura helped us very
much but he seems busy now. Thanks to his works.


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Acked-by: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
---
 MAINTAINERS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3523ab0..6d2a8db 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4311,8 +4311,9 @@ F:	include/linux/mm.h
 F:	mm/
 
 MEMORY RESOURCE CONTROLLER
+M:	Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
+M:	Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
 M:	Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
-M:	Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
 M:	KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
 L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 L:	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
-- 
1.7.4.1


--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
