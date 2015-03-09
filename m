From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v4.0-rc3
Date: Mon, 9 Mar 2015 08:13:53 -0400
Message-ID: <20150309121353.GS13283@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=CT+YrV0DOh+OtyIbnRZamV4tANNMGY80IpWzMDVvVxU=;
        b=N1lQk36vFLOFlJjcFCM+eqLIpH5oY1zTDb74lfpjBRbZpAKVfZqtnF3OwuVjP0n8sc
         qWtECOQDAX9jKhnQxgzwifyZDA69aXzSfGcYbaulEXukz+vn18noiNh5iplzB3v8kimq
         hcD9DMoYdwwvf/fypisqQ2qaLsWGR16Uymdprqi0I1cxdWgTlSw/XtLJpjBZPyrgBdXY
         lZQ6ZbFYQZYwxTXHKxFPvPIaZp+ea2fJn5zCMcjtLyzAbLdAJyBTNlurDc8ceIzNRy/c
         ukrrx6uyXQN5FGpW6kkpwuV3kDLgEy7NTAsSFFqBnBM57HDVYOFdLxugIozj/eTipYs9
         yH3w==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

The cgroup iteration update two years ago and the recent cpuset
restructuring introduced regressions in subset of cpuset
configurations.  Three patches to fix them.  All are marked for
-stable.

Thanks.

The following changes since commit c517d838eb7d07bbe9507871fab3931deccff539:

  Linux 4.0-rc1 (2015-02-22 18:21:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.0-fixes

for you to fetch changes up to 283cb41f426b723a0255702b761b0fc5d1b53a81:

  cpuset: Fix cpuset sched_relax_domain_level (2015-03-02 11:55:04 -0500)

----------------------------------------------------------------
Jason Low (1):
      cpuset: Fix cpuset sched_relax_domain_level

Zefan Li (2):
      cpuset: initialize effective masks when clone_children is enabled
      cpuset: fix a warning when clearing configured masks in old hierarchy

 kernel/cpuset.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1d1fe93..fc7f474 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -548,9 +548,6 @@ static void update_domain_attr_tree(struct sched_domain_attr *dattr,
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, root_cs) {
-		if (cp == root_cs)
-			continue;
-
 		/* skip the whole subtree if @cp doesn't have any CPU */
 		if (cpumask_empty(cp->cpus_allowed)) {
 			pos_css = css_rightmost_descendant(pos_css);
@@ -873,7 +870,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 		 * If it becomes empty, inherit the effective mask of the
 		 * parent, which is guaranteed to have some CPUs.
 		 */
-		if (cpumask_empty(new_cpus))
+		if (cgroup_on_dfl(cp->css.cgroup) && cpumask_empty(new_cpus))
 			cpumask_copy(new_cpus, parent->effective_cpus);
 
 		/* Skip the whole subtree if the cpumask remains the same. */
@@ -1129,7 +1126,7 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 		 * If it becomes empty, inherit the effective mask of the
 		 * parent, which is guaranteed to have some MEMs.
 		 */
-		if (nodes_empty(*new_mems))
+		if (cgroup_on_dfl(cp->css.cgroup) && nodes_empty(*new_mems))
 			*new_mems = parent->effective_mems;
 
 		/* Skip the whole subtree if the nodemask remains the same. */
@@ -1979,7 +1976,9 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 
 	spin_lock_irq(&callback_lock);
 	cs->mems_allowed = parent->mems_allowed;
+	cs->effective_mems = parent->mems_allowed;
 	cpumask_copy(cs->cpus_allowed, parent->cpus_allowed);
+	cpumask_copy(cs->effective_cpus, parent->cpus_allowed);
 	spin_unlock_irq(&callback_lock);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
