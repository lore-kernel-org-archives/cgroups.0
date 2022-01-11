From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Tue, 11 Jan 2022 11:41:26 -0800
Message-ID: <Yd3dZklleDnJCQ46@gmail.com>
References: <20220111071212.1210124-1-surenb@google.com>
 <Yd3RClhoz24rrU04@sol.localdomain>
 <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641930089;
        bh=jYNHzG1wbaAIyjZ88RuWPwTqUfCGhaT6PoqY/x5NTrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bZZke3cGP9qy6WgGCyY08pzem55ryUbgJmk9aZD8S8+kQu7J4Rl1tFen2RRoSBK/o
         tU5b2w4Du6X5IakR895ZclgnQH5Q/QMn/EX3hHm7e2MnB+GJ1DVvgNfqLVW7wX7gi1
         dwEV6C7KZxpcF0+hadCOauvl2vAuyAnHtgnddnlYqIKP8be+R56e8cLVtIIYbU8ovq
         r9mAY4hX2j3Z5DMOkYw+nAGdJ0qUUwqCkR6y/XgY1NyhLzWwC6iH9aKgLMlRy3R7NP
         KvfgqLQ9x5OK3wNNsIvnmsgRkS1mlnPgKX08lZ4wRKpY4CUjJSSL8sevoe1Eoc9Il0
         Pb+X3dZ97KLAg==
Content-Disposition: inline
In-Reply-To: <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Jonathan Corbet <corbet@lwn.net>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, stable <stable@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, syzbot <s>

On Tue, Jan 11, 2022 at 11:11:32AM -0800, Linus Torvalds wrote:
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
> 

This is yet another case of "one time init".  There have been long discussions
on this topic before:
* https://lore.kernel.org/linux-fsdevel/20200713033330.205104-1-ebiggers@kernel.org/T/#u
* https://lore.kernel.org/lkml/20200916233042.51634-1-ebiggers@kernel.org/T/#u
* https://lwn.net/Articles/827180/

I even attempted to document the best practices:
* https://lore.kernel.org/linux-fsdevel/20200717044427.68747-1-ebiggers@kernel.org/T/#u

However, no one could agree on whether READ_ONCE() or smp_load_acquire() should
be used.  smp_load_acquire() is always correct, so it remains my preference.
However, READ_ONCE() is correct in some cases, and some people (including the
primary LKMM maintainer) insist that it be used in all such cases, as well as in
rcu_dereference() even though this places difficult-to-understand constraints on
how rcu_dereference() can be used.

My preference is that smp_load_acquire() be used.  But be aware that this risks
the READ_ONCE() people coming out of the woodwork and arguing for READ_ONCE().

- Eric
