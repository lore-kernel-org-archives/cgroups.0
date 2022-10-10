From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/4] blk-cgroup: correct comment for blk_alloc_queue and
 blk_exit_queue
Date: Mon, 10 Oct 2022 10:26:50 -1000
Message-ID: <Y0SACpAv4+ETrS6Z@slm.duckdns.org>
References: <20221010023859.11896-1-shikemeng@huawei.com>
 <20221010023859.11896-3-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZVV8n5eD6h2TRn2sT93lXmeC6TkQyEPF4f8atiLgu/c=;
        b=IdIHWhIt/4LgFLk+ereoqBvDtQJrdY25MOknBRDc33BecqWtkmyV/jj6U4i8dWshGJ
         OUEqTDFnF0lZPvp3uWNQQK7tBMTGQPJo6as+UVRUem5njExsBj6X0E8zmiWJdIYM5Bvb
         5kklJ0NNraGUI4mKfH9xSMlvXi5dPm3Ldbns8rg6Y3S/mZt99lamxDMqZmtF6NGwc1vO
         txDWxxVQNZaKFn2zPbdP/t4jJvAm6xaEWGhGKgg/NxbKDypNmkbKPieOY9iGzHClSYeG
         lcg55CCl6gZtjHfvLr7yJvLNe+oZEc6Viuw8kLjCYFzdO0y3fSPWDlXm1jgJUdfLaHjD
         CYHQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221010023859.11896-3-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 10, 2022 at 10:38:57AM +0800, Kemeng Shi wrote:
> Since commit 1059699f87eb("block: move blkcg initialization/destroy into
> disk allocation/release handler"), blk_alloc_queue and blk_exit_queue is
> called directly from gendisk. Update the corresponding comment.
> 
> Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  block/blk-cgroup.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index bc4dec705572..463c568d3e86 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1259,7 +1259,7 @@ static int blkcg_css_online(struct cgroup_subsys_state *css)
>   * blkcg_init_queue - initialize blkcg part of request queue
>   * @q: request_queue to initialize
>   *
> - * Called from blk_alloc_queue(). Responsible for initializing blkcg
> + * Called from gendisk. Responsible for initializing blkcg

Maybe be a bit more specific and say blk_alloc_disk()?

>   * part of new request_queue @q.
>   *
>   * RETURNS:
> @@ -1321,7 +1321,7 @@ int blkcg_init_queue(struct request_queue *q)
>   * blkcg_exit_queue - exit and release blkcg part of request_queue
>   * @q: request_queue being released
>   *
> - * Called from blk_exit_queue().  Responsible for exiting blkcg part.
> + * Called from gendisk.  Responsible for exiting blkcg part.

Ditto.

-- 
tejun
