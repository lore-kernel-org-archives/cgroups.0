From: Christoph Hellwig <hch@lst.de>
Subject: switch blk-cgroup to work on gendisk
Date: Tue, 17 Jan 2023 09:12:42 +0100
Message-ID: <20230117081257.3089859-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=tBaVz7h6Ls5siSdNgvaB/QpLtiTcpj4YxidHypc3EsY=; b=TPAf0kJR2DrWHNeTZaF0cwyCha
        oXCkMJtO/yr5NEOzj5pVvHgaw3LPe8wIkVvXv4uZEG8Wyw1r2G4C3lHoqXC3gC6RHblhADFQq6qGy
        xlDTcUHbKrZnLaZUK/SgToLvXY2Kt7dw9EuUAkLJ7j8O1dcUs/sJNWE5d8/l7tpn1cbI2Tx124G/F
        ijXaaOaeRDQAIosHFZDvlzPWQWdmWsSzuTPwwRKKBfRxwLI4IBmhUhNNKdeVZtPDN8WpODx4zhPU8
        Qy6O20qOK19+q2Op0q38iZ0M4oDM3SddzvtQk/em5usPHPaBph6Pjep3WHSQ2N29gQ1u+hjUygNnZ
        +q8w6LmA==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

Hi all,

blk-cgroup works on only on live disks and "file system" I/O from bios.
This all the information should be in the gendisk, and not the
request_queue that also exists for pure passthrough request based
devices.

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
