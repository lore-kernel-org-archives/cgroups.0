From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 10/12] bdi: replace BDI_CAP_STABLE_WRITES with a queue
 and a sb flag
Date: Thu, 17 Sep 2020 11:25:24 +0200
Message-ID: <20200917092524.GC7347@quack2.suse.cz>
References: <20200910144833.742260-1-hch@lst.de>
 <20200910144833.742260-11-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200910144833.742260-11-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Thu 10-09-20 16:48:30, Christoph Hellwig wrote:
> The BDI_CAP_STABLE_WRITES is one of the few bits of information in the
> backing_dev_info shared between the block drivers and the writeback code.
> To help untangling the dependency replace it with a queue flag and a
> superblock flag derived from it.  This also helps with the case of e.g.
> a file system requiring stable writes due to its own checksumming, but
> not forcing it on other users of the block device like the swap code.
> 
> One downside is that we can't support the stable_pages_required bdi
> attribute in sysfs anymore.  It is replaced with a queue attribute, that
> can also be made writable for easier testing.
  ^^^^^^^^^^^^^^^^
  is also made

For a while I was confused thinking that the new attribute is not writeable
but when I checked the code I saw that it is.

Not supporting stable_pages_required attribute is not nice but probably it
isn't widely used. Maybe the deprecation message can even mention to use
the queue attribute? Otherwise the patch looks good to me so feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
