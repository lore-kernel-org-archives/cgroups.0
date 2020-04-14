From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v8 03/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 14 Apr 2020 16:19:01 +0800
Message-ID: <42d5c2cb-3019-993f-eba7-33a1d69ef699@linux.alibaba.com>
References: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
 <1579143909-156105-4-git-send-email-alex.shi@linux.alibaba.com>
 <20200116215222.GA64230@cmpxchg.org>
 <cdcdb710-1d78-6fac-48d7-35519ddcdc6a@linux.alibaba.com>
 <20200413180725.GA99267@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200413180725.GA99267-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aneesh Ku



=D4=DA 2020/4/14 =C9=CF=CE=E72:07, Johannes Weiner =D0=B4=B5=C0:
> But isolation actually needs to lock out charging, or it would operate
> on the wrong list:
>=20
> isolation:                                     commit_charge:
> if (TestClearPageLRU(page))
>                                                page->mem_cgroup =3D new
>   // page is still physically on
>   // the root_mem_cgroup's LRU. We're
>   // updating the wrong list:
>   memcg =3D page->mem_cgroup
>   spin_lock(memcg->lru_lock)
>   del_page_from_lru_list(page, memcg)
>   spin_unlock(memcg->lru_lock)
>=20
> lrucare really is a mess. Even before this patch series, it makes
> things tricky and subtle and error prone.
>=20
> The only reason we're doing it is for when there is swapping without
> swap tracking, in which case swap reahadead needs to put pages on the
> LRU but cannot charge them until we have a faulting vma later.
>=20
> But it's not clear how practical such a configuration is. Both memory
> and swap are shared resources, and isolation isn't really effective
> when you restrict access to memory but then let workloads swap freely.
>=20
> Plus, the overhead of tracking is tiny - 512k per G of swap (0.04%).
>=20
> Maybe we should just delete MEMCG_SWAP and unconditionally track swap
> entry ownership when the memory controller is enabled. I don't see a
> good reason not to, and it would simplify the entire swapin path, the
> LRU locking, and the page->mem_cgroup stabilization rules.

Hi Johannes,

I think what you mean here is to keep swap_cgroup id even it was swaped,
then we read back the page from swap disk, we don't need to charge it.
So all other memcg charge are just happens on non lru list, thus we have
no isolation required in above awkward scenario.

That sounds a good idea. so, split_huge_page and mem_cgroup_migrate should
be safe, tasks cgroup migration may needs extra from_vec->lru_lock. Is that
right?

That's a good idea. I'm glad to have a try...

BTW,
As to the memcg swapped page mixed in swap disk timely. Maybe we could try
Tim Chen's swap_slot for memcg. What's your idea?

Thanks
Alex
