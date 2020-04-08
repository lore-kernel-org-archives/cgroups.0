From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET block/for-5.8] iocost: improve use_delay and latency target handling
Date: Wed,  8 Apr 2020 16:14:45 -0400
Message-ID: <20200408201450.3959560-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sbOTLSdpKRSWoJg86rhLkNXWwpT6Ra+lmlyLxQcG74M=;
        b=EAQj6ooRELE1aSGdzl7xJCc1N1bQ2cVXEuUaSuPh+B65JXFnbaMPbHPnsYsojbTQTv
         J82pjh9KiPam7s6QYx7bnkyDaxRbQFxhX1VnRY/G1HkxOfJrvF2n+2L85QAxDdSaSoUr
         n6H9+zQQamAM0P5VBdHIMJ8vxacPTyhuUmZHyRXrm6NSAw00nu1Qn57W0euRSLugCmZi
         pWBk/lQmL0FXqZVjLH5BO+6+dLC5aQfBwRNkC0WBOV5HvTIF6/E50Hz2YII0b89d978J
         zf8uziZ991jIjlqmJERnMicGbdRW1Y1ZI6n2EK3YeC+aUPZAZ0O3HrbJm9/W+oR7Kr1N
         /l0A==
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@vger.kernel.org, cgroups@vger.kernel.org, newella@fb.com, josef@toxicpanda.com

Hello, Jens.

This patchset improves the following two iocost control behaviors.

* iocost was failing to punish heavy shared IO generators (file metadata, memory
  reclaim) through use_delay mechanism - use_delay automatically decays which
  works well for iolatency but doesn't match how iocost behaves. This led to
  e.g. memory bombs which generate a lot of swap IOs to use over their allotted
  amount. This is fixed by adding non-decaying use_delay mechanism.

* The same latency targets were being applied regardless of the IO sizes. While
  this works fine for loose targets, it gets in the way when trying to tigthen
  them - a latency target adequate for a 4k IO is too short for a 1 meg IO.
  iocost now discounts the size portion of cost when testing whether a given IO
  met or missed its latency target.

While at it, it also makes minor changse to iocost_monitor.py.

This patchset contains the following five patches.

 0001-blk-iocost-switch-to-fixed-non-auto-decaying-use_del.patch
 0002-block-add-request-io_data_len.patch
 0003-blk-iocost-account-for-IO-size-when-testing-latencie.patch
 0004-iocost_monitor-exit-successfully-if-interval-is-zero.patch
 0005-iocost_monitor-drop-string-wrap-around-numbers-when-.patch

and is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git iocost-delay-latency

diffstat follows. Thanks.

 block/Kconfig                  |    4 +++
 block/blk-cgroup.c             |    6 ++++
 block/blk-iocost.c             |   54 ++++++++++++++++++++++++++++-------------
 block/blk-mq.c                 |    6 ++++
 include/linux/blk-cgroup.h     |   43 +++++++++++++++++++++++++-------
 include/linux/blkdev.h         |    8 ++++++
 tools/cgroup/iocost_monitor.py |   48 +++++++++++++++++++-----------------
 7 files changed, 121 insertions(+), 48 deletions(-)

--
tejun

