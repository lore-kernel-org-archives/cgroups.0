From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: bdi cleanups v6
Date: Mon, 21 Sep 2020 10:07:21 +0200
Message-ID: <20200921080734.452759-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=VM2ZDhyOxyQ2Y1dDHiBEPye1qG1o//V0l6TNm5Sr/FU=; b=t0/fR3slvRiXSRxi1ANdVCAPYJ
        cTpjX/9/46DAos1ZZSmSu9iT0bOAPH4s2IIQBYnzF5i80UAkswyyGMaX0ZSmgY9fkoz8dCCpQ3+7h
        Adb3hpLeikh8u7CgrIF0WEBhX1fEIUEBxABgoXVNxCW1d5j5AJgOmtKyCBBj6KDhXKtSvy1xIZBCc
        IWeakTABDNWW43uVABcmb9AXarhhnZYbB4WsyHg0bVqgcTwp9gTxUmvPRwOHYCv4yoky6MCSu5YHs
        0Dz4Pd9AlW7rqDQtJJ5kr4i2Iv7QuEQOFdXgfTL2W5GuhU2d2n8/lsi8Wix4SdH3T6pdRU7OWXlMJ
        GBC1k5xQ==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Thumshirn <Johannes.Thumshirn-Sjgp3cTcYWE@public.gmane.org>, Justin Sanders <justin-kFqnmIA2sJXQT0dZR+AlfA@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Jens,

this series contains a bunch of different BDI cleanups.  The biggest item
is to isolate block drivers from the BDI in preparation of changing the
lifetime of the block device BDI in a follow up series.

Changes since v5:
 - improve a commit message
 - improve the stable_writes deprecation printk
 - drop "drbd: remove RB_CONGESTED_REMOTE"
 - drop a few hunks that add a local variable in a otherwise unchanged
   file due to changes in the previous revisions
 - keep updating ->io_pages in queue_max_sectors_store
 - set an optimal I/O size in aoe
 - inherit the optimal I/O size in bcache

Changes since v4:
 - add a back a prematurely removed assignment in dm-table.c
 - pick up a few reviews from Johannes that got lost

Changes since v3:
 - rebased on the lasted block tree, which has some of the prep
   changes merged
 - extend the ->ra_pages changes to ->io_pages
 - move initializing ->ra_pages and ->io_pages for block devices to
   blk_register_queue

Changes since v2:
 - fix a rw_page return value check
 - fix up various changelogs

Changes since v1:
 - rebased to the for-5.9/block-merge branch
 - explicitly set the readahead to 0 for ubifs, vboxsf and mtd
 - split the zram block_device operations
 - let rw_page users fall back to bios in swap_readpage


Diffstat:
