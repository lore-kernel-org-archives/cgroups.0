From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC][PATCH 8/9 v2] cgroup: avoid creating new cgroup under a cgroup
 being destroyed
Date: Fri, 27 Apr 2012 15:04:14 +0900
Message-ID: <4F9A36DE.30301@jp.fujitsu.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F9A327A.6050409-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

When ->pre_destroy() is called, it should be guaranteed that
new child cgroup is not created under a cgroup, where pre_destroy()
is running. If not, ->pre_destroy() must check children and
return -EBUSY, which causes warning.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 kernel/cgroup.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7a3076b..003ceed 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3970,6 +3970,15 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	mutex_lock(&cgroup_mutex);
 
+	/*
+	 * prevent making child cgroup when ->pre_destroy() is running.
+	 */
+	if (test_bit(CGRP_WAIT_ON_RMDIR, &parent->flags)) {
+		mutex_unlock(&cgroup_mutex);
+		atomic_dec(&sb->s_active);
+		return -EBUSY;
+	}
+
 	init_cgroup_housekeeping(cgrp);
 
 	cgrp->parent = parent;
-- 
1.7.4.1

