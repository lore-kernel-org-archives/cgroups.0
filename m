From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH] cgroup1: don't call release_agent when it is ""
Date: Wed, 19 Feb 2020 12:01:29 -0700
Message-ID: <20200219190129.6899-1-tycho@tycho.ws>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gaq6NM5o+UM+pFOLAVDFZv0/RMH6toB+rITqZIOsMYE=;
        b=lLfi6cyMIxFEgNuwaGXNFp+Ts5Y/KtKR4ejCootJgO0ckrc0gRvgZ7nZudfZhjQoBI
         Q+Knj9pxcd3wq4LHf974POD/1Hnc1WLhh+kb4jKuK0df5rwk2iv1uTnor3Qx5iHTuPG0
         6K4HnlgfXU5h6k7AIRjJaZLVQOz6UOuRrMgB8+OAD6HMboRGS5lIdf7dZ6Ucih5+R7Yl
         Rog2cqFxxqxQHrPhjPpD2KCEN9OsLng7bSpIYqsSPDMDkmsISBpLWbLW2+0qZvzT1V07
         z5vq1ehXDwR3+F8rgzV7zl1I6T57sNXV+zO+rlE6KPJkoXVN3bBVWhpnq9CEo2lp5Kyv
         f3fg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Serge Hallyn <serge@hallyn.com>, linux-kernel@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>

Older (and maybe current) versions of systemd set release_agent to "" when
shutting down, but do not set notify_on_release to 0.

Since 64e90a8acb85 ("Introduce STATIC_USERMODEHELPER to mediate
call_usermodehelper()"), we filter out such calls when the user mode helper
path is "". However, when used in conjunction with an actual (i.e. non "")
STATIC_USERMODEHELPER, the path is never "", so the real usermode helper
will be called with argv[0] == "".

Let's avoid this by not invoking the release_agent when it is "".

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
---
 kernel/cgroup/cgroup-v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index be1a1c83cdd1..b3626c3c6f92 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -782,7 +782,7 @@ void cgroup1_release_agent(struct work_struct *work)
 
 	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
 	agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
-	if (!pathbuf || !agentbuf)
+	if (!pathbuf || !agentbuf || !strlen(agentbuf))
 		goto out;
 
 	spin_lock_irq(&css_set_lock);
-- 
2.20.1

