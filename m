From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/8] blkcg: kill blkio_list and replace blkio_list_lock
 with a mutex
Date: Fri, 13 Apr 2012 09:32:26 -0400
Message-ID: <20120413133226.GB26383@redhat.com>
References: <1334273380-30233-1-git-send-email-tj@kernel.org>
 <1334273380-30233-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1334273380-30233-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Thu, Apr 12, 2012 at 04:29:33PM -0700, Tejun Heo wrote:

Hi Tejun,

> @@ -732,20 +732,21 @@ void blkio_policy_register(struct blkio_policy_type *blkiop)
>  {
>  	struct request_queue *q;
>  
> +	mutex_lock(&blkcg_pol_mutex);
> +
>  	blkcg_bypass_start();
> -	spin_lock(&blkio_list_lock);
>  
>  	BUG_ON(blkio_policy[blkiop->plid]);

A minor nit. It might be a good idea to check that blkiop->plid is not
greater than BLKIO_NR_POLICIES for both registration and unresitration
functions to avoid touching memory beyond blkio_policy[] array.

Thanks
Vivek
