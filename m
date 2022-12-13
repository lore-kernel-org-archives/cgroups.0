From: Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] block/blk-iocost (gcc13): move large values to a new
 enum
Date: Tue, 13 Dec 2022 12:55:05 +0100
Message-ID: <4e74fc1d-1e27-282e-5942-4bc52ab2f7a3@kernel.org>
References: <20221213112148.15235-1-jirislaby@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <20221213112148.15235-1-jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 13. 12. 22, 12:21, Jiri Slaby (SUSE) wrote:
> Since gcc13, each member of an enum has the same type as the enum [1]. And
> that is inherited from its members. Provided:
>    VTIME_PER_SEC_SHIFT     = 37,
>    VTIME_PER_SEC           = 1LLU << VTIME_PER_SEC_SHIFT,
> the named type is unsigned long.
> 
> This generates warnings with gcc-13:
>    block/blk-iocost.c: In function 'ioc_weight_prfill':
>    block/blk-iocost.c:3037:37: error: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'long unsigned int'
> 
>    block/blk-iocost.c: In function 'ioc_weight_show':
>    block/blk-iocost.c:3047:34: error: format '%u' expects argument of type 'unsigned int', but argument 3 has type 'long unsigned int'
> 
> So move the large VTIME values away to a separate enum, so that they
> don't affect other members. Move also VRATE ones as they depend on
> VTIME.
> 
> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

NACK

I forgot to remove the previous "casts" patch and the warning still 
triggers with this v2 alone. Let me do a v3 after finding the root cause.

> Cc: Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Jiri Slaby (SUSE) <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> 
> Notes:
>      [v2] move to a new enum
> 
>   block/blk-iocost.c | 48 ++++++++++++++++++++++++----------------------
>   1 file changed, 25 insertions(+), 23 deletions(-)
> 
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index d1bdc12deaa7..49d6e5aec3d5 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -233,29 +233,6 @@ enum {
>   	/* 1/64k is granular enough and can easily be handled w/ u32 */
>   	WEIGHT_ONE		= 1 << 16,
>   
> -	/*
> -	 * As vtime is used to calculate the cost of each IO, it needs to
> -	 * be fairly high precision.  For example, it should be able to
> -	 * represent the cost of a single page worth of discard with
> -	 * suffificient accuracy.  At the same time, it should be able to
> -	 * represent reasonably long enough durations to be useful and
> -	 * convenient during operation.
> -	 *
> -	 * 1s worth of vtime is 2^37.  This gives us both sub-nanosecond
> -	 * granularity and days of wrap-around time even at extreme vrates.
> -	 */
> -	VTIME_PER_SEC_SHIFT	= 37,
> -	VTIME_PER_SEC		= 1LLU << VTIME_PER_SEC_SHIFT,
> -	VTIME_PER_USEC		= VTIME_PER_SEC / USEC_PER_SEC,
> -	VTIME_PER_NSEC		= VTIME_PER_SEC / NSEC_PER_SEC,
> -
> -	/* bound vrate adjustments within two orders of magnitude */
> -	VRATE_MIN_PPM		= 10000,	/* 1% */
> -	VRATE_MAX_PPM		= 100000000,	/* 10000% */
> -
> -	VRATE_MIN		= VTIME_PER_USEC * VRATE_MIN_PPM / MILLION,
> -	VRATE_CLAMP_ADJ_PCT	= 4,
> -
>   	/* if IOs end up waiting for requests, issue less */
>   	RQ_WAIT_BUSY_PCT	= 5,
>   
> @@ -310,6 +287,31 @@ enum {
>   	LCOEF_RANDIO_PAGES	= 4096,
>   };
>   
> +enum {
> +	/*
> +	 * As vtime is used to calculate the cost of each IO, it needs to
> +	 * be fairly high precision.  For example, it should be able to
> +	 * represent the cost of a single page worth of discard with
> +	 * suffificient accuracy.  At the same time, it should be able to
> +	 * represent reasonably long enough durations to be useful and
> +	 * convenient during operation.
> +	 *
> +	 * 1s worth of vtime is 2^37.  This gives us both sub-nanosecond
> +	 * granularity and days of wrap-around time even at extreme vrates.
> +	 */
> +	VTIME_PER_SEC_SHIFT	= 37,
> +	VTIME_PER_SEC		= 1LLU << VTIME_PER_SEC_SHIFT,
> +	VTIME_PER_USEC		= VTIME_PER_SEC / USEC_PER_SEC,
> +	VTIME_PER_NSEC		= VTIME_PER_SEC / NSEC_PER_SEC,
> +
> +	/* bound vrate adjustments within two orders of magnitude */
> +	VRATE_MIN_PPM		= 10000,	/* 1% */
> +	VRATE_MAX_PPM		= 100000000,	/* 10000% */
> +
> +	VRATE_MIN		= VTIME_PER_USEC * VRATE_MIN_PPM / MILLION,
> +	VRATE_CLAMP_ADJ_PCT	= 4,
> +};
> +
>   enum ioc_running {
>   	IOC_IDLE,
>   	IOC_RUNNING,

-- 
js
suse labs

