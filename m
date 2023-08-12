From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Fri, 11 Aug 2023 19:11:43 -0700
Message-ID: <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
References: <20230809045810.1659356-1-yosryahmed@google.com>
 <ZNNTgZVPZipTL/UM@dhcp22.suse.cz> <CAJD7tkYhxbd2e+4HMZVKUfD4cx6oDauna3vLmttNPLCmFNtpgA@mail.gmail.com>
 <ZNONgeoytpkchHga@dhcp22.suse.cz> <CAJD7tkb9C77UUxAykw_uMQvkzGyaZOZhM0nwWn_kcPjV0umyuA@mail.gmail.com>
 <ZNOVS0Smp2PHUIuq@dhcp22.suse.cz> <CAJD7tkZFxbjas=VfhYSGU84Y5vyjuqHqGsRjiDEOSDWh2BxNAg@mail.gmail.com>
 <ZNYnx9NqwSsXKhX3@dhcp22.suse.cz> <CAJD7tkbJ1fnMDudtsS2xubKn0RTWz7t0Hem=PSRQQp3sGf-iOw@mail.gmail.com>
 <ZNaLGVUtPu7Ua/jL@dhcp22.suse.cz> <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw@mail.gmail.com>
 <CALvZod55S3XeK-MquTq0mDuipq8j0vFymQeX_XnPb_HuPK+oGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691806340; x=1692411140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAmOXeQ0VHSXwwCpVm3J8YOQijq+7iGoLz/Vka2YTMk=;
        b=dL5mRwRgcxjtqEDoIfRVMPS7RQHFXTHE2dp81+2iSyKXxXmt4p7Hsdcs/WW6OzCHr8
         Y+xyvdJtwyK3FfdlwZaw/9Oa+tVjzhIK9ZpIYGIKTttzLEdfTgucXs5GlYa6o3PjHK4u
         kSBkUqpRxu+rx5jjYWx87+cxT1jssYONnzxfCbyWKZwB+wH+NnC+tBkidjKeFqT6RD5Z
         e7l2yuGfipD3XpnSOnDhKFMWcwXAehVpQ07p8xZ/bz0+NuI8JvWRtiEU3NapnlmZfpMP
         mJ2KxJGQLN6DjHjWVqh+mvYjfymau+k6k/smOk9HuULcU+wGkNjjR64SI5hB4UdvRJj/
         DzKw==
In-Reply-To: <CALvZod55S3XeK-MquTq0mDuipq8j0vFymQeX_XnPb_HuPK+oGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Aug 11, 2023 at 7:08=E2=80=AFPM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> Hi all,
>
> (sorry for late response as I was away)
>
> On Fri, Aug 11, 2023 at 1:40=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
> >
> [...]
> > > > >
> > > > > Last note, for /proc/vmstat we have /proc/sys/vm/stat_refresh to =
trigger
> > > > > an explicit refresh. For those users who really need more accurat=
e
> > > > > numbers we might consider interface like that. Or allow to write =
to stat
> > > > > file and do that in the write handler.
> > > >
> > > > This wouldn't be my first option, but if that's the only way to get
> > > > accurate stats I'll take it.
> > >
> > > To be honest, this would be my preferable option because of 2 reasons=
.
> > > a) we do not want to guarantee to much on the precision front because
> > > that would just makes maintainability much more harder with different
> > > people having a different opinion of how much precision is enough and=
 b)
> > > it makes the more rare (need precise) case the special case rather th=
an
> > > the default.
> >
> > How about we go with the proposed approach in this patch (or the mutex
> > approach as it's much cleaner), and if someone complains about slow
> > reads we revert the change and introduce the refresh API? We might
> > just get away with making all reads accurate and avoid the hassle of
> > updating some userspace readers to do write-then-read. We don't know
> > for sure that something will regress.
> >
> > What do you think?
>
> Actually I am with Michal on this one. As I see multiple regression
> reports for reading the stats, I am inclined towards rate limiting the
> sync stats flushing from user readable interfaces (through
> mem_cgroup_flush_stats_ratelimited()) and providing a separate
> interface as suggested by Michal to explicitly flush the stats for
> users ok with the cost. Since we flush the stats every 2 seconds, most
> of the users should be fine and the users who care about accuracy can
> pay for it.

I am worried that writing to a stat for flushing then reading will
increase the staleness window which we are trying to reduce here.
Would it be acceptable to add a separate interface to explicitly read
flushed stats without having to write first? If the distinction
disappears in the future we can just short-circuit both interfaces.
