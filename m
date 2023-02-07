From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 02/19] blk-cgroup: delay blk-cgroup initialization until
 add_disk
Date: Tue, 7 Feb 2023 22:40:32 +0800
Message-ID: <Y+Ji4NL/WkTR8vml@T590>
References: <20230201134123.2656505-1-hch@lst.de>
 <20230201134123.2656505-3-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675780849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/kPBdJL3Ml9b2utJGfG1ftdTv2qoNngUd6jMK67nj/w=;
        b=EVCARjHbLYeohS+qSwZfSUsDl0dAx10dWIvwkgulXCZuhfC+meqbcv4N8gUfO18kA2V+GF
        gRWHganBkMt1lUXQzTd6x36ZzWghMpiQjlzffL7Z2vi53R/CMz3gyLhq6kBDiYJcDN5GRi
        cCR7lrc+O/VliSeEHjwnYRfb9KlQnOI=
Content-Disposition: inline
In-Reply-To: <20230201134123.2656505-3-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>, ming.lei@redhat.com

On Wed, Feb 01, 2023 at 02:41:06PM +0100, Christoph Hellwig wrote:
> There is no need to initialize the cgroup code before the disk is marked
> live.  Moving the cgroup initialization earlier will help to have a
> fully initialized struct device in the gendisk for the cgroup code to
> use in the future.  Similarly tear the cgroup information down in
> del_gendisk to be symmetric and because none of the cgroup tracking is
> needed once non-passthrough I/O stops.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Andreas Herrmann <aherrmann@suse.de>
> ---
>  block/genhd.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 23cf83b3331cde..705dec0800d62e 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -466,10 +466,14 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
>  	 */
>  	pm_runtime_set_memalloc_noio(ddev, true);
>  
> -	ret = blk_integrity_add(disk);
> +	ret = blkcg_init_disk(disk);
>  	if (ret)
>  		goto out_del_block_link;
>  
> +	ret = blk_integrity_add(disk);
> +	if (ret)
> +		goto out_blkcg_exit;
> +
>  	disk->part0->bd_holder_dir =
>  		kobject_create_and_add("holders", &ddev->kobj);
>  	if (!disk->part0->bd_holder_dir) {
> @@ -534,6 +538,8 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
>  	kobject_put(disk->part0->bd_holder_dir);
>  out_del_integrity:
>  	blk_integrity_del(disk);
> +out_blkcg_exit:
> +	blkcg_exit_disk(disk);
>  out_del_block_link:
>  	if (!sysfs_deprecated)
>  		sysfs_remove_link(block_depr, dev_name(ddev));
> @@ -662,6 +668,8 @@ void del_gendisk(struct gendisk *disk)
>  	rq_qos_exit(q);
>  	blk_mq_unquiesce_queue(q);
>  
> +	blkcg_exit_disk(disk);

This patch causes kernel panic:

[  581.975121]  bio_associate_blkg+0x28/0x60
[  581.975798]  bio_init+0x6d/0xc0
[  581.976364]  blkdev_issue_flush+0x21/0x40
[  581.977021]  ? _raw_write_unlock+0x12/0x30
[  581.977686]  ? jbd2_journal_start_commit+0x4b/0x80
[  581.978418]  ext4_sync_fs+0x1c6/0x1d0
[  581.979062]  sync_filesystem+0x77/0x90
[  581.979883]  generic_shutdown_super+0x22/0x130
[  581.980773]  kill_block_super+0x21/0x50
[  581.981622]  deactivate_locked_super+0x2c/0xa0
[  581.982306]  cleanup_mnt+0xbd/0x150

because disk->root_blkg is freed & set as NULL in del_gendisk().

by the following script:

	modprobe -r scsi_debug
	modprobe scsi_debug dev_size_mb=1024
	
	mkfs.xfs -f /dev/sdc	#suppose sdc is the scsi debug disk
	mount /dev/sdc /mnt
	echo 1 > /sys/block/sdc/device/delete
	sleep 1
	umount /mnt


Thanks, 
Ming

