From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] cgroup: move a check to parse_cgroupfs_options()
Date: Thu, 22 Dec 2011 16:43:19 +0800
Message-ID: <4EF2EDA7.4010004@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Always check the validity of mount options in parse_cgroupfs_options().

No functional change.

Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 kernel/cgroup.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4936d88..bdb7994 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1218,7 +1218,6 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	    (opts->subsys_bits & mask))
 		return -EINVAL;
 
-
 	/* Can't specify "none" and some subsystems */
 	if (opts->subsys_bits && opts->none)
 		return -EINVAL;
@@ -1231,6 +1230,13 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 		return -EINVAL;
 
 	/*
+	 * This can happen only when none of the subsystems is enabled
+	 * in the system.
+	 */
+	if (!opts->subsys_bits && !opts->none)
+		return -EINVAL;
+
+	/*
 	 * Grab references on all the modules we'll need, so the subsystems
 	 * don't dance around before rebind_subsystems attaches them. This may
 	 * take duplicate reference counts on a subsystem that's already used,
@@ -1401,9 +1407,6 @@ static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
 {
 	struct cgroupfs_root *root;
 
-	if (!opts->subsys_bits && !opts->none)
-		return NULL;
-
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root)
 		return ERR_PTR(-ENOMEM);
@@ -1442,10 +1445,6 @@ static int cgroup_set_super(struct super_block *sb, void *data)
 	int ret;
 	struct cgroup_sb_opts *opts = data;
 
-	/* If we don't have a new root, we can't set up a new sb */
-	if (!opts->new_root)
-		return -EINVAL;
-
 	BUG_ON(!opts->subsys_bits && !opts->none);
 
 	ret = set_anon_super(sb, NULL);
-- 
1.7.3.1
