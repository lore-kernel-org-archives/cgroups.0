From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 02/19] blk-cgroup: delay blk-cgroup initialization
 until add_disk
Date: Wed, 8 Feb 2023 07:35:52 +0100
Message-ID: <20230208063552.GA15030@lst.de>
References: <20230201134123.2656505-1-hch@lst.de> <20230201134123.2656505-3-hch@lst.de> <Y+Ji4NL/WkTR8vml@T590>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y+Ji4NL/WkTR8vml@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

On Tue, Feb 07, 2023 at 10:40:32PM +0800, Ming Lei wrote:
> because disk->root_blkg is freed & set as NULL in del_gendisk().
> 
> by the following script:
> 
> 	modprobe -r scsi_debug
> 	modprobe scsi_debug dev_size_mb=1024
> 	
> 	mkfs.xfs -f /dev/sdc	#suppose sdc is the scsi debug disk
> 	mount /dev/sdc /mnt
> 	echo 1 > /sys/block/sdc/device/delete
> 	sleep 1
> 	umount /mnt

Thank,

I've sent a fix.  Can you wire up your reproducer in blktests?
