From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH] block: Remove redundant 'return' statement
Date: Thu, 8 Oct 2020 11:40:47 +0800
Message-ID: <20201008034047.GA96391@VM20190228-100.tbsite.net>
References: <633f73addfc154700b2f983bee6230f82de4c984.1601253090.git.baolin.wang@linux.alibaba.com>
Reply-To: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <633f73addfc154700b2f983bee6230f82de4c984.1601253090.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: baolin.wang7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Mon, Sep 28, 2020 at 08:42:26AM +0800, Baolin Wang wrote:
> Remove redundant 'return' statement for 'void' functions.
> 
> Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Gentle ping?

> ---
>  block/blk-iocost.c    | 2 +-
>  block/blk-iolatency.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index ef9476f..e38c406 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -3343,7 +3343,7 @@ static int __init ioc_init(void)
>  
>  static void __exit ioc_exit(void)
>  {
> -	return blkcg_policy_unregister(&blkcg_policy_iocost);
> +	blkcg_policy_unregister(&blkcg_policy_iocost);
>  }
>  
>  module_init(ioc_init);
> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
> index f90429c..81be009 100644
> --- a/block/blk-iolatency.c
> +++ b/block/blk-iolatency.c
> @@ -1046,7 +1046,7 @@ static int __init iolatency_init(void)
>  
>  static void __exit iolatency_exit(void)
>  {
> -	return blkcg_policy_unregister(&blkcg_policy_iolatency);
> +	blkcg_policy_unregister(&blkcg_policy_iolatency);
>  }
>  
>  module_init(iolatency_init);
> -- 
> 1.8.3.1
