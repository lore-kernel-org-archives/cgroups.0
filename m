From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Mon, 15 Aug 2022 08:42:22 -0700
Message-ID: <CAJD7tkaSS61YqYHKztqimASEaEakAdV0XqMs_k0ooJhUbX0+=g@mail.gmail.com>
References: <20220811081913.102770-1-liliguang@baidu.com> <YvWa9MOQWBICInjO@P9FQF9L96D.corp.robot.car>
 <CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg@mail.gmail.com>
 <CAJD7tkbrCNDMkE8dJDWHiTfi=nJJzrZwepaWb3YioRHMrSEuQA@mail.gmail.com>
 <1704B09B-F758-47DF-BDDE-FEA9AB227E12@baidu.com> <CAJD7tkaW7qtaNpc3UHuQAcJAjdjzjmWZCqCMafT-nUES+2QtYg@mail.gmail.com>
 <E0E6FD3B-242B-4187-B4B4-9D4496A5B19A@baidu.com> <CAJD7tkYdJrakJGp8XMt49ixZJuf=qpGm=vSxH6G_GWeenk35dQ@mail.gmail.com>
 <Yvpm3cubIRAqUUJn@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VXv0LOcDj4wDch9oUz0Rg6Hn1DlfxulSzEjxccYfhGA=;
        b=kuXZ020zirScuI8v9FKyyjruMwGPxrzXP6LoEx3u/8kcVVLGMONtTMedOIwBzD3Q4y
         h1vq0DMIcF8z5GzNykL4EUewOg3nx/rYdnNk7N83gzbus1Kz9jcmr2Q1Nh1MIPup0GTr
         64ZjOM7ixJCy36gyD3x9r1bVvlWALIaRdQrmWbZD19HvfB+o8tLqRXwNNJi7/0+xYLic
         8L9ikKVSiX/VOb8RTFpTmTiB2Wr4LH+DUu7DLEOo1IP5RNc8yumVeZ3JSz++XNcihLf1
         /w68PiG5Ayrydse3W1c7L/cQh70wh+R8OqutqgdgUrGKLnk9Z4JbKL72vlZefQAAXt7d
         jbLg==
In-Reply-To: <Yvpm3cubIRAqUUJn-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: "Li,Liguang" <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Mon, Aug 15, 2022 at 8:31 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Mon, Aug 15, 2022 at 06:46:46AM -0700, Yosry Ahmed wrote:
> > Yeah I understand this much, what I don't understand is why we charge
> > the zswap memory through objcg (thus tying it to memcg kmem charging)
> > rather than directly through memcg.
>
> The charged quantities are smaller than a page, so we have to use the
> byte interface.
>
> The byte interface (objcg) was written for slab originally, hence the
> link to the kmem option. But note that CONFIG_MEMCG_KMEM is no longer
> a user-visible option, and for all intents and purposes a fixed part
> of CONFIG_MEMCG.
>
> (There is the SLOB quirk. But I'm not sure anybody uses slob, let
> alone slob + memcg.)

Thanks for the clarification, it makes sense to use the byte interface
here for this, and thanks for pointing out that CONFIC_MEMCG_KMEM is
not part of CONFIG_MEMCG.

One more question :) memcg kmem charging can still be disabled even
with !CONFIG_MEMCG_KMEM, right? In this case zswap charging will also
be off, which seems like an unintended side effect, right?
