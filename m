From: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: 3.10.16 cgroup_mutex deadlock
Date: Mon, 11 Nov 2013 16:06:26 -0600
Message-ID: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=U3/fezr0OvjbScD8dsegNMHLrlB7LaH1vRY+RoZj7U8=;
        b=joPlB4lfG2RAbReblYr1UvwzC+dqFPz5jSiiL7tcCdnmU84hCQmVJE6KAkWfCx2epw
         svzTRgQ4iyLp8p2ZSqbu0J7SSjrV/rTBVhaWXhP9iHe/RpXW4b0gJM2md2If9A5bUcX2
         Ev0pMqY1wp2tD7GeeCujNKXZn530WoHHCsgi435wML7uNtEfkMZlALYfMA9FKeTuJM65
         1VbfW9e/Bof/GJf4USIUDnhhP/AB281capgjZAdHpQTGHPzmD2/x+PiIi3b5y++mf1+u
         vdJEKl7qSgs2mBxdzDTDUA6/5uz6jDqDbKQy9XdVUMZbhuRboc1zX4r1mSMYhHdhDijS
         t/7g==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello,

This morning I had a machine running 3.10.16 go unresponsive but
before we killed it we were able to get the information below.  I'm
not an expert here but it looks like most of the tasks below are
blocking waiting on the cgroup_mutex.  You can see that the
resource_alloca:16502 task is holding the cgroup_mutex and that task
appears to be waiting on a lru_add_drain_all() to complete.

Initially I thought the deadlock might simply be that the per cpu
workqueue work from lru_add_drain_all() is stuck waiting on the
cgroup_free_fn to complete.  However I've read
Documentation/workqueue.txt and it sounds like the current workqueue
has multiple kworker threads per cpu and thus this should not happen.
Both the cgroup_free_fn work and lru_add_dran_all() work run on the
system_wq which has max_active set to 0 so I believe multiple kworker
threads should run.  This also appears to be true since all of the
cgroup_free_fn are running on kworker/12 thread and there are multiple
blocked.

Perhaps someone with more experience in the cgroup and workqueue code
can look at the stacks below and identify the problem, or explain why
the lru_add_drain_all() work has not completed:


[694702.013850] INFO: task systemd:1 blocked for more than 120 seconds.
[694702.015794] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[694702.018217] systemd         D ffffffff81607820     0     1      0 0x00000000
[694702.020505]  ffff88041dcc1d78 0000000000000086 ffff88041dc7f100 ffffffff8110ad54
[694702.023006]  0000000000000001 ffff88041dc78000 ffff88041dcc1fd8 ffff88041dcc1fd8
[694702.025508]  ffff88041dcc1fd8 ffff88041dc78000 ffff88041a1e8698 ffffffff81a417c0
[694702.028011] Call Trace:
[694702.028788]  [<ffffffff8110ad54>] ? vma_merge+0x124/0x330
[694702.030468]  [<ffffffff814b8eb9>] schedule+0x29/0x70
[694702.032011]  [<ffffffff814b918e>] schedule_preempt_disabled+0xe/0x10
[694702.033982]  [<ffffffff814b75b2>] __mutex_lock_slowpath+0x112/0x1b0
[694702.035926]  [<ffffffff8112a2bd>] ? kmem_cache_alloc_trace+0x12d/0x160
[694702.037948]  [<ffffffff814b742a>] mutex_lock+0x2a/0x50
[694702.039546]  [<ffffffff81095b77>] proc_cgroup_show+0x67/0x1d0
[694702.041330]  [<ffffffff8115925b>] seq_read+0x16b/0x3e0
[694702.042927]  [<ffffffff811383d0>] vfs_read+0xb0/0x180
[694702.044498]  [<ffffffff81138652>] SyS_read+0x52/0xa0
[694702.046042]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
[694702.047917] INFO: task kworker/12:1:203 blocked for more than 120 seconds.
[694702.050044] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[694702.052467] kworker/12:1    D 0000000000000000     0   203      2 0x00000000
[694702.054756] Workqueue: events cgroup_free_fn
[694702.056139]  ffff88041bc1fcf8 0000000000000046 ffff88038e7b46a0 0000000300000001
[694702.058642]  ffff88041bc1fd84 ffff88041da6e9f0 ffff88041bc1ffd8 ffff88041bc1ffd8
[694702.061144]  ffff88041bc1ffd8 ffff88041da6e9f0 0000000000000087 ffffffff81a417c0
[694702.063647] Call Trace:
[694702.064423]  [<ffffffff814b8eb9>] schedule+0x29/0x70
[694702.065966]  [<ffffffff814b918e>] schedule_preempt_disabled+0xe/0x10
[694702.067936]  [<ffffffff814b75b2>] __mutex_lock_slowpath+0x112/0x1b0
[694702.069879]  [<ffffffff814b742a>] mutex_lock+0x2a/0x50
[694702.071476]  [<ffffffff810930ec>] cgroup_free_fn+0x2c/0x120
[694702.073209]  [<ffffffff81057c54>] process_one_work+0x174/0x490
[694702.075019]  [<ffffffff81058d0c>] worker_thread+0x11c/0x370
[694702.076748]  [<ffffffff81058bf0>] ? manage_workers+0x2c0/0x2c0
[694702.078560]  [<ffffffff8105f0b0>] kthread+0xc0/0xd0
[694702.080078]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694702.081995]  [<ffffffff814c20dc>] ret_from_fork+0x7c/0xb0
[694702.083671]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694702.085595] INFO: task systemd-logind:2885 blocked for more than 120 seconds.
[694702.087801] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[694702.090225] systemd-logind  D ffffffff81607820     0  2885      1 0x00000000
[694702.092513]  ffff88041ac6fd88 0000000000000082 ffff88041dd8aa60 ffff88041d9bc1a8
[694702.095014]  ffff88041ac6fda0 ffff88041cac9530 ffff88041ac6ffd8 ffff88041ac6ffd8
[694702.097517]  ffff88041ac6ffd8 ffff88041cac9530 0000000000000c36 ffffffff81a417c0
[694702.100019] Call Trace:
[694702.100793]  [<ffffffff814b8eb9>] schedule+0x29/0x70
[694702.102338]  [<ffffffff814b918e>] schedule_preempt_disabled+0xe/0x10
[694702.104309]  [<ffffffff814b75b2>] __mutex_lock_slowpath+0x112/0x1b0
[694702.198316]  [<ffffffff814b742a>] mutex_lock+0x2a/0x50
[694702.292456]  [<ffffffff8108fa6d>] cgroup_lock_live_group+0x1d/0x40
[694702.386833]  [<ffffffff810946c8>] cgroup_mkdir+0xa8/0x4b0
[694702.480679]  [<ffffffff81145ea4>] vfs_mkdir+0x84/0xd0
[694702.574124]  [<ffffffff8114791e>] SyS_mkdirat+0x5e/0xe0
[694702.666986]  [<ffffffff811479b9>] SyS_mkdir+0x19/0x20
[694702.758969]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
[694702.848295] INFO: task kworker/12:2:11512 blocked for more than 120 seconds.
[694702.935749] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[694703.023603] kworker/12:2    D ffffffff816079c0     0 11512      2 0x00000000
[694703.109993] Workqueue: events cgroup_free_fn
[694703.193213]  ffff88041b9dfcf8 0000000000000046 ffff88041da6e9f0 ffffea00106fd240
[694703.278353]  ffff88041f803c00 ffff8803824254c0 ffff88041b9dffd8 ffff88041b9dffd8
[694703.363757]  ffff88041b9dffd8 ffff8803824254c0 0000001f17887bb1 ffffffff81a417c0
[694703.448550] Call Trace:
[694703.531773]  [<ffffffff814b8eb9>] schedule+0x29/0x70
[694703.615316]  [<ffffffff814b918e>] schedule_preempt_disabled+0xe/0x10
[694703.698298]  [<ffffffff814b75b2>] __mutex_lock_slowpath+0x112/0x1b0
[694703.780456]  [<ffffffff810931cc>] ? cgroup_free_fn+0x10c/0x120
[694703.861813]  [<ffffffff814b742a>] mutex_lock+0x2a/0x50
[694703.942719]  [<ffffffff810930ec>] cgroup_free_fn+0x2c/0x120
[694704.023785]  [<ffffffff81057c54>] process_one_work+0x174/0x490
[694704.104080]  [<ffffffff81058d0c>] worker_thread+0x11c/0x370
[694704.184000]  [<ffffffff81058bf0>] ? manage_workers+0x2c0/0x2c0
[694704.264027]  [<ffffffff8105f0b0>] kthread+0xc0/0xd0
[694704.343761]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694704.423868]  [<ffffffff814c20dc>] ret_from_fork+0x7c/0xb0
[694704.503734]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694704.583766] INFO: task resource_alloca:16502 blocked for more than 120 seconds.
[694704.664964] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[694704.747361] resource_alloca D ffffffff81607820     0 16502  16467 0x00000000
[694704.831088]  ffff8803a43cda18 0000000000000086 ffffffff81a10440 ffffffff810287fe
[694704.916440]  ffff8803a43cd9c8 ffff88041ba9b170 ffff8803a43cdfd8 ffff8803a43cdfd8
[694705.002030]  ffff8803a43cdfd8 ffff88041ba9b170 ffff8803a43cda38 ffff8803a43cdb50
[694705.086265] Call Trace:
[694705.168664]  [<ffffffff810287fe>] ? physflat_send_IPI_mask+0xe/0x10
[694705.251780]  [<ffffffff814b8eb9>] schedule+0x29/0x70
[694705.334283]  [<ffffffff814b6d65>] schedule_timeout+0x195/0x1f0
[694705.415962]  [<ffffffff814b8012>] ? __schedule+0x2a2/0x740
[694705.497267]  [<ffffffff814b8715>] wait_for_completion+0xa5/0x110
[694705.578786]  [<ffffffff8106c6f0>] ? try_to_wake_up+0x270/0x270
[694705.659533]  [<ffffffff81057743>] flush_work+0xe3/0x150
[694705.739934]  [<ffffffff810558b0>] ? pool_mayday_timeout+0x100/0x100
[694705.820840]  [<ffffffff810ec7a0>] ? __pagevec_release+0x40/0x40
[694705.901615]  [<ffffffff810592c3>] schedule_on_each_cpu+0xc3/0x110
[694705.982441]  [<ffffffff810ec7c5>] lru_add_drain_all+0x15/0x20
[694706.063268]  [<ffffffff8112df6e>] migrate_prep+0xe/0x20
[694706.143986]  [<ffffffff81120d7b>] do_migrate_pages+0x2b/0x220
[694706.224840]  [<ffffffff8106839b>] ? task_rq_lock+0x5b/0xa0
[694706.305695]  [<ffffffff8125e016>] ? cpumask_next_and+0x36/0x50
[694706.386735]  [<ffffffff81096f88>] cpuset_migrate_mm+0x78/0xa0
[694706.467666]  [<ffffffff81097936>] cpuset_attach+0x296/0x310
[694706.548253]  [<ffffffff810928de>] cgroup_attach_task+0x47e/0x7a0
[694706.628732]  [<ffffffff814b741d>] ? mutex_lock+0x1d/0x50
[694706.708308]  [<ffffffff81092e87>] attach_task_by_pid+0x167/0x1a0
[694706.787271]  [<ffffffff81092ef3>] cgroup_tasks_write+0x13/0x20
[694706.864902]  [<ffffffff8108fe13>] cgroup_file_write+0x143/0x2e0
[694706.941469]  [<ffffffff8113a113>] ? __sb_start_write+0x53/0x110
[694707.018036]  [<ffffffff810f910d>] ? vm_mmap_pgoff+0x7d/0xb0
[694707.094629]  [<ffffffff8113820e>] vfs_write+0xce/0x1e0
[694707.170158]  [<ffffffff811386f2>] SyS_write+0x52/0xa0
[694707.244994]  [<ffffffff814bda2e>] ? do_page_fault+0xe/0x10
[694707.319991]  [<ffffffff814c2182>] system_call_fastpath+0x16/0x1b
[694707.395118] INFO: task kworker/12:0:24144 blocked for more than 120 seconds.
[694707.471258] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[694707.548490] kworker/12:0    D 0000000000000000     0 24144      2 0x00000000
[694707.626683] Workqueue: events cgroup_free_fn
[694707.704578]  ffff88040d8a5cf8 0000000000000046 ffff88038e7b4db0 0000000000012c80
[694707.784819]  0000000000002e7b ffff88038e7b46a0 ffff88040d8a5fd8 ffff88040d8a5fd8
[694707.866017]  ffff88040d8a5fd8 ffff88038e7b46a0 000000000000000c ffffffff81a417c0
[694707.947350] Call Trace:
[694708.027061]  [<ffffffff814b8eb9>] schedule+0x29/0x70
[694708.106747]  [<ffffffff814b918e>] schedule_preempt_disabled+0xe/0x10
[694708.185737]  [<ffffffff814b75b2>] __mutex_lock_slowpath+0x112/0x1b0
[694708.264354]  [<ffffffff814b742a>] mutex_lock+0x2a/0x50
[694708.341905]  [<ffffffff810930ec>] cgroup_free_fn+0x2c/0x120
[694708.419431]  [<ffffffff81057c54>] process_one_work+0x174/0x490
[694708.496983]  [<ffffffff81058d0c>] worker_thread+0x11c/0x370
[694708.573522]  [<ffffffff81058bf0>] ? manage_workers+0x2c0/0x2c0
[694708.649929]  [<ffffffff8105f0b0>] kthread+0xc0/0xd0
[694708.726017]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694708.802451]  [<ffffffff814c20dc>] ret_from_fork+0x7c/0xb0
[694708.878645]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694708.955132] INFO: task kworker/12:3:24145 blocked for more than 120 seconds.
[694709.032683] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[694709.111511] kworker/12:3    D 0000000000000000     0 24145      2 0x00000000
[694709.191327] Workqueue: events cgroup_free_fn
[694709.270794]  ffff880399e6fcf8 0000000000000046 ffff88038e7b54c0 0000000000012c80
[694709.352338]  0000000000002e7b ffff88038e7b4db0 ffff880399e6ffd8 ffff880399e6ffd8
[694709.434361]  ffff880399e6ffd8 ffff88038e7b4db0 000000000000000c ffffffff81a417c0
[694709.516544] Call Trace:
[694709.597775]  [<ffffffff814b8eb9>] schedule+0x29/0x70
[694709.679168]  [<ffffffff814b918e>] schedule_preempt_disabled+0xe/0x10
[694709.759888]  [<ffffffff814b75b2>] __mutex_lock_slowpath+0x112/0x1b0
[694709.839675]  [<ffffffff814b742a>] mutex_lock+0x2a/0x50
[694709.918397]  [<ffffffff810930ec>] cgroup_free_fn+0x2c/0x120
[694709.996989]  [<ffffffff81057c54>] process_one_work+0x174/0x490
[694710.076272]  [<ffffffff81058d0c>] worker_thread+0x11c/0x370
[694710.154597]  [<ffffffff81058bf0>] ? manage_workers+0x2c0/0x2c0
[694710.232443]  [<ffffffff8105f0b0>] kthread+0xc0/0xd0
[694710.309787]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694710.387874]  [<ffffffff814c20dc>] ret_from_fork+0x7c/0xb0
[694710.465882]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694710.544284] INFO: task kworker/12:4:24146 blocked for more than 120 seconds.
[694710.623592] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[694710.704151] kworker/12:4    D 0000000000000000     0 24146      2 0x00000000
[694710.785538] Workqueue: events cgroup_free_fn
[694710.866442]  ffff88041ce81cf8 0000000000000046 ffff88038e7b5bd0 0000000000012c80
[694710.949265]  0000000000002e7b ffff88038e7b54c0 ffff88041ce81fd8 ffff88041ce81fd8
[694711.032620]  ffff88041ce81fd8 ffff88038e7b54c0 000000000000000c ffffffff81a417c0
[694711.116268] Call Trace:
[694711.199224]  [<ffffffff814b8eb9>] schedule+0x29/0x70
[694711.283085]  [<ffffffff814b918e>] schedule_preempt_disabled+0xe/0x10
[694711.367344]  [<ffffffff814b75b2>] __mutex_lock_slowpath+0x112/0x1b0
[694711.451765]  [<ffffffff814b742a>] mutex_lock+0x2a/0x50
[694711.536157]  [<ffffffff810930ec>] cgroup_free_fn+0x2c/0x120
[694711.620825]  [<ffffffff81057c54>] process_one_work+0x174/0x490
[694711.705459]  [<ffffffff81058d0c>] worker_thread+0x11c/0x370
[694711.789879]  [<ffffffff81058bf0>] ? manage_workers+0x2c0/0x2c0
[694711.874566]  [<ffffffff8105f0b0>] kthread+0xc0/0xd0
[694711.959229]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694712.044502]  [<ffffffff814c20dc>] ret_from_fork+0x7c/0xb0
[694712.129694]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694712.215339] INFO: task kworker/12:5:24147 blocked for more than 120 seconds.
[694712.302557] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[694712.391077] kworker/12:5    D 0000000000000000     0 24147      2 0x00000000
[694712.480423] Workqueue: events cgroup_free_fn
[694712.568568]  ffff88040fc3fcf8 0000000000000046 ffff88038e7b62e0 0000000000012c80
[694712.657755]  0000000000002e7b ffff88038e7b5bd0 ffff88040fc3ffd8 ffff88040fc3ffd8
[694712.746434]  ffff88040fc3ffd8 ffff88038e7b5bd0 000000000000000c ffffffff81a417c0
[694712.834847] Call Trace:
[694712.921531]  [<ffffffff814b8eb9>] schedule+0x29/0x70
[694713.008695]  [<ffffffff814b918e>] schedule_preempt_disabled+0xe/0x10
[694713.096069]  [<ffffffff814b75b2>] __mutex_lock_slowpath+0x112/0x1b0
[694713.182672]  [<ffffffff814b742a>] mutex_lock+0x2a/0x50
[694713.268848]  [<ffffffff810930ec>] cgroup_free_fn+0x2c/0x120
[694713.355186]  [<ffffffff81057c54>] process_one_work+0x174/0x490
[694713.441498]  [<ffffffff81058d0c>] worker_thread+0x11c/0x370
[694713.527569]  [<ffffffff81058bf0>] ? manage_workers+0x2c0/0x2c0
[694713.613723]  [<ffffffff8105f0b0>] kthread+0xc0/0xd0
[694713.699558]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694713.785921]  [<ffffffff814c20dc>] ret_from_fork+0x7c/0xb0
[694713.872205]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694713.958940] INFO: task kworker/12:6:24148 blocked for more than 120 seconds.
[694714.046607] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[694714.135393] kworker/12:6    D 0000000000000000     0 24148      2 0x00000000
[694714.224979] Workqueue: events cgroup_free_fn
[694714.313390]  ffff88040cf13cf8 0000000000000046 ffff88038e7b69f0 0000000000012c80
[694714.402790]  0000000000002e7b ffff88038e7b62e0 ffff88040cf13fd8 ffff88040cf13fd8
[694714.491601]  ffff88040cf13fd8 ffff88038e7b62e0 000000000000000c ffffffff81a417c0
[694714.580174] Call Trace:
[694714.667046]  [<ffffffff814b8eb9>] schedule+0x29/0x70
[694714.754314]  [<ffffffff814b918e>] schedule_preempt_disabled+0xe/0x10
[694714.841716]  [<ffffffff814b75b2>] __mutex_lock_slowpath+0x112/0x1b0
[694714.928347]  [<ffffffff814b742a>] mutex_lock+0x2a/0x50
[694715.014577]  [<ffffffff810930ec>] cgroup_free_fn+0x2c/0x120
[694715.100968]  [<ffffffff81057c54>] process_one_work+0x174/0x490
[694715.187306]  [<ffffffff81058d0c>] worker_thread+0x11c/0x370
[694715.273404]  [<ffffffff81058bf0>] ? manage_workers+0x2c0/0x2c0
[694715.359553]  [<ffffffff8105f0b0>] kthread+0xc0/0xd0
[694715.445411]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
[694715.531773]  [<ffffffff814c20dc>] ret_from_fork+0x7c/0xb0
[694715.618058]  [<ffffffff8105eff0>] ? flush_kthread_worker+0xb0/0xb0
