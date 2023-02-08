From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/19] blk-cgroup: delay blk-cgroup initialization until
 add_disk
Date: Wed, 8 Feb 2023 15:32:56 +0800
Message-ID: <Y+NQKABK682e/30a@T590>
References: <20230201134123.2656505-1-hch@lst.de>
 <20230201134123.2656505-3-hch@lst.de>
 <Y+Ji4NL/WkTR8vml@T590>
 <20230208063552.GA15030@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675841591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=73aglTPUHS/85OtfenzciioO7I/A4+2ffz4/jBMkCu0=;
        b=ENujYjCVQlz9DhsBeBHsAWeqTvMQVrAgUH9d8rkyGKky/pnUNNuE9BJl0apWIx5hUB2DDv
        cAvicXYgSvbuxEI49AvfCTceCO96ydCsG9cy98n9O9N1F0vPlmDWjZQLonbTjEoBtqD641
        yS+0fOw42I0zjIP/dLG1QdHiol88FPE=
Content-Disposition: inline
In-Reply-To: <20230208063552.GA15030-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

On Wed, Feb 08, 2023 at 07:35:52AM +0100, Christoph Hellwig wrote:
> On Tue, Feb 07, 2023 at 10:40:32PM +0800, Ming Lei wrote:
> > because disk->root_blkg is freed & set as NULL in del_gendisk().
> > 
> > by the following script:
> > 
> > 	modprobe -r scsi_debug
> > 	modprobe scsi_debug dev_size_mb=1024
> > 	
> > 	mkfs.xfs -f /dev/sdc	#suppose sdc is the scsi debug disk
> > 	mount /dev/sdc /mnt
> > 	echo 1 > /sys/block/sdc/device/delete
> > 	sleep 1
> > 	umount /mnt
> 
> Thank,
> 
> I've sent a fix.  Can you wire up your reproducer in blktests?

Yeah, it is already sent out:

https://lore.kernel.org/linux-block/20230208010235.553252-1-ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/T/#u



Thanks,
Ming

