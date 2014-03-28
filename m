From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/12] cgroup: make css_next_child() skip missing csses
Date: Thu, 27 Mar 2014 22:40:53 -0400
Message-ID: <1395974461-12735-5-git-send-email-tj@kernel.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uF36MKTtH2B8FFGDe1TZe2GpSg1aF6JcT0pcQskM7h8=;
        b=x5zReXdOoE/5t37pVpwENe1VUIkEqvwpwoxX7QRjZviScF4PoeXqKbA3i4xoMFZBfq
         3QPCp5tcvfr4vbFVWmgJm1BUY75XOLtrpb3hLrb3t9pUegeiXf9eVGdr4rKdKhOrBu2k
         B5m/aPmODzHdxLg3dHvQEf6Ot8/3xPc7y2c3IyKwohGW2cww2k3IdqwWYIy8Nk7sLiS9
         Qqa1zsXDcIZImfhMZVlfGWsaodjxu/fRn4dcRcuNxBhlxkkJBVs+m+l8SHeUuY0v8yNe
         VlKSzTDH7O2ZTnmmS2sq4UeoF1I8SpF4KNvlr/bFhlC2+H1L7dC1aw0ij76WgXwLlq6B
         WepQ==
In-Reply-To: <1395974461-12735-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

css_next_child() walks the children of the specified css.  It does
this by finding the next cgroup and then returning the requested css.
On the default unified hierarchy, a cgroup may not have a css
associated with it even if the hierarchy has the subsystem enabled.
This patch updates css_next_child() so that it skips children without
the requested css associated.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2899a6f..9d2d6ef 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2690,10 +2690,19 @@ css_next_child(struct cgroup_subsys_state *pos_css,
 				break;
 	}
 
-	if (&next->sibling == &cgrp->children)
-		return NULL;
+	/*
+	 * @next, if not pointing to the head, can be dereferenced and is
+	 * the next sibling; however, it might have @ss disabled.  If so,
+	 * fast-forward to the next enabled one.
+	 */
+	while (&next->sibling != &cgrp->children) {
+		struct cgroup_subsys_state *next_css = cgroup_css(next, parent_css->ss);
 
-	return cgroup_css(next, parent_css->ss);
+		if (next_css)
+			return next_css;
+		next = list_entry_rcu(next->sibling.next, struct cgroup, sibling);
+	}
+	return NULL;
 }
 
 /**
-- 
1.8.5.3
