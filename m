From: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: missing rcu read lock around task_css_set
Date: Sat,  1 Mar 2014 22:00:11 -0500
Message-ID: <1393729211-937-1-git-send-email-sasha.levin@oracle.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

rcu read lock should be held when calling and working with task_css_set.

This patch also fixes a related lockdep warning.

Signed-off-by: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8f4ddbe..f638ad6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4361,6 +4361,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 	}
 
 	/* Reassign the task to the init_css_set. */
+	rcu_read_lock();
 	cset = task_css_set(tsk);
 	RCU_INIT_POINTER(tsk->cgroups, &init_css_set);
 
@@ -4378,6 +4379,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 
 	if (put_cset)
 		put_css_set(cset, true);
+	rcu_read_unlock();
 }
 
 static void check_for_release(struct cgroup *cgrp)
-- 
1.7.2.5
