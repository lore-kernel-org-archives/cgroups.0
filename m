From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Possible regression with cgroups in 3.11
Date: Thu, 10 Oct 2013 10:50:41 +0200
Message-ID: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1690680.ze7MfnVNSo"
Content-Transfer-Encoding: 7Bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is a multi-part message in MIME format.

--nextPart1690680.ze7MfnVNSo
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

I have upgraded all nodes on our computing cluster to 3.11.3 last week (from 
3.10.9) and experience deadlocks in kernel threads connected to cgroups. They 
appear sometimes, when our queuing system (slurm 2.6.0) tries to clean up its 
cgroups (using freezer, cpuset, memory and devices subsets). I have attached 
the associated kernel messages as well als the cleanup script.

Best regards,
Markus
--nextPart1690680.ze7MfnVNSo
Content-Disposition: attachment; filename="cgroups-bug.txt"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="cgroups-bug.txt"

Oct 10 00:39:48 kaa-14 kernel: [169967.617545] INFO: task kworker/7:0:5201 blocked for more than 120 seconds.
Oct 10 00:39:48 kaa-14 kernel: [169967.617557] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 10 00:39:48 kaa-14 kernel: [169967.617563] kworker/7:0     D ffff88077e873328     0  5201      2 0x00000000
Oct 10 00:39:48 kaa-14 kernel: [169967.617583] Workqueue: events cgroup_offline_fn
Oct 10 00:39:48 kaa-14 kernel: [169967.617590]  ffff8804a4129d70 0000000000000002 ffff8804adc60000 ffff8804a4129fd8
Oct 10 00:39:48 kaa-14 kernel: [169967.617599]  ffff8804a4129fd8 0000000000011c40 ffff88077e872ee0 ffffffff81634ae0
Oct 10 00:39:48 kaa-14 kernel: [169967.617608]  ffffffff81634ae4 ffff88077e872ee0 ffffffff81634ae8 00000000ffffffff
Oct 10 00:39:48 kaa-14 kernel: [169967.617617] Call Trace:
Oct 10 00:39:48 kaa-14 kernel: [169967.617634]  [<ffffffff813c57e4>] schedule+0x60/0x62
Oct 10 00:39:48 kaa-14 kernel: [169967.617645]  [<ffffffff813c5a6b>] schedule_preempt_disabled+0x13/0x1f
Oct 10 00:39:48 kaa-14 kernel: [169967.617654]  [<ffffffff813c4987>] __mutex_lock_slowpath+0x143/0x1d4
Oct 10 00:39:48 kaa-14 kernel: [169967.617665]  [<ffffffff8105a3e8>] ? arch_vtime_task_switch+0x6a/0x6f
Oct 10 00:39:48 kaa-14 kernel: [169967.617673]  [<ffffffff813c3b58>] mutex_lock+0x12/0x22
Oct 10 00:39:48 kaa-14 kernel: [169967.617681]  [<ffffffff81084f4f>] cgroup_offline_fn+0x36/0x137
Oct 10 00:39:48 kaa-14 kernel: [169967.617692]  [<ffffffff81047cb7>] process_one_work+0x15f/0x21e
Oct 10 00:39:48 kaa-14 kernel: [169967.617701]  [<ffffffff81048159>] worker_thread+0x144/0x1f0
Oct 10 00:39:48 kaa-14 kernel: [169967.617711]  [<ffffffff81048015>] ? rescuer_thread+0x275/0x275
Oct 10 00:39:48 kaa-14 kernel: [169967.617720]  [<ffffffff8104cbec>] kthread+0x88/0x90
Oct 10 00:39:48 kaa-14 kernel: [169967.617729]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.617739]  [<ffffffff813c756c>] ret_from_fork+0x7c/0xb0
Oct 10 00:39:48 kaa-14 kernel: [169967.617748]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.617756] INFO: task kworker/13:3:5243 blocked for more than 120 seconds.
Oct 10 00:39:48 kaa-14 kernel: [169967.617761] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 10 00:39:48 kaa-14 kernel: [169967.617766] kworker/13:3    D ffff880b451e9bb8     0  5243      2 0x00000000
Oct 10 00:39:48 kaa-14 kernel: [169967.617777] Workqueue: events cgroup_offline_fn
Oct 10 00:39:48 kaa-14 kernel: [169967.617782]  ffff880c07b9fd70 0000000000000002 ffff880409e2c650 ffff880c07b9ffd8
Oct 10 00:39:48 kaa-14 kernel: [169967.617790]  ffff880c07b9ffd8 0000000000011c40 ffff880b451e9770 ffffffff81634ae0
Oct 10 00:39:48 kaa-14 kernel: [169967.617798]  ffffffff81634ae4 ffff880b451e9770 ffffffff81634ae8 00000000ffffffff
Oct 10 00:39:48 kaa-14 kernel: [169967.617806] Call Trace:
Oct 10 00:39:48 kaa-14 kernel: [169967.617815]  [<ffffffff813c57e4>] schedule+0x60/0x62
Oct 10 00:39:48 kaa-14 kernel: [169967.617823]  [<ffffffff813c5a6b>] schedule_preempt_disabled+0x13/0x1f
Oct 10 00:39:48 kaa-14 kernel: [169967.617831]  [<ffffffff813c4987>] __mutex_lock_slowpath+0x143/0x1d4
Oct 10 00:39:48 kaa-14 kernel: [169967.617840]  [<ffffffff8105a3e8>] ? arch_vtime_task_switch+0x6a/0x6f
Oct 10 00:39:48 kaa-14 kernel: [169967.617848]  [<ffffffff813c3b58>] mutex_lock+0x12/0x22
Oct 10 00:39:48 kaa-14 kernel: [169967.617855]  [<ffffffff81084f4f>] cgroup_offline_fn+0x36/0x137
Oct 10 00:39:48 kaa-14 kernel: [169967.617865]  [<ffffffff81047cb7>] process_one_work+0x15f/0x21e
Oct 10 00:39:48 kaa-14 kernel: [169967.617874]  [<ffffffff81048159>] worker_thread+0x144/0x1f0
Oct 10 00:39:48 kaa-14 kernel: [169967.617883]  [<ffffffff81048015>] ? rescuer_thread+0x275/0x275
Oct 10 00:39:48 kaa-14 kernel: [169967.617891]  [<ffffffff8104cbec>] kthread+0x88/0x90
Oct 10 00:39:48 kaa-14 kernel: [169967.617901]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.617909]  [<ffffffff813c756c>] ret_from_fork+0x7c/0xb0
Oct 10 00:39:48 kaa-14 kernel: [169967.617918]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.617926] INFO: task kworker/4:3:5247 blocked for more than 120 seconds.
Oct 10 00:39:48 kaa-14 kernel: [169967.617930] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 10 00:39:48 kaa-14 kernel: [169967.617934] kworker/4:3     D ffff88080a076208     0  5247      2 0x00000000
Oct 10 00:39:48 kaa-14 kernel: [169967.617945] Workqueue: events cgroup_offline_fn
Oct 10 00:39:48 kaa-14 kernel: [169967.617949]  ffff8804abc3dd70 0000000000000002 ffff880409cc5dc0 ffff8804abc3dfd8
Oct 10 00:39:48 kaa-14 kernel: [169967.617956]  ffff8804abc3dfd8 0000000000011c40 ffff88080a075dc0 ffffffff81634ae0
Oct 10 00:39:48 kaa-14 kernel: [169967.617964]  ffffffff81634ae4 ffff88080a075dc0 ffffffff81634ae8 00000000ffffffff
Oct 10 00:39:48 kaa-14 kernel: [169967.617972] Call Trace:
Oct 10 00:39:48 kaa-14 kernel: [169967.617981]  [<ffffffff813c57e4>] schedule+0x60/0x62
Oct 10 00:39:48 kaa-14 kernel: [169967.617989]  [<ffffffff813c5a6b>] schedule_preempt_disabled+0x13/0x1f
Oct 10 00:39:48 kaa-14 kernel: [169967.617996]  [<ffffffff813c4987>] __mutex_lock_slowpath+0x143/0x1d4
Oct 10 00:39:48 kaa-14 kernel: [169967.618006]  [<ffffffff8105a3e8>] ? arch_vtime_task_switch+0x6a/0x6f
Oct 10 00:39:48 kaa-14 kernel: [169967.618013]  [<ffffffff813c3b58>] mutex_lock+0x12/0x22
Oct 10 00:39:48 kaa-14 kernel: [169967.618021]  [<ffffffff81084f4f>] cgroup_offline_fn+0x36/0x137
Oct 10 00:39:48 kaa-14 kernel: [169967.618030]  [<ffffffff81047cb7>] process_one_work+0x15f/0x21e
Oct 10 00:39:48 kaa-14 kernel: [169967.618039]  [<ffffffff81048159>] worker_thread+0x144/0x1f0
Oct 10 00:39:48 kaa-14 kernel: [169967.618048]  [<ffffffff81048015>] ? rescuer_thread+0x275/0x275
Oct 10 00:39:48 kaa-14 kernel: [169967.618056]  [<ffffffff8104cbec>] kthread+0x88/0x90
Oct 10 00:39:48 kaa-14 kernel: [169967.618066]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.618074]  [<ffffffff813c756c>] ret_from_fork+0x7c/0xb0
Oct 10 00:39:48 kaa-14 kernel: [169967.618083]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.618090] INFO: task kworker/5:3:5251 blocked for more than 120 seconds.
Oct 10 00:39:48 kaa-14 kernel: [169967.618095] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 10 00:39:48 kaa-14 kernel: [169967.618099] kworker/5:3     D ffff88077e871bb8     0  5251      2 0x00000000
Oct 10 00:39:48 kaa-14 kernel: [169967.618108] Workqueue: events cgroup_offline_fn
Oct 10 00:39:48 kaa-14 kernel: [169967.618112]  ffff88056030dd70 0000000000000002 ffff880409e08000 ffff88056030dfd8
Oct 10 00:39:48 kaa-14 kernel: [169967.618120]  ffff88056030dfd8 0000000000011c40 ffff88077e871770 ffffffff81634ae0
Oct 10 00:39:48 kaa-14 kernel: [169967.618128]  ffffffff81634ae4 ffff88077e871770 ffffffff81634ae8 00000000ffffffff
Oct 10 00:39:48 kaa-14 kernel: [169967.618135] Call Trace:
Oct 10 00:39:48 kaa-14 kernel: [169967.618144]  [<ffffffff813c57e4>] schedule+0x60/0x62
Oct 10 00:39:48 kaa-14 kernel: [169967.618152]  [<ffffffff813c5a6b>] schedule_preempt_disabled+0x13/0x1f
Oct 10 00:39:48 kaa-14 kernel: [169967.618160]  [<ffffffff813c4987>] __mutex_lock_slowpath+0x143/0x1d4
Oct 10 00:39:48 kaa-14 kernel: [169967.618169]  [<ffffffff8105a3e8>] ? arch_vtime_task_switch+0x6a/0x6f
Oct 10 00:39:48 kaa-14 kernel: [169967.618177]  [<ffffffff813c3b58>] mutex_lock+0x12/0x22
Oct 10 00:39:48 kaa-14 kernel: [169967.618184]  [<ffffffff81084f4f>] cgroup_offline_fn+0x36/0x137
Oct 10 00:39:48 kaa-14 kernel: [169967.618194]  [<ffffffff81047cb7>] process_one_work+0x15f/0x21e
Oct 10 00:39:48 kaa-14 kernel: [169967.618203]  [<ffffffff81048159>] worker_thread+0x144/0x1f0
Oct 10 00:39:48 kaa-14 kernel: [169967.618212]  [<ffffffff81048015>] ? rescuer_thread+0x275/0x275
Oct 10 00:39:48 kaa-14 kernel: [169967.618220]  [<ffffffff8104cbec>] kthread+0x88/0x90
Oct 10 00:39:48 kaa-14 kernel: [169967.618229]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.618238]  [<ffffffff813c756c>] ret_from_fork+0x7c/0xb0
Oct 10 00:39:48 kaa-14 kernel: [169967.618247]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.618254] INFO: task kworker/8:4:5276 blocked for more than 120 seconds.
Oct 10 00:39:48 kaa-14 kernel: [169967.618258] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 10 00:39:48 kaa-14 kernel: [169967.618262] kworker/8:4     D ffff880e84fa3328     0  5276      2 0x00000000
Oct 10 00:39:48 kaa-14 kernel: [169967.618339] Workqueue: events cgroup_offline_fn
Oct 10 00:39:48 kaa-14 kernel: [169967.618344]  ffff881008c7dd70 0000000000000002 ffff880d72fe4650 ffff881008c7dfd8
Oct 10 00:39:48 kaa-14 kernel: [169967.618353]  ffff881008c7dfd8 0000000000011c40 ffff880e84fa2ee0 ffffffff81634ae0
Oct 10 00:39:48 kaa-14 kernel: [169967.618361]  ffffffff81634ae4 ffff880e84fa2ee0 ffffffff81634ae8 00000000ffffffff
Oct 10 00:39:48 kaa-14 kernel: [169967.618369] Call Trace:
Oct 10 00:39:48 kaa-14 kernel: [169967.618380]  [<ffffffff813c57e4>] schedule+0x60/0x62
Oct 10 00:39:48 kaa-14 kernel: [169967.618388]  [<ffffffff813c5a6b>] schedule_preempt_disabled+0x13/0x1f
Oct 10 00:39:48 kaa-14 kernel: [169967.618396]  [<ffffffff813c4987>] __mutex_lock_slowpath+0x143/0x1d4
Oct 10 00:39:48 kaa-14 kernel: [169967.618405]  [<ffffffff813c6a73>] ? _raw_spin_unlock_irqrestore+0x29/0x34
Oct 10 00:39:48 kaa-14 kernel: [169967.618413]  [<ffffffff813c3b58>] mutex_lock+0x12/0x22
Oct 10 00:39:48 kaa-14 kernel: [169967.618421]  [<ffffffff81084f4f>] cgroup_offline_fn+0x36/0x137
Oct 10 00:39:48 kaa-14 kernel: [169967.618431]  [<ffffffff81047cb7>] process_one_work+0x15f/0x21e
Oct 10 00:39:48 kaa-14 kernel: [169967.618440]  [<ffffffff81048159>] worker_thread+0x144/0x1f0
Oct 10 00:39:48 kaa-14 kernel: [169967.618449]  [<ffffffff81048015>] ? rescuer_thread+0x275/0x275
Oct 10 00:39:48 kaa-14 kernel: [169967.618460]  [<ffffffff8104cbec>] kthread+0x88/0x90
Oct 10 00:39:48 kaa-14 kernel: [169967.618469]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.618478]  [<ffffffff813c756c>] ret_from_fork+0x7c/0xb0
Oct 10 00:39:48 kaa-14 kernel: [169967.618487]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.618495] INFO: task kworker/14:5:5292 blocked for more than 120 seconds.
Oct 10 00:39:48 kaa-14 kernel: [169967.618500] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 10 00:39:48 kaa-14 kernel: [169967.618504] kworker/14:5    D ffff880c0fc91c40     0  5292      2 0x00000000
Oct 10 00:39:48 kaa-14 kernel: [169967.618514] Workqueue: events cgroup_offline_fn
Oct 10 00:39:48 kaa-14 kernel: [169967.618518]  ffff880c08229d70 0000000000000002 ffff880d21e61770 ffff880c08229fd8
Oct 10 00:39:48 kaa-14 kernel: [169967.618526]  ffff880c08229fd8 0000000000011c40 ffff880b451f5dc0 ffffffff81634ae0
Oct 10 00:39:48 kaa-14 kernel: [169967.618534]  ffffffff81634ae4 ffff880b451f5dc0 ffffffff81634ae8 00000000ffffffff
Oct 10 00:39:48 kaa-14 kernel: [169967.618542] Call Trace:
Oct 10 00:39:48 kaa-14 kernel: [169967.618551]  [<ffffffff813c57e4>] schedule+0x60/0x62
Oct 10 00:39:48 kaa-14 kernel: [169967.618559]  [<ffffffff813c5a6b>] schedule_preempt_disabled+0x13/0x1f
Oct 10 00:39:48 kaa-14 kernel: [169967.618566]  [<ffffffff813c4987>] __mutex_lock_slowpath+0x143/0x1d4
Oct 10 00:39:48 kaa-14 kernel: [169967.618576]  [<ffffffff8105a3e8>] ? arch_vtime_task_switch+0x6a/0x6f
Oct 10 00:39:48 kaa-14 kernel: [169967.618610]  [<ffffffff813c3b58>] mutex_lock+0x12/0x22
Oct 10 00:39:48 kaa-14 kernel: [169967.618647]  [<ffffffff81084f4f>] cgroup_offline_fn+0x36/0x137
Oct 10 00:39:48 kaa-14 kernel: [169967.618685]  [<ffffffff81047cb7>] process_one_work+0x15f/0x21e
Oct 10 00:39:48 kaa-14 kernel: [169967.618722]  [<ffffffff81048159>] worker_thread+0x144/0x1f0
Oct 10 00:39:48 kaa-14 kernel: [169967.618760]  [<ffffffff81048015>] ? rescuer_thread+0x275/0x275
Oct 10 00:39:48 kaa-14 kernel: [169967.618797]  [<ffffffff8104cbec>] kthread+0x88/0x90
Oct 10 00:39:48 kaa-14 kernel: [169967.618834]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.618872]  [<ffffffff813c756c>] ret_from_fork+0x7c/0xb0
Oct 10 00:39:48 kaa-14 kernel: [169967.618909]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.618931] INFO: task kworker/14:6:5298 blocked for more than 120 seconds.
Oct 10 00:39:48 kaa-14 kernel: [169967.618952] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 10 00:39:48 kaa-14 kernel: [169967.618972] kworker/14:6    D ffff880b451f1bb8     0  5298      2 0x00000000
Oct 10 00:39:48 kaa-14 kernel: [169967.619021] Workqueue: events cgroup_offline_fn
Oct 10 00:39:48 kaa-14 kernel: [169967.619051]  ffff880af9f51d70 0000000000000002 ffff880b451f5dc0 ffff880af9f51fd8
Oct 10 00:39:48 kaa-14 kernel: [169967.619069]  ffff880af9f51fd8 0000000000011c40 ffff880b451f1770 ffffffff81634ae0
Oct 10 00:39:48 kaa-14 kernel: [169967.619077]  ffffffff81634ae4 ffff880b451f1770 ffffffff81634ae8 00000000ffffffff
Oct 10 00:39:48 kaa-14 kernel: [169967.619085] Call Trace:
Oct 10 00:39:48 kaa-14 kernel: [169967.619095]  [<ffffffff813c57e4>] schedule+0x60/0x62
Oct 10 00:39:48 kaa-14 kernel: [169967.619103]  [<ffffffff813c5a6b>] schedule_preempt_disabled+0x13/0x1f
Oct 10 00:39:48 kaa-14 kernel: [169967.619111]  [<ffffffff813c4987>] __mutex_lock_slowpath+0x143/0x1d4
Oct 10 00:39:48 kaa-14 kernel: [169967.619120]  [<ffffffff8105a3e8>] ? arch_vtime_task_switch+0x6a/0x6f
Oct 10 00:39:48 kaa-14 kernel: [169967.619128]  [<ffffffff813c3b58>] mutex_lock+0x12/0x22
Oct 10 00:39:48 kaa-14 kernel: [169967.619135]  [<ffffffff81084f4f>] cgroup_offline_fn+0x36/0x137
Oct 10 00:39:48 kaa-14 kernel: [169967.619144]  [<ffffffff81047cb7>] process_one_work+0x15f/0x21e
Oct 10 00:39:48 kaa-14 kernel: [169967.619154]  [<ffffffff81048159>] worker_thread+0x144/0x1f0
Oct 10 00:39:48 kaa-14 kernel: [169967.619163]  [<ffffffff81048015>] ? rescuer_thread+0x275/0x275
Oct 10 00:39:48 kaa-14 kernel: [169967.619176]  [<ffffffff8104cbec>] kthread+0x88/0x90
Oct 10 00:39:48 kaa-14 kernel: [169967.619185]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.619194]  [<ffffffff813c756c>] ret_from_fork+0x7c/0xb0
Oct 10 00:39:48 kaa-14 kernel: [169967.619203]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.619210] INFO: task kworker/6:6:5299 blocked for more than 120 seconds.
Oct 10 00:39:48 kaa-14 kernel: [169967.619215] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 10 00:39:48 kaa-14 kernel: [169967.619219] kworker/6:6     D ffff88049cac3328     0  5299      2 0x00000000
Oct 10 00:39:48 kaa-14 kernel: [169967.619230] Workqueue: events cgroup_offline_fn
Oct 10 00:39:48 kaa-14 kernel: [169967.619234]  ffff8804b9115d70 0000000000000002 ffff8804adc62ee0 ffff8804b9115fd8
Oct 10 00:39:48 kaa-14 kernel: [169967.619241]  ffff8804b9115fd8 0000000000011c40 ffff88049cac2ee0 ffffffff81634ae0
Oct 10 00:39:48 kaa-14 kernel: [169967.619249]  ffffffff81634ae4 ffff88049cac2ee0 ffffffff81634ae8 00000000ffffffff
Oct 10 00:39:48 kaa-14 kernel: [169967.619257] Call Trace:
Oct 10 00:39:48 kaa-14 kernel: [169967.619266]  [<ffffffff813c57e4>] schedule+0x60/0x62
Oct 10 00:39:48 kaa-14 kernel: [169967.619294]  [<ffffffff813c5a6b>] schedule_preempt_disabled+0x13/0x1f
Oct 10 00:39:48 kaa-14 kernel: [169967.619301]  [<ffffffff813c4987>] __mutex_lock_slowpath+0x143/0x1d4
Oct 10 00:39:48 kaa-14 kernel: [169967.619310]  [<ffffffff813c6a73>] ? _raw_spin_unlock_irqrestore+0x29/0x34
Oct 10 00:39:48 kaa-14 kernel: [169967.619318]  [<ffffffff813c3b58>] mutex_lock+0x12/0x22
Oct 10 00:39:48 kaa-14 kernel: [169967.619325]  [<ffffffff81084f4f>] cgroup_offline_fn+0x36/0x137
Oct 10 00:39:48 kaa-14 kernel: [169967.619335]  [<ffffffff81047cb7>] process_one_work+0x15f/0x21e
Oct 10 00:39:48 kaa-14 kernel: [169967.619345]  [<ffffffff81048159>] worker_thread+0x144/0x1f0
Oct 10 00:39:48 kaa-14 kernel: [169967.619354]  [<ffffffff81048015>] ? rescuer_thread+0x275/0x275
Oct 10 00:39:48 kaa-14 kernel: [169967.619362]  [<ffffffff8104cbec>] kthread+0x88/0x90
Oct 10 00:39:48 kaa-14 kernel: [169967.619371]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.619380]  [<ffffffff813c756c>] ret_from_fork+0x7c/0xb0
Oct 10 00:39:48 kaa-14 kernel: [169967.619389]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.619396] INFO: task kworker/6:7:5301 blocked for more than 120 seconds.
Oct 10 00:39:48 kaa-14 kernel: [169967.619401] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 10 00:39:48 kaa-14 kernel: [169967.619405] kworker/6:7     D ffff88049cac1bb8     0  5301      2 0x00000000
Oct 10 00:39:48 kaa-14 kernel: [169967.619418] Workqueue: events cgroup_free_fn
Oct 10 00:39:48 kaa-14 kernel: [169967.619422]  ffff8804b90cfd90 0000000000000002 ffff88049cac4650 ffff8804b90cffd8
Oct 10 00:39:48 kaa-14 kernel: [169967.619430]  ffff8804b90cffd8 0000000000011c40 ffff88049cac1770 ffffffff81634ae0
Oct 10 00:39:48 kaa-14 kernel: [169967.619438]  ffffffff81634ae4 ffff88049cac1770 ffffffff81634ae8 00000000ffffffff
Oct 10 00:39:48 kaa-14 kernel: [169967.619446] Call Trace:
Oct 10 00:39:48 kaa-14 kernel: [169967.619455]  [<ffffffff813c57e4>] schedule+0x60/0x62
Oct 10 00:39:48 kaa-14 kernel: [169967.619463]  [<ffffffff813c5a6b>] schedule_preempt_disabled+0x13/0x1f
Oct 10 00:39:48 kaa-14 kernel: [169967.619471]  [<ffffffff813c4987>] __mutex_lock_slowpath+0x143/0x1d4
Oct 10 00:39:48 kaa-14 kernel: [169967.619481]  [<ffffffff81053d16>] ? mmdrop+0x11/0x20
Oct 10 00:39:48 kaa-14 kernel: [169967.619489]  [<ffffffff813c3b58>] mutex_lock+0x12/0x22
Oct 10 00:39:48 kaa-14 kernel: [169967.619497]  [<ffffffff8108286a>] cgroup_free_fn+0x1f/0xc3
Oct 10 00:39:48 kaa-14 kernel: [169967.619506]  [<ffffffff81047cb7>] process_one_work+0x15f/0x21e
Oct 10 00:39:48 kaa-14 kernel: [169967.619516]  [<ffffffff81048159>] worker_thread+0x144/0x1f0
Oct 10 00:39:48 kaa-14 kernel: [169967.619525]  [<ffffffff81048015>] ? rescuer_thread+0x275/0x275
Oct 10 00:39:48 kaa-14 kernel: [169967.619533]  [<ffffffff8104cbec>] kthread+0x88/0x90
Oct 10 00:39:48 kaa-14 kernel: [169967.619542]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.619551]  [<ffffffff813c756c>] ret_from_fork+0x7c/0xb0
Oct 10 00:39:48 kaa-14 kernel: [169967.619560]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.619568] INFO: task kworker/2:0:7688 blocked for more than 120 seconds.
Oct 10 00:39:48 kaa-14 kernel: [169967.619572] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 10 00:39:48 kaa-14 kernel: [169967.619576] kworker/2:0     D ffff8800b6d1e208     0  7688      2 0x00000000
Oct 10 00:39:48 kaa-14 kernel: [169967.619587] Workqueue: events cgroup_offline_fn
Oct 10 00:39:48 kaa-14 kernel: [169967.619591]  ffff88030547bd70 0000000000000002 ffff880409dfaee0 ffff88030547bfd8
Oct 10 00:39:48 kaa-14 kernel: [169967.619598]  ffff88030547bfd8 0000000000011c40 ffff8800b6d1ddc0 ffffffff81634ae0
Oct 10 00:39:48 kaa-14 kernel: [169967.619606]  ffffffff81634ae4 ffff8800b6d1ddc0 ffffffff81634ae8 00000000ffffffff
Oct 10 00:39:48 kaa-14 kernel: [169967.619613] Call Trace:
Oct 10 00:39:48 kaa-14 kernel: [169967.619622]  [<ffffffff813c57e4>] schedule+0x60/0x62
Oct 10 00:39:48 kaa-14 kernel: [169967.619630]  [<ffffffff813c5a6b>] schedule_preempt_disabled+0x13/0x1f
Oct 10 00:39:48 kaa-14 kernel: [169967.619638]  [<ffffffff813c4987>] __mutex_lock_slowpath+0x143/0x1d4
Oct 10 00:39:48 kaa-14 kernel: [169967.619647]  [<ffffffff8105a3e8>] ? arch_vtime_task_switch+0x6a/0x6f
Oct 10 00:39:48 kaa-14 kernel: [169967.619655]  [<ffffffff813c3b58>] mutex_lock+0x12/0x22
Oct 10 00:39:48 kaa-14 kernel: [169967.619662]  [<ffffffff81084f4f>] cgroup_offline_fn+0x36/0x137
Oct 10 00:39:48 kaa-14 kernel: [169967.619671]  [<ffffffff81047cb7>] process_one_work+0x15f/0x21e
Oct 10 00:39:48 kaa-14 kernel: [169967.619681]  [<ffffffff81048159>] worker_thread+0x144/0x1f0
Oct 10 00:39:48 kaa-14 kernel: [169967.619690]  [<ffffffff81048015>] ? rescuer_thread+0x275/0x275
Oct 10 00:39:48 kaa-14 kernel: [169967.619697]  [<ffffffff8104cbec>] kthread+0x88/0x90
Oct 10 00:39:48 kaa-14 kernel: [169967.619707]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60
Oct 10 00:39:48 kaa-14 kernel: [169967.619715]  [<ffffffff813c756c>] ret_from_fork+0x7c/0xb0
Oct 10 00:39:48 kaa-14 kernel: [169967.619724]  [<ffffffff8104cb64>] ? __kthread_parkme+0x60/0x60

--nextPart1690680.ze7MfnVNSo
Content-Disposition: attachment; filename="release_common"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="release_common"

#!/bin/bash
#
# Generic release agent for SLURM cgroup usage
#
# Manage cgroup hierarchy like :
#
# /sys/fs/cgroup/subsystem/uid_%/job_%/step_%/task_%
#
# Automatically sync uid_% cgroups to be coherent
# with remaining job childs when one of them is removed
# by a call to this release agent.
# The synchronisation is made in a flock on the root cgroup
# to ensure coherency of the cgroups contents.
#

progname=$(basename $0)
subsystem=${progname##*_}

get_mount_dir()
{
    local lssubsys=$(type -p lssubsys)
    if [[ $lssubsys ]]; then
        $lssubsys -m $subsystem | awk '{print $2}'
    else
        echo "/sys/fs/cgroup/$subsystem"
    fi
}

mountdir=$(get_mount_dir)

if [[ $# -eq 0 ]]
then
    echo "Usage: $(basename $0) [sync] cgroup"
    exit 1
fi

# build orphan cg path
if [[ $# -eq 1 ]]
then
    rmcg=${mountdir}$1
else
    rmcg=${mountdir}$2
fi
slurmcg=${rmcg%/uid_*}
if [[ ${slurmcg} == ${rmcg} ]]
then
    # not a slurm job pattern, perhaps the slurmcg, just remove 
    # the dir with a lock and exit
    flock -x ${mountdir} -c "rmdir ${rmcg}"
    exit $?
fi
orphancg=${slurmcg}/orphan

# make sure orphan cgroup is existing
if [[ ! -d ${orphancg} ]]
then
    mkdir ${orphancg}
    case ${subsystem} in 
	cpuset)
	    cat ${mountdir}/cpuset.cpus > ${orphancg}/cpuset.cpus
	    cat ${mountdir}/cpuset.mems > ${orphancg}/cpuset.mems
	    ;;
	*)
	    ;;
    esac
fi
    
# kernel call
if [[ $# -eq 1 ]]
then

    rmcg=${mountdir}$@

    # try to extract the uid cgroup from the input one
    # ( extract /uid_% from /uid%/job_*...)
    uidcg=${rmcg%/job_*}
    if [[ ${uidcg} == ${rmcg} ]]
    then
	# not a slurm job pattern, perhaps the uidcg, just remove 
	# the dir with a lock and exit
	flock -x ${mountdir} -c "rmdir ${rmcg}"
	exit $?
    fi

    if [[ -d ${mountdir} ]]
    then
	flock -x ${mountdir} -c "$0 sync $@"
    fi

    exit $?

# sync subcall (called using flock by the kernel hook to be sure
# that no one is manipulating the hierarchy, i.e. PAM, SLURM, ...)
elif [[ $# -eq 2 ]] && [[ $1 == "sync" ]]
then

    shift
    rmcg=${mountdir}$@
    uidcg=${rmcg%/job_*}

    # remove this cgroup
    if [[ -d ${rmcg} ]]
    then
        case ${subsystem} in
            memory)
		# help to correctly remove lazy cleaning memcg
		# but still not perfect
                sleep 1
                ;;
            *)
		;;
        esac
	rmdir ${rmcg}
    fi
    if [[ ${uidcg} == ${rmcg} ]]
    then
	## not a slurm job pattern exit now do not sync
	exit 0
    fi

    # sync the user cgroup based on targeted subsystem
    # and the remaining job
    if [[ -d ${uidcg} ]]
    then
	case ${subsystem} in 
	    cpuset)
		cpus=$(cat ${uidcg}/job_*/cpuset.cpus 2>/dev/null)
		if [[ -n ${cpus} ]]
		then
		    cpus=$(scontrol show hostnames $(echo ${cpus} | tr ' ' ','))
		    cpus=$(echo ${cpus} | tr ' ' ',')
		    echo ${cpus} > ${uidcg}/cpuset.cpus
		else
		    # first move the remaining processes to 
		    # a cgroup reserved for orphaned processes
		    for t in $(cat ${uidcg}/tasks)
		    do
			echo $t > ${orphancg}/tasks
		    done
		    # then remove the remaining cpus from the cgroup
		    echo "" > ${uidcg}/cpuset.cpus
		fi
		;;
	    *)
		;;
	esac
    fi

# error
else
    echo "Usage: $(basename $0) [sync] cgroup"
    exit 1
fi

exit 0

--nextPart1690680.ze7MfnVNSo--
