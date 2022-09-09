From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] memcg: extract memcg_vmstats from struct mem_cgroup
Date: Fri, 9 Sep 2022 09:11:48 -0700
Message-ID: <CALvZod77qUb0XRJh3y3-GQevoKjcwdt-Gtq0u0Tp6zTxBe-4CA@mail.gmail.com>
References: <20220907043537.3457014-1-shakeelb@google.com> <20220907043537.3457014-2-shakeelb@google.com>
 <YxqIQOWzrsrPnff3@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=eDrfYVwDQC+B+QpEvQ41UIS7OrQEnld5CNSxZdpZPgA=;
        b=F0wkqBGJL1xYRFxmN2T75z4AIhNt1UbmivRoZwZ3KboiF5oDQtO7ium3Kzq9dCV+3L
         RP2ICzUpgzxqrq8hUXPMY0eGLmRwA+zAdDYSuZh9GUeWrGuwZqUh08H8pA77P9iEsPGp
         b6pnj6Rb9wFZ+c+JdoNtMdcrNCB7NeeWChdxumtbo3jnTMvn/m+9Yh9o+8/jqU14NYlo
         Uq/uY6XTV/gnfIa8IZ92OH+bqS6ePdD+EGQoRQq+nYue9IGW4Px3jClughrHNWAxX7uT
         XPnuvp8oyCH45KSg9104v6Oi+FYeivUUTm11neuKW+KDrm0old9h/hl2dytqCvmymdak
         rzBw==
In-Reply-To: <YxqIQOWzrsrPnff3@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 8, 2022 at 5:26 PM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote:
>
> Hi.
>
> On Wed, Sep 07, 2022 at 04:35:35AM +0000, Shakeel Butt <shakeelb@google.c=
om> wrote:
> > This is a preparatory patch to reduce the memory overhead of memory
> > cgroup. The struct memcg_vmstats is the largest object embedded into th=
e
> > struct mem_cgroup.
> > This patch extracts struct memcg_vmstats from struct
> > mem_cgroup to ease the following patches in reducing the size of struct
> > memcg_vmstats.
>
> Is the reason for the extraction just moving things away from the header
> file?
> Or is the separate allocation+indirection somehow beneficial wrt, e.g.
> fragmentation?
>

The main reason was to move away from the head file. I have not yet
measured the performance impact of these changes. I am planning to
rearrange struct mem_cgroup and will do some performance tests after
that.
