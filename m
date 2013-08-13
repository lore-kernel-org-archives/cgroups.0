From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cpuset: remove redundant checks in file write functions
Date: Tue, 13 Aug 2013 09:17:53 +0800
Message-ID: <52098941.4070600@huawei.com>
References: <5209892D.8070502@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5209892D.8070502-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Now cgroup core gets a reference to the css when a cgroup file is
opened(), and the reference is dropped at file release. so it's
guaranteed the cpuset is online during the write function.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9d8d637..8c4b3c4 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1589,8 +1589,6 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	int retval = -ENODEV;
 
 	mutex_lock(&cpuset_mutex);
-	if (!is_cpuset_online(cs))
-		goto out_unlock;
 
 	switch (type) {
 	case FILE_CPU_EXCLUSIVE:
@@ -1624,7 +1622,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 		retval = -EINVAL;
 		break;
 	}
-out_unlock:
+
 	mutex_unlock(&cpuset_mutex);
 	return retval;
 }
@@ -1637,8 +1635,6 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	int retval = -ENODEV;
 
 	mutex_lock(&cpuset_mutex);
-	if (!is_cpuset_online(cs))
-		goto out_unlock;
 
 	switch (type) {
 	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
@@ -1648,7 +1644,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 		retval = -EINVAL;
 		break;
 	}
-out_unlock:
+
 	mutex_unlock(&cpuset_mutex);
 	return retval;
 }
@@ -1677,8 +1673,6 @@ static int cpuset_write_resmask(struct cgroup_subsys_state *css,
 	flush_work(&cpuset_hotplug_work);
 
 	mutex_lock(&cpuset_mutex);
-	if (!is_cpuset_online(cs))
-		goto out_unlock;
 
 	trialcs = alloc_trial_cpuset(cs);
 	if (!trialcs) {
-- 
1.8.0.2
