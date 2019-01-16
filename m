From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v2 5/5] psi: introduce psi monitor
Date: Wed, 16 Jan 2019 13:29:24 -0800
Message-ID: <CAJuCfpG1+=XXS=7oTaBw_J9cGvmheTDrr3jv8UxBThwa4K+Dmw@mail.gmail.com>
References: <20190110220718.261134-1-surenb@google.com> <20190110220718.261134-6-surenb@google.com>
 <20190114102137.GB14054@worktop.programming.kicks-ass.net>
 <CAJuCfpGUWs0E9oPUjPTNm=WhPJcE_DBjZCtCiaVu5WXabKRW6A@mail.gmail.com>
 <20190116132446.GF10803@hirez.programming.kicks-ass.net> <CAJuCfpEJW6Uq4GSGEGLKOM4K7ySHUeTGrSUGM1+EJSQ16d8SJg@mail.gmail.com>
 <20190116191728.GA1380@cmpxchg.org> <20190116192744.GA1576@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HJrfE3jaolNs6YKqdZtpYFmOvcf18H8OhY7pa4kzWEY=;
        b=j8HwzKf4QtGnl55VhWxxU62RJz2zdHqwwXdAJtf4r17Cb5i4Z9PTr3LYowNmAp7bfs
         +ORL7QKVLtsnXsxfog2gfV4zCd8b0Lp/hBynHbSFCWHpsjhb+gUzSAD4s6BHH/fRV6pB
         Y8RKIyku/qvSySJPfI4lQbUHofvTuiB69SAxZnEm2/M1qYVOb6tzofxI8DeoSsxlVo+u
         nZ82jRaDZ+i/eUXJAlQsvkLtbuNxntHHswTgQKdk/B7zvICxLyY6D2dBF/Yx3CINZzCc
         r7EEDIuZ1ahCWCcTqQtXrHreZMO0rz9tVS/ldkSGVBMgfPl+UDSbYYc4Q+A3wO26h8wa
         jfTw==
In-Reply-To: <20190116192744.GA1576@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Wed, Jan 16, 2019 at 11:27 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Wed, Jan 16, 2019 at 02:17:28PM -0500, Johannes Weiner wrote:
> > On Wed, Jan 16, 2019 at 09:39:13AM -0800, Suren Baghdasaryan wrote:
> > > On Wed, Jan 16, 2019 at 5:24 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > > >
> > > > On Mon, Jan 14, 2019 at 11:30:12AM -0800, Suren Baghdasaryan wrote:
> > > > > For memory ordering (which Johannes also pointed out) the critical point is:
> > > > >
> > > > > times[cpu] += delta           | if g->polling:
> > > > > smp_wmb()                     |   g->polling = polling = 0
> > > > > cmpxchg(g->polling, 0, 1)     |   smp_rmb()
> > > > >                               |   delta = times[*] (through goto SLOWPATH)
> > > > >
> > > > > So that hotpath writes to times[] then g->polling and slowpath reads
> > > > > g->polling then times[]. cmpxchg() implies a full barrier, so we can
> > > > > drop smp_wmb(). Something like this:
> > > > >
> > > > > times[cpu] += delta           | if g->polling:
> > > > > cmpxchg(g->polling, 0, 1)     |   g->polling = polling = 0
> > > > >                               |   smp_rmb()
> > > > >                               |   delta = times[*] (through goto SLOWPATH)
> > > > >
> > > > > Would that address your concern about ordering?
> > > >
> > > > cmpxchg() implies smp_mb() before and after, so the smp_wmb() on the
> > > > left column is superfluous.
> > >
> > > Should I keep it in the comments to make it obvious and add a note
> > > about implicit barriers being the reason we don't call smp_mb() in the
> > > code explicitly?
> >
> > I'd keep 'em out if they aren't actually in the code. But I'd switch
> >
> >       delta = times[*]
> >
> > in this comment to to
> >
> >       get_recent_times() // implies smp_mb()
>
> Actually, I might have been mistaken about this. The seqcount locking
> does an smp_rmb() and an smp_wmb(), and that orders reads and writes
> respectively, but doesn't necessarily order reads against writes.
>
> So I think we need an explicit smp_mb() after all.

I see. So, the action items I collected so far:

1. Add a comment in the code next to cmpxchg() indicating implicit smp_mb.
2. Add explicit smp_mb after "g->polling = 0" and before "delta =
times[*]" both in the code and in the comments (in the slowpath).
3. Use atomic_t for g->polling. Add a note in the comments why atomic
operations are not needed in the slowpath.
4. Minimize line-breaks.

Please let me know if I missed anything, otherwise will make these
changes and post ver 3 of the patchset.
Thanks,
Suren.
