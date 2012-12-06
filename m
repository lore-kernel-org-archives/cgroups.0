From: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] cgroup_rm_file: don't delete the uncreated files
Date: Thu, 6 Dec 2012 11:09:10 +0800
Message-ID: <1354763350-3139-1-git-send-email-gaofeng@cn.fujitsu.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

in cgroup_add_file,when creating files for cgroup,
some of creation may be skipped. So we need to avoid
deleting these uncreated files in cgroup_rm_file,
otherwise the warning msg will be triggered.

"cgroup_addrm_files: failed to remove memory_pressure_enabled, err=-2"

Signed-off-by: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 kernel/cgroup.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5cc3724..6928b3e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -932,6 +932,12 @@ static int cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 	lockdep_assert_held(&cgrp->dentry->d_inode->i_mutex);
 	lockdep_assert_held(&cgroup_mutex);
 
+	/* does @cft->flags tell us this file isn't created on @cgrp? */
+	if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgrp->parent)
+		return 0;
+	if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgrp->parent)
+		return 0;
+
 	list_for_each_entry(cfe, &cgrp->files, node) {
 		struct dentry *d = cfe->dentry;
 
-- 
1.7.7.6
