From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 11/14] mm: use SWP_SYNCHRONOUS_IO more intelligently
Date: Wed, 22 Jul 2020 09:26:45 -0700
Message-ID: <CALvZod6zF7Ak8KWf4dq0pEF2ty7JN_SyNE7PxLjrfF+EuDbZ2w@mail.gmail.com>
References: <20200722062552.212200-1-hch@lst.de> <20200722062552.212200-12-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2kHXQvVGBuGkaVHirVH2ldXpqiigd2kMJlKCki7PqMg=;
        b=ra98AzIYvVtLIKFmQ0582LpmVzZLDFtXPiDLxSIB7SoDAYKfzHUmecVZxZuP/M6Pvb
         fDufO1C+Q4FiAbYniw6ePsXq6IniiF94IvlcqmWtmSWtqcN5EqOCbg+nsxHw7v2/BzpD
         yqdQ4eKGDs88B1pTQ+/lVZ3atNYajhFCrKFlxc6iGCv2w9U5QibkcB5fjdiaYFspwg/7
         DUAeDu27aJnyG2kaxKFRHFuV9pRJvCocGy9/pSs9I4O2w31H+artkiu+wABWqj20BtFU
         4mfkDrAHear+tV6pm6mm5Q1TEtNXZAq/Blh918qa8SfTMXEI9nUlQIkjpdOHfrsto+Ju
         hfqQ==
In-Reply-To: <20200722062552.212200-12-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>

On Tue, Jul 21, 2020 at 11:27 PM Christoph Hellwig <hch@lst.de> wrote:
>
> There is no point in trying to call bdev_read_page if SWP_SYNCHRONOUS_IO
> is not set, as the device won't support it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/page_io.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index ccda7679008851..442061348dfb26 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -403,15 +403,17 @@ int swap_readpage(struct page *page, bool synchronous)
>                 goto out;
>         }
>
> -       ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
> -       if (!ret) {
> -               if (trylock_page(page)) {
> -                       swap_slot_free_notify(page);
> -                       unlock_page(page);
> -               }
> +       if (sis->flags & SWP_SYNCHRONOUS_IO) {
> +               ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
> +               if (ret) {

!ret

> +                       if (trylock_page(page)) {
> +                               swap_slot_free_notify(page);
> +                               unlock_page(page);
> +                       }
>
> -               count_vm_event(PSWPIN);
> -               goto out;
> +                       count_vm_event(PSWPIN);
> +                       goto out;
> +               }
>         }
>
>         ret = 0;
> --
> 2.27.0
>
