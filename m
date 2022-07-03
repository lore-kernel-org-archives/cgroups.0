From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: do not miss MEMCG_MAX events for
 enforced allocations
Date: Sun, 3 Jul 2022 15:50:59 -0700
Message-ID: <YsIdU0xJeQWR2DwL@castle>
References: <20220702033521.64630-1-roman.gushchin@linux.dev>
 <CALvZod7TGhWtcRD6HeEx90T2+Rod-yamq9i+WbEQUKwNFTi-1A@mail.gmail.com>
 <YsBmoqEBCa7ra7w2@castle>
 <CALvZod6zCHKyjd8Ewr02xcHRWrxR_82my6mmTgsRp3HceqsBcg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656888664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x1aMEnERkcYXRuDziS0Zc8C87mC49RuzSVJcPFqy0W4=;
        b=NdeXq3Q0aH+DxBKSCS1GbadzG/ojBzsDFkJu1dEehs/A4VIcHKeDcfyrAAnIt+xW787Q2Y
        llJrgKxTG0lCaWhR1V20IxPimKLEoF19Q8mA27pxNl262HKIDQydxfIJM2PNiE+uDGrGfC
        m9H4YfvK0CIGGgqwrCL8m/lvsv4A7zw=
Content-Disposition: inline
In-Reply-To: <CALvZod6zCHKyjd8Ewr02xcHRWrxR_82my6mmTgsRp3HceqsBcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, Jul 02, 2022 at 10:36:28PM -0700, Shakeel Butt wrote:
> On Sat, Jul 2, 2022 at 8:39 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> >
> > On Fri, Jul 01, 2022 at 10:50:40PM -0700, Shakeel Butt wrote:
> > > On Fri, Jul 1, 2022 at 8:35 PM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> > > >
> > > > Yafang Shao reported an issue related to the accounting of bpf
> > > > memory: if a bpf map is charged indirectly for memory consumed
> > > > from an interrupt context and allocations are enforced, MEMCG_MAX
> > > > events are not raised.
> > > >
> > > > It's not/less of an issue in a generic case because consequent
> > > > allocations from a process context will trigger the reclaim and
> > > > MEMCG_MAX events. However a bpf map can belong to a dying/abandoned
> > > > memory cgroup, so it might never happen.
> > >
> > > The patch looks good but the above sentence is confusing. What might
> > > never happen? Reclaim or MAX event on dying memcg?
> >
> > Direct reclaim and MAX events. I agree it might be not clear without
> > looking into the code. How about something like this?
> >
> > "It's not/less of an issue in a generic case because consequent
> > allocations from a process context will trigger the direct reclaim
> > and MEMCG_MAX events will be raised. However a bpf map can belong
> > to a dying/abandoned memory cgroup, so there will be no allocations
> > from a process context and no MEMCG_MAX events will be triggered."
> >
> 
> SGTM and you can add:
> 
> Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thank you!
