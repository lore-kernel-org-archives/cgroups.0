From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Sat, 12 Aug 2023 10:35:55 +0200
Message-ID: <ZNdEaw2nktq1NfmH@dhcp22.suse.cz>
References: <CAJD7tkZFxbjas=VfhYSGU84Y5vyjuqHqGsRjiDEOSDWh2BxNAg@mail.gmail.com>
 <ZNYnx9NqwSsXKhX3@dhcp22.suse.cz>
 <CAJD7tkbJ1fnMDudtsS2xubKn0RTWz7t0Hem=PSRQQp3sGf-iOw@mail.gmail.com>
 <ZNaLGVUtPu7Ua/jL@dhcp22.suse.cz>
 <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw@mail.gmail.com>
 <CALvZod55S3XeK-MquTq0mDuipq8j0vFymQeX_XnPb_HuPK+oGQ@mail.gmail.com>
 <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
 <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
 <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1691829356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJlNOetLP1c9ycAs8A2815lzssMFUEbIER+s4cVzY7E=;
        b=Q1+SdD1ePlUyb5K2u8qRDaFYuWyq/npUtKZ0updc2Xp53oigEoqFdP8xFNrUnUqJzJ99d1
        0bPDafZq9D7cNg35IFIT7/x7xYHr66y8z9sErgoHA+2MUz+aJHu19MOl99fZq+uGhCbQFj
        nekk1FHEBzMfi59qcazL2CbPzmKrQY0=
Content-Disposition: inline
In-Reply-To: <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 11-08-23 19:48:14, Shakeel Butt wrote:
> On Fri, Aug 11, 2023 at 7:36 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Fri, Aug 11, 2023 at 7:29 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >
> > > On Fri, Aug 11, 2023 at 7:12 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > >
> > > [...]
> > > >
> > > > I am worried that writing to a stat for flushing then reading will
> > > > increase the staleness window which we are trying to reduce here.
> > > > Would it be acceptable to add a separate interface to explicitly read
> > > > flushed stats without having to write first? If the distinction
> > > > disappears in the future we can just short-circuit both interfaces.
> > >
> > > What is the acceptable staleness time window for your case? It is hard
> > > to imagine that a write+read will always be worse than just a read.
> > > Even the proposed patch can have an unintended and larger than
> > > expected staleness window due to some processing on
> > > return-to-userspace or some scheduling delay.
> >
> > Maybe I am worrying too much, we can just go for writing to
> > memory.stat for explicit stats refresh.
> >
> > Do we still want to go with the mutex approach Michal suggested for
> > do_flush_stats() to support either waiting for ongoing flushes
> > (mutex_lock) or skipping (mutex_trylock)?
> 
> I would say keep that as a separate patch.

Separate patches would be better but please make the mutex conversion
first. We really do not want to have any busy waiting depending on a
sleep exported to the userspace. That is just no-go.

Thanks!
-- 
Michal Hocko
SUSE Labs
