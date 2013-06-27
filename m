From: Holger Brunck <holger.brunck-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Subject: cgroups and SCHED_IDLE
Date: Thu, 27 Jun 2013 19:17:06 +0200
Message-ID: <51CC7392.8080701@keymile.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Germs, Frits (extern)" <Frits.Germs-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>

Hi all,
I entered a problem when using cgroups on a powerpc board, but I think it's a
general problem or question.

Whats the status of tasks which are running with SCHED_IDLE and cgroups? The
kernel configuration for CGROUPS distinguishes between SCHED_OTHER and
SCHED_RT/FIFO. SCHED_IDLE isn't mentioned at all. If I create two threads which
are creating load on the cpu with SCHED_IDLE I see that they are sharing the CPU
load. If I move one of this tasks to a cgroup I saw that afterwards this task
eats up (more or less) all of the CPU load and the other one is starving, even
if both are still SCHED_IDLE.

It's easy to reproduce with this script (at least on my single 32 bit ppc cpu),
which set up a cgroup sets the current shell to SCHED_IDLE, create a task move
this one to the cgroup and start the second one:

mount -t tmpfs cgroup_root /sys/fs/cgroup
mkdir /sys/fs/cgroup/cpu
mount -t cgroup -ocpu none /sys/fs/cgroup/cpu
cd /sys/fs/cgroup/cpu
mkdir browser
echo $$ | xargs chrt -i -p 0
dd if=/dev/zero of=/dev/null &
pgrep ^dd$ > browser/tasks
dd if=/dev/zero of=/dev/null &

If you start top you will see that the first dd process eats up the CPU time.

If you skip moving the task you would see that both tasks consumes the same load.

So my question is. Is this a bug or is it forbidden to move a task into a
specific cgroup? If the second statement is true  then it may be good to deny
such a request e.g.:

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a7c9e6d..b475315 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2149,6 +2149,11 @@ retry_find_task:
                rcu_read_unlock();
                goto out_unlock_cgroup;
        }
+       if (tsk->policy == SCHED_IDLE) {
+               ret = -EPERM;
+               rcu_read_unlock();
+               goto out_unlock_cgroup;
+       }

        get_task_struct(tsk);
        rcu_read_unlock();

Any opinion on this?

Best regards
Holger
