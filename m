From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH 05/18] mm: memcontrol: convert page cache to a new
 mem_cgroup_charge() API
Date: Tue, 21 Apr 2020 17:12:11 +0800
Message-ID: <e3d70030-a9ae-a679-9cf9-1cd5b680650e@linux.alibaba.com>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-6-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200420221126.341272-6-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org



=D4=DA 2020/4/21 =C9=CF=CE=E76:11, Johannes Weiner =D0=B4=B5=C0:
> The try/commit/cancel protocol that memcg uses dates back to when
> pages used to be uncharged upon removal from the page cache, and thus
> couldn't be committed before the insertion had succeeded. Nowadays,
> pages are uncharged when they are physically freed; it doesn't matter
> whether the insertion was successful or not. For the page cache, the
> transaction dance has become unnecessary.
>=20
> Introduce a mem_cgroup_charge() function that simply charges a newly
> allocated page to a cgroup and sets up page->mem_cgroup in one single
> step. If the insertion fails, the caller doesn't have to do anything
> but free/put the page.
>=20
> Then switch the page cache over to this new API.
>=20
> Subsequent patches will also convert anon pages, but it needs a bit
> more prep work. Right now, memcg depends on page->mapping being
> already set up at the time of charging, so that it can maintain its
> own MEMCG_CACHE and MEMCG_RSS counters. For anon, page->mapping is set
> under the same pte lock under which the page is publishd, so a single
> charge point that can block doesn't work there just yet.
>=20
> The following prep patches will replace the private memcg counters
> with the generic vmstat counters, thus removing the page->mapping
> dependency, then complete the transition to the new single-point
> charge API and delete the old transactional scheme.
>=20
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gman=
e.org>
> ---

Reviewed-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gma=
ne.org>
