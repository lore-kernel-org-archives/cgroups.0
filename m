From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/12] cgroup: update subsystem rebind restrictions
Date: Thu, 27 Mar 2014 22:40:59 -0400
Message-ID: <1395974461-12735-11-git-send-email-tj@kernel.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WBazYa0ZZXjMsLYDkL6lCAWI8E8SXBiSZTjGOOnEkUM=;
        b=ph1+AEHZc7uZGxsxehz0ANl1nVhHaFevS9nfI8K616MfRxopFWtqsXWIh2cdIrmgCL
         yk+N2dZAWx93IIn/DJ4Oj6BCNr5FLPQkJo/X3Qo+0NURJvPaRcK1NWwKOf07a4N1DY0Q
         1C6Wx2aUuOd40Z0n/i3GFnHLRoCxmXuSyWMSLKtaN59Ojyy4n3hPpmlmHURbEKkRX5mV
         gEFLlNhUJBqzTNWr07V/2XFz7IeOQikwWMJsPgB9TF5d69x49OVXVU0l4HixYecWAf1r
         4z4nh0U3e61azz/IdxIXGKP6HGaVG+l7t9abBvD6D4qMQONrZo8PFvzB9k4QIKjHlC0C
         DXPA==
In-Reply-To: <1395974461-12735-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Because the default root couldn't have any non-root csses attached to
it, rebinding away from it was always allowed; however, the default
hierarchy will soon host the unified hierarchy and have non-root csses
so the rebind restrictions need to be updated accordingly.

Instead of special casing rebinding from the default hierarchy and
then checking whether the source hierarchy has children cgroups, which
implies non-root csses for !dfl hierarchies, simply check whether the
source hierarchy has non-root csses for the subsystem using
css_next_child().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e714ccf..0c67141 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1051,16 +1051,12 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 		if (!(ss_mask & (1 << ssid)))
 			continue;
 
-		/* if @ss is on the dummy_root, we can always move it */
-		if (ss->root == &cgrp_dfl_root)
-			continue;
-
-		/* if @ss has non-root cgroups attached to it, can't move */
-		if (!list_empty(&ss->root->cgrp.children))
+		/* if @ss has non-root csses attached to it, can't move */
+		if (css_next_child(NULL, cgroup_css(&ss->root->cgrp, ss)))
 			return -EBUSY;
 
 		/* can't move between two non-dummy roots either */
-		if (dst_root != &cgrp_dfl_root)
+		if (ss->root != &cgrp_dfl_root && dst_root != &cgrp_dfl_root)
 			return -EBUSY;
 	}
 
-- 
1.8.5.3
