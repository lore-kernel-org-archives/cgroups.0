From: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: remove definition of MEM_CGROUP_ID_MAX when
 !CONFIG_MEMCG
Date: Fri, 7 Jul 2023 10:25:35 +0800
Message-ID: <52C942A9-29F7-473F-8674-6CB584F009BA@linux.dev>
References: <20230706112820.2393447-1-linmiaohe@huawei.com>
 <892B507C-CFE8-4792-BA5F-3C698290A8EE@linux.dev>
 <61ce2910-f3de-cfb7-bdd3-546ade0cb6f3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688696770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0xRLT9ea/2ScZsoJKQA4zG+jZgoWMbP6gLAC+IguOQ8=;
        b=Wf36/tDV+B1vbKdnbBZ3K4lf3PqmVLFmdnV05SyMbbAZQ3rrHLS+oJeEwM9jfj8Us3Bqd2
        T9CB2agUUHRxpTTZBp1RhpB7BrW2H3eVlV/A0mG6izsBCPlunuGuLqRy0aYbExsdC5ELeQ
        VxY2I2256KXI+KJem9mlrCol+BHn8hA=
In-Reply-To: <61ce2910-f3de-cfb7-bdd3-546ade0cb6f3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>



> On Jul 7, 2023, at 10:06, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>=20
> On 2023/7/7 9:47, Muchun Song wrote:
>>=20
>>=20
>>> On Jul 6, 2023, at 19:28, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>>=20
>>> MEM_CGROUP_ID_MAX is only used when CONFIG_MEMCG is configured. =
Remove
>>> unneeded !CONFIG_MEMCG variant.
>>>=20
>>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>=20
>> MEM_CGROUP_ID_MAX is also only used in mem_cgroup_alloc(), maybe you =
also
>> could move it from memcontrol.h to memcontrol.c. And define it as:
>>=20
>> #define MEM_CGROUP_ID_MAX ((1U << MEM_CGROUP_ID_SHIFT) - 1)
>>=20
>> I am not suggesting defining it as USHRT_MAX, because if someone =
changes
>> MEM_CGROUP_ID_SHIFT in the future, then MEM_CGROUP_ID_MAX will not =
updated
>> accordingly.
>=20
> Looks sensible to me. Do you suggest squashing above changes into the =
current patch
> or a separate patch is preferred?

I think it's better to squash.

>=20
>>=20
>> For this patch, LGTM.
>>=20
>> Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>=20
> Thanks for review and suggestion.
>=20
>=20
>=20

