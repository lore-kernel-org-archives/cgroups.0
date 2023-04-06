From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v2 0/3] blk-cgroup: some cleanup
Date: Thu,  6 Apr 2023 22:50:47 +0800
Message-ID: <20230406145050.49914-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680792663;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jsN7tdxypihrla/GoL2oV2FbQRrK9CjsAVFPGAuvGMk=;
        b=hNPXzmSIy/mxvyggQ3ydVzZKSJmXyokWxnfuXMrXOwox3waYSO9HkrwG/OUveIPAvb
         0K5NAGLjHQD+lM5P1nRRJVprnOaQL4Yhfr7DAOL0LM57bac3qiLBE+nZ9nlINlUQfvAl
         nd+qBy402VJeQOrbVrqxNZsJkIAV84N4iRmTdQI9H5+1HvIx8HAxnCon4Ba7mIVD947S
         Echo6XtpjPCS2sx+NwqR0Mr5flBYxeMj9uAbB2Jig4vvOEz2N6OUEuHaEZxxtThXRWG5
         WYNKwgpvc4oRkks7blCcpPDF6gXXQes14x/fCEhLVsH8qMuEejRxJuVeDKB+LyGPZMj0
         x1Sw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org
Cc: paolo.valente@linaro.org, josef@toxicpanda.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>

These are some cleanup patches of blk-cgroup. Thanks for review.

v2:
 - Add Acked tags from Tejun.

Chengming Zhou (3):
  block, bfq: remove BFQ_WEIGHT_LEGACY_DFL
  blk-cgroup: delete cpd_bind_fn of blkcg_policy
  blk-cgroup: delete cpd_init_fn of blkcg_policy

 block/bfq-cgroup.c  | 12 ++----------
 block/bfq-iosched.h |  1 -
 block/blk-cgroup.c  | 25 -------------------------
 block/blk-cgroup.h  |  2 --
 4 files changed, 2 insertions(+), 38 deletions(-)

-- 
2.39.2

