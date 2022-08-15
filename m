From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Mon, 15 Aug 2022 09:16:08 -0700
Message-ID: <CAJD7tkbVz44d64yPm15kUMmpFEQwFtut6Ye8D8oO1jiS9s_tBw@mail.gmail.com>
References: <20220811081913.102770-1-liliguang@baidu.com> <YvWa9MOQWBICInjO@P9FQF9L96D.corp.robot.car>
 <CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg@mail.gmail.com>
 <CAJD7tkbrCNDMkE8dJDWHiTfi=nJJzrZwepaWb3YioRHMrSEuQA@mail.gmail.com>
 <1704B09B-F758-47DF-BDDE-FEA9AB227E12@baidu.com> <CAJD7tkaW7qtaNpc3UHuQAcJAjdjzjmWZCqCMafT-nUES+2QtYg@mail.gmail.com>
 <E0E6FD3B-242B-4187-B4B4-9D4496A5B19A@baidu.com> <CAJD7tkYdJrakJGp8XMt49ixZJuf=qpGm=vSxH6G_GWeenk35dQ@mail.gmail.com>
 <Yvpm3cubIRAqUUJn@cmpxchg.org> <CAJD7tkaSS61YqYHKztqimASEaEakAdV0XqMs_k0ooJhUbX0+=g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=NiPfdsvJTMDvYiHxjIlVruzvPreI0sXDM9XcYGIg7ro=;
        b=nwlr6RfxGmDc9FPkJ8pMlRUSKkvKSg+/dfOHtYjazvYB24ITZuxH/BAX6MimWtVEt5
         n+rj74b/x0akMGs3XmfmLkowqdqDvCffGxwrIOz8S4UhChIKz9jmQAwrsZqnpX8RdzC9
         w9sqnuDygJOGVGsaHKzf8Jm6cyhZ9mykLbbOFlbSpHYSm4ahEYXZWoe/P71sxc+tM+0i
         rB0ns4hUoBgGGlfHhNxrjsWInDwvOjLhCs1zKhHVDgUjuyOHM/eRK4Tj6k8QruiD7PGo
         QNiOubqUnrhLUSOQuqw7ppZqZHrfeHy/9losRWfPEW/FRmo0+orGsjl7Wz7PiCGNqjIh
         AU9w==
In-Reply-To: <CAJD7tkaSS61YqYHKztqimASEaEakAdV0XqMs_k0ooJhUbX0+=g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: "Li,Liguang" <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Mon, Aug 15, 2022 at 8:42 AM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Mon, Aug 15, 2022 at 8:31 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > On Mon, Aug 15, 2022 at 06:46:46AM -0700, Yosry Ahmed wrote:
> > > Yeah I understand this much, what I don't understand is why we charge
> > > the zswap memory through objcg (thus tying it to memcg kmem charging)
> > > rather than directly through memcg.
> >
> > The charged quantities are smaller than a page, so we have to use the
> > byte interface.
> >
> > The byte interface (objcg) was written for slab originally, hence the
> > link to the kmem option. But note that CONFIG_MEMCG_KMEM is no longer
> > a user-visible option, and for all intents and purposes a fixed part
> > of CONFIG_MEMCG.
> >
> > (There is the SLOB quirk. But I'm not sure anybody uses slob, let
> > alone slob + memcg.)
>
> Thanks for the clarification, it makes sense to use the byte interface
> here for this, and thanks for pointing out that CONFIC_MEMCG_KMEM is
> not part of CONFIG_MEMCG.
>
> One more question :) memcg kmem charging can still be disabled even
> with !CONFIG_MEMCG_KMEM, right? In this case zswap charging will also
> be off, which seems like an unintended side effect, right?

memcg kmem charging can still be disabled even
with CONFIG_MEMCG_KMEM***
