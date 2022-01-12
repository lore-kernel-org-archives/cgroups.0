From: Eric Biggers <ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Wed, 12 Jan 2022 10:44:52 -0800
Message-ID: <Yd8hpPwsIT2pbKUN@gmail.com>
References: <20220111232309.1786347-1-surenb@google.com>
 <Yd7oPlxCpnzNmFzc@cmpxchg.org>
 <CAJuCfpGHLXDvMU1GLMcgK_K72_ErPhbcFh1ZvEeHg025yinNuw@mail.gmail.com>
 <CAJuCfpEaM3KoPy3MUG7HW2yzcT6oJ5gdceyHPNpHrqTErq27eQ@mail.gmail.com>
 <Yd8a8TdThrGHsf2o@casper.infradead.org>
 <CAJuCfpF45VY_7esx7p2yEK+eK-ufSMsBETEdJPF=Mzxj+BTnLA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642013094;
        bh=LW70gO4DLI9yvYy93v3QKw+URWyMDt50sXq2NeIJKtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u9JyeUuGZinPYZac9f50ZGapw9lan1RmyRRYW6nsTq8Kzhkpsjl1QGkaz+oFRnqVN
         7FZPmXLOZcqpo1pFn456eGEuQuqgkfk4cKrThZvQHIoq0gP0NWJrNg5bT9OYwgigh6
         X1qxvJ8t2zZPtnNyGlI82cYsOlxgc4Wgw8nT4d1kKN5f91W3lGNeyPImjj7G/f9i+s
         b0ygOn9p1x9rcOhj16ej7REyR+9FSy+AA1EubEkrfizXFPIwzk2t7/ocGMNuDUIHZu
         ff6Aai615p5p8nnquDFEkpEwFQ+QQeofZvGLFKcPrV10stWyP4K/kieXrkhKZVwoGh
         vdJBm2AYGVeEw==
Content-Disposition: inline
In-Reply-To: <CAJuCfpF45VY_7esx7p2yEK+eK-ufSMsBETEdJPF=Mzxj+BTnLA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel

On Wed, Jan 12, 2022 at 10:26:08AM -0800, Suren Baghdasaryan wrote:
> On Wed, Jan 12, 2022 at 10:16 AM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >
> > On Wed, Jan 12, 2022 at 09:49:00AM -0800, Suren Baghdasaryan wrote:
> > > > This happens with the following config:
> > > >
> > > > CONFIG_CGROUPS=n
> > > > CONFIG_PSI=y
> > > >
> > > > With cgroups disabled these functions are defined as non-static but
> > > > are not defined in the header
> > > > (https://elixir.bootlin.com/linux/latest/source/include/linux/psi.h#L28)
> > > > since the only external user cgroup.c is disabled. The cleanest way to
> > > > fix these I think is by doing smth like this in psi.c:
> >
> > A cleaner way to solve these is simply:
> >
> > #ifndef CONFIG_CGROUPS
> > static struct psi_trigger *psi_trigger_create(...);
> > ...
> > #endif
> >
> > I tested this works:
> >
> > $ cat foo5.c
> > static int psi(void *);
> >
> > int psi(void *x)
> > {
> >         return (int)(long)x;
> > }
> >
> > int bar(void *x)
> > {
> >         return psi(x);
> > }
> > $ gcc -W -Wall -O2 -c -o foo5.o foo5.c
> > $ readelf -s foo5.o
> >
> > Symbol table '.symtab' contains 4 entries:
> >    Num:    Value          Size Type    Bind   Vis      Ndx Name
> >      0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
> >      1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS foo5.c
> >      2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 .text
> >      3: 0000000000000000     3 FUNC    GLOBAL DEFAULT    1 bar
> >
> 
> Thanks Matthew!
> That looks much cleaner. I'll post a separate patch to fix these. My
> main concern was whether it's worth adding more code to satisfy this
> warning but with this approach the code changes are minimal, so I'll
> go ahead and post it shortly.

Why not simply move the declarations of psi_trigger_create() and
psi_trigger_destroy() in include/linux/psi.h outside of the
'#ifdef CONFIG_CGROUPS' block, to match the .c file?

They *could* be static when !CONFIG_CGROUPS, but IMO it's not worth bothering.

- Eric
