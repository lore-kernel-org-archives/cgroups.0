From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Fri, 11 Aug 2023 19:08:19 -0700
Message-ID: <CALvZod55S3XeK-MquTq0mDuipq8j0vFymQeX_XnPb_HuPK+oGQ@mail.gmail.com>
References: <20230809045810.1659356-1-yosryahmed@google.com>
 <ZNNTgZVPZipTL/UM@dhcp22.suse.cz> <CAJD7tkYhxbd2e+4HMZVKUfD4cx6oDauna3vLmttNPLCmFNtpgA@mail.gmail.com>
 <ZNONgeoytpkchHga@dhcp22.suse.cz> <CAJD7tkb9C77UUxAykw_uMQvkzGyaZOZhM0nwWn_kcPjV0umyuA@mail.gmail.com>
 <ZNOVS0Smp2PHUIuq@dhcp22.suse.cz> <CAJD7tkZFxbjas=VfhYSGU84Y5vyjuqHqGsRjiDEOSDWh2BxNAg@mail.gmail.com>
 <ZNYnx9NqwSsXKhX3@dhcp22.suse.cz> <CAJD7tkbJ1fnMDudtsS2xubKn0RTWz7t0Hem=PSRQQp3sGf-iOw@mail.gmail.com>
 <ZNaLGVUtPu7Ua/jL@dhcp22.suse.cz> <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691806112; x=1692410912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=prshbHi/RKP0L2cqyUY4iqu/u7CuqG4ghac599t9a+c=;
        b=ReRx55kHOx8AyhNaCNICBO3aB+8MDPDoP1bHhZkVlrgxynlOIcCOUhQLwCn8BDNYw3
         0Of4nqaCvFFX3F9rwMrq/poL70+DBi+ykgx6RuCSdq3EjKthBBGVHNqfNjwWYSiv+1Tm
         qM/zSvWaQg+U7H6Ln56hYIedt/nmux/3RJNo1V3dI2YA7SqezrOIdhIRDftNhBjkSSZ4
         UqwMWgmQVLAuevHN83O6259kWMIvzy5lvJqosQDVH3JxJ/rEPkCzbwCaPV47rX/TTX97
         glAcCit60db6/4eMR1hdiWSeq05x2fPt9Hg4Y46oEShGuTdMYhUeSHcV4dpLtBd+aeiB
         IgFg==
In-Reply-To: <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

(sorry for late response as I was away)

On Fri, Aug 11, 2023 at 1:40=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
[...]
> > > >
> > > > Last note, for /proc/vmstat we have /proc/sys/vm/stat_refresh to tr=
igger
> > > > an explicit refresh. For those users who really need more accurate
> > > > numbers we might consider interface like that. Or allow to write to=
 stat
> > > > file and do that in the write handler.
> > >
> > > This wouldn't be my first option, but if that's the only way to get
> > > accurate stats I'll take it.
> >
> > To be honest, this would be my preferable option because of 2 reasons.
> > a) we do not want to guarantee to much on the precision front because
> > that would just makes maintainability much more harder with different
> > people having a different opinion of how much precision is enough and b=
)
> > it makes the more rare (need precise) case the special case rather than
> > the default.
>
> How about we go with the proposed approach in this patch (or the mutex
> approach as it's much cleaner), and if someone complains about slow
> reads we revert the change and introduce the refresh API? We might
> just get away with making all reads accurate and avoid the hassle of
> updating some userspace readers to do write-then-read. We don't know
> for sure that something will regress.
>
> What do you think?

Actually I am with Michal on this one. As I see multiple regression
reports for reading the stats, I am inclined towards rate limiting the
sync stats flushing from user readable interfaces (through
mem_cgroup_flush_stats_ratelimited()) and providing a separate
interface as suggested by Michal to explicitly flush the stats for
users ok with the cost. Since we flush the stats every 2 seconds, most
of the users should be fine and the users who care about accuracy can
pay for it.
