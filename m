From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: remove unneeded return value of cgroup_rm_cftypes_locked()
Date: Sat, 1 Jul 2023 15:38:56 +0800
Message-ID: <20230701073856.2095425-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

The return value of cgroup_rm_cftypes_locked() is always 0. So remove
it to simplify the code. No functional change intended.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index bfe3cd8ccf36..b0d98542eea2 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4320,14 +4320,13 @@ static int cgroup_init_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	return ret;
 }
 
-static int cgroup_rm_cftypes_locked(struct cftype *cfts)
+static void cgroup_rm_cftypes_locked(struct cftype *cfts)
 {
 	lockdep_assert_held(&cgroup_mutex);
 
 	list_del(&cfts->node);
 	cgroup_apply_cftypes(cfts, false);
 	cgroup_exit_cftypes(cfts);
-	return 0;
 }
 
 /**
@@ -4343,8 +4342,6 @@ static int cgroup_rm_cftypes_locked(struct cftype *cfts)
  */
 int cgroup_rm_cftypes(struct cftype *cfts)
 {
-	int ret;
-
 	if (!cfts || cfts[0].name[0] == '\0')
 		return 0;
 
@@ -4352,9 +4349,9 @@ int cgroup_rm_cftypes(struct cftype *cfts)
 		return -ENOENT;
 
 	cgroup_lock();
-	ret = cgroup_rm_cftypes_locked(cfts);
+	cgroup_rm_cftypes_locked(cfts);
 	cgroup_unlock();
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.33.0

