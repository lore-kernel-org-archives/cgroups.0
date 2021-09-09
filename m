From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 0/2] refactor sqthread cpu binding logic
Date: Thu, 9 Sep 2021 14:34:05 +0200
Message-ID: <20210909123405.GA7872@blackbody.suse.cz>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210902164808.GA10014@blackbody.suse.cz>
 <efd3c387-9c7c-c0d8-1306-f722da2a9ba1@kernel.dk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631190848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=otlEKKTKaxtvvMLg6ergurTGZ0izRkiNu8lIiQOoJG8=;
        b=pafa6rOLfy8b6s0LOtgRFEyJrgMHk2KL8oMKsBNZqMIZBfwqiSjy0lZ7HvQn9lCFIa0Def
        3I/YVOWFpRHNDb+lcKi49HsIXhj7fESeGM/4jkVBGp0o6almfudRW5jGBLok/fvcJn3Fx1
        m+3/6IVrYh3limVU1shkb/0FMRtdzdA=
Content-Disposition: inline
In-Reply-To: <efd3c387-9c7c-c0d8-1306-f722da2a9ba1-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Hao Xu <haoxu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Thanks for the answer and the context explanations.

On Thu, Sep 02, 2021 at 12:00:33PM -0600, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
> We already have this API to set the affinity based on when these were
> regular kernel threads, so it needs to work with that too. As such they
> are marked PF_NO_SETAFFINITY.

I see the current implementation "allows" at most one binding (by the
passed sq_cpu arg) to a CPU and then "locks" it by setting
PF_NO_SETAFFINITY subsequently (after set_cpus_allowed_ptr).
And actually doesn't check whether it succeeded or not (Hao suggests in
another subthread sq_cpu is a mere hint).

Nevertheless, you likely don't want to "trespass" the boundary of a
cpuset and I think that it'll end up with a loop checking against
hotplug races. That is already implemented in __sched_affinity, it'd be
IMO good to have it in one place only.

> > [1] Not only spending their life in kernel but providing some
> > delocalized kernel service.
> 
> That's what they do...

(I assume that answer to "life in kernel" and the IO threads serve only
the originating cpuset (container) i.e. are (co)localized to it (not
delocalized as some kernel workers).)

Cheers,
Michal
