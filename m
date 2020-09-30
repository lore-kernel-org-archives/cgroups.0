From: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] PM/hibernate: remove the bogus call to get_gendisk in software_resume
Date: Wed, 30 Sep 2020 17:45:27 +0200
Message-ID: <CAJZ5v0h8TbOZ=seE8+OqFKTRxOYK25aTXDam7Lez0VR5qnkM3Q@mail.gmail.com>
References: <20200925161447.1486883-1-hch@lst.de> <20200925161447.1486883-3-hch@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200925161447.1486883-3-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Minho Ban <mhban-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux PM <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Sep 25, 2020 at 6:15 PM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>
> get_gendisk grabs a reference on the disk and file operation, so this
> code will leak both of them while having absolutely no use for the
> gendisk itself.
>
> This effectively reverts commit 2df83fa4bce421f
> ("PM / Hibernate: Use get_gendisk to verify partition if resume_file is integer format")
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  kernel/power/hibernate.c | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index e7aa57fb2fdc33..7d0b99d2e69631 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -948,17 +948,6 @@ static int software_resume(void)
>
>         /* Check if the device is there */
>         swsusp_resume_device = name_to_dev_t(resume_file);
> -
> -       /*
> -        * name_to_dev_t is ineffective to verify parition if resume_file is in
> -        * integer format. (e.g. major:minor)
> -        */
> -       if (isdigit(resume_file[0]) && resume_wait) {
> -               int partno;
> -               while (!get_gendisk(swsusp_resume_device, &partno))
> -                       msleep(10);
> -       }
> -
>         if (!swsusp_resume_device) {
>                 /*
>                  * Some device discovery might still be in progress; we need
> --
> 2.28.0
>
