From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Wed, 12 Jan 2022 11:49:58 -0800
Message-ID: <CAJuCfpHeg9mb4oq71P6xcC9fQipWBaAy9WJZg=jM+cUnR+ouMg@mail.gmail.com>
References: <20220111232309.1786347-1-surenb@google.com> <Yd7oPlxCpnzNmFzc@cmpxchg.org>
 <CAJuCfpGHLXDvMU1GLMcgK_K72_ErPhbcFh1ZvEeHg025yinNuw@mail.gmail.com>
 <CAJuCfpEaM3KoPy3MUG7HW2yzcT6oJ5gdceyHPNpHrqTErq27eQ@mail.gmail.com>
 <Yd8a8TdThrGHsf2o@casper.infradead.org> <CAJuCfpF45VY_7esx7p2yEK+eK-ufSMsBETEdJPF=Mzxj+BTnLA@mail.gmail.com>
 <Yd8hpPwsIT2pbKUN@gmail.com> <CAJuCfpF_aZ7OnDRYr2MNa-x=ctO-daw-U=k+-GCYkJR1_yTHQg@mail.gmail.com>
 <Yd8mIY5IxwOKTK+D@gmail.com> <CAJuCfpG9o5Z7x6hvPXy-Tfgom31sm4rjAA=f4KiY9pppGRGSHQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jRJqEvb6RaoXDTGIGvfe6D9l0JWX3IBGy+0XrscHKFk=;
        b=A05wtVt0YhyBSdDPVxnMOaffKavmT2bc7mtYBlQvpXZuCcKdvBu2pQnaPFx3DGatS3
         dletqWECy0d2sgn8vA9vLAVgNohXHyzj9Cgqbl79LKWXgG+hE4wDbGAhWFykD9TScLom
         RAoovIZCddTCKuxzFHyAQtyUFKl1Zj9Pah7k/alWN5AMM8RaorUkk56uf1K/F+4vbrJ1
         tVX2xsXqH3CMuhvO/jQ0GHItrhwrslksLTTyVuEJKA47jbtOoEt6Dy2V8InbwuqJee6U
         RtN4mRaJgakGvKhskjQGCe4cEY3Rn9j04AANjfnBq6vDTcY1WWI2cp4TB0GwIncWQef6
         qjjQ==
In-Reply-To: <CAJuCfpG9o5Z7x6hvPXy-Tfgom31sm4rjAA=f4KiY9pppGRGSHQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel

On Wed, Jan 12, 2022 at 11:06 AM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Jan 12, 2022 at 11:04 AM Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Wed, Jan 12, 2022 at 10:53:48AM -0800, Suren Baghdasaryan wrote:
> > > On Wed, Jan 12, 2022 at 10:44 AM Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > >
> > > > On Wed, Jan 12, 2022 at 10:26:08AM -0800, Suren Baghdasaryan wrote:
> > > > > On Wed, Jan 12, 2022 at 10:16 AM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > > > > >
> > > > > > On Wed, Jan 12, 2022 at 09:49:00AM -0800, Suren Baghdasaryan wrote:
> > > > > > > > This happens with the following config:
> > > > > > > >
> > > > > > > > CONFIG_CGROUPS=n
> > > > > > > > CONFIG_PSI=y
> > > > > > > >
> > > > > > > > With cgroups disabled these functions are defined as non-static but
> > > > > > > > are not defined in the header
> > > > > > > > (https://elixir.bootlin.com/linux/latest/source/include/linux/psi.h#L28)
> > > > > > > > since the only external user cgroup.c is disabled. The cleanest way to
> > > > > > > > fix these I think is by doing smth like this in psi.c:
> > > > > >
> > > > > > A cleaner way to solve these is simply:
> > > > > >
> > > > > > #ifndef CONFIG_CGROUPS
> > > > > > static struct psi_trigger *psi_trigger_create(...);
> > > > > > ...
> > > > > > #endif
> > > > > >
> > > > > > I tested this works:
> > > > > >
> > > > > > $ cat foo5.c
> > > > > > static int psi(void *);
> > > > > >
> > > > > > int psi(void *x)
> > > > > > {
> > > > > >         return (int)(long)x;
> > > > > > }
> > > > > >
> > > > > > int bar(void *x)
> > > > > > {
> > > > > >         return psi(x);
> > > > > > }
> > > > > > $ gcc -W -Wall -O2 -c -o foo5.o foo5.c
> > > > > > $ readelf -s foo5.o
> > > > > >
> > > > > > Symbol table '.symtab' contains 4 entries:
> > > > > >    Num:    Value          Size Type    Bind   Vis      Ndx Name
> > > > > >      0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
> > > > > >      1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS foo5.c
> > > > > >      2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 .text
> > > > > >      3: 0000000000000000     3 FUNC    GLOBAL DEFAULT    1 bar
> > > > > >
> > > > >
> > > > > Thanks Matthew!
> > > > > That looks much cleaner. I'll post a separate patch to fix these. My
> > > > > main concern was whether it's worth adding more code to satisfy this
> > > > > warning but with this approach the code changes are minimal, so I'll
> > > > > go ahead and post it shortly.
> > > >
> > > > Why not simply move the declarations of psi_trigger_create() and
> > > > psi_trigger_destroy() in include/linux/psi.h outside of the
> > > > '#ifdef CONFIG_CGROUPS' block, to match the .c file?
> > >
> > > IIRC this was done to avoid another warning that these functions are
> > > not used outside of psi.c when CONFIG_CGROUPS=n
> > >
> >
> > What tool gave that warning?
>
> Let me double-check by building it. It has been a while since I
> developed the code and I don't want to mislead by making false claims.
>

No warnings, so it was probably done to keep the scope of these
functions as local as possible.
I agree that moving them out of #ifdef CONFIG_CGROUPS in the header
file makes sense here. The scope unnecessarily expands when
CONFIG_CGROUPS=n but the code is simpler. Will do that then.

I noticed there is another warning about psi_cpu_proc_ops and similar
structures being unused when CONFIG_PROC_FS=n. Looks like I'll need
some more ifdefs to fix all these warnings.

> >
> > - Eric
