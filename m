From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 4.14 16/28] cgroup1: don't call release_agent when it is ""
Date: Wed, 18 Mar 2020 16:55:43 -0400
Message-ID: <20200318205555.17447-16-sashal@kernel.org>
References: <20200318205555.17447-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564974;
        bh=BEppHJSF0Q3dBGNXBQdv4LxwkkElFKHdTM/3CINeEuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAhG2WE7QPgbCPCmC7Nk7orbcE19Eg6e5+t8jYEFmiDQ6PvhY4XNEXlV4WQ8Ttcme
         dEKPvavz3L7wNMM6jrnuvNllWtEC937E1OvY9Q7b4+ofS0FX+crKDnu6tLIhXdGtav
         s27cSkCWAwLrPSAc67MfF9Dq3mglfO9aKdsgfQZg=
In-Reply-To: <20200318205555.17447-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>

[ Upstream commit 2e5383d7904e60529136727e49629a82058a5607 ]

Older (and maybe current) versions of systemd set release_agent to "" when
shutting down, but do not set notify_on_release to 0.

Since 64e90a8acb85 ("Introduce STATIC_USERMODEHELPER to mediate
call_usermodehelper()"), we filter out such calls when the user mode helper
path is "". However, when used in conjunction with an actual (i.e. non "")
STATIC_USERMODEHELPER, the path is never "", so the real usermode helper
will be called with argv[0] == "".

Let's avoid this by not invoking the release_agent when it is "".

Signed-off-by: Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index d148965180893..545f29c5268d7 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -824,7 +824,7 @@ void cgroup1_release_agent(struct work_struct *work)
 
 	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
 	agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
-	if (!pathbuf || !agentbuf)
+	if (!pathbuf || !agentbuf || !strlen(agentbuf))
 		goto out;
 
 	spin_lock_irq(&css_set_lock);
-- 
2.20.1

