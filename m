From: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix kernel-doc
Date: Tue, 25 May 2021 09:09:26 -0700
Message-ID: <CAHbLzkr1rUM7M5uv=LgCQtOngpwg-tUGMj9MUp7CkirDLMSwHw@mail.gmail.com>
References: <1621851862-34443-1-git-send-email-yang.lee@linux.alibaba.com> <YKy2o2WGRcD7vht8@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E6s3ZtPWtmcbcuCeFGZbGrPYTepr+v29FJOymW4C+CY=;
        b=TI96WuRxMj8Pb/NY0nygtA/+Bl5w6M+BxwVGoRPlVAqEaxjSm8XSyTA6izGFX12/Ul
         cswyq/6GOFnWHlaXm4bu6LPk+ZzqOPk5SiHTvUcpQuoxIAwlqwh1WddtcFBrJOe0RfyK
         /HLD3j1Ll/Zxl6eplQ+KPIWGpaeF9WD5jXehoNlTNCB40w5+BKhNYiih8iFIdIKtrtKv
         CTJIdfSIqH972mbqjwxz1Oeq4ZN3cQef5wSyjbxhHryWuwexoCXy1NUJ7qpkrTckbo6p
         xYy7uy2ul+TARuzDwtX+4jJLB+V/Wz/jZEuoSCcq714rDsQfvcQFU1miuWz7Wl+KuGfO
         1Thg==
In-Reply-To: <YKy2o2WGRcD7vht8-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, May 25, 2021 at 1:34 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 24-05-21 18:24:22, Yang Li wrote:
> > Fix function name in mm/memcontrol.c kernel-doc comment
> > to remove a warning.
> >
> > mm/memcontrol.c:6546: warning: expecting prototype for
> > mem_cgroup_protected(). Prototype was for
> > mem_cgroup_calculate_protection() instead.
> >
> > Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> > Signed-off-by: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

It seems this has been covered by Mel's W=1 warning cleanup series,
see https://lore.kernel.org/linux-mm/20210520084809.8576-7-mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org/.

>
> Thanks!
>
> > ---
> >  mm/memcontrol.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 64ada9e..030c1dc 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6456,7 +6456,7 @@ static unsigned long effective_protection(unsigned long usage,
> >  }
> >
> >  /**
> > - * mem_cgroup_protected - check if memory consumption is in the normal range
> > + * mem_cgroup_calculate_protection - check if memory consumption is in the normal range
> >   * @root: the top ancestor of the sub-tree being checked
> >   * @memcg: the memory cgroup to check
> >   *
> > --
> > 1.8.3.1
>
> --
> Michal Hocko
> SUSE Labs
>
