From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM/BPF TOPIC] Reducing zombie memcgs
Date: Tue, 11 Apr 2023 16:48:12 -0700
Message-ID: <CAJD7tkZw9uVPe5KH2xrihsv5nDmExJmkmsUPYP6Npvv6Q0NcVw@mail.gmail.com>
References: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681256929; x=1683848929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xoyQVeaFsgpeGhfzOdZSPoa4a8w+FT9SRbAgSywf7sc=;
        b=qDjRrSVe7rsc75FviosB6qBZZ8fCZ27cRjYKQggjvqCGoWu4bJAUH/sIetxt+jzJmA
         C9SIxTBxB4l4i/l8YBaF/G4nsjyQj4fLt+nst3hlwnb76omBpv+cgdFVmcsgGIPpzEe8
         kPANJ5G/LZzwI2nbaWbd5sCf7GJX4TkHJKdcoey1qCE3RRRT3fG+f++YWyLHngRa6OA0
         GGOzSZDP0zNup7QsE8n2/iT33pRTx7h89PnzZyF5K/DNwnlY3syA43611ydty5JEeTYe
         lIkyLa9naq08kcgIbNf0WqfSC50meamQ5Veq+kczO7cHl5BDnXd2a4kHWujmddiHMSeT
         HVLw==
In-Reply-To: <CABdmKX2M6koq4Q0Cmp_-=wbP0Qa190HdEGGaHfxNS05gAkUtPA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 11, 2023 at 4:36=E2=80=AFPM T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
> When a memcg is removed by userspace it gets offlined by the kernel.
> Offline memcgs are hidden from user space, but they still live in the
> kernel until their reference count drops to 0. New allocations cannot
> be charged to offline memcgs, but existing allocations charged to
> offline memcgs remain charged, and hold a reference to the memcg.
>
> As such, an offline memcg can remain in the kernel indefinitely,
> becoming a zombie memcg. The accumulation of a large number of zombie
> memcgs lead to increased system overhead (mainly percpu data in struct
> mem_cgroup). It also causes some kernel operations that scale with the
> number of memcgs to become less efficient (e.g. reclaim).
>
> There are currently out-of-tree solutions which attempt to
> periodically clean up zombie memcgs by reclaiming from them. However
> that is not effective for non-reclaimable memory, which it would be
> better to reparent or recharge to an online cgroup. There are also
> proposed changes that would benefit from recharging for shared
> resources like pinned pages, or DMA buffer pages.

I am very interested in attending this discussion, it's something that
I have been actively looking into -- specifically recharging pages of
offlined memcgs.

>
> Suggested attendees:
> Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
