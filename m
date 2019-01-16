From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 5/5] psi: introduce psi monitor
Date: Wed, 16 Jan 2019 14:17:28 -0500
Message-ID: <20190116191728.GA1380@cmpxchg.org>
References: <20190110220718.261134-1-surenb@google.com>
 <20190110220718.261134-6-surenb@google.com>
 <20190114102137.GB14054@worktop.programming.kicks-ass.net>
 <CAJuCfpGUWs0E9oPUjPTNm=WhPJcE_DBjZCtCiaVu5WXabKRW6A@mail.gmail.com>
 <20190116132446.GF10803@hirez.programming.kicks-ass.net>
 <CAJuCfpEJW6Uq4GSGEGLKOM4K7ySHUeTGrSUGM1+EJSQ16d8SJg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kIFFLkmq7d3xFpRMLDb08Mw1HpNVbvYZHc+n3mgNoj8=;
        b=NNSL/Bd3aNrBfSndV2o1hvQ3nbYDQ3op0STM0igBEdRn8QAeAmSSbGIugQi43fcd5V
         b8FNwOkSMLltBhPH6uzFCikvhmh/KuhWnRObaUw2AkhiHXf7S4hKCiSq61zp4r9PIaA+
         BL2xSSnZJVsoP1r5qg9HlTN1zRpYiRkI5PZEo/ynNddY0l83FBP8pCEgNKFoeeSvY/fD
         5VT6G1MQkskyoTaGsiqJ7pD8/XsObcLDBFxJSMW7RhXnc9ekhDPGw9CSQF0iGSemOPuK
         Bmf9gGjHDicM8qG90ire2HSUPXzunPANhQ8gD90oyUxt+2yv2Oxr+0fVV1ULNUOQ7oyP
         fgpg==
Content-Disposition: inline
In-Reply-To: <CAJuCfpEJW6Uq4GSGEGLKOM4K7ySHUeTGrSUGM1+EJSQ16d8SJg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Wed, Jan 16, 2019 at 09:39:13AM -0800, Suren Baghdasaryan wrote:
> On Wed, Jan 16, 2019 at 5:24 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Mon, Jan 14, 2019 at 11:30:12AM -0800, Suren Baghdasaryan wrote:
> > > For memory ordering (which Johannes also pointed out) the critical point is:
> > >
> > > times[cpu] += delta           | if g->polling:
> > > smp_wmb()                     |   g->polling = polling = 0
> > > cmpxchg(g->polling, 0, 1)     |   smp_rmb()
> > >                               |   delta = times[*] (through goto SLOWPATH)
> > >
> > > So that hotpath writes to times[] then g->polling and slowpath reads
> > > g->polling then times[]. cmpxchg() implies a full barrier, so we can
> > > drop smp_wmb(). Something like this:
> > >
> > > times[cpu] += delta           | if g->polling:
> > > cmpxchg(g->polling, 0, 1)     |   g->polling = polling = 0
> > >                               |   smp_rmb()
> > >                               |   delta = times[*] (through goto SLOWPATH)
> > >
> > > Would that address your concern about ordering?
> >
> > cmpxchg() implies smp_mb() before and after, so the smp_wmb() on the
> > left column is superfluous.
> 
> Should I keep it in the comments to make it obvious and add a note
> about implicit barriers being the reason we don't call smp_mb() in the
> code explicitly?

I'd keep 'em out if they aren't actually in the code. But I'd switch

	delta = times[*]

in this comment to to

	get_recent_times() // implies smp_mb()

or something to make the ordering a bit more visible.

And also add a comment to the actual cmpxchg() in the code directly
that says that we rely on the implied ordering and that it pairs with
the smp_mb() in the slowpath; add a similar comment to the smp_mb().

> > Also, you probably want to use atomic_t for g->polling, because we
> > (sadly) have architectures where regular stores and atomic ops don't
> > work 'right'.
> 
> Oh, I see. Will do. Thanks!

Yikes, that's news to me too. Good to know.
