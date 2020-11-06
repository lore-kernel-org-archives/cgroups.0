From: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH] cgroup/cgroup.c: replace 'of->kn->priv' with of_cft()
Date: Fri, 6 Nov 2020 22:47:40 +0800
Message-ID: <20201106144740.GA9692@rlk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=lcBJi
        p8ZNNvvSPADxy2tq0eOE8BhPbgY2uyruI3Bgms=; b=JWk5wGPQXlpX8nNKA/ARa
        vBuaMqLarm1G1WPJdbB9RJAgWydHW5CR3Tm/QZo3G/Tv67ogyLSyNpKckp8M10WG
        TQAViSZDY9fW0Xm4j2LXN1Bn+i/OZuAqP3ISd9QJ+Nyz3ZaNNwTzzz4b2tlTXZiF
        lQbu3sT5RkIOVx68MtMyKc=
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sh_def-9Onoh4P/yGk@public.gmane.org

we have supplied the inline function: of_cft() in cgroup.h.

So replace the direct use 'of->kn->priv' with inline func
of_cft(), which is more readable.

Signed-off-by: Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e41c21819ba0..078d7f167890 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3657,7 +3657,7 @@ static ssize_t cgroup_freeze_write(struct kernfs_open_file *of,
 
 static int cgroup_file_open(struct kernfs_open_file *of)
 {
-	struct cftype *cft = of->kn->priv;
+	struct cftype *cft = of_cft(of);
 
 	if (cft->open)
 		return cft->open(of);
@@ -3666,7 +3666,7 @@ static int cgroup_file_open(struct kernfs_open_file *of)
 
 static void cgroup_file_release(struct kernfs_open_file *of)
 {
-	struct cftype *cft = of->kn->priv;
+	struct cftype *cft = of_cft(of);
 
 	if (cft->release)
 		cft->release(of);
@@ -3677,7 +3677,7 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 {
 	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup *cgrp = of->kn->parent->priv;
-	struct cftype *cft = of->kn->priv;
+	struct cftype *cft = of_cft(of);
 	struct cgroup_subsys_state *css;
 	int ret;
 
@@ -3727,7 +3727,7 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 
 static __poll_t cgroup_file_poll(struct kernfs_open_file *of, poll_table *pt)
 {
-	struct cftype *cft = of->kn->priv;
+	struct cftype *cft = of_cft(of);
 
 	if (cft->poll)
 		return cft->poll(of, pt);
-- 
2.29.0


