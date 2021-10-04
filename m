From: Vishal Verma <vverma-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org>
Subject: [PATCH] cgroup: cgroup-v1: do not exclude cgrp_dfl_root
Date: Mon,  4 Oct 2021 20:19:48 +0000
Message-ID: <20211004201948.20293-1-vverma@digitalocean.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LQGXlr8JsxYTcOQMokcqY9RnbuNcOY4TaFS93GsjX5s=;
        b=gBaPYPFr2c8ulT+/+JaIiT+5iPPcLGSJfTfBfJQwCOvCrhUQsImxweBvZ8n0PSx2Ar
         9Hp5BCLgzXUucupqyOZjZuddMIjkxzRYWduE0FxjN1TZHe4f6SvzdXLQnN5xEdw1IY8w
         rFEOyyNFQ+h0uIql+JqmelRn/dI30R5/EUF20=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vishal Verma <vverma-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org>

Found an issue within cgroup_attach_task_all() fn which seem
to exclude cgrp_dfl_root (cgroupv2) while attaching tasks to
the given cgroup. This was noticed when the system was running
qemu/kvm with kernel vhost helper threads. It appears that the
vhost layer which uses cgroup_attach_task_all() fn to assign the
vhost kthread to the right qemu cgroup works fine with cgroupv1
based configuration but not in cgroupv2. With cgroupv2, the vhost
helper thread ends up just belonging to the root cgroup as is
shown below:

$ stat -fc %T /sys/fs/cgroup/
cgroup2fs
$ sudo pgrep qemu
1916421
$ ps -eL | grep 1916421
1916421 1916421 ?        00:00:01 qemu-system-x86
1916421 1916431 ?        00:00:00 call_rcu
1916421 1916435 ?        00:00:00 IO mon_iothread
1916421 1916436 ?        00:00:34 CPU 0/KVM
1916421 1916439 ?        00:00:00 SPICE Worker
1916421 1916440 ?        00:00:00 vnc_worker
1916433 1916433 ?        00:00:00 vhost-1916421
1916437 1916437 ?        00:00:00 kvm-pit/1916421
$ cat /proc/1916421/cgroup
0::/machine.slice/machine-qemu\x2d18\x2dDroplet\x2d7572850.scope/emulator
$ cat /proc/1916439/cgroup
0::/machine.slice/machine-qemu\x2d18\x2dDroplet\x2d7572850.scope/emulator
$ cat /proc/1916433/cgroup
0::/

From above, it can be seen that the vhost kthread (PID: 1916433)
doesn't seem to belong the qemu cgroup like other qemu PIDs.

After applying this patch:

$ pgrep qemu
1643
$ ps -eL | grep 1643
   1643    1643 ?        00:00:00 qemu-system-x86
   1643    1645 ?        00:00:00 call_rcu
   1643    1648 ?        00:00:00 IO mon_iothread
   1643    1649 ?        00:00:00 CPU 0/KVM
   1643    1652 ?        00:00:00 SPICE Worker
   1643    1653 ?        00:00:00 vnc_worker
   1647    1647 ?        00:00:00 vhost-1643
   1651    1651 ?        00:00:00 kvm-pit/1643
$ cat /proc/1647/cgroup
0::/machine.slice/machine-qemu\x2d18\x2dDroplet\x2d7572850.scope/emulator

Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Vishal Verma <vverma-tWEdnPwa2b6ifxm/DiOjgA@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 35b920328344..f6cc5f8484dc 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -63,9 +63,6 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 	for_each_root(root) {
 		struct cgroup *from_cgrp;
 
-		if (root == &cgrp_dfl_root)
-			continue;
-
 		spin_lock_irq(&css_set_lock);
 		from_cgrp = task_cgroup_from_root(from, root);
 		spin_unlock_irq(&css_set_lock);
-- 
2.17.1

