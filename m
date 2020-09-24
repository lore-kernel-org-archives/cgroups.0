From: Christoph Hellwig <hch@lst.de>
Subject: bdi cleanups v7
Date: Thu, 24 Sep 2020 08:51:27 +0200
Message-ID: <20200924065140.726436-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=5cv5XM1WbeIcMKM5m6HEEjDcYpaEJfjGWw9dDjM6nfI=; b=r2w8hhD+ZBoRdDKl0qZXo3vF81
        hM/13MLXzpPkHMHSdkeatYWtW/3Rk3FztSV6U5y+CbAh6t7JHsfTFWVb3fcVheFT1g+IP1CUvdL/M
        qf6RvhVVVcfKzIDmXfduJ5W90Ne2Xmv0UFnYt+mp024P858pnetDNMffHtNWZutPuWI481/Ixizft
        VzlRi+PBja8K/ca/ZHfPdeq8UXLIZ3VY+HnhwsTOu5umASFwHza1/IftOvz3nrDcW8iJ2OvWsxcVr
        FHnaTnZTbgNXfbL0liL+h4MJ2F/DEq8P/XjVxB+RLUSVk0zwY6gebGFkYLAM8tqFMr4ps3to5Wmm/
        AERB55ug==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Coly Li <colyli@suse.de>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Justin Sanders <justin@coraid.com>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

Hi Jens,

this series contains a bunch of different BDI cleanups.  The biggest item
is to isolate block drivers from the BDI in preparation of changing the
lifetime of the block device BDI in a follow up series.

Changes since v6:
 - add a new blk_queue_update_readahead helper and use it in stacking
   drivers
 - improve another commit log

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
