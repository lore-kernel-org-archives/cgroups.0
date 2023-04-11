From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm-unstable RFC 3/5] memcg: calculate root usage from
 global state
Date: Tue, 11 Apr 2023 09:59:35 -0700
Message-ID: <CAJD7tkZvRek3hJ1AyC7rPjTJTkKCM0DNLaTu1XXLGKmc3gdztA@mail.gmail.com>
References: <20230403220337.443510-1-yosryahmed@google.com>
 <20230403220337.443510-4-yosryahmed@google.com> <rdjvbr5zuwic27s27xcmguce2wfbqiyeu4bjr5pfxhprlxecui@4wsoogvb4ivp>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681232412; x=1683824412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3nf45VfTna2qtmHbcyQx3azMJIZK67P9z9b6hMPmWY=;
        b=ygamK3A3NM1JD2kKgXRiue98TQPKvYM28SIh/wf7BXymkX7onuXLJL3zdwCTUe/eVe
         SIrwlFECWwZJJri9YnaDb7qj+p3Fx8mztu1CVpQMc/XKpJLJlWPcEMyzHAaCZxvxJUip
         7FrcmhZzUhSkqU/9ce+HuOqM+20Y6naugqTmb3UDLmOMbosxkWeNqwmpF/mr+icSJFEA
         DkfsjBlrrbGUYgnxglGGrWrB3iI0El6Hk8tD6oRP64tYwrP2NsbfZPf5khW44kuDdufB
         HB1CpOLX1xMCVefNbt6lQkTWz8mUP82sqHSntwR7puMl5Pt+e551R9IduCfw125lUGRr
         smYA==
In-Reply-To: <rdjvbr5zuwic27s27xcmguce2wfbqiyeu4bjr5pfxhprlxecui@4wsoogvb4ivp>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Apr 11, 2023 at 5:53=E2=80=AFAM Michal Koutn=C3=BD <mkoutny-WDPRK7U/wSs@public.gmane.org=
m> wrote:
>
> On Mon, Apr 03, 2023 at 10:03:35PM +0000, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > Instead, approximate the root usage from global state. This is not 100%
> > accurate, but the root usage has always been ill-defined anyway.
>
> Technically, this approximation should be closer to truth because global
> counters aren't subject to flushing "delay".

It is a tiny bit different when some pages are in swap, probably
because of swap slot caching and other swap specifics. At least in
cgroup v1, the swap uncharging and freeing of the underlying swap
entry may happen at different times. I think it practically doesn't
really matter though.

>
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 24 +++++-------------------
> >  1 file changed, 5 insertions(+), 19 deletions(-)
>
> But feel free to add
> Reviewed-by: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>

Thanks!
>
