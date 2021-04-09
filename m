From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: memcg: performance degradation since v5.9
Date: Fri, 9 Apr 2021 09:50:45 -0700
Message-ID: <CALvZod4uRU==p7Z0eP_xO49iA3ShFDHKzyWZbd7RdMso5PHsfA@mail.gmail.com>
References: <20210408193948.vfktg3azh2wrt56t@gabell> <YG9tW1h9VSJcir+Y@carbon.dhcp.thefacebook.com>
 <CALvZod58NBQLvk2m7Mb=_0oGCApcNeisxVuE1b+qh1OKDSy0Ag@mail.gmail.com> <20210409163539.5374pde3u6gkbg4a@gabell>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ydAqvEvjbti1VLEzYDXfmB0v6HN/16FzgGH3F04ZLl4=;
        b=Ku8jowge8CGqLIX9rDeK1rUNeZs0BpzWI63PkuG58eTTRQjw9OWcAEd7foQc41esT1
         JmyKp9pirl+Zn2IN0o/8JQaF0/tJlnNFI88SSyoSlWXIeEeuHfIW/MrnDdwLPEronJD0
         SiNv9+FJ7Wb+3LtSufgntha5moXUanEotTltXSGODoLwX3MQUpaUFi+vLFQbD04H6oct
         vpsXFbiLU+IIC9KJh2Aa4hKSrd7BtPWtUg7ai9uBPrZHnNzNGsLIuggMW89tMxsPiJZK
         d/sWm0boTnhGVnPr8mLz+E6rm0gjgU+TBIDSly3YMB/BxZ/x6KQ316ZzzhPdCo6Rp2AB
         nTdA==
In-Reply-To: <20210409163539.5374pde3u6gkbg4a@gabell>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, Apr 9, 2021 at 9:35 AM Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
[...]
> > Can you please explain how to read these numbers? Or at least put a %
> > regression.
>
> Let me summarize them here.
> The total duration ('total' column above) of each system call is as follows
> if v5.8 is assumed as 100%:
>
> - sendto:
>   - v5.8         100%
>   - v5.9         128%
>   - v5.12-rc6    116%
>
> - revfrom:
>   - v5.8         100%
>   - v5.9         114%
>   - v5.12-rc6    108%
>

Thanks, that is helpful. Most probably the improvement of 5.12 from
5.9 is due to 3de7d4f25a7438f ("mm: memcg/slab: optimize objcg stock
draining").

[...]
> >
> > One idea would be to increase MEMCG_CHARGE_BATCH.
>
> Thank you for the idea! It's hard-corded as 32 now, so I'm wondering it may be
> a good idea to make MEMCG_CHARGE_BATCH tunable from a kernel parameter or something.
>

Can you rerun the benchmark with MEMCG_CHARGE_BATCH equal 64UL?

I think with memcg stats moving to rstat, the stat accuracy is not an
issue if we increase MEMCG_CHARGE_BATCH to 64UL. Not sure if we want
this to be tuneable but most probably we do want this to be sync'ed
with SWAP_CLUSTER_MAX.
