From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/27] blk-iocost: make ioc_now->now and ioc->period_at 64bit
Date: Tue,  1 Sep 2020 14:52:40 -0400
Message-ID: <20200901185257.645114-11-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kkFoDBzJXtohjGExUSaDt/SZfRBA8OsFvyf57BiJvyg=;
        b=cxg/UxVAB6yQXR3TZQm4h8sbyRVSYu+uhDSfcqkgpdnlD21RHugcINxXFcSRleiXJv
         eASQJsFp8YoQy2bNQEPjflIStjRBqT3xMzOBW+SCvqxeBqAQrYVBmJZbAcLEBn+xgZI/
         Q6vKOOK7PQsxfBPW/sgPXQ3gNtTxzElyrcOyhvQZbRmdhcIJqSKuOoltun0aP4ks/Aa9
         mP/EJrsPFqyNQuKWojEvF5Dlzic6YjUQzAg0apY1Q/bTV/X8Xv91XuKOqqYhrmEiNJId
         1OfDuY2UKMrOf0xGcPrE//vyBzVtl0l3eaIcmVJR21ld44TE7ZAYR+TWA5PTE5FqoyuX
         ziTg==
In-Reply-To: <20200901185257.645114-1-tj@kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, newella@fb.com, Tejun Heo <tj@kernel.org>

They are in microseconds and wrap in around 1.2 hours with u32. While
unlikely, confusions from wraparounds are still possible. We aren't saving
anything meaningful by keeping these u32. Let's make them u64.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 00c5a3ad2b5b..dc72cd965837 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -409,7 +409,7 @@ struct ioc {
 	atomic64_t			vtime_rate;
 
 	seqcount_spinlock_t		period_seqcount;
-	u32				period_at;	/* wallclock starttime */
+	u64				period_at;	/* wallclock starttime */
 	u64				period_at_vtime; /* vtime starttime */
 
 	atomic64_t			cur_period;	/* inc'd each period */
@@ -508,7 +508,7 @@ struct ioc_cgrp {
 
 struct ioc_now {
 	u64				now_ns;
-	u32				now;
+	u64				now;
 	u64				vnow;
 	u64				vrate;
 };
-- 
2.26.2

