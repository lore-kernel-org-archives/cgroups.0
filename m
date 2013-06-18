From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cgroup: fix memory leak in cgroup_rm_cftypes()
Date: Tue, 18 Jun 2013 18:41:53 +0800
Message-ID: <51C03971.7000008@huawei.com>
References: <51C03913.5020008@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C03913.5020008-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

The memory allocated in cgroup_add_cftypes() should be freed. The
effect of this bug is we leak a bit memory everytime we unload
cfq-iosched module if blkio cgroup is enabled.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e2dcf08..1d5b1d6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2879,7 +2879,8 @@ int cgroup_rm_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 
 	list_for_each_entry(set, &ss->cftsets, node) {
 		if (set->cfts == cfts) {
-			list_del_init(&set->node);
+			list_del(&set->node);
+			kfree(set);
 			cgroup_cfts_commit(ss, cfts, false);
 			return 0;
 		}
-- 
1.8.0.2
