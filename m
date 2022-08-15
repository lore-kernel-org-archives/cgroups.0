From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Mon, 15 Aug 2022 10:55:56 -0700
Message-ID: <CAJD7tkZKyNyxbtxXyWSnosJjpBmCE4CT1mMdbP-L_VEa__NoCg@mail.gmail.com>
References: <YvWa9MOQWBICInjO@P9FQF9L96D.corp.robot.car> <CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg@mail.gmail.com>
 <CAJD7tkbrCNDMkE8dJDWHiTfi=nJJzrZwepaWb3YioRHMrSEuQA@mail.gmail.com>
 <1704B09B-F758-47DF-BDDE-FEA9AB227E12@baidu.com> <CAJD7tkaW7qtaNpc3UHuQAcJAjdjzjmWZCqCMafT-nUES+2QtYg@mail.gmail.com>
 <E0E6FD3B-242B-4187-B4B4-9D4496A5B19A@baidu.com> <CAJD7tkYdJrakJGp8XMt49ixZJuf=qpGm=vSxH6G_GWeenk35dQ@mail.gmail.com>
 <Yvpm3cubIRAqUUJn@cmpxchg.org> <CAJD7tkaSS61YqYHKztqimASEaEakAdV0XqMs_k0ooJhUbX0+=g@mail.gmail.com>
 <CAJD7tkbVz44d64yPm15kUMmpFEQwFtut6Ye8D8oO1jiS9s_tBw@mail.gmail.com> <YvqGoxfs25bEyQGJ@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=XCzC1k5JaSs6DVSxuA2P3WfUqr4hU66sPfesxZu2dUs=;
        b=HOKkfB0gFcImmm8qD1rRnAB9O6Np3Uxgn5FoWtQm+SA9NiFobkW0mDb2PoQNBqFCng
         rH29D9fdqxBaHiwjgUmtaIX/II1UBXNecm+GG8Ju6AhJ4C9Z4a3mSrvGuS2jknZrJnJJ
         Y+s4yHlSemcD8+ZH1KXhaV9VDkJhmSW8qqweYrSjyNMAU1yNiLAruehBOBq0XweJOm/U
         rMUCZOu+cPA7fbW45VyT3mZS2uFRmJ4DpFjwxZZqKBCuFCxZ5yQ80+p7UuFjI7zMtJK7
         GSQ+PZ4jdWGWBy81yVXZwkuuPDAUNKug6Xr0M3VdqDav61SotURKhAgAPrJ4hwea/Tfw
         loCw==
In-Reply-To: <YvqGoxfs25bEyQGJ-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: "Li,Liguang" <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Mon, Aug 15, 2022 at 10:47 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Mon, Aug 15, 2022 at 09:16:08AM -0700, Yosry Ahmed wrote:
> > On Mon, Aug 15, 2022 at 8:42 AM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > On Mon, Aug 15, 2022 at 8:31 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > > >
> > > > On Mon, Aug 15, 2022 at 06:46:46AM -0700, Yosry Ahmed wrote:
> > > > > Yeah I understand this much, what I don't understand is why we charge
> > > > > the zswap memory through objcg (thus tying it to memcg kmem charging)
> > > > > rather than directly through memcg.
> > > >
> > > > The charged quantities are smaller than a page, so we have to use the
> > > > byte interface.
> > > >
> > > > The byte interface (objcg) was written for slab originally, hence the
> > > > link to the kmem option. But note that CONFIG_MEMCG_KMEM is no longer
> > > > a user-visible option, and for all intents and purposes a fixed part
> > > > of CONFIG_MEMCG.
> > > >
> > > > (There is the SLOB quirk. But I'm not sure anybody uses slob, let
> > > > alone slob + memcg.)
> > >
> > > Thanks for the clarification, it makes sense to use the byte interface
> > > here for this, and thanks for pointing out that CONFIC_MEMCG_KMEM is
> > > not part of CONFIG_MEMCG.
> > >
> > > One more question :) memcg kmem charging can still be disabled even
> > > with !CONFIG_MEMCG_KMEM, right? In this case zswap charging will also
> > > be off, which seems like an unintended side effect, right?
> >
> > memcg kmem charging can still be disabled even
> > with CONFIG_MEMCG_KMEM***
>
> Yes, indeed, if the host is booted with the nokmem flag. Doing so will
> turn off slab, percpu, and (as of recently) zswap.
>
> The zswap backing storage *is* kernel memory, so that seems like the
> correct semantics for the flag.

I honestly didn't consider it first as kernel memory, as the memory is
coming from LRU pages. It can be confusing to think about, given that
it is memory that the kernel allocates and manages, but it has user
data. Anyway, maybe it's not worth overthinking this, since it can be
considered as kernel memory.

>
> That said, the distinction between kernel and user memory is becoming
> increasingly odd. The more kernel memory we track, the more ridiculous
> the size of the hole you punch into resource control by disabling it.
>
> Maybe we should just deprecate that knob altogether.

Yeah a lot of used memory will just go unaccounted even with memcg
enabled if the knob is disabled (which is what memcg is all about).
This is even more significant now with zswap in the picture.
