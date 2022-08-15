From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Mon, 15 Aug 2022 13:47:15 -0400
Message-ID: <YvqGoxfs25bEyQGJ@cmpxchg.org>
References: <YvWa9MOQWBICInjO@P9FQF9L96D.corp.robot.car>
 <CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg@mail.gmail.com>
 <CAJD7tkbrCNDMkE8dJDWHiTfi=nJJzrZwepaWb3YioRHMrSEuQA@mail.gmail.com>
 <1704B09B-F758-47DF-BDDE-FEA9AB227E12@baidu.com>
 <CAJD7tkaW7qtaNpc3UHuQAcJAjdjzjmWZCqCMafT-nUES+2QtYg@mail.gmail.com>
 <E0E6FD3B-242B-4187-B4B4-9D4496A5B19A@baidu.com>
 <CAJD7tkYdJrakJGp8XMt49ixZJuf=qpGm=vSxH6G_GWeenk35dQ@mail.gmail.com>
 <Yvpm3cubIRAqUUJn@cmpxchg.org>
 <CAJD7tkaSS61YqYHKztqimASEaEakAdV0XqMs_k0ooJhUbX0+=g@mail.gmail.com>
 <CAJD7tkbVz44d64yPm15kUMmpFEQwFtut6Ye8D8oO1jiS9s_tBw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Kk1le+XvE3D7VTktFKWjawEbexVd49xc8A2KpMO7iq8=;
        b=eQKsJ8stLgyyQXvUP/E7q4Wlp+v19noK96fAZX3mr1P14cj6AK0dtNCRHwiSjq8W1l
         F8ZvkF96Q5GjKKQVwJmHra/4F8MrB1pugUURKfQIqnqMjnOPth5Dp4M5Uff4f3gq6qYY
         3vtXQk1lAyet/XMy+J3dj6NBxEc9umEp/KX4uUH8ncLTYut8nnYwzxnMWSZIK0ndAXUh
         IR6I2kwQxzUoxKaGK3s2qONIQKu4KpEBk4MvJ8tcq+A8apZYOV1GBg2xwo7n9eamEnd+
         2qSM2leEG3F8LydH6TQ7qn3yJR4IY11gT6d+X8TAgKKmaTZ7RMFCdgvCO6u+ocW8oaqL
         ajTA==
Content-Disposition: inline
In-Reply-To: <CAJD7tkbVz44d64yPm15kUMmpFEQwFtut6Ye8D8oO1jiS9s_tBw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Li,Liguang" <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Mon, Aug 15, 2022 at 09:16:08AM -0700, Yosry Ahmed wrote:
> On Mon, Aug 15, 2022 at 8:42 AM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Mon, Aug 15, 2022 at 8:31 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > >
> > > On Mon, Aug 15, 2022 at 06:46:46AM -0700, Yosry Ahmed wrote:
> > > > Yeah I understand this much, what I don't understand is why we charge
> > > > the zswap memory through objcg (thus tying it to memcg kmem charging)
> > > > rather than directly through memcg.
> > >
> > > The charged quantities are smaller than a page, so we have to use the
> > > byte interface.
> > >
> > > The byte interface (objcg) was written for slab originally, hence the
> > > link to the kmem option. But note that CONFIG_MEMCG_KMEM is no longer
> > > a user-visible option, and for all intents and purposes a fixed part
> > > of CONFIG_MEMCG.
> > >
> > > (There is the SLOB quirk. But I'm not sure anybody uses slob, let
> > > alone slob + memcg.)
> >
> > Thanks for the clarification, it makes sense to use the byte interface
> > here for this, and thanks for pointing out that CONFIC_MEMCG_KMEM is
> > not part of CONFIG_MEMCG.
> >
> > One more question :) memcg kmem charging can still be disabled even
> > with !CONFIG_MEMCG_KMEM, right? In this case zswap charging will also
> > be off, which seems like an unintended side effect, right?
> 
> memcg kmem charging can still be disabled even
> with CONFIG_MEMCG_KMEM***

Yes, indeed, if the host is booted with the nokmem flag. Doing so will
turn off slab, percpu, and (as of recently) zswap.

The zswap backing storage *is* kernel memory, so that seems like the
correct semantics for the flag.

That said, the distinction between kernel and user memory is becoming
increasingly odd. The more kernel memory we track, the more ridiculous
the size of the hole you punch into resource control by disabling it.

Maybe we should just deprecate that knob altogether.
