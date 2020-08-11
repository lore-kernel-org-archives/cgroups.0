From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [Resend PATCH 2/6] mm/memcg: remove useless check on
 page->mem_cgroup
Date: Tue, 11 Aug 2020 20:42:28 +0800
Message-ID: <a1da796f-e42a-aaac-58e2-8b352fde4dc2@linux.alibaba.com>
References: <1597144232-11370-1-git-send-email-alex.shi@linux.alibaba.com>
 <1597144232-11370-2-git-send-email-alex.shi@linux.alibaba.com>
 <20200811113008.GK4793@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200811113008.GK4793-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



=D4=DA 2020/8/11 =CF=C2=CE=E77:30, Michal Hocko =D0=B4=B5=C0:
> subject line looks like a left over. It doesn't match the path. Did you
> mean
> memcg: bail out early from swap accounting when memcg is disabled?

It's much better, Thanks for correction!

>=20
> Btw. if this patch was first in the series then you wouldn't need to
> mention the warnings that would trigger based on your previous patch.
> I am fine with both ways but mentioning the warning is usefule.

Right. but the patch is very simple,  w/o warning message doesn't cuase tro=
uble.
So, removing the 'and keep WARN_ON monitor' make sense too.

Do I need a resend for the commit log change?

Thanks a lot!
Alex

>=20
> On Tue 11-08-20 19:10:28, Alex Shi wrote:
>> If we disabled memcg by cgroup_disable=3Dmemory, the swap charges are
>> still called. Let's return from the funcs earlier and keep WARN_ON
>> monitor.
>>
>> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@publi=
c.gmane.org>
>> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
>> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.o=
rg>
>> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.or=
g>
>> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
>> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>>  mm/memcontrol.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 299382fc55a9..419cf565f40b 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -7098,6 +7098,9 @@ void mem_cgroup_swapout(struct page *page, swp_ent=
ry_t entry)
>>  	VM_BUG_ON_PAGE(PageLRU(page), page);
>>  	VM_BUG_ON_PAGE(page_count(page), page);
>> =20
>> +	if (mem_cgroup_disabled())
>> +		return;
>> +
>>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>>  		return;
>> =20
>> @@ -7163,6 +7166,9 @@ int mem_cgroup_try_charge_swap(struct page *page, =
swp_entry_t entry)
>>  	struct mem_cgroup *memcg;
>>  	unsigned short oldid;
>> =20
>> +	if (mem_cgroup_disabled())
>> +		return 0;
>> +
>>  	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>>  		return 0;
>> =20
>> --=20
>> 1.8.3.1
>=20
