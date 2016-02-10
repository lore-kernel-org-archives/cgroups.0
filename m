From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] cgroup: provide cgroup_nov1= to disable controllers in v1 mounts
Date: Wed, 10 Feb 2016 17:59:55 -0500
Message-ID: <1455145195-7553-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Testing cgroup2 can be painful with system software automatically
mounting and populating all cgroup controllers in v1 mode. Sometimes
they can be unmounted from rc.local, sometimes even that is too late.

Provide a commandline option to disable certain controllers in v1
mounts, so that they remain available for cgroup2 mounts.

Example use:

cgroup_nov1=memory,cpu
cgroup_nov1=all

Disabling will be confirmed at boot-time as such:

[    0.013770] Disabling cpu control group subsystem in v1 mounts
[    0.016004] Disabling memory control group subsystem in v1 mounts

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 kernel/cgroup.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d27904c193da..44ff23a10235 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -180,6 +180,9 @@ EXPORT_SYMBOL_GPL(cgrp_dfl_root);
  */
 static bool cgrp_dfl_root_visible;
 
+/* Controllers blocked by the commandline in v1 */
+static unsigned long cgroup_nov1_mask;
+
 /* some controllers are not supported in the default hierarchy */
 static unsigned long cgrp_dfl_root_inhibit_ss_mask;
 
@@ -241,6 +244,11 @@ static bool cgroup_ssid_enabled(int ssid)
 	return static_key_enabled(cgroup_subsys_enabled_key[ssid]);
 }
 
+static bool cgroup_ssid_nov1(int ssid)
+{
+	return cgroup_nov1_mask & (1 << ssid);
+}
+
 /**
  * cgroup_on_dfl - test whether a cgroup is on the default hierarchy
  * @cgrp: the cgroup of interest
@@ -1678,6 +1686,8 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 				continue;
 			if (!cgroup_ssid_enabled(i))
 				continue;
+			if (cgroup_ssid_nov1(i))
+				continue;
 
 			/* Mutually exclusive option 'all' + subsystem name */
 			if (all_ss)
@@ -1698,7 +1708,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	 */
 	if (all_ss || (!one_ss && !opts->none && !opts->name))
 		for_each_subsys(ss, i)
-			if (cgroup_ssid_enabled(i))
+			if (cgroup_ssid_enabled(i) && !cgroup_ssid_nov1(i))
 				opts->subsys_mask |= (1 << i);
 
 	/*
@@ -5324,6 +5334,10 @@ int __init cgroup_init(void)
 			continue;
 		}
 
+		if (cgroup_ssid_nov1(ssid))
+			printk(KERN_INFO "Disabling %s control group subsystem in v1 mounts\n",
+			       ss->name);
+
 		cgrp_dfl_root.subsys_mask |= 1 << ss->id;
 
 		if (!ss->dfl_cftypes)
@@ -5750,6 +5764,33 @@ static int __init cgroup_disable(char *str)
 }
 __setup("cgroup_disable=", cgroup_disable);
 
+static int __init cgroup_nov1(char *str)
+{
+	struct cgroup_subsys *ss;
+	char *token;
+	int i;
+
+	while ((token = strsep(&str, ",")) != NULL) {
+		if (!*token)
+			continue;
+
+		if (!strcmp(token, "all")) {
+			cgroup_nov1_mask = ~0UL;
+			break;
+		}
+
+		for_each_subsys(ss, i) {
+			if (strcmp(token, ss->name) &&
+			    strcmp(token, ss->legacy_name))
+				continue;
+
+			cgroup_nov1_mask |= 1 << i;
+		}
+	}
+	return 1;
+}
+__setup("cgroup_nov1=", cgroup_nov1);
+
 /**
  * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
  * @dentry: directory dentry of interest
-- 
2.7.1
