From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 0/5] Some improvements for blk-throttle
Date: Mon,  7 Sep 2020 16:10:12 +0800
Message-ID: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang@linux.alibaba.com, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi All,

This patch set did some clean-ups, as well as removing some unnecessary
bps/iops limitation calculation when checking if can dispatch a bio or
not for a tg. Please help to review. Thanks.

Baolin Wang (5):
  blk-throttle: Fix some comments' typos
  blk-throttle: Use readable READ/WRITE macros
  blk-throttle: Define readable macros instead of static variables
  blk-throttle: Avoid calculating bps/iops limitation repeatedly
  blk-throttle: Avoid checking bps/iops limitation if bps or iops is    
    unlimited

 block/blk-throttle.c | 59 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 23 deletions(-)

-- 
1.8.3.1

