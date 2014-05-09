From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] cgroup: css_release() shouldn't clear cgroup->subsys[]
Date: Fri,  9 May 2014 15:32:51 -0400
Message-ID: <1399663975-315-4-git-send-email-tj@kernel.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dh3JjGgLy5JvTdblEe4DBd/ps2lKj07KKyEpY08oDkc=;
        b=KzcvKBekILAk/jj94/JKMcVQzCNzY6HpWb4qiCr2N85fOjgt54r/ymO39znGXK3xSv
         C7A219jiKHdfG0Y729XRcoLwZz1aRlQKvDCzZFsHQfnwJSNlXlUUY04WY9TsUyGgkEwo
         cF+6NL9mxJK8+CBhSrorOyosvWvh3IIqIeUU3FSEOGVxWCk5HV3m/Z787vcAtw9FTmEu
         frwBQR1k6HGFv3x9J6Qdqi4mIY5OLBv5r23Yw5JFWOGLbfN+ElIzKIrT0QZBrySrKSE8
         SQHsSu8oXKvs6FVCzL6+KU2ST/xqb5tTzp4X3dVVDf1Q7qTV5MP6lrG+wol5/GY/uLJb
         1Cpg==
In-Reply-To: <1399663975-315-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

c1a71504e971 ("cgroup: don't recycle cgroup id until all csses' have
been destroyed") made cgroup ID persist until a cgroup is released and
add cgroup->subsys[] clearing to css_release() so that css_from_id()
doesn't return a css which has already been released which happens
before cgroup release; however, the right change here was updating
offline_css() to clear cgroup->subsys[] which was done by e32978031016
("cgroup: cgroup->subsys[] should be cleared after the css is
offlined") instead of clearing it from css_release().

We're now clearing cgroup->subsys[] twice.  This is okay for
traditional hierarchies as a css's lifetime is the same as its
cgroup's; however, this confuses unified hierarchy and turning on and
off a controller repeatedly using "cgroup.subtree_control" can lead to
an oops like the following which happens because cgroup->subsys[] is
incorrectly cleared asynchronously by css_release().

 BUG: unable to handle kernel NULL pointer dereference at 00000000000000 08
 IP: [<ffffffff81130c11>] kill_css+0x21/0x1c0
 PGD 1170d067 PUD f0ab067 PMD 0
 Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 Modules linked in:
 CPU: 2 PID: 459 Comm: bash Not tainted 3.15.0-rc2-work+ #5
 Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 task: ffff880009296710 ti: ffff88000e198000 task.ti: ffff88000e198000
 RIP: 0010:[<ffffffff81130c11>]  [<ffffffff81130c11>] kill_css+0x21/0x1c0
 RSP: 0018:ffff88000e199dc8  EFLAGS: 00010202
 RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000001
 RDX: 0000000000000001 RSI: ffffffff8238a968 RDI: ffff880009296f98
 RBP: ffff88000e199de0 R08: 0000000000000001 R09: 02b0000000000000
 R10: 0000000000000000 R11: ffff880009296fc0 R12: 0000000000000001
 R13: ffff88000db6fc58 R14: 0000000000000001 R15: ffff8800139dcc00
 FS:  00007ff9160c5740(0000) GS:ffff88001fb00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000008 CR3: 0000000013947000 CR4: 00000000000006e0
 Stack:
  ffff88000e199de0 ffffffff82389160 0000000000000001 ffff88000e199e80
  ffffffff8113537f 0000000000000007 ffff88000e74af00 ffff88000e199e48
  ffff880009296710 ffff88000db6fc00 ffffffff8239c100 0000000000000002
 Call Trace:
  [<ffffffff8113537f>] cgroup_subtree_control_write+0x85f/0xa00
  [<ffffffff8112fd18>] cgroup_file_write+0x38/0x1d0
  [<ffffffff8126fc97>] kernfs_fop_write+0xe7/0x170
  [<ffffffff811f2ae6>] vfs_write+0xb6/0x1c0
  [<ffffffff811f35ad>] SyS_write+0x4d/0xc0
  [<ffffffff81d0acd2>] system_call_fastpath+0x16/0x1b
 Code: 5c 41 5d 41 5e 41 5f 5d c3 90 0f 1f 44 00 00 55 48 89 e5 41 54 53 48 89 fb 48 83 ec 08 8b 05 37 ad 29 01 85 c0 0f 85 df 00 00 00 <48> 8b 43 08 48 8b 3b be 01 00 00 00 8b 48 5c d3 e6 e8 49 ff ff
 RIP  [<ffffffff81130c11>] kill_css+0x21/0x1c0
  RSP <ffff88000e199dc8>
 CR2: 0000000000000008
 ---[ end trace e7aae1f877c4e1b4 ]---

Remove the unnecessary cgroup->subsys[] clearing from css_release().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e2ff925..35daf89 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4102,7 +4102,6 @@ static void css_release(struct percpu_ref *ref)
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 	struct cgroup_subsys *ss = css->ss;
 
-	RCU_INIT_POINTER(css->cgroup->subsys[ss->id], NULL);
 	cgroup_idr_remove(&ss->css_idr, css->id);
 
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
-- 
1.9.0
