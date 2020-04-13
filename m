From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET v2 block/for-5.8] iocost: improve use_delay and latency target handling
Date: Mon, 13 Apr 2020 12:27:54 -0400
Message-ID: <20200413162758.97252-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kgnSzHTYieIvS0nv69ZyDoepjTsOMDuCzo7OjVc7aYQ=;
        b=smPWj6uFcGxjikAWXyCjZk81xcoBdlfI1r09+XQvuTJU0NLeoa4fGgalgQF+RXTNVy
         y1njgc2Q/+NJQ0bP9d+A4RWbHFmyg87LdSZFCrMsQklZXF0qGm0o+DrodsL92rbOzmQt
         G++EEpyVSa7lrtjupMHe3jNU0DHa4m/9VLsmROB5eD7iH9264C7ozZdcegrzUOLyZdtf
         gxkJ2V7ipVx6uZHtM4rZhdRT0FWPvqy6KrzG2GaXP1Vshw+r7ngWejmoHgX4AmOkdfKW
         m0/9Rgj4TtgIZPy6zYwPOfcR2/iBwH+FsKwNnZSIhRaMQ1mw6mpDcjIGk14FL7TXXbHs
         zUvg==
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, newella@fb.com, josef@toxicpanda.com, asml.silence@gmail.com, ming.lei@redhat.com, bvanassche@acm.org

Changes from v1[1]

* Dropped 0002-block-add-request-io_data_len.patch and updated to use
  rq->stats_sectors instead as suggested by Pavel Begunkov.

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
 0002-blk-iocost-account-for-IO-size-when-testing-latencie.patch
 0003-iocost_monitor-exit-successfully-if-interval-is-zero.patch
 0004-iocost_monitor-drop-string-wrap-around-numbers-when-.patch

and is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git iocost-delay-latency-v2

diffstat follows. Thanks.

 block/Kconfig                  |    1 
 block/blk-cgroup.c             |    6 ++++
 block/blk-iocost.c             |   56 +++++++++++++++++++++++++++++------------
 include/linux/blk-cgroup.h     |   43 ++++++++++++++++++++++++-------
 tools/cgroup/iocost_monitor.py |   48 +++++++++++++++++++----------------
 5 files changed, 106 insertions(+), 48 deletions(-)

--
tejun

[1] http://lkml.kernel.org/r/20200408201450.3959560-1-tj@kernel.org

