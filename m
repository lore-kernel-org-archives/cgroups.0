From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [Resend PATCH 2/6] mm/memcg: remove useless check on
 page->mem_cgroup
Date: Wed, 12 Aug 2020 11:25:53 +0800
Message-ID: <0b5e1ac3-c9c7-35e9-2661-b58430314d0a@linux.alibaba.com>
References: <1597144232-11370-1-git-send-email-alex.shi@linux.alibaba.com>
 <1597144232-11370-2-git-send-email-alex.shi@linux.alibaba.com>
 <20200811113008.GK4793@dhcp22.suse.cz>
 <776b0e6f-4129-9fb9-0f66-47757cf320d5@linux.alibaba.com>
 <20200811135626.GL4793@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200811135626.GL4793@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



=D4=DA 2020/8/11 =CF=C2=CE=E79:56, Michal Hocko =D0=B4=B5=C0:
> On Tue 11-08-20 20:54:18, Alex Shi wrote:
>> >From beeac61119ab39b1869c520c0f272fb8bab93765 Mon Sep 17 00:00:00 2001
>> From: Alex Shi <alex.shi@linux.alibaba.com>
>> Date: Wed, 5 Aug 2020 21:02:30 +0800
>> Subject: [PATCH 2/6] memcg: bail out early from swap accounting when mem=
cg is
>>  disabled>>
>> If we disabled memcg by cgroup_disable=3Dmemory, the swap charges are
>> still called. Let's return from the funcs earlier.
> They are not, are they? page->memcg will be NULL and so the charge is
> skipped and that will trigger a warning with your current ordering.

Hi Michal,

Thanks for comment! Looks like we both agree the memcg wasn't charged, but =
funcs
just are called. :)
 =20
>=20
> Let me repeat again. Either you put it first in the series and argue
> that we can bail out early or keep the ordering then this makes sure the
> warning doesn't trigger.
>=20

Is the following commit log fine?

Thanks!
Alex

From 999b0fe5fc65865c3b59ff28500d45572a4a9570 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@linux.alibaba.com>
Date: Wed, 5 Aug 2020 21:02:30 +0800
Subject: [PATCH 2/6] mm/memcg: bail out early from swap accounting when mem=
cg
 is disabled

If we disabled memcg by cgroup_disable=3Dmemory, page->memcg will be NULL
and so the charge is skipped and that will trigger a warning like below.
Let's return from the funcs earlier.

 ---[ end trace f1f34bfc3b32ed2f ]---
 anon flags:0x5005b48008000d(locked|uptodate|dirty|swapbacked)
 raw: 005005b48008000d dead000000000100 dead000000000122 ffff8897c7c76ad1
 raw: 0000000000000022 0000000000000000 0000000200000000 0000000000000000
 page dumped because: VM_WARN_ON_ONCE_PAGE(!memcg)

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 299382fc55a9..419cf565f40b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7098,6 +7098,9 @@ void mem_cgroup_swapout(struct page *page, swp_entry_=
t entry)
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
=20
+	if (mem_cgroup_disabled())
+		return;
+
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
=20
@@ -7163,6 +7166,9 @@ int mem_cgroup_try_charge_swap(struct page *page, swp=
_entry_t entry)
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
=20
+	if (mem_cgroup_disabled())
+		return 0;
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
=20
--=20
1.8.3.1

