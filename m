From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/8] memcg: accounting for fib6_nodes cache
Date: Mon, 15 Mar 2021 12:35:16 -0700
Message-ID: <20210315123516.6264ba0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
        <85b5f428-294b-af57-f496-5be5fddeeeea@virtuozzo.com>
        <20210315100942.3cc98bb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALvZod4ct6X_M1fzKufX1jKoO2JEE_ONwEmiDWTbpt-fut85yA@mail.gmail.com>
        <YE+2N0zb9wKTriDH@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615836917;
        bh=WTbVaWsn2s6L40UENjvSIP12aHJ+ixP4fEvzAyMwqdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V9U3lx/SRExGNl7ANONDuDDsz1cwP6og9RBlgLxmJt4k6lsk1KW4zl7F7oRpdv2nI
         1lCuP+7sRGjGRZ1gh1PMqr+vBmkB1hVIS0vinUPxFxHHMG4m3Pqyo7xXdsp1GbConZ
         20Jx7Xmza4070aeJBRf+7t6pE0A4G7/1szsLQPfbQeDtIziTdk9WJvsAGx4BlCRViu
         SZeUccNGREYMqlurXWLft5HmfWpoDq6LJL0xay+tWxTqEWaHQ0Iv20WitZOf4fJ+6k
         1onK0XWAcycey/B3fS9UfoxB7glddVb7fmYZLbIt0hv7HHBQ7nLA6YJVGjVaD+i0EC
         OXgVmxXknEk8Q==
In-Reply-To: <YE+2N0zb9wKTriDH-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, 15 Mar 2021 12:32:07 -0700 Roman Gushchin wrote:
> On Mon, Mar 15, 2021 at 12:24:31PM -0700, Shakeel Butt wrote:
> > On Mon, Mar 15, 2021 at 10:09 AM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:  
> > > Sorry for a random question, I didn't get the cover letter.
> > >
> > > What's the overhead of adding SLAB_ACCOUNT?
> > 
> > The potential overhead is for MEMCG users where we need to
> > charge/account each allocation from SLAB_ACCOUNT kmem caches. However
> > charging is done in batches, so the cost is amortized. If there is a
> > concern about a specific workload then it would be good to see the
> > impact of this patch for that workload.
> >   
> > > Please make sure you CC netdev on series which may impact networking.  
> 
> In general the overhead is not that big, so I don't think we should argue
> too much about every new case where we want to enable the accounting and
> rather focus on those few examples (if any?) where it actually hurts
> the performance in a meaningful way.

Ack, no serious concerns about this particular case.

I was expecting you'd have micro benchmark numbers handy so I was
curious to learn what they are, but that appears not to be the case.
