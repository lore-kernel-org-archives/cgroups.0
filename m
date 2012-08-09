From: aris@ruivo.org
Subject: [PATCH RESEND 2/4] device_cgroup: introduce dev_whitelist_clean()
Date: Thu, 09 Aug 2012 15:04:16 -0400
Message-ID: <20120809190415.269834380@muttley.lan.cathedral>
References: <20120809190414.773462171@muttley.lan.cathedral>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=introduce_whitelist_clean.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>

This function cleans all the items in a whitelist and will be used by the next
patches.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

Index: github/security/device_cgroup.c
===================================================================
--- github.orig/security/device_cgroup.c	2012-07-24 17:16:00.085156162 -0400
+++ github/security/device_cgroup.c	2012-07-24 17:58:42.984081909 -0400
@@ -154,6 +154,22 @@
 	}
 }
 
+/**
+ * dev_whitelist_clean - frees all entries of the whitelist
+ * @dev_cgroup: dev_cgroup with the whitelist to be cleaned
+ *
+ * called under devcgroup_mutex
+ */
+static void dev_whitelist_clean(struct dev_cgroup *dev_cgroup)
+{
+	struct dev_whitelist_item *wh, *tmp;
+
+	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
+		list_del(&wh->list);
+		kfree(wh);
+	}
+}
+
 /*
  * called from kernel/cgroup.c with cgroup_lock() held.
  */
@@ -200,13 +216,9 @@
 static void devcgroup_destroy(struct cgroup *cgroup)
 {
 	struct dev_cgroup *dev_cgroup;
-	struct dev_whitelist_item *wh, *tmp;
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
-	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
-		list_del(&wh->list);
-		kfree(wh);
-	}
+	dev_whitelist_clean(dev_cgroup);
 	kfree(dev_cgroup);
 }
 
