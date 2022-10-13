From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.19 19/63] blk-throttle: prevent overflow while calculating wait time
Date: Wed, 12 Oct 2022 20:17:53 -0400
Message-ID: <20221013001842.1893243-19-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620376;
        bh=BrPmkkzV33LoAQaZVvf/My4DJRhBfffGea4/qAXPUQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dky3QKgnwfLced6CDVSVB9r9w9+YVlZf20gO+HykkmI9FLLm6zgUwDoR0TBBgyQZg
         eYIVWqtJ+crN1y/MNaYpaJ6QYuQ9dJKZF8tY23qyqsq9C/97ZYZAxsiWOSVzsUA/7B
         8xkCK44eVcsxcnFnj+YxIe1Nw8v0FOVKi0ZyF6R/wLt5OlS6e/o8YHNnaqzOI9JHhz
         EE6XZ8Teb8+qBjOgSSl+93pb/g5sw+1DnD7UH6da6Uh5cWo6o1PV87WVQBmIVfAJZA
         lskVWIzrSd+CxIG59+OXcvBLRtxtgnkvRlaHsLbLrvKs079VwsELqK+N7ewQC8fgnc
         jrYTqzg3I5ivg==
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yu Kuai <yukuai3@huawei.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 8d6bbaada2e0a65f9012ac4c2506460160e7237a ]

There is a problem found by code review in tg_with_in_bps_limit() that
'bps_limit * jiffy_elapsed_rnd' might overflow. Fix the problem by
calling mul_u64_u64_div_u64() instead.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20220829022240.3348319-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 139b2d7a99e2..d3c048fbb0e5 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -806,7 +806,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 				 u64 bps_limit, unsigned long *wait)
 {
 	bool rw = bio_data_dir(bio);
-	u64 bytes_allowed, extra_bytes, tmp;
+	u64 bytes_allowed, extra_bytes;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
@@ -824,10 +824,8 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 		jiffy_elapsed_rnd = tg->td->throtl_slice;
 
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
-
-	tmp = bps_limit * jiffy_elapsed_rnd;
-	do_div(tmp, HZ);
-	bytes_allowed = tmp;
+	bytes_allowed = mul_u64_u64_div_u64(bps_limit, (u64)jiffy_elapsed_rnd,
+					    (u64)HZ);
 
 	if (tg->bytes_disp[rw] + bio_size <= bytes_allowed) {
 		if (wait)
-- 
2.35.1

