From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] cfq-iosched: fold cfq_find_alloc_queue() into
 cfq_get_queue()
Date: Wed, 10 Jun 2015 11:47:27 +0900
Message-ID: <20150610024727.GD11955@mtj.duckdns.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
 <1433753973-23684-8-git-send-email-tj@kernel.org>
 <x49twuhrlml.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5VPOguDT++vA/FakSd1YtkvSS2jzbg0TYqL4u2fLfY4=;
        b=kvc7KmWZbaVF2GFuR8dHw2xtLAVGLaSvFDCUUiWPN36cj/ctPxxaXh21IXp5usKKj0
         rF0YxYhXRqhO+ejAprGR+cUaTZBK4F0Mu62wA6oG4Wvlu6vBN1Un2BLXLkjEzylxKzQ+
         W0zancm9PHhV22qM1mvBptMGCTHpi/jHD3hft3aVGu54Ex4v4nY1SOLH/c7+8ycMSxXk
         BmUnTDvQEx9vDj0WxRZXONHEZx+zB3/YAZupQR7oR3W9z8SI+spZfr0IDw6Zx7DU8Wn5
         2MkqRNhOK32qXB3NXGZ8o2S2kqEyoRQR07QheFd8tu5pOBagETx2ML1di0sW6HypY18Z
         KdXg==
Content-Disposition: inline
In-Reply-To: <x49twuhrlml.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hey, Jeff.

On Tue, Jun 09, 2015 at 10:40:02AM -0400, Jeff Moyer wrote:
> The resulting code (introduced by the last patch, I know) is not ideal:
> 
>         rcu_read_lock();
>         cfqg = cfq_lookup_create_cfqg(cfqd, bio_blkcg(bio));
>         if (!cfqg) {
>                 cfqq = &cfqd->oom_cfqq;
>                 goto out;
>         }
> 
>         if (!is_sync) {
>                 if (!ioprio_valid(cic->ioprio)) {
>                         struct task_struct *tsk = current;
>                         ioprio = task_nice_ioprio(tsk);
>                         ioprio_class = task_nice_ioclass(tsk);
>                 }
>                 async_cfqq = cfq_async_queue_prio(cfqd, ioprio_class,
>                 ioprio);
>                 cfqq = *async_cfqq;
>                 if (cfqq)
>                         goto out;
>         }
> 
> As you mentioned, we don't need to lookup the cfqg for the async queue.
> What's more is we could fallback to the oom_cfqq even if we had an
> existing async cfqq.  I'm guessing you structured the code this way to
> make the error path cleaner.  I don't think it's a big deal, as it
> should be a rare occurrence, so...

In this patch, the lookup seems unnecessary for the async case but the
change is required for the following changes because async queues are
moved from cfq_data to cfq_group, so we can't determine async queues
w/o looking up cfqg at all and we'll have to fall back to oom_cfqq if
cfqg lookup fails (cuz there's no system-wide async queues).

Thanks.

-- 
tejun
