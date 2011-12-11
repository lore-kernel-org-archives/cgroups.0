From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH] make clone_children a flag
Date: Sun, 11 Dec 2011 15:45:35 +0100
Message-ID: <1323614738-7405-2-git-send-email-glommer@parallels.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323614738-7405-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

There is no reason to have a flags field, and then a separate
bool field just to indicate if the clone_children flag is set.
Make it a flag

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 kernel/cgroup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e4b9d3c..fa405ee 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -231,6 +231,7 @@ inline int cgroup_is_removed(const struct cgroup *cgrp)
 /* bits in struct cgroupfs_root flags field */
 enum {
 	ROOT_NOPREFIX, /* mounted subsystems have no named prefix */
+	ROOT_CLONE_CHILDREN, /* mounted subsystems starts with clone_children */
 };
 
 static int cgroup_is_releasable(const struct cgroup *cgrp)
@@ -1062,7 +1063,6 @@ struct cgroup_sb_opts {
 	unsigned long subsys_bits;
 	unsigned long flags;
 	char *release_agent;
-	bool clone_children;
 	char *name;
 	/* User explicitly requested empty subsystem */
 	bool none;
@@ -1113,7 +1113,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			continue;
 		}
 		if (!strcmp(token, "clone_children")) {
-			opts->clone_children = true;
+			set_bit(ROOT_CLONE_CHILDREN, &opts->flags);
 			continue;
 		}
 		if (!strncmp(token, "release_agent=", 14)) {
@@ -1400,7 +1400,7 @@ static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
 		strcpy(root->release_agent_path, opts->release_agent);
 	if (opts->name)
 		strcpy(root->name, opts->name);
-	if (opts->clone_children)
+	if (test_bit(ROOT_CLONE_CHILDREN, &opts->flags))
 		set_bit(CGRP_CLONE_CHILDREN, &root->top_cgroup.flags);
 	return root;
 }
-- 
1.7.6.4

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
