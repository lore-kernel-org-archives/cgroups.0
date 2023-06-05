From: Zou Cao <zoucaox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: fixed the cset refcnt leak when fork() failed
Date: Mon,  5 Jun 2023 21:04:44 +0800
Message-ID: <20230605130444.1421-1-zoucao@kuaishou.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685970296; x=1688562296;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PwnioUR0ZjoyRGzrp5k5mjXo7WPIskiZGVP9H/Ozl1w=;
        b=ikWXlcNmcjTchboSGAIljatHvSG1Z4LVpxBFkZ9O1es07NKSLDjhDfsLYrkfj8J8re
         JLiOzSxDdNlnBMcKLYmB/eFroD/t8DpaSJZLaNskfnHACkfLND8sljVzpqiA3FtKk8Hf
         bl3rK/ew+hxR6lwA9ZX/w9ulk67kwP7kJZ0katk94Gpvw76pFfAoi7r6QuYK/3QqFFbD
         +TQ5MtVRhCOp47VRQeNhtXolsiEpyYmSczhBNeDAZh5T7LjPM1S21GZa9GtZRTVMjgeP
         5WdqyznmnMtecDf/2/bMpuU9NUZKDFS1F1MIqN/S9qCaEkUnd/7tViMEV3qLUiR6vk4R
         49KQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Zou Cao <zoucao-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>

TeamID: B1486294

when fork, cset will be increased by commit "ef2c41cf38a7", the refcnt will
be decrease by child exit, but when failed in fork(), this refcnt will
be lost decrease in cgroup_cancel_fork as follow:

copy_process
     |
cgroup_can_fork    //  increase the css refcount
  ......
  spin_lock_irq(&css_set_lock);
  cset = task_css_setcurrent);
  get_css_set(cset);
  spin_unlock_irq&css_set_lock);
  ......
     |
goto cgroup_cancel_fork    // if failed in  copy_process
     |
cgroup_cancel_fork  // lost the decrease refcount if flag not CLONE_INTO_CGROUP

Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Signed-off-by: Zou Cao <zoucao-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d18c2ef..5ecd706 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6284,6 +6284,11 @@ void cgroup_cancel_fork(struct task_struct *child,
 		if (ss->cancel_fork)
 			ss->cancel_fork(child, kargs->cset);
 
+	if (!(kargs->flags & CLONE_INTO_CGROUP) &&
+			kargs->cset) {
+		put_css_set(kargs->cset);
+	}
+
 	cgroup_css_set_put_fork(kargs);
 }
 
-- 
1.8.3.1

