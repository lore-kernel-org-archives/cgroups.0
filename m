From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 4/4] writeback: remove bdi->congested_fn
Date: Thu, 2 Jul 2020 08:38:29 +0800
Message-ID: <69234075-06c9-fcca-0c59-2452aa4e2714@suse.de>
References: <20200701090622.3354860-1-hch@lst.de>
 <20200701090622.3354860-5-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200701090622.3354860-5-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, dm-devel@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On 2020/7/1 17:06, Christoph Hellwig wrote:
> Except for pktdvd, the only places setting congested bits are file
> systems that allocate their own backing_dev_info structures.  And
> pktdvd is a deprecated driver that isn't useful in stack setup
> either.  So remove the dead congested_fn stacking infrastructure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

For the bcache part, Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li


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
>  fs/btrfs/disk-io.c               | 23 -------------
>  include/linux/backing-dev-defs.h |  4 ---
>  include/linux/backing-dev.h      |  4 ---
>  include/linux/device-mapper.h    | 11 ------
>  23 files changed, 1 insertion(+), 464 deletions(-)
> 

[snipped]

> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 7acf024e99f351..cda05fc61c3afa 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1228,36 +1228,10 @@ static int cached_dev_ioctl(struct bcache_device *d, fmode_t mode,
>  	return __blkdev_driver_ioctl(dc->bdev, mode, cmd, arg);
>  }
>  
> -static int cached_dev_congested(void *data, int bits)
> -{
> -	struct bcache_device *d = data;
> -	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
> -	struct request_queue *q = bdev_get_queue(dc->bdev);
> -	int ret = 0;
> -
> -	if (bdi_congested(q->backing_dev_info, bits))
> -		return 1;
> -
> -	if (cached_dev_get(dc)) {
> -		unsigned int i;
> -		struct cache *ca;
> -
> -		for_each_cache(ca, d->c, i) {
> -			q = bdev_get_queue(ca->bdev);
> -			ret |= bdi_congested(q->backing_dev_info, bits);
> -		}
> -
> -		cached_dev_put(dc);
> -	}
> -
> -	return ret;
> -}
> -
>  void bch_cached_dev_request_init(struct cached_dev *dc)
>  {
>  	struct gendisk *g = dc->disk.disk;
>  
> -	g->queue->backing_dev_info->congested_fn = cached_dev_congested;
>  	dc->disk.cache_miss			= cached_dev_cache_miss;
>  	dc->disk.ioctl				= cached_dev_ioctl;
>  }
> @@ -1342,27 +1316,10 @@ static int flash_dev_ioctl(struct bcache_device *d, fmode_t mode,
>  	return -ENOTTY;
>  }
>  
> -static int flash_dev_congested(void *data, int bits)
> -{
> -	struct bcache_device *d = data;
> -	struct request_queue *q;
> -	struct cache *ca;
> -	unsigned int i;
> -	int ret = 0;
> -
> -	for_each_cache(ca, d->c, i) {
> -		q = bdev_get_queue(ca->bdev);
> -		ret |= bdi_congested(q->backing_dev_info, bits);
> -	}
> -
> -	return ret;
> -}
> -
>  void bch_flash_dev_request_init(struct bcache_device *d)
>  {
>  	struct gendisk *g = d->disk;
>  
> -	g->queue->backing_dev_info->congested_fn = flash_dev_congested;
>  	d->cache_miss				= flash_dev_cache_miss;
>  	d->ioctl				= flash_dev_ioctl;
>  }
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 2014016f9a60d3..1810d7ca2f6653 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -877,7 +877,6 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  
>  	d->disk->queue			= q;
>  	q->queuedata			= d;
> -	q->backing_dev_info->congested_data = d;
>  	q->limits.max_hw_sectors	= UINT_MAX;
>  	q->limits.max_sectors		= UINT_MAX;
>  	q->limits.max_segment_size	= UINT_MAX;
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index d3bb355819a421..24549dc92eeec5 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -421,8 +421,6 @@ struct cache {
>  
>  	struct rw_semaphore quiesce_lock;
>  
> -	struct dm_target_callbacks callbacks;
> -
>  	/*
>  	 * origin_blocks entries, discarded if set.
>  	 */
> @@ -2423,20 +2421,6 @@ static void set_cache_size(struct cache *cache, dm_cblock_t size)
>  	cache->cache_size = size;
>  }
>  
> -static int is_congested(struct dm_dev *dev, int bdi_bits)
> -{
> -	struct request_queue *q = bdev_get_queue(dev->bdev);
> -	return bdi_congested(q->backing_dev_info, bdi_bits);
> -}
> -
> -static int cache_is_congested(struct dm_target_callbacks *cb, int bdi_bits)
> -{
> -	struct cache *cache = container_of(cb, struct cache, callbacks);
> -
> -	return is_congested(cache->origin_dev, bdi_bits) ||
> -		is_congested(cache->cache_dev, bdi_bits);
> -}
> -
>  #define DEFAULT_MIGRATION_THRESHOLD 2048
>  
>  static int cache_create(struct cache_args *ca, struct cache **result)
> @@ -2471,9 +2455,6 @@ static int cache_create(struct cache_args *ca, struct cache **result)
>  			goto bad;
>  	}
>  
> -	cache->callbacks.congested_fn = cache_is_congested;
> -	dm_table_add_target_callbacks(ti->table, &cache->callbacks);
> -
>  	cache->metadata_dev = ca->metadata_dev;
>  	cache->origin_dev = ca->origin_dev;
>  	cache->cache_dev = ca->cache_dev;

[snipped]
