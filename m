From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] blkcg: make ->cpd_init_fn() optional
Date: Thu, 13 Jun 2019 18:56:12 -0700
Message-ID: <20190614015620.1587672-3-tj@kernel.org>
References: <20190614015620.1587672-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=75WxO2o1ANUQ23e7/l2/5rNs/NOLt4FGGwCAxlIKBW0=;
        b=qx1z00X5ideAjYd6TZno/ffdD3lXZInAFbMTneAqyt87oXP1watdYXmJaxvV7i70+G
         QpegO3wNlUlp8uYvqU7gCtA0MMQ+50hw60oZ2oxmw9x2Jy4gnpJIQzra6tLSMwfBxixg
         oxoSLws8KwRRq3WsL51VV1fof5qGlk1TNyAVDX20xydqNskOTyUeGxnQn5kpTy3OzlgA
         sG0iO7FqjL8JbO7fRzeM30Ap62l7DtUtqZawypoCeMS4jDMsqiDV4AdS+fukMbglBWcy
         R7RseVVwtMQ3x41JRBOLGi1B+ojxYMpL3G6psCVFbFKe4UPn0loETZobi3dZKh3TanSo
         Ty/w==
In-Reply-To: <20190614015620.1587672-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org, Tejun Heo <tj@kernel.org>

For policies which can do enough initialization from ->cpd_alloc_fn(),
make ->cpd_init_fn() optional.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 30d3a0fbccac..60ad9b96e6eb 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1534,7 +1534,8 @@ int blkcg_policy_register(struct blkcg_policy *pol)
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

