Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795437164;
	b=ScGMLxLAIv0jmZa4oGoli5vKxfOBlB3Z02vsd7B0+uVS3tfjNZBNxQVzmdHwAoL+InvR
	 K4+RXm2LC4BrJrfZlMTeKg49z2Gqke166JoTuN+UaJFp4Jt4euTergxV5/5kTXoo1wsgo
	 dgVvtE12DxMy6jAPs/FLWLEF2XcNG3T9u9ojiopHEKInJbcw81RiVpAeMfhShRMMG1hHP
	 Kdtqg2X4ocplepkRDtKiYdVoMfyh69aowKQdzGo6qEKIbKdj9V+Y0PVHAb25rVEMXWjJr
	 3Kz8m3aUo+5W9G1SmJ8sPNkJjmSa76gNQMjQhKttXHxMONdMjjTLGU1g8OHxREtIKDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795437164;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=e2RVQ3O8W1C8YW2wJ9aXaBh6gRelyzfxjUCFahQNfPU=;
	b=MU5RgmWwkPLDM0F80FNfLtrlQl3/rOx0fE+hThfpHwLrkoqzWta2WTzd3CdpAoWI6dHb
	 QdZM3xCIquvC4xbv3ERZwtR+M+IxK4ckXRYsnE+3Lq4++QwBY4xSqF3vNUxjEyTDTjKDE
	 NehhG0YdQuqET+Hh849yeBY1LkvBTSQsV+wulTGTGJzf1YwQWYZ9JUMdbuA9Vw8pJEZq/
	 wG/ylhJ8ZPgUKclr85KMFcwdchePnQH1weFwAalz678OMlsxwyZc/iX9a+vyNMipHfjsw
	 +7uZ3+Tcxx+VEga5w3FKJu3SmjgrYX/ghjI/9Z5lj7dgeoh6FpZxgG5DCG0LUanFtLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=g6yK4vC5;
	arc=none smtp.remote-ip=95.215.58.4
Received: from mta1.migadu.com (out-4.mta1.migadu.com [95.215.58.4])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E1D606A31E
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 12:32:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59E1D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=g6yK4vC5
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IaXfb5Hi/QpRbuwTQppmoutVL2pV2Zxy6b6NwmIDvTU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795437161; v=1; x=1796041961;
 b=g6yK4vC5n37WbsNdGMf0BkpnaNq+7uKBUXX15GD4SctWed5eePPBRCkJyQwRQZ4z/2o4XLKV
 YjmYuMufUFgSZOOqhTlUeP2HjKWGmRdRX2H20UrtpcOKL+huQpOCQUOCQ19bckPFv9Cpco69Ln0
 n04OISklYq56LohQvRYFpXuk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6fa58fd50eb09120;
	Mon, 23 Nov 2026 12:32:41 +0000
X-Mizu-Trace-ID: 6fa58fd50eb09120
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v5 04/17] mm/memcg: add folio-based lruvec live helper
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <awMX9W-Ykjw4maRg@KASONG-MC4>
Date: Mon, 23 Nov 2026 20:32:16 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 kasong@tencent.com,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>,
 Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>,
 Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org,
 Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>,
 David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>,
 Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>,
 Chen Ridong <chenridong@xiaomi.com>,
 Tal Zussman <tz2294@columbia.edu>,
 Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
 Lian Wang <lianux.mm@gmail.com>,
 Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>,
 Hui Zhu <hui.zhu@linux.dev>,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 damon@lists.linux.dev,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <71FD1E6D-6F79-42B7-AED8-FCFACAB541AB@linux.dev>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
 <42207e26-ba7f-4df5-8c80-71fa1b84d26e@linux.dev>
 <awMX9W-Ykjw4maRg@KASONG-MC4>
To: Kairui Song <ryncsn@gmail.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)



> On Nov 23, 2026, at 01:03, Kairui Song <ryncsn@gmail.com> wrote:
>=20
> On Sun, Nov 22, 2026 at 03:53:44PM +0800, Muchun Song wrote:
>>=20
>>=20
>> On 2026/11/19 05:03, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>=20
>>> Add a helper that resolves a live lruvec for a folio under RCU
>>> without taking the lruvec lock.  It takes a folio directly so the
>>> lruvec lookup happens inside the RCU read-side critical section,
>>> which a lruvec-based interface cannot guarantee.  The first user is
>>> the lockless folio_inc_lru_refs() path later in the series.
>>>=20
>>> Factor the ancestor walk out of lruvec_live_lock_irq() into
>>> __lruvec_get_live(), so that both entry points share it, and spell
>>> out why the walk is enough while only the RCU read lock is held:
>>> reparenting of a memcg that starts dying waits for a grace period,
>>> so it cannot race with the caller until the lock is released.
>>>=20
>>> Move memcg_is_dying() up in memcontrol.h, next to the other memcg =
state
>>> predicates, and use it for the walk rather than repeating the open =
coded
>>> css_is_dying() test a few definitions away from where it is =
explained.
>>>=20
>>> No functional change for existing callers.
>>>=20
>>> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>=20
>> Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
>>=20
>> Some nits bellow:
>>=20
>>> ---
>>>  include/linux/memcontrol.h | 71 =
++++++++++++++++++++++++++++++++++++----------
>>>  1 file changed, 56 insertions(+), 15 deletions(-)
>>>=20
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index 980358bc6f49..441a5d57e723 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -571,6 +571,11 @@ static inline bool mem_cgroup_disabled(void)
>>>   	return !cgroup_subsys_enabled(memory_cgrp_subsys);
>>>  }
>>> +static inline bool memcg_is_dying(struct mem_cgroup *memcg)
>>=20
>> Let's make it const for @memcg along the way.
>=20
> Good idea, but css_is_dying isn't constified, maybe we can do it later =
I think.

Fine.

>=20
>>> @@ -1510,28 +1520,41 @@ static inline void lruvec_lock_irq(struct =
lruvec *lruvec)
>>>   spin_lock_irq(&lruvec->lru_lock);
>>>  }
>>> -static inline struct lruvec *lruvec_live_lock_irq(struct lruvec =
*lruvec)
>>> +/*
>>> + * Reparenting moves a dying memcg's LRU state to its parent at any =
time,
>>> + * so anything added to that LRU afterwards would be lost.  This =
helper
>>> + * walks up to the nearest live ancestor while the caller must hold =
the
>>> + * RCU read lock: reparenting of a memcg that starts dying waits =
for a
>>> + * grace period, so it cannot race with the caller until the lock =
is
>>> + * released.
>>> + */
>>> +static inline struct lruvec *__lruvec_get_live(struct lruvec =
*lruvec)
>>=20
>> Cound @lruvec be const as well?
>=20
> The argument is fine, but tricky for the return value: when nothing is =
dying it
> hands back @lruvec unchanged, so a const argument means a const return =
(which
> isn't right) or a cast dropping it again.

A cast is not nice. Let's keep things as they are.

Thanks,
Muchun

>=20
>>> @@ -1561,6 +1584,34 @@ static inline bool folio_matches_lruvec(const =
struct folio *folio,
>>>          lruvec_memcg(lruvec) =3D=3D folio_memcg(folio);
>>>  }
>>> +/**
>>> + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
>>> + * @folio: the folio
>>> + *
>>> + * Same as folio_lruvec(), except that a folio whose memcg is dying =
is
>>> + * accounted to the nearest live ancestor, which is where =
reparenting
>>> + * would put it anyway.
>>> + *
>>> + * Return: the live lruvec, with rcu_read_lock() held.  Pair it =
with
>>> + * folio_lruvec_live_put().
>>> + */
>>> +static inline struct lruvec *folio_lruvec_live_get(struct folio =
*folio)
>>=20
>> const folio?
>=20
> This is doable, will do!
>=20
> Thanks for the review!


