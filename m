From: Christoph Hellwig <hch@lst.de>
Subject: switch blk-cgroup to work on gendisk v2
Date: Tue, 24 Jan 2023 07:57:00 +0100
Message-ID: <20230124065716.152286-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=VmYGANj5EWw8Lo4TLS15TVfS0hjnPfIXbECc6g3JZec=; b=cFatyu2CSvkHizkSFbuyleHtBb
        LKYY2w1tKlWZ+BbxR6ZL26qnFDlAAH8L5jxJuAZhSbVqrGHQhFzRfII0g0uCo67pZBYa5azgqsD07
        NTmLTs0ctgryv5x47YoyMMnbNSNQGhReS/ofPuPK15kBY84vcmuRjJtRVCDQABhTL6wJuf+tWLZrL
        4upq31PcJ1eLUXeyurgvIMS5bCj+3iS4iCFEedpi6As62PNJmu2+4RgCuS+ToKByb0QgKjCxjEUz0
        FRX5eU4qOsjmMyt21MrFfF18RVfejlLOLwy2NpHzMpyhc/52L1f+QaQbinrHP9Rud6i2uTbBsmPOk
        GxIcU5KA==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

Hi all,

blk-cgroup works on only on live disks and "file system" I/O from bios.
This all the information should be in the gendisk, and not the
request_queue that also exists for pure passthrough request based
devices.

Changes since v1:
 - use the local disk variable in wbt_init instead of q->disk
 - various spelling fixes

Diffstat:
 block/bfq-cgroup.c        |   18 ++--
 block/bfq-iosched.c       |    6 -
 block/blk-cgroup-rwstat.c |    2 
 block/blk-cgroup.c        |  185 +++++++++++++++++++++-------------------------
 block/blk-cgroup.h        |   41 ++++------
 block/blk-iocost.c        |   40 ++++-----
 block/blk-iolatency.c     |   41 ++++------
 block/blk-ioprio.c        |    6 -
 block/blk-mq-debugfs.c    |   10 --
 block/blk-rq-qos.c        |   67 ++++++++++++++++
 block/blk-rq-qos.h        |   66 +---------------
 block/blk-stat.c          |    3 
 block/blk-sysfs.c         |    4 
 block/blk-throttle.c      |   31 ++++---
 block/blk-wbt.c           |   39 ++++-----
 block/blk-wbt.h           |   12 +-
 block/genhd.c             |   17 ++--
 include/linux/blkdev.h    |   10 +-
 include/linux/sched.h     |    2 
 kernel/fork.c             |    2 
 mm/swapfile.c             |    2 
 21 files changed, 292 insertions(+), 312 deletions(-)
