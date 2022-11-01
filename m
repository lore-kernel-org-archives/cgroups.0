From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/3] block: Correct comment for scale_cookie_change
Date: Tue, 1 Nov 2022 17:38:34 +0800
Message-ID: <d92907aa-2e57-dd68-c6ce-b8065cd25770@huawei.com>
References: <20221018111240.22612-1-shikemeng@huawei.com>
 <20221018111240.22612-3-shikemeng@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221018111240.22612-3-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Friendly ping.

on 10/18/2022 7:12 PM, Kemeng Shi wrote:
> Default queue depth of iolatency_grp is unlimited, so we scale down
> quickly(once by half) in scale_cookie_change. Remove the "subtract
> 1/16th" part which is not the truth and add the actual way we
> scale down.
> 
> Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  block/blk-iolatency.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
> index b24d7b788ba3..2c574f98c8d1 100644
> --- a/block/blk-iolatency.c
> +++ b/block/blk-iolatency.c
> @@ -364,9 +364,11 @@ static void scale_cookie_change(struct blk_iolatency *blkiolat,
>  }
>  
>  /*
> - * Change the queue depth of the iolatency_grp.  We add/subtract 1/16th of the
> + * Change the queue depth of the iolatency_grp.  We add 1/16th of the
>   * queue depth at a time so we don't get wild swings and hopefully dial in to
> - * fairer distribution of the overall queue depth.
> + * fairer distribution of the overall queue depth.  We halve the queue depth
> + * at a time so we can scale down queue depth quickly from default unlimited
> + * to target.
>   */
>  static void scale_change(struct iolatency_grp *iolat, bool up)
>  {
> 

-- 
Best wishes
Kemeng Shi
