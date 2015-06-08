From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/8] cfq-iosched: fix async oom queue handling
Date: Mon, 08 Jun 2015 14:42:41 -0400
Message-ID: <x49r3pmhwim.fsf@segfault.boston.devel.redhat.com>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
	<1433753973-23684-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433753973-23684-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (Tejun Heo's
	message of "Mon, 8 Jun 2015 17:59:27 +0900")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Async cfqq's (cfq_queue's) are shared across cfq_data.  When
> cfq_get_queue() obtains a new queue from cfq_find_alloc_queue(), it
> stashes the pointer in cfq_data and reuses it from then on; however,
> the function doesn't consider that cfq_find_alloc_queue() may return
> the oom_cfqq under memory pressure and installs the returned queue
> unconditionally.
>
> If the oom_cfqq is installed as an async cfqq, cfq_set_request() will
> continue calling cfq_get_queue() hoping to replace it with a proper
> queue; however, cfq_get_queue() will keep returning the cached queue
> for the slot - the oom_cfqq.
>
> Fix it by skipping caching if the queue is the oom one.

Good catch.

Reviewed-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
