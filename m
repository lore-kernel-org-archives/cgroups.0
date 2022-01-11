From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Tue, 11 Jan 2022 11:11:32 -0800
Message-ID: <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com>
References: <20220111071212.1210124-1-surenb@google.com> <Yd3RClhoz24rrU04@sol.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B44bvcGMR7HJrF8RjjxVk6yTIMoiYipBLak96y+Vc5U=;
        b=b2vOkvqM6CrU97KTnO6tCUMPeqtx4Tb9raQiqg+DsCBvIm5TjoldAmKmEfiOSjOJi8
         Q2wHU19wTfiKrO4kFP5KoxmIJN/5uCNBtFVo+DFeoT5q8s6S7/g7wbRMshY/F57KQpZc
         HByWVJ89WRq9xPL/+lWSfsSWUMQUEeyGZRwaA=
In-Reply-To: <Yd3RClhoz24rrU04-8Kz7deQLoS0mYvmMESoHnA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, syzbot <s>

On Tue, Jan 11, 2022 at 10:48 AM Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> The write here needs to use smp_store_release(), since it is paired with the
> concurrent READ_ONCE() in psi_trigger_poll().

A smp_store_release() doesn't make sense pairing with a READ_ONCE().

Any memory ordering that the smp_store_release() does on the writing
side is entirely irrelevant, since the READ_ONCE() doesn't imply any
ordering on the reading side. Ordering one but not the other is
nonsensical.

So the proper pattern is to use a WRITE_ONCE() to pair with a
READ_ONCE() (when you don't care about memory ordering, or you handle
it explicitly), or a smp_load_acquire() with a smp_store_release() (in
which case writes before the smp_store_release() on the writing side
will be ordered wrt accesses after smp_load_acquire() on the reading
side).

Of course, in practice, for pointers, the whole "dereference off a
pointer" on the read side *does* imply a barrier in all relevant
situations. So yes, a smp_store_release() -> READ_ONCE() does work in
practice, although it's technically wrong (in particular, it's wrong
on alpha, because of the completely broken memory ordering that alpha
has that doesn't even honor data dependencies as read-side orderings)

But in this case, I do think that since there's some setup involved
with the trigger pointer, the proper serialization is to use
smp_store_release() to set the pointer, and then smp_load_acquire() on
the reading side.

Or just use the RCU primitives - they are even better optimized, and
handle exactly that case, and can be more efficient on some
architectures if release->acquire isn't already cheap.

That said, we've pretty much always accepted that normal word writes
are not going to tear, so we *have* also accepted just

 - do any normal store of a value on the write side

 - do a READ_ONCE() on the reading side

where the reading side doesn't actually care *what* value it gets, it
only cares that the value it gets is *stable* (ie no compiler reloads
that might show up as two different values on the reading side).

Of course, that has the same issue as WRITE_ONCE/READ_ONCE - you need
to worry about memory ordering separately.

> > +     seq->private = new;
>
> Likewise here.

Yeah, same deal, except here you can't even use the RCU ones, because
'seq->private' isn't annotated for RCU.

Or you'd do the casting, of course.

              Linus
