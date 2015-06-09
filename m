From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] cfq-iosched: fold cfq_find_alloc_queue() into cfq_get_queue()
Date: Tue, 09 Jun 2015 10:40:02 -0400
Message-ID: <x49twuhrlml.fsf@segfault.boston.devel.redhat.com>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
	<1433753973-23684-8-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433753973-23684-8-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (Tejun Heo's
	message of "Mon, 8 Jun 2015 17:59:32 +0900")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> cfq_find_alloc_queue() checks whether a queue actually needs to be
> allocated, which is unnecessary as its sole caller, cfq_get_queue(),
> only calls it if so.  Also, the oom queue fallback logic is scattered
> between cfq_get_queue() and cfq_find_alloc_queue().  There really
> isn't much going on in the latter and things can be made simpler by
> folding it into cfq_get_queue().
>
> This patch collapses cfq_find_alloc_queue() into cfq_get_queue().  The
> change is fairly straight-forward with one exception - async_cfqq is
> now initialized to NULL and the "!is_sync" test in the last if
> conditional is replaced with "async_cfqq" test.  This is because gcc
> (5.1.1) gets confused for some reason and warns that async_cfqq may be
> used uninitialized otherwise.  Oh well, the code isn't necessarily
> worse this way.
>
> This patch doesn't cause any functional difference.

The resulting code (introduced by the last patch, I know) is not ideal:

        rcu_read_lock();
        cfqg = cfq_lookup_create_cfqg(cfqd, bio_blkcg(bio));
        if (!cfqg) {
                cfqq = &cfqd->oom_cfqq;
                goto out;
        }

        if (!is_sync) {
                if (!ioprio_valid(cic->ioprio)) {
                        struct task_struct *tsk = current;
                        ioprio = task_nice_ioprio(tsk);
                        ioprio_class = task_nice_ioclass(tsk);
                }
                async_cfqq = cfq_async_queue_prio(cfqd, ioprio_class,
                ioprio);
                cfqq = *async_cfqq;
                if (cfqq)
                        goto out;
        }

As you mentioned, we don't need to lookup the cfqg for the async queue.
What's more is we could fallback to the oom_cfqq even if we had an
existing async cfqq.  I'm guessing you structured the code this way to
make the error path cleaner.  I don't think it's a big deal, as it
should be a rare occurrence, so...

Reviewed-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
