From: Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: memcg: performance degradation since v5.9
Date: Mon, 12 Apr 2021 11:22:10 -0400
Message-ID: <20210412152210.y5bizdfbn62sgeqg@gabell>
References: <20210408193948.vfktg3azh2wrt56t@gabell>
 <YG9tW1h9VSJcir+Y@carbon.dhcp.thefacebook.com>
 <CALvZod58NBQLvk2m7Mb=_0oGCApcNeisxVuE1b+qh1OKDSy0Ag@mail.gmail.com>
 <20210409163539.5374pde3u6gkbg4a@gabell>
 <CALvZod4uRU==p7Z0eP_xO49iA3ShFDHKzyWZbd7RdMso5PHsfA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ERqCI38M3BY/3SOC3pgh5AxFU4XWzgptnCfUipXNgug=;
        b=gYe5Up3OaU/+pnMLbIoo4fGw8EW/wVqIDfiJjiTGlAuevEjxM8fhcVcYjWLc0Hd4xP
         hA6vETqs5aigURkzuBOUUcrJ4MqW2iIZ5cg0KuyXY8cdfwDMzNf5JJD/gqlIeb9tz69t
         H243bX0LV289m2WtQZ/bQCHN7SztQEZBGdUaTI2tC9mBQleVY4txXKniVPtyH+OFYHXm
         ughPAw0w12CqzIGqmA21Axu1+8CSR2LvwYHJL81CVAbjVQY8aljszWj/80+/lOdtGUav
         b4tmg4wfnrQrNMktySbmYn6clgC6g+45rMuz+OqwSCpdRoCxHtc+G1Tu9EvbNDyffDjk
         241Q==
Content-Disposition: inline
In-Reply-To: <CALvZod4uRU==p7Z0eP_xO49iA3ShFDHKzyWZbd7RdMso5PHsfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, Apr 09, 2021 at 09:50:45AM -0700, Shakeel Butt wrote:
> On Fri, Apr 9, 2021 at 9:35 AM Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> [...]
> > > Can you please explain how to read these numbers? Or at least put a %
> > > regression.
> >
> > Let me summarize them here.
> > The total duration ('total' column above) of each system call is as follows
> > if v5.8 is assumed as 100%:
> >
> > - sendto:
> >   - v5.8         100%
> >   - v5.9         128%
> >   - v5.12-rc6    116%
> >
> > - revfrom:
> >   - v5.8         100%
> >   - v5.9         114%
> >   - v5.12-rc6    108%
> >
> 
> Thanks, that is helpful. Most probably the improvement of 5.12 from
> 5.9 is due to 3de7d4f25a7438f ("mm: memcg/slab: optimize objcg stock
> draining").
> 
> [...]
> > >
> > > One idea would be to increase MEMCG_CHARGE_BATCH.
> >
> > Thank you for the idea! It's hard-corded as 32 now, so I'm wondering it may be
> > a good idea to make MEMCG_CHARGE_BATCH tunable from a kernel parameter or something.
> >
> 
Hi!

Thank you for your comments!

> Can you rerun the benchmark with MEMCG_CHARGE_BATCH equal 64UL?

Yes, I reran the benchmark with MEMCG_CHARGE_BATCH == 64UL, but it seems that
it doesn't reduce the duration of system calls...

- v5.12-rc6 vanilla

   syscall      total  
               (msec) 
   --------- --------
   sendto    3049.221
   recvfrom  2421.601

- v5.12-rc6 with MEMCG_CHARGE_BATCH==64

   syscall      total  
               (msec) 
   --------- --------
   sendto    3071.607
   recvfrom  2436.488

> I think with memcg stats moving to rstat, the stat accuracy is not an
> issue if we increase MEMCG_CHARGE_BATCH to 64UL. Not sure if we want
> this to be tuneable but most probably we do want this to be sync'ed
> with SWAP_CLUSTER_MAX.

Thanks. I understand that. 
Waiman posted some patches to reduce the overhead [1]. I'll try the patch.

[1]: https://lore.kernel.org/linux-mm/51ea6b09-b7ee-36e9-a500-b7141bd3a42b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/T/#me75806a3555e7a42e793f099b98c42e687962d10

Thanks!
Masa
