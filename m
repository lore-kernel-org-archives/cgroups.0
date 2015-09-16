From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] cgroup: implement static_key based cgroup_subsys_enabled() and cgroup_subsys_on_dfl()
Date: Tue, 15 Sep 2015 21:51:23 -0400
Message-ID: <1442368285-16306-3-git-send-email-tj@kernel.org>
References: <1442368285-16306-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H+Silj4uXGq50R4mUDjfrx2Fi3nzBdXthaAxaIh9RrY=;
        b=CY0pbF5SrI27SkM/IHNMZnXdrmgOpp6nCsaR8tBwamv7koNeQMIYT11WZaj5ry3xdm
         CTq4csqbr8VtilEz7PWaxQ+sLrHeqeGvk04sVG508hyPLbxSa4DKuGnW9/LU/+xSPJFR
         4tJNFhvyyD4n37yWEidPAALQ7ENOQ/rpcMS/TEmYFTZNmICBHQmYRuXBXz1wYeyoWPjo
         WCRjmF/5zYJ7RUUL23Hfu35JY7EspWGTlggAZDCYIyR+1w6PBeqCYi6nN9nT43TcW7TC
         XWb1++Gfmx928HOC+BO9970b3zTaRoGcmhc57DO+2cav+MmHsGkR1IpKPR8ftqYbX04M
         A1Uw==
In-Reply-To: <1442368285-16306-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Whether a subsys is enabled and attached to the default hierarchy
seldom changes and may be tested in the hot paths.  This patch
implements static_key based cgroup_subsys_enabled() and
cgroup_subsys_on_dfl() tests.

The following patches will update the users and remove duplicate
mechanisms.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 21 +++++++++++++++++++++
 kernel/cgroup.c        | 27 ++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index eb7ca55..c3a9f1e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/kernfs.h>
+#include <linux/jump_label.h>
 
 #include <linux/cgroup-defs.h>
 
@@ -50,6 +51,26 @@ extern struct css_set init_css_set;
 #include <linux/cgroup_subsys.h>
 #undef SUBSYS
 
+#define SUBSYS(_x)								\
+	extern struct static_key_true _x ## _cgrp_subsys_enabled_key;		\
+	extern struct static_key_true _x ## _cgrp_subsys_on_dfl_key;
+#include <linux/cgroup_subsys.h>
+#undef SUBSYS
+
+/**
+ * cgroup_subsys_enabled - fast test on whether a subsys is enabled
+ * @ss: subsystem in question
+ */
+#define cgroup_subsys_enabled(ss)						\
+	static_branch_likely(&ss ## _enabled_key)
+
+/**
+ * cgroup_subsys_on_dfl - fast test on whether a subsys is on default hierarchy
+ * @ss: subsystem in question
+ */
+#define cgroup_subsys_on_dfl(ss)						\
+	static_branch_likely(&ss ## _on_dfl_key)
+
 bool css_has_online_children(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss);
 struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgroup,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2cf0f79..3619389 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -139,6 +139,27 @@ static const char *cgroup_subsys_name[] = {
 };
 #undef SUBSYS
 
+/* array of static_keys for cgroup_subsys_enabled() and cgroup_subsys_on_dfl() */
+#define SUBSYS(_x)								\
+	DEFINE_STATIC_KEY_TRUE(_x ## _cgrp_subsys_enabled_key);			\
+	DEFINE_STATIC_KEY_TRUE(_x ## _cgrp_subsys_on_dfl_key);			\
+	EXPORT_SYMBOL_GPL(_x ## _cgrp_subsys_enabled_key);			\
+	EXPORT_SYMBOL_GPL(_x ## _cgrp_subsys_on_dfl_key);
+#include <linux/cgroup_subsys.h>
+#undef SUBSYS
+
+#define SUBSYS(_x) [_x ## _cgrp_id] = &_x ## _cgrp_subsys_enabled_key,
+static struct static_key_true *cgroup_subsys_enabled_key[] = {
+#include <linux/cgroup_subsys.h>
+};
+#undef SUBSYS
+
+#define SUBSYS(_x) [_x ## _cgrp_id] = &_x ## _cgrp_subsys_on_dfl_key,
+static struct static_key_true *cgroup_subsys_on_dfl_key[] = {
+#include <linux/cgroup_subsys.h>
+};
+#undef SUBSYS
+
 /*
  * The default hierarchy, reserved for the subsystems that are otherwise
  * unattached - it never has more than a single cgroup, and all tasks are
@@ -1319,9 +1340,12 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 
 		/* default hierarchy doesn't enable controllers by default */
 		dst_root->subsys_mask |= 1 << ssid;
-		if (dst_root != &cgrp_dfl_root) {
+		if (dst_root == &cgrp_dfl_root) {
+			static_branch_enable(cgroup_subsys_on_dfl_key[ssid]);
+		} else {
 			dst_root->cgrp.subtree_control |= 1 << ssid;
 			cgroup_refresh_child_subsys_mask(&dst_root->cgrp);
+			static_branch_disable(cgroup_subsys_on_dfl_key[ssid]);
 		}
 
 		if (ss->bind)
@@ -5483,6 +5507,7 @@ static int __init cgroup_disable(char *str)
 			    strcmp(token, ss->legacy_name))
 				continue;
 
+			static_branch_disable(cgroup_subsys_enabled_key[i]);
 			ss->disabled = 1;
 			printk(KERN_INFO "Disabling %s control group subsystem\n",
 			       ss->name);
-- 
2.4.3
