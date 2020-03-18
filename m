From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 25/73] cgroup1: don't call release_agent when it is ""
Date: Wed, 18 Mar 2020 16:52:49 -0400
Message-ID: <20200318205337.16279-25-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564847;
        bh=0geW2N5yklwjKb6rivq1v7IxgkL4xJnOpRV3pgTthvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WP39XUgrySw46+NnDtGuF3S5N0/h7hM+2w0wipJ4OzloiEwWsG6C0GN/NKJ7qZKb6
         L9ROFnGf2hR+DRhjDOpxTHZU9rZqnSclx8rRh/tXymKAQWAz8ntk0+LTpROrA1HgFM
         ZtO3OIuEMV31o8/hWhwEjotYxnMonACcQq+o1FFQ=
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tycho Andersen <tycho@tycho.ws>, Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org

From: Tycho Andersen <tycho@tycho.ws>

[ Upstream commit 2e5383d7904e60529136727e49629a82058a5607 ]

Older (and maybe current) versions of systemd set release_agent to "" when
shutting down, but do not set notify_on_release to 0.

Since 64e90a8acb85 ("Introduce STATIC_USERMODEHELPER to mediate
call_usermodehelper()"), we filter out such calls when the user mode helper
path is "". However, when used in conjunction with an actual (i.e. non "")
STATIC_USERMODEHELPER, the path is never "", so the real usermode helper
will be called with argv[0] == "".

Let's avoid this by not invoking the release_agent when it is "".

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup-v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 2db582706ec5c..f684c82efc2ea 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -784,7 +784,7 @@ void cgroup1_release_agent(struct work_struct *work)
 
 	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
 	agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
-	if (!pathbuf || !agentbuf)
+	if (!pathbuf || !agentbuf || !strlen(agentbuf))
 		goto out;
 
 	spin_lock_irq(&css_set_lock);
-- 
2.20.1

