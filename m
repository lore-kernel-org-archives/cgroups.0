From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 07/13] block: lift setting the readahead size into the
 block layer
Date: Thu, 24 Sep 2020 11:03:19 -0400
Message-ID: <20200924150318.GE13849@redhat.com>
References: <20200924065140.726436-1-hch@lst.de>
 <20200924065140.726436-8-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600959809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CuPbzvXQosIYzpsTmyDB+PWCFgx3pRZznwdDq166LWs=;
        b=IKbUluUBlNINh996O+RKMbH4p1TuesSGuv2sE3xB98vIqE3nYLAdyw9+kt7iDm7BAzNJ1K
        CG+M8f5Oy9fI5yvidOYu/UJ2xvA9Rs8lEvfXIs77/dUGkBzMkCINAatJAIYR2s8jTfm89t
        g28a2lipLgQdQp9Rd2uoPMfINmJHzRc=
Content-Disposition: inline
In-Reply-To: <20200924065140.726436-8-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, Justin Sanders <justin@coraid.com>, Minchan Kim <minchan@kernel.org>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, cgroups@vger.kernel.org, linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>, linux-block@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com, linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>, drbd-dev@tron.linbit.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, Sep 24 2020 at  2:51am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Drivers shouldn't really mess with the readahead size, as that is a VM
> concept.  Instead set it based on the optimal I/O size by lifting the
> algorithm from the md driver when registering the disk.  Also set
> bdi->io_pages there as well by applying the same scheme based on
> max_sectors.  To ensure the limits work well for stacking drivers a
> new helper is added to update the readahead limits from the block
> limits, which is also called from disk_stack_limits.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Coly Li <colyli@suse.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Thanks for adding blk_queue_update_readahead()

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

