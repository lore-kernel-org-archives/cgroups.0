From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: lock assert fails in dev_exception_clean()
Date: Wed, 23 Jan 2013 09:29:39 -0500
Message-ID: <20130123142939.GC17632@redhat.com>
References: <1358460018-14717-1-git-send-email-jerry.snitselaar@oracle.com>
 <1358460018-14717-2-git-send-email-jerry.snitselaar@oracle.com>
 <20130117220642.GE16568@mtj.dyndns.org>
 <20130117231341.GA14588@cantor.us.oracle.com>
 <20130123043140.GA5913@cantor.us.oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130123043140.GA5913-w8wXvOoPVbZpWwPY5x2yo1aTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jerry Snitselaar <jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Jerry,
On Tue, Jan 22, 2013 at 09:31:41PM -0700, Jerry Snitselaar wrote:
> The original patch I sent to James and lkml got pulled in to linus. Is
> the correct thing to do here put the list cleanup code back in
> devcgroup_css_free and drop the call to dev_exception_clean along with
> change my patch made like this?

I think this is what was suggested (not tested):

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
Aristeu
