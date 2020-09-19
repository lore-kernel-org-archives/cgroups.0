From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 10/12] bdi: replace BDI_CAP_STABLE_WRITES with a queue
 and a sb flag
Date: Sat, 19 Sep 2020 08:51:26 +0200
Message-ID: <20200919065126.GA8048@lst.de>
References: <20200910144833.742260-1-hch@lst.de> <20200910144833.742260-11-hch@lst.de> <20200917092524.GC7347@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200917092524.GC7347-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 17, 2020 at 11:25:24AM +0200, Jan Kara wrote:
> On Thu 10-09-20 16:48:30, Christoph Hellwig wrote:
> > The BDI_CAP_STABLE_WRITES is one of the few bits of information in the
> > backing_dev_info shared between the block drivers and the writeback code.
> > To help untangling the dependency replace it with a queue flag and a
> > superblock flag derived from it.  This also helps with the case of e.g.
> > a file system requiring stable writes due to its own checksumming, but
> > not forcing it on other users of the block device like the swap code.
> > 
> > One downside is that we can't support the stable_pages_required bdi
> > attribute in sysfs anymore.  It is replaced with a queue attribute, that
> > can also be made writable for easier testing.
>   ^^^^^^^^^^^^^^^^
>   is also made
> 
> For a while I was confused thinking that the new attribute is not writeable
> but when I checked the code I saw that it is.
> 
> Not supporting stable_pages_required attribute is not nice but probably it
> isn't widely used. Maybe the deprecation message can even mention to use
> the queue attribute? Otherwise the patch looks good to me so feel free to
> add:
> 
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Thanks.  I've fixed the commit log and changed the warning to:

	dev_warn_once(dev, 
                 "the stable_pages_required attribute has been removed. Use the
		 stable_writes queue attribute instead.\n");
