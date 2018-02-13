From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH V3 10/10] sched/deadline: Prevent CPU hotplug operation if DL task on CPU
Date: Tue, 13 Feb 2018 13:32:47 -0700
Message-ID: <1518553967-20656-11-git-send-email-mathieu.poirier@linaro.org>
References: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UbhPA4pshwFydxif8sqRTcHzvw2HfoMH+EbQHDwykcA=;
        b=DVCvk9ZgdcQD0+NZcisAYqDjgZApKtpzarE0SHhAEP+eCsvDNE7jRWw+vziFuo//fK
         Gqe9w9iZ9w/L7PwaNXVeK+be+4JCB81gW+QTZKEdFOiK0tvEGXbOFsjtuSClYkzJwE78
         Elgeik8iROxXblraNm/mLY5KbNAQxq+8WSBu8=
In-Reply-To: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org
Cc: lizefan@huawei.com, mingo@redhat.com, rostedt@goodmis.org, claudio@evidence.eu.com, bristot@redhat.com, tommaso.cucinotta@santannapisa.it, juri.lelli@redhat.com, luca.abeni@santannapisa.it, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

When a DL task is assigned a CPU the "utilisation" (this_bw) and the
"active utilisation" (running_bw) fields of rq->dl are incremented
accordingly.  If the CPU is hotplugged out the DL task is transferred
to another CPU but the task's contribution to this_bw and running_bw
isn't substracted from the outgoing CPU's rq nor added to the newly
appointed CPU.

In this example (where a kernel has been instrumented to output the
relevant information) we have a 4 CPU system with one 6:10 DL task that
has been assigned to CPU 2:

	root@dragon:/home/linaro/# cat /proc/rq_debug

	dl_rq[0]:
	  .online			: yes
	  .dl_nr_running		: 0
	  .running_bw			: 0
	  .this_bw			: 0
	  .rd->span			: 0-3
	  .dl_nr_migratory		: 0
	  .rd->dl_bw->bw		: 3984588
	  .rd->dl_bw->total_bw		: 629145

	dl_rq[1]:
	  .online			: yes
	  .dl_nr_running		: 0
	  .running_bw			: 0
	  .this_bw			: 0
	  .rd->span:			: 0-3
	  .dl_nr_migratory		: 0
	  .rd->dl_bw->bw		: 3984588	<-- RD capacity for 4 CPUs
	  .rd->dl_bw->total_bw		: 629145

	dl_rq[2]:
	  .online			: yes
	  .dl_nr_running		: 1		<-- One task running
	  .running_bw			: 629145	<-- Normal behavior
	  .this_bw			: 629145	<-- Normal behavior
	  .rd->span			: 0-3
	  .dl_nr_migratory		: 1
	  .rd->dl_bw->bw		: 3984588
	  .rd->dl_bw->total_bw		: 629145

	dl_rq[3]:
	  .online			: yes
	  .dl_nr_running		: 0
	  .running_bw			: 0
	  .this_bw			: 0
	  .rd->span			: 0-3
	  .dl_nr_migratory		: 0
	  .rd->dl_bw->bw		: 3984588
	  .rd->dl_bw->total_bw		: 629145

At this point we hotplug out CPU2 and list the status again:

root@dragon:/home/linaro/# echo  0 > /sys/devices/system/cpu/cpu2/online
root@dragon:/home/linaro/# cat /proc/rq_debug

	dl_rq[0]:
	  .online			: yes
	  .dl_nr_running		: 1		<-- DL task was moved here
	  .running_bw			: 0		<-- Contribution not added
	  .this_bw			: 0		<-- Contribution not added
	  .rd->span			: 0-1,3
	  .dl_nr_migratory		: 1
	  .rd->dl_bw->bw		: 2988441	<-- RD capacity updated
	  .rd->dl_bw->total_bw		: 629145

	dl_rq[1]:
	  .online			: yes
	  .dl_nr_running		: 0
	  .running_bw			: 0
	  .this_bw			: 0
	  .rd->span			: 0-1,3
	  .dl_nr_migratory		: 0
	  .rd->dl_bw->bw		: 2988441
	  .rd->dl_bw->total_bw		: 629145

	dl_rq[2]:
	  .online			: no		<-- runqueue no longer online
	  .dl_nr_running		: 0		<-- DL task was moved
	  .running_bw			: 629145	<-- Contribution not substracted
	  .this_bw			: 629145	<-- Contribution not substracted
	  .rd->span			: 2
	  .dl_nr_migratory		: 0
	  .rd->dl_bw->bw		: 996147
	  .rd->dl_bw->total_bw		: 0

	dl_rq[3]:
	  .online			: yes
	  .dl_nr_running		: 0
	  .running_bw			: 0
	  .this_bw			: 0
	  .rd->span			: 0-1,3
	  .dl_nr_migratory		: 0
	  .rd->dl_bw->bw		: 2988441
	  .rd->dl_bw->total_bw: 629145

Upon rebooting the system a splat is also produced:

[  578.184789] ------------[ cut here ]------------
[  578.184813] dl_rq->running_bw > old
[  578.184838] WARNING: CPU: 0 PID: 4076 at /home/mpoirier/work/linaro/deadline/kernel/kernel/sched/deadline.c:98 dequeue_task_dl+0x128/0x168
[  578.191693] Modules linked in:
[  578.191705] CPU: 0 PID: 4076 Comm: burn Not tainted 4.15.0-00009-gf597fc1e5764-dirty #259
[  578.191708] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[  578.191713] pstate: 60000085 (nZCv daIf -PAN -UAO)
[  578.191718] pc : dequeue_task_dl+0x128/0x168
[  578.191722] lr : dequeue_task_dl+0x128/0x168
[  578.191724] sp : ffff8000383ebbf0
[  578.191727] x29: ffff8000383ebbf0 x28: ffff800038288000
[  578.191733] x27: 0000000000000009 x26: ffff800038890000
[  578.191739] x25: ffff800038994e60 x24: ffff800038994e00
[  578.191744] x23: 0000000000000000 x22: 0000000000000000
[  578.191749] x21: 000000000000000e x20: ffff800038288000
[  578.191755] x19: ffff80003d950aa8 x18: 0000000000000010
[  578.191761] x17: 0000000000000001 x16: 0000000000002710
[  578.191766] x15: 0000000000000006 x14: ffff0000892ed37f
[  578.191772] x13: ffff0000092ed38d x12: 0000000000000000
[  578.191778] x11: ffff8000383eb840 x10: 0000000005f5e0ff
[  578.191784] x9 : 0000000000000034 x8 : 625f676e696e6e75
[  578.191794] x7 : 723e2d71725f6c64 x6 : 000000000000016c
[  578.191800] x5 : 0000000000000000 x4 : 0000000000000000
[  578.191806] x3 : ffffffffffffffff x2 : 000080003480f000
[  578.191812] x1 : ffff800038288000 x0 : 0000000000000017
[  578.191818] Call trace:
[  578.191824]  dequeue_task_dl+0x128/0x168
[  578.191830]  sched_move_task+0xa8/0x150
[  578.191837]  sched_autogroup_exit_task+0x20/0x30
[  578.191843]  do_exit+0x2c4/0x9f8
[  578.191847]  do_group_exit+0x3c/0xa0
[  578.191853]  get_signal+0x2a4/0x568
[  578.191860]  do_signal+0x70/0x210
[  578.191866]  do_notify_resume+0xe0/0x138
[  578.191870]  work_pending+0x8/0x10
[  578.191874] ---[ end trace 345388d10dc698fe ]---

As a stop-gap measure before the real solution is available this patch
prevents users from carrying out a CPU hotplug operation if a DL task is
running (or suspended) on said CPU.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 kernel/sched/deadline.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 8eb508cf1990..c46aaa7c3569 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2741,11 +2741,16 @@ bool dl_cpu_busy(unsigned int cpu)
 	int cpus;
 
 	rcu_read_lock_sched();
+	overflow = !!(cpu_rq(cpu)->dl.this_bw);
+	if (overflow)
+		goto out;
+
 	dl_b = dl_bw_of(cpu);
 	raw_spin_lock_irqsave(&dl_b->lock, flags);
 	cpus = dl_bw_cpus(cpu);
 	overflow = __dl_overflow(dl_b, cpus, 0, 0);
 	raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+out:
 	rcu_read_unlock_sched();
 	return overflow;
 }
-- 
2.7.4

