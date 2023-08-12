From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Fri, 11 Aug 2023 19:48:14 -0700
Message-ID: <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com>
References: <20230809045810.1659356-1-yosryahmed@google.com>
 <ZNNTgZVPZipTL/UM@dhcp22.suse.cz> <CAJD7tkYhxbd2e+4HMZVKUfD4cx6oDauna3vLmttNPLCmFNtpgA@mail.gmail.com>
 <ZNONgeoytpkchHga@dhcp22.suse.cz> <CAJD7tkb9C77UUxAykw_uMQvkzGyaZOZhM0nwWn_kcPjV0umyuA@mail.gmail.com>
 <ZNOVS0Smp2PHUIuq@dhcp22.suse.cz> <CAJD7tkZFxbjas=VfhYSGU84Y5vyjuqHqGsRjiDEOSDWh2BxNAg@mail.gmail.com>
 <ZNYnx9NqwSsXKhX3@dhcp22.suse.cz> <CAJD7tkbJ1fnMDudtsS2xubKn0RTWz7t0Hem=PSRQQp3sGf-iOw@mail.gmail.com>
 <ZNaLGVUtPu7Ua/jL@dhcp22.suse.cz> <CAJD7tkbF1tNi8v0W4Mnqs0rzpRBshOFepxFTa1SiSvmBEBUEvw@mail.gmail.com>
 <CALvZod55S3XeK-MquTq0mDuipq8j0vFymQeX_XnPb_HuPK+oGQ@mail.gmail.com>
 <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com> <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691808506; x=1692413306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cxwplmLw+2JXkb5WdLZaW6GfeS9OxDdNZrnocn749ls=;
        b=PZ2MuncHZhfjcO+ZSWYBG7AjpER7iFNiyG2mAvkgdjnqDE404SW+LGIzxTRFgtG/rA
         Ze5AjzQ1Yy6pxjuG/liV8H0vsgWl6cL4Vuty19T8nqFCdlUudHH28vjS+kc8KHSgVRzF
         S/wsfc2ATtlf3lbb8xR8qx4UFCXH+nyFivMwVpobvy+pJO9hGHi7NKsPgm9yoPhoW+g5
         9ouYTGgP7V2H029wqXksIxTE8AoVWslw/7k9FdxPXjL7r9PBR87wzLF5hmNVuNueBkGL
         sq5YgWODSp05WxdnyzZ//RBLnSX+oNz2TaLLW5HKNsZ/qSosxxAeF3oSbrg8sY2jeIg+
         eRLA==
In-Reply-To: <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Aug 11, 2023 at 7:36=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>=
 wrote:
>
> On Fri, Aug 11, 2023 at 7:29=E2=80=AFPM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
> >
> > On Fri, Aug 11, 2023 at 7:12=E2=80=AFPM Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > >
> > [...]
> > >
> > > I am worried that writing to a stat for flushing then reading will
> > > increase the staleness window which we are trying to reduce here.
> > > Would it be acceptable to add a separate interface to explicitly read
> > > flushed stats without having to write first? If the distinction
> > > disappears in the future we can just short-circuit both interfaces.
> >
> > What is the acceptable staleness time window for your case? It is hard
> > to imagine that a write+read will always be worse than just a read.
> > Even the proposed patch can have an unintended and larger than
> > expected staleness window due to some processing on
> > return-to-userspace or some scheduling delay.
>
> Maybe I am worrying too much, we can just go for writing to
> memory.stat for explicit stats refresh.
>
> Do we still want to go with the mutex approach Michal suggested for
> do_flush_stats() to support either waiting for ongoing flushes
> (mutex_lock) or skipping (mutex_trylock)?

I would say keep that as a separate patch.
