From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3 for-5.4/block] iocost: bump up default latency targets
 for hard disks
Date: Wed, 25 Sep 2019 16:03:35 -0700
Message-ID: <20190925230335.GK2233839@devbig004.ftw2.facebook.com>
References: <20190925230207.GI2233839@devbig004.ftw2.facebook.com>
 <20190925230309.GJ2233839@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WfbXh+sodiUMPQSO5yCeqiJJDmHL2yMhTTI21O9c//4=;
        b=UrO+9FhI4EIs4jI4yXfKf1L+DbuNMlCxcVZ3jN5cwJ77HfdAjqNgQ6FQPxLj6MbdI5
         EQ/qM8/S1CQq7aJbPc4BEHeXaKa0t8kWWT5CI/Ss8KJpfdfe8ErjJVNEUNWUDkWlTdu7
         CHchGLYEiaLnnldmMtFmLQKgaZqfp6lWYUGq4/CRCyN96qPXjBLljijuJ4/6rOpNNE/B
         P/9roPgUV+Yc+bU/97dcTbYlgJnckw5Lls8VQSeJnLllwEXdKFmD+ONt+yzarNqHB0kZ
         WhlCKuVX9JQyMt2nUCrCRDD5K/0JcLluu+G+Yq3HIEN3rNKrvMOGWYzCiyxaKhpZuEsy
         Of9w==
Content-Disposition: inline
In-Reply-To: <20190925230309.GJ2233839@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org

The default hard disk param sets latency targets at 50ms.  As the
default target percentiles are zero, these don't directly regulate
vrate; however, they're still used to calculate the period length -
100ms in this case.

This is excessively low.  A SATA drive with QD32 saturated with random
IOs can easily reach avg completion latency of several hundred msecs.
A period duration which is substantially lower than avg completion
latency can lead to wildly fluctuating vrate.

Let's bump up the default latency targets to 250ms so that the period
duration is sufficiently long.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -529,8 +529,8 @@ struct iocg_wake_ctx {
 static const struct ioc_params autop[] = {
 	[AUTOP_HDD] = {
 		.qos				= {
-			[QOS_RLAT]		=         50000, /* 50ms */
-			[QOS_WLAT]		=         50000,
+			[QOS_RLAT]		=        250000, /* 250ms */
+			[QOS_WLAT]		=        250000,
 			[QOS_MIN]		= VRATE_MIN_PPM,
 			[QOS_MAX]		= VRATE_MAX_PPM,
 		},
