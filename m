From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.4-fixes] cgroup: make css_set pin its css's to
 avoid use-afer-free
Date: Mon, 23 Nov 2015 14:55:41 -0500
Message-ID: <20151123195541.GA19072@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=ev3gP1QMBo8sSTJaV1yFwUswKg7rn9sAvSqbk5ypTPg=;
        b=y4jk8Q5W9HZvJIVDRyt3reJN0SlkHDv3H5ioxyMtYpD2TibejgJwiiausqsxbJh0jZ
         Rdpt+h84kF3JsaR+HYCPvDaj5ohwyiJ9zwA/x2wz5/JdI3hKH05JtE9hlzATqv4kdmdT
         1G6QlYP0O36QuPZBUiFeRUA+HvtsCCqhlN/s9KbBg6YV9TeZYvPLtbKhkaCor0Nwh8oF
         6QY4SFcOqIZK1AVGNdvWS8vzBK7OsCrFQNeO3HcjF5zJzAS5XE8e7C86vTiN7YdBAvtM
         YwPVs34KUs/9jTXJGgvuwItLQSO8ok3ikF0As++KbSU/WuSTKDZZmeToYq6Sq1gkhnaf
         PEjg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

A css_set represents the relationship between a set of tasks and
css's.  css_set never pinned the associated css's.  This was okay
because tasks used to always disassociate immediately (in RCU sense) -
either a task is moved to a different css_set or exits and never
accesses css_set again.

Unfortunately, afcf6c8b7544 ("cgroup: add cgroup_subsys->free() method
and use it to fix pids controller") and patches leading up to it made
a zombie hold onto its css_set and deref the associated css's on its
release.  Nothing pins the css's after exit and it might have already
been freed leading to use-after-free.

 general protection fault: 0000 [#1] PREEMPT SMP
 task: ffffffff81bf2500 ti: ffffffff81be4000 task.ti: ffffffff81be4000
 RIP: 0010:[<ffffffff810fa205>]  [<ffffffff810fa205>] pids_cancel.constprop.4+0x5/0x40
 ...
 Call Trace:
  <IRQ>
  [<ffffffff810fb02d>] ? pids_free+0x3d/0xa0
  [<ffffffff810f8893>] cgroup_free+0x53/0xe0
  [<ffffffff8104ed62>] __put_task_struct+0x42/0x130
  [<ffffffff81053557>] delayed_put_task_struct+0x77/0x130
  [<ffffffff810c6b34>] rcu_process_callbacks+0x2f4/0x820
  [<ffffffff810c6af3>] ? rcu_process_callbacks+0x2b3/0x820
  [<ffffffff81056e54>] __do_softirq+0xd4/0x460
  [<ffffffff81057369>] irq_exit+0x89/0xa0
  [<ffffffff81876212>] smp_apic_timer_interrupt+0x42/0x50
  [<ffffffff818747f4>] apic_timer_interrupt+0x84/0x90
  <EOI>
 ...
 Code: 5b 5d c3 48 89 df 48 c7 c2 c9 f9 ae 81 48 c7 c6 91 2c ae 81 e8 1d 94 0e 00 31 c0 5b 5d c3 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 <f0> 48 83 87 e0 00 00 00 ff 78 01 c3 80 3d 08 7a c1 00 00 74 02
 RIP  [<ffffffff810fa205>] pids_cancel.constprop.4+0x5/0x40
  RSP <ffff88001fc03e20>
 ---[ end trace 89a4a4b916b90c49 ]---
 Kernel panic - not syncing: Fatal exception in interrupt
 Kernel Offset: disabled
 ---[ end Kernel panic - not syncing: Fatal exception in interrupt

Fix it by making css_set pin the associate css's until its release.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>
Reported-by: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Link: http://lkml.kernel.org/g/20151120041836.GA18390-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org
Link: http://lkml.kernel.org/g/5652D448.3080002-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org
Fixes: afcf6c8b7544 ("cgroup: add cgroup_subsys->free() method and use it to fix pids controller")
---
 kernel/cgroup.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -754,9 +754,11 @@ static void put_css_set_locked(struct cs
 	if (!atomic_dec_and_test(&cset->refcount))
 		return;
 
-	/* This css_set is dead. unlink it and release cgroup refcounts */
-	for_each_subsys(ss, ssid)
+	/* This css_set is dead. unlink it and release cgroup and css refs */
+	for_each_subsys(ss, ssid) {
 		list_del(&cset->e_cset_node[ssid]);
+		css_put(cset->subsys[ssid]);
+	}
 	hash_del(&cset->hlist);
 	css_set_count--;
 
@@ -1056,9 +1058,13 @@ static struct css_set *find_css_set(stru
 	key = css_set_hash(cset->subsys);
 	hash_add(css_set_table, &cset->hlist, key);
 
-	for_each_subsys(ss, ssid)
+	for_each_subsys(ss, ssid) {
+		struct cgroup_subsys_state *css = cset->subsys[ssid];
+
 		list_add_tail(&cset->e_cset_node[ssid],
-			      &cset->subsys[ssid]->cgroup->e_csets[ssid]);
+			      &css->cgroup->e_csets[ssid]);
+		css_get(css);
+	}
 
 	spin_unlock_bh(&css_set_lock);
 
