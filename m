From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: don't make all constants unsigned long long
Date: Wed, 4 Jan 2023 12:16:17 -1000
Message-ID: <Y7X6sUDLe2CrPk8H@slm.duckdns.org>
References: <20221220201819.1497577-1-ydroneaud@opteya.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=moYSPHE+ptO3fAO4T89FF5ZIPNcPkGMhods8Wk+acgw=;
        b=IAM5Dmd4MW6BIb12ZqVe6jaKnPSKH3m9/N6nt+o7KrcNeFFY6Q3yJyzPzuWxDK97kZ
         XLyKTKIjdetwusXLk3Ze7VgwckVk27NKnK0dCNdOhH4RTnVYZFKe8meBnb9VU8Jab/m8
         yvSp68B+IgePhe25pq3fOVkX7xHzpvlSu52i/rxuzmqL31MgslkP3YENdfKSFPFn5mOJ
         2dVI+8Her4rJWcBC3Rfw7qq3IVqZt8owEFH+NvVpw9QFgaEa9+n4tdx9gq1ir4ux1Afs
         z80kd+pIJLc5cJyq8Rhz2TlsoMXJp62UuEV6mbRwJRFMarvGYE5aMukxJZaEsclVnUm+
         OwWw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221220201819.1497577-1-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Dec 20, 2022 at 09:18:19PM +0100, Yann Droneaud wrote:
> My shiny new compiler (GCC 13) is reporting the following
> warnings:
> 
>   ../block/blk-iocost.c: In function 'ioc_weight_prfill':
>   ../block/blk-iocost.c:3035:37: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'long unsigned int' [-Wformat=]
>    3035 |                 seq_printf(sf, "%s %u\n", dname, iocg->cfg_weight / WEIGHT_ONE);
>         |                                    ~^            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |                                     |                             |
>         |                                     unsigned int                  long unsigned int
>         |                                    %lu
>   ../block/blk-iocost.c: In function 'ioc_weight_show':
>   ../block/blk-iocost.c:3045:34: warning: format '%u' expects argument of type 'unsigned int', but argument 3 has type 'long unsigned int' [-Wformat=]
>    3045 |         seq_printf(sf, "default %u\n", iocc->dfl_weight / WEIGHT_ONE);
>         |                                 ~^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |                                  |                      |
>         |                                  unsigned int           long unsigned int
>         |                                 %lu
> 
> It appears WEIGHT_ONE enum is unnecessarly unsigned long
> (or unsigned long long on 32bit) because of VTIME_PER_SEC
> and/or AUTOP_CYCLE_NSEC need the enum to be that large.
> 
> Addressed by lazy splitting the "catch all" anonymous
> enum and placing the unsigned long long constants in
> their own anonymous enums.
> 
> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

There's a better patch doing this which groups the enums into two groups.
Let's do that instead.

Thanks.

-- 
tejun
