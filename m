From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/8] cfq-iosched: move cfq_group determination from cfq_find_alloc_queue() to cfq_get_queue()
Date: Tue, 09 Jun 2015 10:32:35 -0400
Message-ID: <x49y4jtrlz0.fsf@segfault.boston.devel.redhat.com>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
	<1433753973-23684-7-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433753973-23684-7-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (Tejun Heo's
	message of "Mon, 8 Jun 2015 17:59:31 +0900")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> This is necessary for making async cfq_cgroups per-cfq_group instead
> of per-cfq_data.  While this change makes cfq_get_queue() perform RCU
> locking and look up cfq_group even when it reuses async queue, the
> extra overhead is extremely unlikely to be noticeable given that this
> is already sitting behind cic->cfqq[] cache and the overall cost of
> cfq operation.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
