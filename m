From: Christoph Hellwig <hch@lst.de>
Subject: remove dead bdi congestion leftovers
Date: Wed,  1 Jul 2020 11:06:18 +0200
Message-ID: <20200701090622.3354860-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=kVtz6vlqJaw/bVcdduLYH4iE1TfD3bHAdPcoJqUty3c=; b=fqj9Bq+LPiX5Cw82+DKENOtZGq
        aBH2pV9JriMzRvy5+0j64xrRmqbi06FwHdCyyH3uCDubulK1NERetFJK1xFzKQY+iXQVy5XGPU+xl
        /8+zjmJSUzyKDSohp1PbTPulp7b3LNcKbeAeTRiFa5ER5du9CjNnVFmk1/cLC4YQcwJeNFeAu/B/t
        7LQYhpHNJ89uXgEEGIP8Kl/6Q59oBdTnE2iI0XlR6ib/eAbUM2WK68TsWfzhy2JvgP5NrxmDNwUdK
        2kLdrPLtmrx4+deQuyG8ej+JvRoHTRyPjJ4ocq2XFWOIjBChE8rflkGjPJ8f2cJsvLg9xAC3ZO5Oq
        zQLc42fA==;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, dm-devel@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hi Jens,

we have a lot of bdi congestion related code that is left around without
any use.  This series removes it in preparation of sorting out the bdi
lifetime rules properly.

Diffstat:
 block/blk-cgroup.c               |   19 ----
 drivers/block/drbd/drbd_main.c   |   59 --------------
 drivers/block/drbd/drbd_proc.c   |    1 
 drivers/md/bcache/request.c      |   43 ----------
 drivers/md/bcache/super.c        |    1 
 drivers/md/dm-cache-target.c     |   19 ----
 drivers/md/dm-clone-target.c     |   15 ---
 drivers/md/dm-era-target.c       |   15 ---
 drivers/md/dm-raid.c             |   12 --
 drivers/md/dm-table.c            |   37 ---------
 drivers/md/dm-thin.c             |   16 ---
 drivers/md/dm.c                  |   33 --------
 drivers/md/dm.h                  |    1 
 drivers/md/md-linear.c           |   24 -----
 drivers/md/md-multipath.c        |   23 -----
 drivers/md/md.c                  |   23 -----
 drivers/md/md.h                  |    4 
 drivers/md/raid0.c               |   16 ---
 drivers/md/raid1.c               |   31 -------
 drivers/md/raid10.c              |   26 ------
 drivers/md/raid5.c               |   25 ------
 fs/btrfs/disk-io.c               |   23 -----
 include/linux/backing-dev-defs.h |   43 ----------
 include/linux/backing-dev.h      |   22 -----
 include/linux/blk-cgroup.h       |    6 -
 include/linux/device-mapper.h    |   11 --
 mm/backing-dev.c                 |  157 +++------------------------------------
 27 files changed, 20 insertions(+), 685 deletions(-)
