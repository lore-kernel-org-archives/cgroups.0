From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Tue, 11 Jan 2022 11:26:59 -0800
Message-ID: <CAJuCfpE3feNU=36qRUdCJsk41rxQBv1gRYy5R1dB1djMd0NLjg@mail.gmail.com>
References: <20220111071212.1210124-1-surenb@google.com> <Yd3RClhoz24rrU04@sol.localdomain>
 <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3SD2cpfSGkAK1w66aKc7m2NiJafQlutBqzxhSCCaOqc=;
        b=TzjUw/oUevlONYTmUZCO+vFz1L3zQ1+crDuIuYltIcAJtHMwFDChmeLSs2gDl7mh06
         Hlra3FtwWGyUTsMDlDaLAb8posIm2eML95P1zVTYG5i0Kwc3a/eguhrpIVIpgePSXbC5
         PtDQuvSxp36wV1baRDzETqB6hGUFKD3dprwj+NaaVmpCpW9jt6m0heI/03r25028rGdp
         /c9Ggm3fJnJpjw5fXgmXPM2SCNL04voZhaM2lMPF+HalxNmYzZgtyZndJ8kDRgq/FzGn
         t7XhJTqNz9rg+46Z7gPIyNYoM/asGldtAU6O7WJizUqNjQtuq5OwTb/J8Pwz5dVoEPz1
         hS+Q==
In-Reply-To: <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Jonathan Corbet <corbet@lwn.net>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, stable <stable@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, syzbot <syzbo>

On Tue, Jan 11, 2022 at 11:11 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Jan 11, 2022 at 10:48 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > The write here needs to use smp_store_release(), since it is paired with the
> > concurrent READ_ONCE() in psi_trigger_poll().
>
> A smp_store_release() doesn't make sense pairing with a READ_ONCE().
>
> Any memory ordering that the smp_store_release() does on the writing
> side is entirely irrelevant, since the READ_ONCE() doesn't imply any
> ordering on the reading side. Ordering one but not the other is
> nonsensical.
>
> So the proper pattern is to use a WRITE_ONCE() to pair with a
> READ_ONCE() (when you don't care about memory ordering, or you handle
> it explicitly), or a smp_load_acquire() with a smp_store_release() (in
> which case writes before the smp_store_release() on the writing side
> will be ordered wrt accesses after smp_load_acquire() on the reading
> side).
>
> Of course, in practice, for pointers, the whole "dereference off a
> pointer" on the read side *does* imply a barrier in all relevant
> situations. So yes, a smp_store_release() -> READ_ONCE() does work in
> practice, although it's technically wrong (in particular, it's wrong
> on alpha, because of the completely broken memory ordering that alpha
> has that doesn't even honor data dependencies as read-side orderings)
>
> But in this case, I do think that since there's some setup involved
> with the trigger pointer, the proper serialization is to use
> smp_store_release() to set the pointer, and then smp_load_acquire() on
> the reading side.
>
> Or just use the RCU primitives - they are even better optimized, and
> handle exactly that case, and can be more efficient on some
> architectures if release->acquire isn't already cheap.
>
> That said, we've pretty much always accepted that normal word writes
> are not going to tear, so we *have* also accepted just
>
>  - do any normal store of a value on the write side
>
>  - do a READ_ONCE() on the reading side
>
> where the reading side doesn't actually care *what* value it gets, it
> only cares that the value it gets is *stable* (ie no compiler reloads
> that might show up as two different values on the reading side).
>
> Of course, that has the same issue as WRITE_ONCE/READ_ONCE - you need
> to worry about memory ordering separately.
>
> > > +     seq->private = new;
> >
> > Likewise here.
>
> Yeah, same deal, except here you can't even use the RCU ones, because
> 'seq->private' isn't annotated for RCU.
>
> Or you'd do the casting, of course.

Thanks for the explanation!
So, it sounds like the best (semantically correct) option I have here
is smp_store_release() to set the pointer, and then smp_load_acquire()
to read it. Is my understanding correct?

>
>               Linus
