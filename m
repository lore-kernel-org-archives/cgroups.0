From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/8] cfq-iosched: simplify control flow in cfq_get_queue()
Date: Mon, 08 Jun 2015 14:36:52 -0400
Message-ID: <x49vbeyhwsb.fsf@segfault.boston.devel.redhat.com>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
	<1433753973-23684-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433753973-23684-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (Tejun Heo's
	message of "Mon, 8 Jun 2015 17:59:26 +0900")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> cfq_get_queue()'s control flow looks like the following.
>
> 	async_cfqq = NULL;
> 	cfqq = NULL;
>
> 	if (!is_sync) {
> 		...
> 		async_cfqq = ...;
> 		cfqq = *async_cfqq;
> 	}
>
> 	if (!cfqq)
> 		cfqq = ...;
>
> 	if (!is_sync && !(*async_cfqq))
> 		...;
>
> The only thing the local variable init, the second if, and the
> async_cfqq test in the third if achieves is to skip cfqq creation and
> installation if *async_cfqq was already non-NULL.  This is needlessly
> complicated with different tests examining the same condition.
> Simplify it to the following.
>
> 	if (!is_sync) {
> 		...
> 		async_cfqq = ...;
> 		cfqq = *async_cfqq;
> 		if (cfqq)
> 			goto out;
> 	}
>
> 	cfqq = ...;
>
> 	if (!is_sync)
> 		...;
>  out:
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
