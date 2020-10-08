From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH v2 0/8] Some improvements for blk throttle
Date: Thu,  8 Oct 2020 11:52:21 +0800
Message-ID: <cover.1602128837.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang@linux.alibaba.com, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

This patch set did some improvements for blk throttle, please
help to review. Thanks.

Changes from v1:
 - Add another 4 new patches in this patch set.

Baolin Wang (8):
  blk-throttle: Remove a meaningless parameter for
    throtl_downgrade_state()
  blk-throttle: Avoid getting the current time if tg->last_finish_time
    is 0
  blk-throttle: Avoid tracking latency if low limit is invalid
  blk-throttle: Fix IO hang for a corner case
  blk-throttle: Move the list operation after list validation
  blk-throttle: Move service tree validation out of the
    throtl_rb_first()
  blk-throttle: Open code __throtl_de/enqueue_tg()
  blk-throttle: Re-use the throtl_set_slice_end()

 block/blk-throttle.c | 69 ++++++++++++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 34 deletions(-)

-- 
1.8.3.1

