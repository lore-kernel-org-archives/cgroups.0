From: Jerry Snitselaar <jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] device_cgroup: don't grab mutex in rcu callback
Date: Wed, 23 Jan 2013 10:17:06 -0700
Message-ID: <1358961426-8482-1-git-send-email-jerry.snitselaar@oracle.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

commit 103a197 "security/device_cgroup: lock assert fails in
dev_exception_clean()" grabs devcgroup_mutex to fix assert failure,
but mutex can't be grabbed in rcu callback. Since there shouldn't be
any other references when css_free is called, mutex isn't needed for
list cleanup in devcgroup_css_free().

Signed-off-by: Jerry Snitselaar <jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 security/device_cgroup.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index d794abc..1c69e38 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -159,6 +159,16 @@ static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
 	}
 }
 
+static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
+{
+	struct dev_exception_item *ex, *tmp;
+
+	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
+		list_del_rcu(&ex->list);
+		kfree_rcu(ex, rcu);
+	}
+}
+
 /**
  * dev_exception_clean - frees all entries of the exception list
  * @dev_cgroup: dev_cgroup with the exception list to be cleaned
@@ -167,14 +177,9 @@ static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
  */
 static void dev_exception_clean(struct dev_cgroup *dev_cgroup)
 {
-	struct dev_exception_item *ex, *tmp;
-
 	lockdep_assert_held(&devcgroup_mutex);
 
-	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
-		list_del_rcu(&ex->list);
-		kfree_rcu(ex, rcu);
-	}
+	__dev_exception_clean(dev_cgroup);
 }
 
 /*
@@ -215,9 +220,7 @@ static void devcgroup_css_free(struct cgroup *cgroup)
 	struct dev_cgroup *dev_cgroup;
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
-	mutex_lock(&devcgroup_mutex);
-	dev_exception_clean(dev_cgroup);
-	mutex_unlock(&devcgroup_mutex);
+	__dev_exception_clean(dev_cgroup);
 	kfree(dev_cgroup);
 }
 
-- 
1.8.1.1.293.gfe73786
