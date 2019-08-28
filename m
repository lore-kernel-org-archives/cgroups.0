From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] blkcg: make ->cpd_init_fn() optional
Date: Wed, 28 Aug 2019 15:05:52 -0700
Message-ID: <20190828220600.2527417-3-tj@kernel.org>
References: <20190828220600.2527417-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=77lPCJVMbm2iaN6uswmaTozVPtpjzTspO9i1Ih4UGx0=;
        b=lkuKDlvcQJNAPDyWqh7z64PzAcgiPoVACIt2kCEHwITSzvm4646qx3UMoaXftENKBP
         qLyFOZlWg14FxVymoH+uPbQl5Gnj4yAngGhap+ZB4Fye+TKJ5t9O9oP3sOU0ECzPLIOu
         wxBCfu1/n/dbUAViCv+xm4hkJguZeixMibUkeKzeq++SwfncBv9StsMNCnbev2XjWe8s
         s+aivSvYkDNyXnvuS80dFmkhr36IlGtUhus4hZmcE4BNJGEROllypy8x7eOngTefjfPV
         NtY5z2iL8XeBKR+WnmNvi5CAGSiOehrdsB49BDNYDXU7nwVWydGk6Zc/AFGP+5IcHCPw
         q23A==
In-Reply-To: <20190828220600.2527417-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

For policies which can do enough initialization from ->cpd_alloc_fn(),
make ->cpd_init_fn() optional.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 6a82ca3fb5cf..78ccbdcfe723 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1475,7 +1475,8 @@ int blkcg_policy_register(struct blkcg_policy *pol)
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

