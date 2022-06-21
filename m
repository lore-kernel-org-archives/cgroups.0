From: Lin Feng <linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup.c: remove redundant check for mixable cgroup in cgroup_migrate_vet_dst
Date: Tue, 21 Jun 2022 17:23:58 +0800
Message-ID: <20220621092358.223594-1-linf@wangsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org

We have:
int cgroup_migrate_vet_dst(struct cgroup *dst_cgrp)
{
...
	/* mixables don't care */
	if (cgroup_is_mixable(dst_cgrp))
		return 0;

	/*
	 * If @dst_cgrp is already or can become a thread root or is
	 * threaded, it doesn't matter.
	 */
	if (cgroup_can_be_thread_root(dst_cgrp) || cgroup_is_threaded(dst_cgrp))
		return 0;
...
}

but in fact the entry of cgroup_can_be_thread_root() covers case that
checking cgroup_is_mixable() as following:
static bool cgroup_can_be_thread_root(struct cgroup *cgrp)
{
        /* mixables don't care */
        if (cgroup_is_mixable(cgrp))
                return true;
...
}

so explicitly checking in cgroup_migrate_vet_dst is unnecessary.

Signed-off-by: Lin Feng <linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1779ccddb734..ad4aa08ec988 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2570,10 +2570,6 @@ int cgroup_migrate_vet_dst(struct cgroup *dst_cgrp)
 	if (!cgroup_is_valid_domain(dst_cgrp->dom_cgrp))
 		return -EOPNOTSUPP;
 
-	/* mixables don't care */
-	if (cgroup_is_mixable(dst_cgrp))
-		return 0;
-
 	/*
 	 * If @dst_cgrp is already or can become a thread root or is
 	 * threaded, it doesn't matter.
-- 
2.31.1

