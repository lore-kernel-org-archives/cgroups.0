From: Chen Hanxiao <chenhanxiao-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] cgroup: fix some comment typos
Date: Thu, 23 Apr 2015 07:57:33 -0400
Message-ID: <1429790253-4085-1-git-send-email-chenhanxiao@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

s/effctive/effective
s/hierarhcy/hierarchy
s/shoulid/should

Signed-off-by: Chen Hanxiao <chenhanxiao-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 kernel/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 469dd54..cfa27f9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -261,7 +261,7 @@ static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
  * @cgrp: the cgroup of interest
  * @ss: the subsystem of interest (%NULL returns @cgrp->self)
  *
- * Similar to cgroup_css() but returns the effctive css, which is defined
+ * Similar to cgroup_css() but returns the effective css, which is defined
  * as the matching css of the nearest ancestor including self which has @ss
  * enabled.  If @ss is associated with the hierarchy @cgrp is on, this
  * function is guaranteed to return non-NULL css.
@@ -882,7 +882,7 @@ static void cgroup_exit_root_id(struct cgroup_root *root)
 static void cgroup_free_root(struct cgroup_root *root)
 {
 	if (root) {
-		/* hierarhcy ID shoulid already have been released */
+		/* hierarchy ID should already have been released */
 		WARN_ON_ONCE(root->hierarchy_id);
 
 		idr_destroy(&root->cgroup_idr);
-- 
2.1.0
