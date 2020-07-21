From: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/14] mm: use SWP_SYNCHRONOUS_IO more intelligently
Date: Mon, 20 Jul 2020 22:46:17 -0700
Message-ID: <20200721054617.GA1879427@google.com>
References: <20200720075148.172156-1-hch@lst.de>
 <20200720075148.172156-12-hch@lst.de>
 <CALvZod7ACBnNX5W-gtTzheh8R-rxv1nB-5q7UcDUZ7BvtpakpA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3veC3pi53wl7dFDGpjkOo+uS1itnPbzCOm4x4ko6JVY=;
        b=D/IxIwyEq3hF3iTuaIk+KFCFZyGC8VqcCGJnFT12TDv/8eGagJrHkXCGkF3Muc266t
         OGT7OoG2HtHbaXMhlknQISHa5De5A/xFpxWKJLCbc/SAIqTngBdVmIG3+rFG2+Y1Wb46
         YATZPWszcpNmKSDpEHErZUkhido9bvZlai2206IHzthib3Y0UiQ6fX8Re2N3orWnF12s
         XZ6RPqQNT9T2QKcABfS3hJr1GCzgJFm/rDpCofJQA16hsZZMLUHK0fkaVJHJKDnTcvEP
         YayBMF/DStbLmLjOPFjbig16IweaRvLj4UCWCSitHEj/N0DuM+39Lm+dho9165oRwpKe
         XDKQ==
Content-Disposition: inline
In-Reply-To: <CALvZod7ACBnNX5W-gtTzheh8R-rxv1nB-5q7UcDUZ7BvtpakpA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Thanks for Ccing me, Shakeel.

On Mon, Jul 20, 2020 at 10:52:55AM -0700, Shakeel Butt wrote:
> +Minchan Kim
> 
> On Mon, Jul 20, 2020 at 12:52 AM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> >
> > There is no point in trying to call bdev_read_page if SWP_SYNCHRONOUS_IO
> > is not set, as the device won't support it.  Also there is no point in
> > trying a bio submission if bdev_read_page failed.
> 
> This will at least break the failure path of zram_rw_page().

Yes, it needs post processing for error propagaion like *page* handling
part in end_swap_bio_read(mostly, PG_error and PG_uptodate with pr_alert).
bdev_read_page's sematic doesn't need to be synchronous so it could just
submit the IO request and complete the IO afterward. In that case, we
need right error handling, too if the IO encoutered error. BIO fallback
makes it simple.

 * bdev_read_page() - Start reading a page from a block device
 * @bdev: The device to read the page from
 * @sector: The offset on the device to read the page to (need not be aligned)
 * @page: The page to read
 *
 * On entry, the page should be locked.  It will be unlocked when the page
 * has been read.  If the block driver implements rw_page synchronously,
 * that will be true on exit from this function, but it need not be.
 *
 * Errors returned by this function are usually "soft", eg out of memory, or
 * queue full; callers should try a different route to read this page rather
 * than propagate an error back up the stack.

The other concern about this patch is zram have used rw_page for a long
time even though sometime it doesn't declare BDI_CAP_SYNCHRONOUS_IO by itself
because rw_page shows 4~5% bandwidth improvement compared to bio-based.
The performance gain becomes more important these day because compressor
becomes more fast day by day.

> 
> >
> > Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> > ---
> >  mm/page_io.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/page_io.c b/mm/page_io.c
> > index ccda7679008851..63b44b8221af0f 100644
> > --- a/mm/page_io.c
> > +++ b/mm/page_io.c
> > @@ -403,8 +403,11 @@ int swap_readpage(struct page *page, bool synchronous)
> >                 goto out;
> >         }
> >
> > -       ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
> > -       if (!ret) {
> > +       if (sis->flags & SWP_SYNCHRONOUS_IO) {
> > +               ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
> > +               if (ret)
> > +                       goto out;
> > +
> >                 if (trylock_page(page)) {
> >                         swap_slot_free_notify(page);
> >                         unlock_page(page);
> > --
> > 2.27.0
> >
