From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Tue, 11 Jan 2022 12:14:55 -0800
Message-ID: <CAHk-=wiQ-qzKU8vyhgm8xsWE8DG6rR4jmbvOfBvbjVYq4SKQMA@mail.gmail.com>
References: <20220111071212.1210124-1-surenb@google.com> <Yd3RClhoz24rrU04@sol.localdomain>
 <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com> <Yd3dZklleDnJCQ46@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QIPHuIOvokpeNHmHUixV0mApYnjljbKFO0KUPR67zl4=;
        b=WkUrQMItIdviW32gVxTME1qmG78cK09N/WFqLy9Iv0myOcHM0JJ6ekcU8JpQUo1c6s
         EwUt9qH+HwlFUcOS9uJquiUQoS0opheUzJrb5L+hu3uiCv/lHpZjZUIRYpu+6riD7OVJ
         g1sIlIT7CN1X65a9ArD4h2V5w+0vG4Ns+U5Lo=
In-Reply-To: <Yd3dZklleDnJCQ46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, syzbot <s>

On Tue, Jan 11, 2022 at 11:41 AM Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> This is yet another case of "one time init".

Ehh. It's somewhat debatable.

For a flag that sets a value once, the rules are somewhat different.
In that case, people may simply not care about memory ordering at all,
because all they care about is the actual flag value, and - thanks to
the one-time behavior - basically whether some transition had happened
or not. That's not all that unusual.

But when you fetch a pointer, things are at least conceptually
slightly different.

Of course, you may use the existence of the pointer itself as a flag
(ie just a "NULL or not"), in which case it's the same as any other
one-time flag thing.

But if you use it to dereference something, then _by_definition_
you're not just fetching a one-time flag - even if the pointer is only
set once. At that point, at a minimum, you require that that thing has
been initialized.

Now, it's then absolutely true that the stuff behind the pointer may
then have other reasons not to care about memory ordering again, and
you may be able to avoid memory ordering even then. If you're just
switching the pointer around between different objects that has been
statically allocated and initialized, then there is no memory ordering
required, for example. You might be back to the "I just want one or
the other of these two pointers".

But if you have something that was initialized before the pointer was
assigned, you really do hit the problem we had on alpha, where even if
you order the pointer write side accesses, the dereferencing of the
pointer may not be ordered on the read side.

Now, alpha is basically dead, and we probably don't really care. Even
on alpha, the whole "data dependency isn't a memory ordering" is
almost impossible to trigger.

And in fact, to avoid too much pain we ended up saying "screw alpha"
and added a memory barrier to READ_ONCE(), so it turns out that
smp_store_release -> READ_ONCE() does work because we just couldn't be
bothered to try something more proper.

So yeah, READ_ONCE() ends up making the "access through a pointer"
thing safe, but that's less of a "it should be safe" and more of a "we
can't waste time dealing with braindamage on platforms that don't
matter".

In general, I think the rule should be that READ_ONCE() is for things
that simply don't care about memory ordering at all (or do whatever
ordering they want explicitly). And yes, one such very common case is
the "one-way flag" where once a certain state has been reached, it's
idempotent.

Of course, then we have the fact that READ_ONCE() can be more
efficient than "smp_load_acquire()" on some platforms, so if something
is *hugely* performance-critical, you might use READ_ONCE() even if
it's not really technically the right thing.

So it's complicated.

A lot of READ_ONCE() users exist just for historical reasons because
they predated smp_store_release/smp_load_acquire. They may well have
been using ACCESS_ONCE() long ago.

And some are there because it's a very critical piece of code, and
it's very intentional.

But if you don't have some huge reasons, I really would prefer people
use "smp_store_release -> smp_load_acquire" as a very clear "handoff"
event.

              Linus
