From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/27] blk-iocost: clamp inuse and skip noops in __propagate_weights()
Date: Tue,  1 Sep 2020 14:52:35 -0400
Message-ID: <20200901185257.645114-6-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a96NqVhWlH/6rbnaJHsSXmoP7NyH4YVeyS7xAuR4Ue8=;
        b=Rl00dssZUwB0VlBF0vtS3UAVh028ZEmyWDony//gcOYbkr1LyexfkGRr2AguBVNakR
         K9Ebkf/f1WXdvNiuOuHTGxQxRLnqr3R8Fm7YHS1XMUOlsM758If3x29KbUASRlcqgw30
         vqtyL+ENveuwJjS5jDfPnVcikKUUEnxCOzWM6HwXiVJ/CZPghydNweK9CflK1x5ZGzrk
         V2fj/o0wnwORTQvSZYBc3FYl5UTbNxX5tZhJvvqbb3rFrh3GCGYCrH9CnrGOi2q5PrwO
         d6ktGCGprgljvf9/VpsSttymMRC1kzi+LXId7l4BQgp7cA1tElxDRWhoJafqSIslJER8
         K1BQ==
In-Reply-To: <20200901185257.645114-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, newella@fb.com, Tejun Heo <tj@kernel.org>

__propagate_weights() currently expects the callers to clamp inuse within
[1, active], which is needlessly fragile. The inuse adjustment logic is
going to be revamped, in preparation, let's make __propagate_weights() clamp
inuse on entry.

Also, make it avoid weight updates altogether if neither active or inuse is
changed.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 78e6919153d8..8dfe73dde2a8 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -897,7 +897,10 @@ static void __propagate_weights(struct ioc_gq *iocg, u32 active, u32 inuse)
 
 	lockdep_assert_held(&ioc->lock);
 
-	inuse = min(active, inuse);
+	inuse = clamp_t(u32, inuse, 1, active);
+
+	if (active == iocg->active && inuse == iocg->inuse)
+		return;
 
 	for (lvl = iocg->level - 1; lvl >= 0; lvl--) {
 		struct ioc_gq *parent = iocg->ancestors[lvl];
-- 
2.26.2

