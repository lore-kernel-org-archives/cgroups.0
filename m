From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 11/14] mm: use SWP_SYNCHRONOUS_IO more intelligently
Date: Mon, 20 Jul 2020 10:52:55 -0700
Message-ID: <CALvZod7ACBnNX5W-gtTzheh8R-rxv1nB-5q7UcDUZ7BvtpakpA@mail.gmail.com>
References: <20200720075148.172156-1-hch@lst.de> <20200720075148.172156-12-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kya9ou2H4xCIeg2jTugLQPDLPsUiSPAXkhjVJRHMDG8=;
        b=SX8NYsOLgCeGmFxjb3Z0RzsYrlrHY6Njtfv46WXbScI3rw3tkdMvNy7qsqcNAy91ok
         EmnOsjkBbRSUSYO4/Q+Cx/xTEf85/D7y3ubLVL9GrTTaC883stkN/jVXYzE2FCCqF7eB
         9s7gGZej8MgWwlJIFwC85V0qxylpm5PoPDao/u8vX7pBu4QWu3w4EYzNHhOsY3D9UTQv
         wZ7VKxvMYrxM6QJlB3KwFInEXd5SELo26Gs2/yM5C+3lGgUkJm4gOG1yFNX6CZ+WQun4
         2A746f0YswL5r2QB7a0ry1PuFLvHVFwRkJvX+AeFb1QZo7ouw1eWDpQA/DMeKnb180Pl
         r/LA==
In-Reply-To: <20200720075148.172156-12-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>

+Minchan Kim

On Mon, Jul 20, 2020 at 12:52 AM Christoph Hellwig <hch@lst.de> wrote:
>
> There is no point in trying to call bdev_read_page if SWP_SYNCHRONOUS_IO
> is not set, as the device won't support it.  Also there is no point in
> trying a bio submission if bdev_read_page failed.

This will at least break the failure path of zram_rw_page().

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/page_io.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index ccda7679008851..63b44b8221af0f 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -403,8 +403,11 @@ int swap_readpage(struct page *page, bool synchronous)
>                 goto out;
>         }
>
> -       ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
> -       if (!ret) {
> +       if (sis->flags & SWP_SYNCHRONOUS_IO) {
> +               ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
> +               if (ret)
> +                       goto out;
> +
>                 if (trylock_page(page)) {
>                         swap_slot_free_notify(page);
>                         unlock_page(page);
> --
> 2.27.0
>
