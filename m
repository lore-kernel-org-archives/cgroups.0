From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 1/4] don't trigger warning when d_subdirs is not empty.
Date: Tue, 20 Mar 2012 20:50:53 +0400
Message-ID: <1332262256-13407-2-git-send-email-glommer@parallels.com>
References: <1332262256-13407-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332262256-13407-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

It is never empty at this point, because of the self references.
a better test is to see if any of them gets d_inode set.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index cf7b298..b45a653 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -947,10 +947,16 @@ static int cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 static void cgroup_clear_directory(struct dentry *dir)
 {
 	struct cgroup *cgrp = __d_cgrp(dir);
+	struct list_head *child;
 
 	while (!list_empty(&cgrp->files))
 		cgroup_rm_file(cgrp, NULL);
-	WARN_ON_ONCE(!list_empty(&dir->d_subdirs));
+
+	list_for_each(child, &dir->d_subdirs) {
+		struct dentry *d;
+		d = list_entry(child, struct dentry, d_u.d_child);
+		WARN_ON_ONCE(d->d_inode);
+	}
 }
 
 /*
-- 
1.7.7.6
