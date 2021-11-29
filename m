From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] block: Use div64_ul instead of do_div
Date: Mon, 29 Nov 2021 08:19:17 -1000
Message-ID: <YaUZpZYI71K66Zka@slm.duckdns.org>
References: <20211117010358.158313-1-deng.changcheng@zte.com.cn>
 <20211118034033.163550-1-deng.changcheng@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nQZmy4cGScvJRiDlRHVd4gzuHUav0YqXgvVm+3n0P84=;
        b=d+idyvNHakWhb7W1cxj73/tcSGYR8+qLm/NoDZ5ro8n/DN2vzjKEcrinrJ7bGnxsxr
         ATXdS+Yuj/kLjB3k/3WmB6m8jR6+CPKUNX7CaL8NTFh4SFSYZVEbfTYN6oQaBXmGiYYn
         /YFwxy+i9nc1fgZiycYoZ8J02PptokM9xDCHIrMYX9gw/ivMB9Kksq3D2tc3Y+GcZd0N
         gpR63e1UH/iJGTfuLblGo9mB95uJIPLfhQQ3RD9jLogaPJps05xd+48YX2DJPkLXsyWA
         p7bOLMTIxKdL4DtGjELnyNkYcqi6hiKHx521vudwlewk105i33Dj1kJRUqexxOpG6GJx
         3N6g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211118034033.163550-1-deng.changcheng-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, deng.changcheng-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

On Thu, Nov 18, 2021 at 03:40:33AM +0000, cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Changcheng Deng <deng.changcheng-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> 
> do_div() does a 64-by-32 division. Here the divisor is an unsigned long
> which on some platforms is 64 bit wide. So use div64_ul instead of do_div
> to avoid a possible truncation.
> 
> Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> Signed-off-by: Changcheng Deng <deng.changcheng-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> ---
>  block/blk-throttle.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 39bb6e68a9a2..2db635d66617 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -1903,7 +1903,7 @@ static void throtl_downgrade_check(struct throtl_grp *tg)
>  
>  	if (tg->bps[READ][LIMIT_LOW]) {
>  		bps = tg->last_bytes_disp[READ] * HZ;
> -		do_div(bps, elapsed_time);
> +		bps = div64_ul(bps, elapsed_time);

Yeah, the divisor is ulong for whatever reason but the thing is in jiffies.
I have a hard time imagining it overflowing 32bit. I'm not sure how useful
this patch is.

-- 
tejun
