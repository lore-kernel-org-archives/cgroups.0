From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/12] cgroup: make cgroup_drain_offline() and cgroup_apply_control_{disable|enable}() recursive
Date: Mon, 22 Feb 2016 22:45:43 -0500
Message-ID: <1456199146-14765-10-git-send-email-tj@kernel.org>
References: <1456199146-14765-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aEmkly5zIy/LEhGNsPeoW380Wy/UufpaxTkN4zODSRk=;
        b=wMu8MkLaniO5UWEgO7Rm28us+cF6cmMOCQgk2DeuQckTjLShqD/5f0i78iPvfYCFzW
         BO3A9iQfjgNoaU/NHlOj27k5KVDYKkOfN+tVITmNYP/MQkxgmt3bDJX2rmOqFBQMxT7m
         9kcdqtoZy0IB9LkBfBHhbUOcp68/ERfNsvmc6LMAEE7+eUfbHGZAOoQvUXl0tkF6jzZR
         TNJgq3M1uUpiqAKhMfYldzn+VZD5ILg4G4Dxd/VJH8bMPNvvLiHZqNqgxGnXxWWdKshW
         ynxaVHvdffa9EzYKC/LVSyaEyqjwMowBl2vPFS6SQPkemWjSjKkN73A1ofSljxXu09Ak
         F4yQ==
In-Reply-To: <1456199146-14765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

The three factored out css management operations -
cgroup_drain_offline() and cgroup_apply_control_{disable|enable}() -
only depend on the current state of the target cgroups and idempotent
and thus can be easily made to operate on the subtree instead of the
immediate children.

This patch introduces the iterators which walk live subtree and
converts the three functions to operate on the subtree including self
instead of the children.  While this leads to spurious walking and be
slightly more expensive, it will allow them to be used for wider scope
of operations.

Note that cgroup_drain_offline() now tests for whether a css is dying
before trying to drain it.  This is to avoid trying to drain live
csses as there can be mix of live and dying csses in a subtree unlike
children of the same parent.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5a5cb52..d8c8eb2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -569,6 +569,24 @@ static int notify_on_release(const struct cgroup *cgrp)
 			;						\
 		else
 
+/* walk live descendants in preorder */
+#define cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp)		\
+	css_for_each_descendant_pre((d_css), cgroup_css((cgrp), NULL))	\
+		if (({ lockdep_assert_held(&cgroup_mutex);		\
+		       (dsct) = (d_css)->cgroup;			\
+		       cgroup_is_dead(dsct); }))			\
+			;						\
+		else
+
+/* walk live descendants in postorder */
+#define cgroup_for_each_live_descendant_post(dsct, d_css, cgrp)		\
+	css_for_each_descendant_post((d_css), cgroup_css((cgrp), NULL))	\
+		if (({ lockdep_assert_held(&cgroup_mutex);		\
+		       (dsct) = (d_css)->cgroup;			\
+		       cgroup_is_dead(dsct); }))			\
+			;						\
+		else
+
 static void cgroup_release_agent(struct work_struct *work);
 static void check_for_release(struct cgroup *cgrp);
 
@@ -2962,11 +2980,11 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 
 /**
  * cgroup_drain_offline - wait for previously offlined csses to go away
- * @cgrp: parent of the target cgroups
+ * @cgrp: root of the target subtree
  *
  * Because css offlining is asynchronous, userland may try to re-enable a
  * controller while the previous css is still around.  This function drains
- * the previous css instances of @cgrp's children.
+ * the previous css instances of @cgrp's subtree.
  *
  * Must be called with cgroup_mutex held.  Returns %false if there were no
  * dying css instances.  Returns %true if there were one or more and this
@@ -2977,17 +2995,18 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 static bool cgroup_drain_offline(struct cgroup *cgrp)
 {
 	struct cgroup *dsct;
+	struct cgroup_subsys_state *d_css;
 	struct cgroup_subsys *ss;
 	int ssid;
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	cgroup_for_each_live_child(dsct, cgrp) {
+	cgroup_for_each_live_descendant_post(dsct, d_css, cgrp) {
 		for_each_subsys(ss, ssid) {
 			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
 			DEFINE_WAIT(wait);
 
-			if (!css)
+			if (!css || !percpu_ref_is_dying(&css->refcnt))
 				continue;
 
 			cgroup_get(dsct);
@@ -3009,9 +3028,9 @@ static bool cgroup_drain_offline(struct cgroup *cgrp)
 
 /**
  * cgroup_apply_control_enable - enable or show csses according to control
- * @cgrp: parent of the target cgroups
+ * @cgrp: root of the target subtree
  *
- * Walk @cgrp's children and create new csses or make the existing ones
+ * Walk @cgrp's subtree and create new csses or make the existing ones
  * visible.  A css is created invisible if it's being implicitly enabled
  * through dependency.  An invisible css is made visible when the userland
  * explicitly enables it.
@@ -3023,10 +3042,11 @@ static bool cgroup_drain_offline(struct cgroup *cgrp)
 static int cgroup_apply_control_enable(struct cgroup *cgrp)
 {
 	struct cgroup *dsct;
+	struct cgroup_subsys_state *d_css;
 	struct cgroup_subsys *ss;
 	int ssid, ret;
 
-	cgroup_for_each_live_child(dsct, cgrp) {
+	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
 		for_each_subsys(ss, ssid) {
 			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
 
@@ -3052,9 +3072,9 @@ static int cgroup_apply_control_enable(struct cgroup *cgrp)
 
 /**
  * cgroup_apply_control_disable - kill or hide csses according to control
- * @cgrp: parent of the target cgroups
+ * @cgrp: root of the target subtree
  *
- * Walk @cgrp's children and kill and hide csses so that they match
+ * Walk @cgrp's subtree and kill and hide csses so that they match
  * cgroup_ss_mask() and cgroup_visible_mask().
  *
  * A css is hidden when the userland requests it to be disabled while other
@@ -3066,10 +3086,11 @@ static int cgroup_apply_control_enable(struct cgroup *cgrp)
 static void cgroup_apply_control_disable(struct cgroup *cgrp)
 {
 	struct cgroup *dsct;
+	struct cgroup_subsys_state *d_css;
 	struct cgroup_subsys *ss;
 	int ssid;
 
-	cgroup_for_each_live_child(dsct, cgrp) {
+	cgroup_for_each_live_descendant_post(dsct, d_css, cgrp) {
 		for_each_subsys(ss, ssid) {
 			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
 
-- 
2.5.0

