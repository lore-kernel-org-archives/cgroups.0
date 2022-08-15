From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: correctly charge compressed memory to its memcg
Date: Mon, 15 Aug 2022 11:31:41 -0400
Message-ID: <Yvpm3cubIRAqUUJn@cmpxchg.org>
References: <20220811081913.102770-1-liliguang@baidu.com>
 <YvWa9MOQWBICInjO@P9FQF9L96D.corp.robot.car>
 <CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg@mail.gmail.com>
 <CAJD7tkbrCNDMkE8dJDWHiTfi=nJJzrZwepaWb3YioRHMrSEuQA@mail.gmail.com>
 <1704B09B-F758-47DF-BDDE-FEA9AB227E12@baidu.com>
 <CAJD7tkaW7qtaNpc3UHuQAcJAjdjzjmWZCqCMafT-nUES+2QtYg@mail.gmail.com>
 <E0E6FD3B-242B-4187-B4B4-9D4496A5B19A@baidu.com>
 <CAJD7tkYdJrakJGp8XMt49ixZJuf=qpGm=vSxH6G_GWeenk35dQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=kjUsObjVqN3I7az1Kd4dUP6iOhCJ8WK+mdTv5P8AJTs=;
        b=5n/GrNy90njXPlXWQ0a//HP28qQhjYUJxn2CFByPOJoPlz69BGXOZuwsZ57nudHS/R
         vhRQGQw3CC3uHiMNAXJd1MZaUOrEvy1ao4QxZBeUJdDndotInc7d5xoBJyXvy0bQRFtE
         1jGG6iWk9zcJFlQ2wi3uRuVbIGZYDAGksif1hgos5Y9EmfW9NSXSdoALeyofn6nqitMu
         Hb/7E/Pr58V2/Rw5XwylbtyMBCElScJ8X8A9cBwaXjsf79rl4bMyZDFzAd9AS5o88bEw
         Dyx/B+A0zVWp7p0Xtc6ZxxP3t9Z/zXIsFVablL5iCvmSC6voJlbj48Q4+f7TKV0slZwD
         eX3A==
Content-Disposition: inline
In-Reply-To: <CAJD7tkYdJrakJGp8XMt49ixZJuf=qpGm=vSxH6G_GWeenk35dQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Li,Liguang" <liliguang-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Mon, Aug 15, 2022 at 06:46:46AM -0700, Yosry Ahmed wrote:
> Yeah I understand this much, what I don't understand is why we charge
> the zswap memory through objcg (thus tying it to memcg kmem charging)
> rather than directly through memcg.

The charged quantities are smaller than a page, so we have to use the
byte interface.

The byte interface (objcg) was written for slab originally, hence the
link to the kmem option. But note that CONFIG_MEMCG_KMEM is no longer
a user-visible option, and for all intents and purposes a fixed part
of CONFIG_MEMCG.

(There is the SLOB quirk. But I'm not sure anybody uses slob, let
alone slob + memcg.)
