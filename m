From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] cgroup: fix incorrect destination cgroup in cgroup_update_dfl_csses()
Date: Thu,  3 Mar 2016 12:19:59 -0500
Message-ID: <1457025602-4193-2-git-send-email-tj@kernel.org>
References: <1457025602-4193-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FLHxORuWYtIpn88dUUBNt6ADaqLbPqcgtL4Oyx1FSkU=;
        b=M/SFMcMsRnfYMxKD6ZV5XpzclKQM80d9FHgQbn+AImxNoidHOE/DrC3Z+x0f3ttyYq
         ZjBdyKR7d9QO3e/bZZ9Cv8DeZg76wMT2sF0IdnXh/AGadNgg935ua3JyR/R+QlbQwg8s
         3/9CXu2fTU6Tcrx6d+496cGmw8lz5yRuGgHJFDth077GOKcKecT/pYI3tAqQZPQNh3sH
         Lw26MQ9cUAnfxwyEe/KRZDXfrMO+sBb3NMTsRd4vFu0OrJA8ySgkrGlOv3E4XhrvZLUm
         kvNisfcr4wXduFMZ8CE+oZZpPBjfWDSI9NKNEchuan65LsywIBWbr+vWAeBMj8L+esTw
         s27g==
In-Reply-To: <1457025602-4193-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

cgroup_update_dfl_csses() should move each task in the subtree to
self; however, it was incorrectly calling cgroup_migrate_add_src()
with the root of the subtree as @dst_cgrp.  Fortunately,
cgroup_migrate_add_src() currently uses @dst_cgrp only to determine
the hierarchy and the bug doesn't cause any actual breakages.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c63fce0..50879aa 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2901,7 +2901,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 		struct cgrp_cset_link *link;
 
 		list_for_each_entry(link, &dsct->cset_links, cset_link)
-			cgroup_migrate_add_src(link->cset, cgrp,
+			cgroup_migrate_add_src(link->cset, dsct,
 					       &preloaded_csets);
 	}
 	spin_unlock_bh(&css_set_lock);
-- 
2.5.0

