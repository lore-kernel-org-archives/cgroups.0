From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH 16/18] mm: memcontrol: charge swapin pages on
 instantiation
Date: Tue, 21 Apr 2020 17:21:26 +0800
Message-ID: <6f03ed4e-f917-2ccc-26c0-c438c84d3d97@linux.alibaba.com>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-17-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200420221126.341272-17-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org



=D4=DA 2020/4/21 =C9=CF=CE=E76:11, Johannes Weiner =D0=B4=B5=C0:
> Right now, users that are otherwise memory controlled can easily
> escape their containment and allocate significant amounts of memory
> that they're not being charged for. That's because swap readahead
> pages are not being charged until somebody actually faults them into
> their page table. This can be exploited with MADV_WILLNEED, which
> triggers arbitrary readahead allocations without charging the pages.
>=20
> There are additional problems with the delayed charging of swap pages:
>=20
> 1. To implement refault/workingset detection for anonymous pages, we
>    need to have a target LRU available at swapin time, but the LRU is
>    not determinable until the page has been charged.
>=20
> 2. To implement per-cgroup LRU locking, we need page->mem_cgroup to be
>    stable when the page is isolated from the LRU; otherwise, the locks
>    change under us. But swapcache gets charged after it's already on
>    the LRU, and even if we cannot isolate it ourselves (since charging
>    is not exactly optional).
>=20
> The previous patch ensured we always maintain cgroup ownership records
> for swap pages. This patch moves the swapcache charging point from the
> fault handler to swapin time to fix all of the above problems.
>=20
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gman=
e.org>

Reviewed-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gma=
ne.org>
