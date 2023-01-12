From: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] mm: multi-gen LRU: working set extensions
Date: Wed, 11 Jan 2023 17:38:37 -0800
Message-ID: <CAJj2-QHxcC3u49Boh7t0Z2tZfhrg_W5uLqBcMDYmukJra8D22Q@mail.gmail.com>
References: <20221214225123.2770216-1-yuanchu@google.com> <20230111141716.GA14685@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AvPtEwtZM9M8vhjcnDBhdGXaa7R7IpCHINyiVw91Tqw=;
        b=ew490uHSuUDb6IZiNj7J2omgVWofPd8fWgOYael7TpZBTXDtsHSAd1MktEsOv9faYX
         dk/AonZsRunyMpaJLLzXaM8J0rTiwnXf8VG29KNWe62a/gal2kTOWFjr0sequymp1DCY
         deryNvmfVbw3MfE8u6IwwSbV2nln5PFQpFtFcpyOWSMd9CXS/AKtS1p1YOGlfMpw79jP
         l5NkVrrTWEoDSakAg1zFF/4YwIyh4Rbq1+qoZZdl/j2jVgBkjX4nVsmfV9VLo3uChPQg
         JBL++ZZpMvU46kwYRyxClLlCAHYkOfjPCY0EBI0/s73cr3oKqru9ihboYjhKi2PyyHda
         So2Q==
In-Reply-To: <20230111141716.GA14685-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 11, 2023 at 6:17 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> On Wed, Dec 14, 2022 at 02:51:21PM -0800, Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
> wrote:
> > that's frequently used. The only missing pieces between MGLRU
> > generations and working set estimation are a consistent aging cadence
> > and an interface; we introduce the two additions.
> >
> > Periodic aging
> > =3D=3D=3D=3D=3D=3D
> > MGLRU Aging is currently driven by reclaim, so the amount of time
> > between generations is non-deterministic. With memcgs being aged
> > regularly, MGLRU generations become time-based working set information.
>
> Is this periodic aging specific to memcgs? IOW, periodic aging isn't
> needed without memcgs (~with root only)
> (Perhaps similar question to Aneeh's.)
Originally, I didn't see much value in periodic aging without memcgs,
as the main goal was to provide working set information.
Periodic aging might lead to MGLRU making better reclaim decisions,
but I don't have any benchmarks to back it up right now.

>
> > Use case: proactive reclaimer
> > =3D=3D=3D=3D=3D=3D
> > The proactive reclaimer sets the aging interval, and periodically reads
> > the page idle age stats, forming a working set estimation, which it the=
n
> > calculates an amount to write to memory.reclaim.
> >
> > With the page idle age stats, a proactive reclaimer could calculate a
> > precise amount of memory to reclaim without continuously probing and
> > inducing reclaim.
>
> Could the aging be also made per-memcg? (Similar to memory.reclaim,
> possibly without the new kthread (if global reclaim's aging is enough).)
It is possible. We can have hierarchical aging, invoked by writing to
memory.aging with a time duration. For every child memcg, if its young
generation is older than (current time - specified duration), do
aging.
However, now we need a userspace tool to drive the aging, invoking
this interface every few seconds, since every memcg is aged at a
different cadence.
Having a kthread perform aging has the benefit of simplicity, gives a
source of truth for the aging interval, and makes the feature more
accessible. The application developers, if they want to take a look at
the page idle age stats, could do so without needing additional
ceremony.

Thanks,
Yuanchu
