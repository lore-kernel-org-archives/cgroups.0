From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v3.14-rc5
Date: Sat, 8 Mar 2014 10:32:09 -0500
Message-ID: <20140308153209.GC25021@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=UA3OVDYRevB04Tx8PimmJQ2tZhl9FjyAWrqa15ZAfEA=;
        b=xDOOf0w+pijCoeYMHPL/fq2yjilQQQ/QKs6X4HvOpDAuCrfbShIli7EYspMP/kpzyR
         lzLE2XMcvAPgDJIzC85X6tphvYHLYq2qF4EFZF1MKGzEkQGzuD3u//6akort+j9+m23n
         lg4h3ZGzAjSdZhvz61uerQ0ZtaKAKFKa23rDZFsTpGk+G1Gl6TdGwkQnIw4mrSQ2bDt3
         vwcsm/OrnUZxozOPiVd66pXFyv4G03W6SZAxfnM7L+dmFhxNhAoZs5cdP7RCORcsRffJ
         FTQAMJxzL3vcLjeA5pt63VRDLw98z18q+UvxSdA1Tqd1TqCsDtiu5gDX/MuaMcyS6q03
         Tf8w==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Two cpuset locking fixes from Li.  Both tagged for -stable.

The following changes since commit 532de3fc72adc2a6525c4d53c07bf81e1732083d:

  cgroup: update cgroup_enable_task_cg_lists() to grab siglock (2014-02-18 18:23:18 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.14-fixes

for you to fetch changes up to 99afb0fd5f05aac467ffa85c36778fec4396209b:

  cpuset: fix a race condition in __cpuset_node_allowed_softwall() (2014-02-27 09:39:54 -0500)

Thanks.

----------------------------------------------------------------
Li Zefan (2):
      cpuset: fix a locking issue in cpuset_migrate_mm()
      cpuset: fix a race condition in __cpuset_node_allowed_softwall()

 kernel/cpuset.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4410ac6..e6b1b66 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -974,12 +974,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
  *    Temporarilly set tasks mems_allowed to target nodes of migration,
  *    so that the migration code can allocate pages on these nodes.
  *
- *    Call holding cpuset_mutex, so current's cpuset won't change
- *    during this call, as manage_mutex holds off any cpuset_attach()
- *    calls.  Therefore we don't need to take task_lock around the
- *    call to guarantee_online_mems(), as we know no one is changing
- *    our task's cpuset.
- *
  *    While the mm_struct we are migrating is typically from some
  *    other task, the task_struct mems_allowed that we are hacking
  *    is for our current task, which must allocate new pages for that
@@ -996,8 +990,10 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 
 	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
 
+	rcu_read_lock();
 	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
 	guarantee_online_mems(mems_cs, &tsk->mems_allowed);
+	rcu_read_unlock();
 }
 
 /*
@@ -2486,9 +2482,9 @@ int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 
 	task_lock(current);
 	cs = nearest_hardwall_ancestor(task_cs(current));
+	allowed = node_isset(node, cs->mems_allowed);
 	task_unlock(current);
 
-	allowed = node_isset(node, cs->mems_allowed);
 	mutex_unlock(&callback_mutex);
 	return allowed;
 }
