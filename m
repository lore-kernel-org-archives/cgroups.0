From: Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 02/16] memcg: enable accounting for IP address and
 routing-related objects
Date: Mon, 19 Jul 2021 15:00:42 +0100
Message-ID: <CAJwJo6ZgXDoXevNRte4G3Phei8WcgJ897JebWDkQDnPYrgTTQA@mail.gmail.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com> <9123bca3-23bb-1361-c48f-e468c81ad4f6@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WeegeVqvWY1KsOnYeA94i2R1jRKeSi2HU6pzHBia1vY=;
        b=So99eQ/gs1bn8C1NzBd8SPabyD4ZCKj3ZajS/lP0G4X4PpwXq39wRThJmMCu9a+6Up
         GKJdpcsT+LY9o2KBAc+/H30NVGNArKhSoWo0d5qoz2vmT5Qelk8eergP0GB7D3EmvZ2U
         SvO3ztIngEaoxdwriaY1qw+ILp/B6AYjsnKUBt66uwCgU5qK4SN0HQOmP20LiW+Jqem8
         H7Q6iFB2v9nDRTZC7KE3TEkkFPrulSWNiQ04SgV5a0iSlS3bJnP9FmjmM0Yf/090SIVM
         OzPAk3kwLZvY4XiJJ2taT4PB9Ki/UHqXUOmbZZ7eHVGXKxUX8LanghwlZ0u2DrH/9hfH
         LCSw==
In-Reply-To: <9123bca3-23bb-1361-c48f-e468c81ad4f6-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Vasily,

On Mon, 19 Jul 2021 at 11:45, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
[..]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ae1f5d0..1bbf239 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -968,7 +968,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>                 return false;
>
>         /* Memcg to charge can't be determined. */
> -       if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
> +       if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
>                 return true;

This seems to do two separate things in one patch.
Probably, it's better to separate them.
(I may miss how route changes are related to more generic
__alloc_pages() change)

Thanks,
           Dmitry
