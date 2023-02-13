From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 3/3] blk-cgroup: only grab an inode reference to the disk
 for each blkg
Date: Mon, 13 Feb 2023 20:11:36 +0800
Message-ID: <Y+oo+P0MIZK8QMDZ@T590>
References: <20230213104134.475204-1-hch@lst.de>
 <20230213104134.475204-4-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676290310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RNqQ9bXDgnnpNFNLGb68QXM6v2J1h53ebKftG058Huc=;
        b=EfHYRmaFIIhHzMQaz7YjMOYdMLzw4y77wuoQP6b91HynnQ8x169E9zFESaCtrn3IpyI4gB
        IzsE9HecAktrEeDP1eblp7OGrO9Nqncq3RgS5lAiaW0O9IW0MYkBeoTUvwUdfzD8YXl0eD
        CgO6IBGdU2W3L72L1Wzop9tEvY5QfoM=
Content-Disposition: inline
In-Reply-To: <20230213104134.475204-4-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, ming.lei@redhat.com

On Mon, Feb 13, 2023 at 11:41:34AM +0100, Christoph Hellwig wrote:
> To avoid a circular reference, do not grab a device model reference
> to the gendisk for each blkg, but just the lower level inode reference
> preventing the memory from beeing freed.

It might not be enough to just prevent gendisk memory from being freed,
anywhere queue reference via disk->queue could become not safe given
disk->queue can be released after disk_release() is called.

thanks,
Ming

