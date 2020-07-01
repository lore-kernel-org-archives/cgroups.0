From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 4/4] writeback: remove bdi->congested_fn
Date: Wed, 1 Jul 2020 16:48:06 +0200
Message-ID: <20200701144805.GC27795@twin.jikos.cz>
References: <20200701090622.3354860-1-hch@lst.de>
 <20200701090622.3354860-5-hch@lst.de>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200701090622.3354860-5-hch@lst.de>
Sender: linux-bcache-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, dm-devel@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed, Jul 01, 2020 at 11:06:22AM +0200, Christoph Hellwig wrote:
> Except for pktdvd, the only places setting congested bits are file
> systems that allocate their own backing_dev_info structures.  And
> pktdvd is a deprecated driver that isn't useful in stack setup
> either.  So remove the dead congested_fn stacking infrastructure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/drbd/drbd_main.c   | 59 --------------------------------
>  drivers/md/bcache/request.c      | 43 -----------------------
>  drivers/md/bcache/super.c        |  1 -
>  drivers/md/dm-cache-target.c     | 19 ----------
>  drivers/md/dm-clone-target.c     | 15 --------
>  drivers/md/dm-era-target.c       | 15 --------
>  drivers/md/dm-raid.c             | 12 -------
>  drivers/md/dm-table.c            | 37 +-------------------
>  drivers/md/dm-thin.c             | 16 ---------
>  drivers/md/dm.c                  | 33 ------------------
>  drivers/md/dm.h                  |  1 -
>  drivers/md/md-linear.c           | 24 -------------
>  drivers/md/md-multipath.c        | 23 -------------
>  drivers/md/md.c                  | 23 -------------
>  drivers/md/md.h                  |  4 ---
>  drivers/md/raid0.c               | 16 ---------
>  drivers/md/raid1.c               | 31 -----------------
>  drivers/md/raid10.c              | 26 --------------
>  drivers/md/raid5.c               | 25 --------------

For the btrfs bits

>  fs/btrfs/disk-io.c               | 23 -------------

Acked-by: David Sterba <dsterba@suse.com>
