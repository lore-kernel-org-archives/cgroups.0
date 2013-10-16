From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] blk-throttle: use READ/WRITE directly
Date: Wed, 16 Oct 2013 09:59:22 -0400
Message-ID: <20131016135922.GD17611@redhat.com>
References: <1381921012-12114-1-git-send-email-zhiguohong@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1381921012-12114-1-git-send-email-zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hong Zhiguo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Wed, Oct 16, 2013 at 06:56:52PM +0800, Hong Zhiguo wrote:
> From: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> 
> To save some instructions
> 
I am not sure if this change is worth doing or not. But ofcourse it
is simple enough.

Acked-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Vivek

> Signed-off-by: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> ---
>  block/blk-throttle.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 8331aba..f4fb859 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -1120,7 +1120,7 @@ static int throtl_dispatch_tg(struct throtl_grp *tg)
>  	while ((bio = throtl_peek_queued(&sq->queued[READ])) &&
>  	       tg_may_dispatch(tg, bio, NULL)) {
>  
> -		tg_dispatch_one_bio(tg, bio_data_dir(bio));
> +		tg_dispatch_one_bio(tg, READ);
>  		nr_reads++;
>  
>  		if (nr_reads >= max_nr_reads)
> @@ -1130,7 +1130,7 @@ static int throtl_dispatch_tg(struct throtl_grp *tg)
>  	while ((bio = throtl_peek_queued(&sq->queued[WRITE])) &&
>  	       tg_may_dispatch(tg, bio, NULL)) {
>  
> -		tg_dispatch_one_bio(tg, bio_data_dir(bio));
> +		tg_dispatch_one_bio(tg, WRITE);
>  		nr_writes++;
>  
>  		if (nr_writes >= max_nr_writes)
> @@ -1605,9 +1605,9 @@ static void tg_drain_bios(struct throtl_service_queue *parent_sq)
>  		throtl_dequeue_tg(tg);
>  
>  		while ((bio = throtl_peek_queued(&sq->queued[READ])))
> -			tg_dispatch_one_bio(tg, bio_data_dir(bio));
> +			tg_dispatch_one_bio(tg, READ);
>  		while ((bio = throtl_peek_queued(&sq->queued[WRITE])))
> -			tg_dispatch_one_bio(tg, bio_data_dir(bio));
> +			tg_dispatch_one_bio(tg, WRITE);
>  	}
>  }
>  
> -- 
> 1.8.1.2
