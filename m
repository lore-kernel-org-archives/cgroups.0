From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v2 02/06] kernel: cgroup: fix misuse of %x
Date: Sun, 21 Apr 2019 19:47:27 +0800
Message-ID: <20190421114727.20325-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=l1XMfRfwz3PYG87O4Xru/p0h0VgC3g5uSZkBJ4fCYy0=;
        b=GQaBDRhGo3GA9dXYbej6iuWKt4/L6Nbh1CB2Fhr313moYpRWPPlELcW9sImdOppe3l
         Y/1cFyyZ0SWz80ikORm6Byf7f88iHF9uE1AB2Dk2zyMjoHiBifSRNuTK4QDsyq35M7S/
         uFOdfIyZjK3fwd/ncPT2mIDKuEOXZgs2WhNvX5Rr/cooSIbjwszQZCrwueRHjRBo94/g
         kOW3JV9EX/GnfmsArfxKgeK3KUGLKPKR8hd0B8iNjvcQPhyNqRkoM1JrRUp/O8FfkKAf
         XynF2/RbBAoqeSg7aASUbW/3eYtSPnzUTPdKcK9lNplT+okwCVjlPH5Q6XI68oUeF0qJ
         AseQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Fuqian Huang <huangfq.daxian@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Pointers should be printed with %p or %px rather than
cast to unsigned long type and printed with %lx.
Change %lx to %p to print the pointers.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 kernel/cgroup/debug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index 5f1b873..80aa3f0 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -64,8 +64,8 @@ static int current_css_set_read(struct seq_file *seq, void *v)
 		css = cset->subsys[ss->id];
 		if (!css)
 			continue;
-		seq_printf(seq, "%2d: %-4s\t- %lx[%d]\n", ss->id, ss->name,
-			  (unsigned long)css, css->id);
+		seq_printf(seq, "%2d: %-4s\t- %p[%d]\n", ss->id, ss->name,
+			  css, css->id);
 	}
 	rcu_read_unlock();
 	spin_unlock_irq(&css_set_lock);
@@ -224,8 +224,8 @@ static int cgroup_subsys_states_read(struct seq_file *seq, void *v)
 		if (css->parent)
 			snprintf(pbuf, sizeof(pbuf) - 1, " P=%d",
 				 css->parent->id);
-		seq_printf(seq, "%2d: %-4s\t- %lx[%d] %d%s\n", ss->id, ss->name,
-			  (unsigned long)css, css->id,
+		seq_printf(seq, "%2d: %-4s\t- %p[%d] %d%s\n", ss->id, ss->name,
+			  css, css->id,
 			  atomic_read(&css->online_cnt), pbuf);
 	}
 
-- 
2.11.0

