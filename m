From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 0/4] Some improvements for blk throttle
Date: Sun, 20 Sep 2020 17:10:17 +0800
Message-ID: <cover.1600592693.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang@linux.alibaba.com, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

This patch set did some improvements for blk throttle, please
help to review. Thanks.

Baolin Wang (4):
  blk-throttle: Remove a meaningless parameter for
    throtl_downgrade_state()
  blk-throttle: Avoid getting the current time if tg->last_finish_time
    is 0
  blk-throttle: Avoid tracking latency if low limit is invalid
  blk-throttle: Fix IO hang for a corner case

 block/blk-throttle.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

-- 
1.8.3.1

