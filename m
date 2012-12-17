From: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [RFC PATCH 8/9] cgroup: disallow container to change top cgroup's subsys files
Date: Mon, 17 Dec 2012 14:43:34 +0800
Message-ID: <1355726615-15224-9-git-send-email-gaofeng@cn.fujitsu.com>
References: <1355726615-15224-1-git-send-email-gaofeng@cn.fujitsu.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1355726615-15224-1-git-send-email-gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

this patch disallows container to change top cgroup's
subsystem files,since these files are shared with host.

Signed-off-by: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 kernel/cgroup.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e077660..b0caa1d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2928,6 +2928,14 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 	}
 
 	mode = cgroup_file_mode(cft);
+	/*
+	 * Disallow container to change it's top cgroup's subsys files,
+	 * since these files are shared with host.
+	 */
+	if (test_bit(ROOT_NAMESPACE, &cgrp->root->flags) &&
+	    cgrp == cgrp->top_cgroup)
+		mode &= ~S_IWUSR;
+
 	error = cgroup_create_file(dentry, mode | S_IFREG, cgrp->root->sb);
 	if (!error) {
 		cfe->type = (void *)cft;
-- 
1.7.7.6
