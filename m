From: Christoph Hellwig <hch@lst.de>
Subject: move the bdi from the request_queue to the gendisk
Date: Mon,  9 Aug 2021 16:17:39 +0200
Message-ID: <20210809141744.1203023-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=/1LqcjPeqkvTqmLoClgHGpxYg7gRK9WdMqO+RkPb7dU=; b=qaeVxxYlsqLnEMTE4rjzYnt+Lh
        muxR3ztLnp5WIHrYANGGeM+/zKKxKZNON67rQvXB/kC0sl/VEP0LTlmTmiIzaZgec9GOB0C0NYJja
        zng9cjNKj7KMCPjFRAEVEJtExmgE+sNgpYoVsTWqPi9Ky0fcuU4v7pH281Fn7AcWOdhiuQ5vel2Y9
        qeH5hEE5B2AfGaOADshEolNYxvTgAap5nZiTRFDlOex7G1rdg0aBr74tt7tePqI0UBh6u8A7KSEQb
        pusAFK4G+UhjKmEuWliS5x38l1Hb+Ivz5RYqFh8Ui3VWK+BsumJlZ+dumL3hOBxImK0nrFxeSuUxY
        2wyC1qHA==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

Hi Jens,

this series moves the pointer to the bdi from the request_queue
to the bdi, better matching the life time rules of the different
objects.

Diffstat:
 block/bfq-iosched.c           |    4 ++--
 block/blk-cgroup.c            |    7 +++----
 block/blk-core.c              |   18 +++---------------
 block/blk-mq.c                |    2 +-
 block/blk-settings.c          |   22 ++++++++++++++--------
 block/blk-sysfs.c             |   28 +++++++++++++---------------
 block/blk-wbt.c               |   10 +++++-----
 block/genhd.c                 |   23 ++++++++++++++---------
 block/ioctl.c                 |    7 ++++---
 drivers/block/drbd/drbd_nl.c  |    2 +-
 drivers/block/drbd/drbd_req.c |    5 ++---
 drivers/block/pktcdvd.c       |    8 +++-----
 drivers/md/dm-table.c         |    2 +-
 drivers/nvme/host/core.c      |    2 +-
 fs/block_dev.c                |   13 +------------
 fs/fat/fatent.c               |    1 +
 fs/nilfs2/super.c             |    2 +-
 fs/super.c                    |    2 +-
 fs/xfs/xfs_buf.c              |    2 +-
 include/linux/backing-dev.h   |    2 +-
 include/linux/blk_types.h     |    1 -
 include/linux/blkdev.h        |    6 ++----
 include/linux/genhd.h         |    1 +
 mm/backing-dev.c              |    3 +++
 mm/page-writeback.c           |    2 --
 25 files changed, 79 insertions(+), 96 deletions(-)
