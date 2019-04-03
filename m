From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] cgroup: remove extra cgroup_migrate_finish() call
Date: Wed,  3 Apr 2019 16:03:54 -0700
Message-ID: <20190403230354.117915-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FIYtD+2JyCBUBuNMFC53VJ5k0K3Im0wqDkI3BMTr5U0=;
        b=uvpQS/sOp0F4/7auZRIGbkWQpb4Wu8lNLSbaYPYCQuDPuIIctcQEg03f3TKnxmS6oc
         HIFMCKzdOSuYNWqcl4Q5VsHjWov71kLFC/b63Qv6PAQ8+ff4JsaOWb7nhC6oOs/yMv3m
         7ptIBR4Elsi28SMZ4ujXt9e1T/lE8er+N6aJiBgec0jowELLZWn8CsCciFPO29CUehhO
         QE93VHLSn35s1N/muma+UvtJHhlXyABdQl4DR6Xtkuzl/4S93zPjUMak0/M9thzI8WB4
         dxZ5+ezMY/TZeQ+EUFqedh6wDmNDeB+acwnkx9cmnwd6R4un0VFKkASUgPCboUcbwYX7
         bFBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

The callers of cgroup_migrate_prepare_dst() correctly call
cgroup_migrate_finish() for success and failure cases both. No need to
call it in cgroup_migrate_prepare_dst() in failure case.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 kernel/cgroup/cgroup.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 3f2b4bde0f9c..f219c195a9a5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2602,7 +2602,7 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 
 		dst_cset = find_css_set(src_cset, src_cset->mg_dst_cgrp);
 		if (!dst_cset)
-			goto err;
+			return -ENOMEM;
 
 		WARN_ON_ONCE(src_cset->mg_dst_cset || dst_cset->mg_dst_cset);
 
@@ -2634,9 +2634,6 @@ int cgroup_migrate_prepare_dst(struct cgroup_mgctx *mgctx)
 	}
 
 	return 0;
-err:
-	cgroup_migrate_finish(mgctx);
-	return -ENOMEM;
 }
 
 /**
-- 
2.21.0.392.gf8f6787159e-goog

