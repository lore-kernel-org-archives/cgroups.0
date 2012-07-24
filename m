From: Aristeu Rozanski <aris-moeOTchvdi7YtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/4] device_cgroup: add "deny_all" in dev_cgroup structure
Date: Tue, 24 Jul 2012 18:03:34 -0400
Message-ID: <20120724220334.256148145@muttley.lan.cathedral>
References: <20120724220333.966415895@muttley.lan.cathedral>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=deny_all.patch
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

deny_all will determine if the default policy is to deny all device access
unless for the ones in the exception list.

This variable will be used in the next patches to convert device_cgroup
internally into a default policy + rules.

Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
 security/device_cgroup.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: github/security/device_cgroup.c
===================================================================
--- github.orig/security/device_cgroup.c	2012-07-24 17:15:58.277108951 -0400
+++ github/security/device_cgroup.c	2012-07-24 17:16:00.085156162 -0400
@@ -42,6 +42,7 @@
 struct dev_cgroup {
 	struct cgroup_subsys_state css;
 	struct list_head whitelist;
+	bool deny_all;
 };
 
 static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
@@ -178,12 +179,14 @@
 		wh->minor = wh->major = ~0;
 		wh->type = DEV_ALL;
 		wh->access = ACC_MASK;
+		dev_cgroup->deny_all = false;
 		list_add(&wh->list, &dev_cgroup->whitelist);
 	} else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
 		mutex_lock(&devcgroup_mutex);
 		ret = dev_whitelist_copy(&dev_cgroup->whitelist,
 				&parent_dev_cgroup->whitelist);
+		dev_cgroup->deny_all = parent_dev_cgroup->deny_all;
 		mutex_unlock(&devcgroup_mutex);
 		if (ret) {
 			kfree(dev_cgroup);
@@ -409,9 +412,11 @@
 	case DEVCG_ALLOW:
 		if (!parent_has_perm(devcgroup, &wh))
 			return -EPERM;
+		devcgroup->deny_all = false;
 		return dev_whitelist_add(devcgroup, &wh);
 	case DEVCG_DENY:
 		dev_whitelist_rm(devcgroup, &wh);
+		devcgroup->deny_all = true;
 		break;
 	default:
 		return -EINVAL;
