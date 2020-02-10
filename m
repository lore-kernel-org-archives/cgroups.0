From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fix for v5.6-rc1
Date: Mon, 10 Feb 2020 17:55:12 -0500
Message-ID: <20200210225512.GA9161@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=E1/oZoQh9QL4yRF08kP3BiVhpoqJi/RGcTjwu+hD+Uo=;
        b=hI0yzy9uB34lReOpIUa5bR1hl6htD9hFShmppKuHKpzTUWMiE2XXybmh47ht49a69Z
         DRVjdJQgObSRd3M5Dd7zQ5Sfa6PqijHkp6UQjrvMYEiYsmB6IrYIjXg/1sE9Z2eB/pcu
         z71MpR8mvJ5cp9hdOEos3Lx1GFowwlwB8OV0SoNWu9BgPfznqvjqaD9hJA3u4xcBj3C6
         y9gkhGNuixfSRke92qLBiFkAIVTA3ER8EBezXSx1+1H+4276sK80/6Bx7WYNCAzNGtRV
         4v2juLna4MVQPLpxHypsZC9Oh6URw9f7nqYOzN8Zd9Q3q/p2TPkgFbFcF4Jw1l7c8vSo
         L4gA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

I made a mistake while removing cgroup task list lazy init
optimization making the root cgroup.procs show entries for the
init_tasks. The 0 entries doesn't cause critical failures but does
make systemd print out warning messages during boot. Fix it by
omitting init_tasks as they should be.

Thanks.

The following changes since commit 39bed42de2e7d74686a2d5a45638d6a5d7e7d473:

  Merge tag 'for-linus-hmm' of git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma (2020-01-29 19:56:50 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.6-fixes

for you to fetch changes up to 0cd9d33ace336bc424fc30944aa3defd6786e4fe:

  cgroup: init_tasks shouldn't be linked to the root cgroup (2020-01-30 11:37:33 -0500)

----------------------------------------------------------------
Tejun Heo (1):
      cgroup: init_tasks shouldn't be linked to the root cgroup

 kernel/cgroup/cgroup.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b3744872263e..cf8a36bdf5c8 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5932,11 +5932,14 @@ void cgroup_post_fork(struct task_struct *child)
 
 	spin_lock_irq(&css_set_lock);
 
-	WARN_ON_ONCE(!list_empty(&child->cg_list));
-	cset = task_css_set(current); /* current is @child's parent */
-	get_css_set(cset);
-	cset->nr_tasks++;
-	css_set_move_task(child, NULL, cset, false);
+	/* init tasks are special, only link regular threads */
+	if (likely(child->pid)) {
+		WARN_ON_ONCE(!list_empty(&child->cg_list));
+		cset = task_css_set(current); /* current is @child's parent */
+		get_css_set(cset);
+		cset->nr_tasks++;
+		css_set_move_task(child, NULL, cset, false);
+	}
 
 	/*
 	 * If the cgroup has to be frozen, the new task has too.  Let's set

