From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix to break the while loop in cgroup_attach_task()
 correctly
Date: Sat, 12 Oct 2013 10:59:17 +0800
Message-ID: <5258BB05.8030106@huawei.com>
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com> <20131004130207.GA9338@redhat.com> <20131007184507.GD27396@htj.dyndns.org> <20131008145833.GA15600@redhat.com> <5254EB2A.7090803@huawei.com> <20131009133047.GA12414@redhat.com> <20131009140551.GA15849@redhat.com> <20131009165448.GA22437@redhat.com> <5257F9E3.5030708@huawei.com> <20131011160004.GA26416@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131011160004.GA26416-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eunki_kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org

From: Anjana V Kumar <anjanavk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Both Anjana and Eunki reported a stall in the while_each_thread loop
in cgroup_attach_task().

It's because, when we attach a single thread to a cgroup, if the cgroup
is exiting or is already in that cgroup, we won't break the loop.

If the task is already in the cgroup, the bug can lead to another thread
being attached to the cgroup unexpectedly:

  # echo 5207 > tasks
  # cat tasks
  5207
  # echo 5207 > tasks
  # cat tasks
  5207
  5215

What's worse, if the task to be attached isn't the leader of the thread
group, we might never exit the loop, hence cpu stall. Thanks for Oleg's
analysis.

This bug was introduced by commit 081aa458c38ba576bdd4265fc807fa95b48b9e79
("cgroup: consolidate cgroup_attach_task() and cgroup_attach_proc()")

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.9+
Reported-by: Eunki Kim <eunki_kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Reported-by: Anjana V Kumar <anjanavk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Anjana V Kumar <anjanavk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
[ lizf: - fixed the first continue, pointed out by Oleg,
        - rewrote changelog. ]
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5629f1..3db1d2e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2002,7 +2002,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 
 		/* @tsk either already exited or can't exit until the end */
 		if (tsk->flags & PF_EXITING)
-			continue;
+			goto next;
 
 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
@@ -2010,7 +2010,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 		ent.cgrp = task_cgroup_from_root(tsk, root);
 		/* nothing to do if this task is already in the cgroup */
 		if (ent.cgrp == cgrp)
-			continue;
+			goto next;
 		/*
 		 * saying GFP_ATOMIC has no effect here because we did prealloc
 		 * earlier, but it's good form to communicate our expectations.
@@ -2018,7 +2018,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
 		BUG_ON(retval != 0);
 		i++;
-
+next:
 		if (!threadgroup)
 			break;
 	} while_each_thread(leader, tsk);
-- 
1.8.0.2
