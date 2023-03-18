From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3, 0/4] mm, memcg: cgroup v1 and v2 tunable load/store
 tearing fixes
Date: Fri, 17 Mar 2023 17:58:26 -0700
Message-ID: <CALvZod4UjoYasn8Z4-e4NEdv9QRWiuJuJjm8+sH_xFdPTEWEoA@mail.gmail.com>
References: <20230308162555.14195-1-findns94@gmail.com> <ZAjIeTBKteZaYEEb@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679101117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjzUh8wvEqOhjDa9bqpHAUbvJHT68H6FHaSidqfbom8=;
        b=JVXYvxAJeUXHaKDbRodHwwtH7IQbXLRoiZr3q/I9SA2PCpkS1A7jED2SYMDkJTLBLv
         LBkOeMxmB5abOcyMXF5T1ALdKfk1bSw5BQEvIilpvJs77fL+HDTEDX9+gKH3RtDieSKP
         vbfLPrrOBKZOzx73nkbbXIjbsv8pRnYEwsIr+/yjETCCg+eYwK/QWp1+WAx+ALkV4MvY
         /VivS/YbrC2rsHalrhTI922KgXxyVaQsQu7kjf3zjmGU6o512Et9PEi0irT3IVbpQEcV
         Tu1TX0cyiKBZrpslrzTS6GopLi8jnKqRS6ssSqutjLuhZ4Hz7QuXjUdKltEvKgtRTueB
         NIow==
In-Reply-To: <ZAjIeTBKteZaYEEb-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Wed, Mar 8, 2023 at 9:40=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> On Thu 09-03-23 00:25:51, Yue Zhao wrote:
> > This patch series helps to prevent load/store tearing in
> > several cgroup knobs.
> >
> > As kindly pointed out by Michal Hocko, we should add
> > [WRITE|READ]_ONCE for all occurrences of memcg->oom_kill_disable,
> > memcg->swappiness and memcg->soft_limit.
> >
> > v3:
> > - Add [WRITE|READ]_ONCE for all occurrences of
> > memcg->oom_kill_disable, memcg->swappiness and memcg->soft_limit
> > v2:
> > - Rephrase changelog
> > - Add [WRITE|READ]_ONCE for memcg->oom_kill_disable,
> >  memcg->swappiness, vm_swappiness and memcg->soft_limit
> > v1:
> > - Add [WRITE|READ]_ONCE for memcg->oom_group
> >
> > Past patches:
> > V2: https://lore.kernel.org/linux-mm/20230306154138.3775-1-findns94@gma=
il.com/
> > V1: https://lore.kernel.org/linux-mm/20230220151638.1371-1-findns94@gma=
il.com/
> >
> > Yue Zhao (4):
> >   mm, memcg: Prevent memory.oom.group load/store tearing
> >   mm, memcg: Prevent memory.swappiness load/store tearing
> >   mm, memcg: Prevent memory.oom_control load/store tearing
> >   mm, memcg: Prevent memory.soft_limit_in_bytes load/store tearing
> >
> >  include/linux/swap.h |  8 ++++----
> >  mm/memcontrol.c      | 30 +++++++++++++++---------------
> >  2 files changed, 19 insertions(+), 19 deletions(-)
>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>
> Btw. you could have preserved acks for patches you haven't changed from
> the previous version.
>

For whole series:

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
