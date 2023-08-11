From: Li kunyu <kunyu-5L972MDCkn1Wk0Htik3J/w@public.gmane.org>
Subject: [PATCH] =?UTF-8?q?cgroup:=20cgroup:=20Remove=20unnecessary=20?= =?UTF-8?q?=E2=80=980=E2=80=99=20values=20from=20ret?=
Date: Fri, 11 Aug 2023 09:16:39 -0000 (UTC)
Message-ID: <20230813014734.2916-1-kunyu@nfschina.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date: Sun, 13 Aug 2023 09:47:34 +0800
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li kunyu <kunyu-5L972MDCkn1Wk0Htik3J/w@public.gmane.org>

ret is assigned first, so it does not need to initialize the assignment.

Signed-off-by: Li kunyu <kunyu-5L972MDCkn1Wk0Htik3J/w@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f55a40db065f..cdda2a147d6b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2859,7 +2859,7 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 {
 	DEFINE_CGROUP_MGCTX(mgctx);
 	struct task_struct *task;
-	int ret = 0;
+	int ret;
 
 	/* look up all src csets */
 	spin_lock_irq(&css_set_lock);
@@ -3945,7 +3945,7 @@ static void cgroup_kill(struct cgroup *cgrp)
 static ssize_t cgroup_kill_write(struct kernfs_open_file *of, char *buf,
 				 size_t nbytes, loff_t off)
 {
-	ssize_t ret = 0;
+	ssize_t ret;
 	int kill;
 	struct cgroup *cgrp;
 
@@ -5083,7 +5083,7 @@ static int cgroup_attach_permissions(struct cgroup *src_cgrp,
 				     struct super_block *sb, bool threadgroup,
 				     struct cgroup_namespace *ns)
 {
-	int ret = 0;
+	int ret;
 
 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp, sb, ns);
 	if (ret)
@@ -5921,7 +5921,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 int cgroup_rmdir(struct kernfs_node *kn)
 {
 	struct cgroup *cgrp;
-	int ret = 0;
+	int ret;
 
 	cgrp = cgroup_kn_lock_live(kn, false);
 	if (!cgrp)
@@ -6995,7 +6995,7 @@ static ssize_t delegate_show(struct kobject *kobj, struct kobj_attribute *attr,
 {
 	struct cgroup_subsys *ss;
 	int ssid;
-	ssize_t ret = 0;
+	ssize_t ret;
 
 	ret = show_delegatable_files(cgroup_base_files, buf + ret,
 				     PAGE_SIZE - ret, NULL);
-- 
2.18.2

