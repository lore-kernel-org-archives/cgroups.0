From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH blk-cgroup/for-5.8] blk-cgroup: show global disk stats in
 root cgroup io.stat
Date: Mon, 1 Jun 2020 11:43:51 -0400
Message-ID: <20200601154351.GD31548@mtj.thefacebook.com>
References: <20200529232017.1795920-1-boris@bur.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G2ppN+SO01U35andcJx4wK7uE7Y/yhFiQ+1V3mTLz5k=;
        b=g9LHrVyOk4LXkO1djAdvgd7CoGtQeMTrsqvothE6BTPFJHbZe1UYxFWaj2XyM5+u2v
         mIzUJNAuuxFS1k6lMjA0i5s4/9jM45hbiIf8z0Dygga25k5k+7D6d43ZbgDv61GZdkPh
         vtRTrhph/+vvVXh6nvvH+GMtH5KdVjeQ4IMvg4ZWEu6I8tvl7HMF0VBK9vUfvMOEtC1T
         ePkoMQeqZDC5D6jatZ0EUQgWuhwlYGRn+qhPlayT98/jFKvUdkeIJQQSSs5ZuvYtZDk3
         ZGD5JVvRxwXieZvNhlpPZ9Dq0UEmyVz4cRGWwiGy4h/S27RV5TUM1ECVgCN1RejuUZcC
         S2Pg==
Content-Disposition: inline
In-Reply-To: <20200529232017.1795920-1-boris-UrQYPotlwNs@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello, Boris.

On Fri, May 29, 2020 at 04:20:17PM -0700, Boris Burkov wrote:
> In order to improve consistency and usability in cgroup stat accounting,
> we would like to support the root cgroup's io.stat.
> 
> Since the root cgroup has processes doing io even if the system has no
> explicitly created cgroups, we need to be careful to avoid overhead in
> that case.  For that reason, the rstat algorithms don't handle the root
> cgroup, so just turning the file on wouldn't give correct statistics.
> 
> To get around this, we simulate flushing the iostat struct by filling it
> out directly from global disk stats. The result is a root cgroup io.stat
> file consistent with both /proc/diskstats and io.stat.
> 
> Signed-off-by: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
> Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
...
> +static void blkg_iostat_set(struct blkg_iostat *dst, struct blkg_iostat *src)
> +{

Can you please separate out code reorganization to a separate patch so that
the actual change can be reviewed clearly?

> +/*
> + * The rstat algorithms intentionally don't handle the root cgroup to avoid
> + * incurring overhead when no cgroups are defined. For that reason,
> + * cgroup_rstat_flush in blkcg_print_stat does not actually fill out the
> + * iostat in the root cgroup's blkcg_gq.
> + *
> + * However, we would like to re-use the printing code between the root and
> + * non-root cgroups to the extent possible. For that reason, we simulate
> + * flushing the root cgroup's stats by explicitly filling in the iostat
> + * with disk level statistics.
> + */

This is clever and neat.

> +static void blkcg_fill_root_iostats(void)
> +{
> +	struct class_dev_iter iter;
> +	struct device *dev;
> +
> +	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
> +	while ((dev = class_dev_iter_next(&iter))) {
> +		struct gendisk *disk = dev_to_disk(dev);
> +		struct hd_struct *part = disk_get_part(disk, 0);
> +		struct blkcg_gq *blkg = blk_queue_root_blkg(disk->queue);
> +		struct blkg_iostat tmp;
> +		int cpu;
> +
> +		memset(&tmp, 0, sizeof(tmp));
> +		for_each_possible_cpu(cpu) {
> +			struct disk_stats *cpu_dkstats;
> +
> +			cpu_dkstats = per_cpu_ptr(part->dkstats, cpu);
> +			tmp.ios[BLKG_IOSTAT_READ] +=
> +				cpu_dkstats->ios[STAT_READ];
> +			tmp.ios[BLKG_IOSTAT_WRITE] +=
> +				cpu_dkstats->ios[STAT_WRITE];
> +			tmp.ios[BLKG_IOSTAT_DISCARD] +=
> +				cpu_dkstats->ios[STAT_DISCARD];
> +			// convert sectors to bytes
> +			tmp.bytes[BLKG_IOSTAT_READ] +=
> +				cpu_dkstats->sectors[STAT_READ] << 9;
> +			tmp.bytes[BLKG_IOSTAT_WRITE] +=
> +				cpu_dkstats->sectors[STAT_WRITE] << 9;
> +			tmp.bytes[BLKG_IOSTAT_DISCARD] +=
> +				cpu_dkstats->sectors[STAT_DISCARD] << 9;
> +
> +			u64_stats_update_begin(&blkg->iostat.sync);
> +			blkg_iostat_set(&blkg->iostat.cur, &tmp);
> +			u64_stats_update_end(&blkg->iostat.sync);
> +		}
> +	}
> +}
...
> diff --git a/block/genhd.c b/block/genhd.c
> index afdb2c3e5b22..4f5f4590517c 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -38,8 +38,6 @@ static struct kobject *block_depr;
>  static DEFINE_SPINLOCK(ext_devt_lock);
>  static DEFINE_IDR(ext_devt_idr);
>  
> -static const struct device_type disk_type;
> -
>  static void disk_check_events(struct disk_events *ev,
>  			      unsigned int *clearing_ptr);
>  static void disk_alloc_events(struct gendisk *disk);
> @@ -1566,7 +1564,7 @@ static char *block_devnode(struct device *dev, umode_t *mode,
>  	return NULL;
>  }
>  
> -static const struct device_type disk_type = {
> +const struct device_type disk_type = {
>  	.name		= "disk",
>  	.groups		= disk_attr_groups,
>  	.release	= disk_release,
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index a9384449465a..ea38bc36bc6d 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -26,6 +26,7 @@
>  #define disk_to_dev(disk)	(&(disk)->part0.__dev)
>  #define part_to_dev(part)	(&((part)->__dev))
>  
> +extern const struct device_type disk_type;

So, this is fine but I'd explicitly mention it in the patch description.

Thanks.

-- 
tejun
