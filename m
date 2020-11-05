From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v20 00/20] per memcg lru lock
Date: Thu, 5 Nov 2020 13:07:48 +0800
Message-ID: <59f37649-0530-e2d8-c2e3-ecb70871ffb4@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <811216d4-4972-4721-d6b9-1028c02f4290@linux.alibaba.com>
 <20201104165935.GA744831@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201104165935.GA744831-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org



=D4=DA 2020/11/5 =C9=CF=CE=E712:59, Johannes Weiner =D0=B4=B5=C0:
> On Wed, Nov 04, 2020 at 07:55:39PM +0800, Alex Shi wrote:
>> @@ -1380,6 +1383,14 @@ struct lruvec *mem_cgroup_page_lruvec(struct page=
 *page, struct pglist_data *pgd
>>         return lruvec;
>>  }
>>
>> +/**
>> + * lock_page_lruvec - return lruvec for the locked page.
>=20
> I would say "lock and return the lruvec for a given page"
>=20
>> + * @page: the page
>> + *
>> + * This series functions should be used in either conditions:
>> + * PageLRU is cleared or unset
>> + * or, page->_refcount is zero
>=20
> or page is locked
>=20
> The other changes look good to me, thanks!
>=20

Thanks a lot for both comments!
I will pick them and sent out in v21.

Thanks!
Alex
