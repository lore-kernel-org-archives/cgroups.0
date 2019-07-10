From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] blkcg: make ->cpd_init_fn() optional
Date: Wed, 10 Jul 2019 13:51:20 -0700
Message-ID: <20190710205128.1316483-3-tj@kernel.org>
References: <20190710205128.1316483-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XFh42r4xNNDnKj1zoXVhN66idRikWSnd44I9jtIogT8=;
        b=myn7c+wAv6aqdY+Lq3Y+dXFf6vNr1cjq2qmjuWFHefy8B5VaVPpKh1Zen3sG5yyIau
         S+fHXCHIHZK62ZZZQl4GKYZx3aqVkisP3cvekm3Q2t6MsiYuNCz6lFoZZVErcPhI5YZV
         snwp1Si+NXJ6E0KkySFS60F7xP2MZCSzvuNezrwuELLs11zfq6G+U57lKx0qEXGH6Qme
         qdfnP7ElPrZVbfMFcyH7L8UlwlmnfQtiId0n8Gqx/bAFzRnEaucNrTNvzxXthawnlvdj
         8A7r/XaX0aXuYCbPy/wXIVRykURG6GzFcY3gU3eCkjiM7Ob/nxMrMiezEJGx/7EQkEsq
         ClHg==
In-Reply-To: <20190710205128.1316483-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

For policies which can do enough initialization from ->cpd_alloc_fn(),
make ->cpd_init_fn() optional.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 75f7f78b87b2..818e50b4cc7a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1478,7 +1478,8 @@ int blkcg_policy_register(struct blkcg_policy *pol)
 			blkcg->cpd[pol->plid] = cpd;
 			cpd->blkcg = blkcg;
 			cpd->plid = pol->plid;
-			pol->cpd_init_fn(cpd);
+			if (pol->cpd_init_fn)
+				pol->cpd_init_fn(cpd);
 		}
 	}
 
-- 
2.17.1

