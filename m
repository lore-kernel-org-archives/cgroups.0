From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.12] cgroup: mark cgroup_get() with __maybe_unused
Date: Mon, 1 May 2017 15:41:32 -0400
Message-ID: <20170501194132.GF8921@htj.duckdns.org>
References: <20170501145340.17e8ef86@canb.auug.org.au>
Mime-Version: 1.0
Return-path: <linux-next-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wGPZ/dyvg2U0Ut+5mALy0DmcPv66BKyyePVsH69U678=;
        b=pKGAPKToEN/kozrMUGUoBKe7kimHiQitcavmDGNh0FhFEBb5N41LDGf6sAHc6Xq6Z9
         zscR8ZHlFz8ZArDk2hYKetvpGu8X8In8p7gwJ60grlS47Adi2A/XTKg6eTIHtztz7io0
         KFXZTF3gL3S09+nv/dyN88JNZiUFQtJLAJ7mfU5x/FGRHd8Ru1en/0tzqrN+Hd8kG7lr
         6tZvobyYlf0VVYYX2JijOLUhfHRpawLhdKwRN6EYT7DQ+IFwHKD+I4zkzYlYboseLMO4
         jOa4+Wt4X9NzPedRfpSpVLnCocFdsmVT2bfJjW0kLvBS674AoTz90Rc4QIczKXlumtSa
         yDjQ==
Content-Disposition: inline
In-Reply-To: <20170501145340.17e8ef86@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

From 310b4816a5d8082416b4ab83e5a7b3cb92883a4d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 1 May 2017 15:24:14 -0400

a590b90d472f ("cgroup: fix spurious warnings on cgroup_is_dead() from
cgroup_sk_alloc()") converted most cgroup_get() usages to
cgroup_get_live() leaving cgroup_sk_alloc() the sole user of
cgroup_get().  When !CONFIG_SOCK_CGROUP_DATA, this ends up triggering
unused warning for cgroup_get().

Silence the warning by adding __maybe_unused to cgroup_get().

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Link: http://lkml.kernel.org/r/20170501145340.17e8ef86@canb.auug.org.au
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to cgroup/for-4.12.

Thanks!

 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 38d9386..f2bcc11 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -436,7 +436,7 @@ struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgrp,
 	return css;
 }
 
-static void cgroup_get(struct cgroup *cgrp)
+static void __maybe_unused cgroup_get(struct cgroup *cgrp)
 {
 	css_get(&cgrp->self);
 }
-- 
2.9.3
