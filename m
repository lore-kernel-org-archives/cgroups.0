From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning
Date: Wed,  2 Feb 2022 22:31:03 -0500
Message-ID: <20220203033103.773030-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643859081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Wc8dl729Kfw/oo6FN8HrQApuGc0MHf1g6N7P5YsZBDw=;
        b=IdeG2VNr99Zpj4+6sgCVyBC+dBR2S1g+88Q1ELFgOstq7FWc9Kh1Eg9NKwdIVQLRIVg7Cx
        i9bYlYUvao9DVX3M5mLrZSyEqaRVnt5mui/2lXpqubUzRPHY3M3HCMIqMhIZGHFTfLk6gc
        bifAvrOI+tTkA0OMg66iUb3jWvf6O5U=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It was found that a "suspicious RCU usage" lockdep warning was issued
with the rcu_read_lock() call in update_sibling_cpumasks().  It is
because the update_cpumasks_hier() function may sleep. So we have
to release the RCU lock, call update_cpumasks_hier() and reacquire
it afterward.

Also add a percpu_rwsem_assert_held() in update_sibling_cpumasks()
instead of stating that in the comment.

Fixes: 4716909cc5c5 ("cpuset: Track cpusets that use parent's effective_cpus")
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index dc653ab26e50..b147acece984 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1522,10 +1522,15 @@ static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
 	struct cpuset *sibling;
 	struct cgroup_subsys_state *pos_css;
 
+	percpu_rwsem_assert_held(&cpuset_rwsem);
+
 	/*
 	 * Check all its siblings and call update_cpumasks_hier()
 	 * if their use_parent_ecpus flag is set in order for them
 	 * to use the right effective_cpus value.
+	 *
+	 * The update_cpumasks_hier() function may sleep. So we have to
+	 * release the RCU read lock before calling it.
 	 */
 	rcu_read_lock();
 	cpuset_for_each_child(sibling, pos_css, parent) {
@@ -1533,8 +1538,13 @@ static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
 			continue;
 		if (!sibling->use_parent_ecpus)
 			continue;
+		if (!css_tryget_online(&sibling->css))
+			continue;
 
+		rcu_read_unlock();
 		update_cpumasks_hier(sibling, tmp);
+		rcu_read_lock();
+		css_put(&sibling->css);
 	}
 	rcu_read_unlock();
 }
-- 
2.27.0

