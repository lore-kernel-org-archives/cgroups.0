Received: from cu-ua11p00im-quki07170902.ua.silu.net (cu-ua11p00im-quki07170902.ua.silu.net [123.126.78.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273AF339390;
	Wed,  2 Sep 2026 03:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=123.126.78.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788321254; cv=none; b=YJH9hR5kW7a2cqO2/2WDx06k5XNS5Iq8mDDv059w9TFatCzjXQ2venYbISytv4k1OwZPFfJxaZf6+PRWNmg6AMa23MwGNEp2Q5gnQbIUdJaFdpuJlm7fauJo71OSUEtj9fbfY/mZq7fnqC7qggMb0/Z2Ul88cl9Knu+J5FAvUG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788321254; c=relaxed/simple;
	bh=6o96VhsPEnVEZ2gIAswjOdSxx+PGSleuvRr/bfcpeg8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=aVmkFgHrUeN5IgJDm7Qs1kIMBLn5vmOk2XNzNyJzKSjlc/T01rKIIbnPosB4RJo5iI8oVMrKp8+mTyOQ2Xw17CxzbDrV49OKYtuRAYaKMbToirbY04QYq8SLDgdy9zCHaE0tXLVvghAji+OubsFlF5pBJcc4QOMSNQqdXF/8HUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=sovUyfkV; arc=none smtp.client-ip=123.126.78.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="sovUyfkV"
Received: from smtpclient.apple (ua11p00im-asmtpcmvip.ua.silu.net [112.19.242.76])
	by ua11p00im-quki07170902.ua.silu.net (Postfix) with ESMTPSA id 637F7CC00B8;
	Wed,  2 Sep 2026 03:54:05 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788321250; x=1790913250; bh=gt9G2GKgH5tHFxWKVawtkc5MhF/w6yd2haL+O80x1ZM=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=sovUyfkVQ2D2qdC3E7IiMd3EJNIMXo0mBwjYkwUSxdEv9sNjpHiJHuVNRqlb0HhLHma/S5QnF+I8VH8Hp5d3Q7wWE3tovnxHGb+xRpq1wRScIQU1Ncq65nyr6tdyIZgu16KBEuApINgF+upYvHSEPSYw6hzBvv0FC0YtplEmXCbVjqLi6RBPNAfmScsZKZK5tHrcpmGhUt3QYQYAjPFmU7gkjAe863qDBxevTpwVfAAIbCgX8MMEME7ogGqU3hTm/9xQZjdPbHdpR5J0vU01Upa+iwRViV5W3q38Mqddx+hwpXQbnCfPQI5CDOB9PXPHR8eup9lX33xAuDv5bLavVg==
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH RFC v2 6/6] mm/memcg: filter out reparented memcgs got
 from memcgid
From: Bingfang Guo <bfguo@icloud.com>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-6-8edd7f7a7251@tencent.com>
Date: Wed, 2 Sep 2026 11:53:53 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6134564F-5800-4F1C-AB02-3487D3EFA8B3@icloud.com>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-6-8edd7f7a7251@tencent.com>
To: bingfangguo@tencent.com
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Proofpoint-GUID: R8Jnm2sXbLLOvCYd3F9jlxXiU9mU3hyO
X-Proofpoint-ORIG-GUID: R8Jnm2sXbLLOvCYd3F9jlxXiU9mU3hyO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDAyNSBTYWx0ZWRfXzaqJ9OUR5xah
 rgCed482E6xWFm/AiHM8FsTJcElEwQpynwl2NVpHbjWrtvxwdtO/3PVNdSxKL9XLBaCfJRmeU4j
 NtAZoAYNopGU0Mjuo7RyFGmF5tPztsBEcT/OrDhKIH8RkdG2a87fC3MqcK/eEDWAnKwEe+XWtLS
 mrtMfsrQjwvEfr9pY/4gJt7mA1NJ1Zb8bYDOulDnXwmVBOpTsTXxOhcpe0lE27xKDJAdGzYTgDS
 JAUh3uqW4H/+CuCN4q0YpyWiRVMbmM8kdbZKsvzLN1ib2hDYPVIUPFvD3NEUNMQCakBeG0Bpuo3
 fo556HkHtOsf1MHuhuCRSSLSnEd9Y39SdSEMTtAHw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_06,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=-2147483648 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2609020025


Forwarding reviews from Sashiko:
>> From: Bingfang Guo <bingfangguo@tencent.com>
>>=20
>> mem_cgroup_from_private_id() looks up the objcg that owns the id and
>> returns the objcg's current memcg.  After reparenting, that memcg can
>> differ from the one the id originally belonged to.
>>=20
>> Callers such as the list lru and workingset refault code expect to =
get
>> back exactly the memcg referred to by the memcgid, so check that the
>> returned memcg still owns the id and return NULL otherwise. In this
>> case, make list_lru just skip and workingset tests use the root (as =
the
>> comments said in workingset.c:460).
>>=20
>> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
>> ---
>> mm/list_lru.c   | 2 +-
>> mm/memcontrol.c | 9 ++++++++-
>> mm/workingset.c | 2 +-
>> 3 files changed, 10 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/mm/list_lru.c b/mm/list_lru.c
>> index 36662d02ff963..bc956267f6835 100644
>> --- a/mm/list_lru.c
>> +++ b/mm/list_lru.c
>> @@ -428,7 +428,7 @@ unsigned long list_lru_walk_node(struct list_lru =
*lru, int nid,
>> 		xa_for_each(&lru->xa, index, mlru) {
>> 			rcu_read_lock();
>> 			memcg =3D mem_cgroup_from_private_id(index);
>> -			if (!mem_cgroup_tryget(memcg)) {
>> +			if (!memcg || !mem_cgroup_tryget(memcg)) {
>> 				rcu_read_unlock();
>> 				continue;
>> 			}
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 38d2b00657a7a..84dcab3acb8a2 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4112,17 +4112,24 @@ struct mem_cgroup =
*mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
>>  * @id: the memcg id to look up
>>  *
>>  * Caller must hold rcu_read_lock().
>> + *
>> + * @return: the memcg, or NULL if the memcg is already reparented.
>>  */
>> struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
>> {
>> 	struct obj_cgroup *objcg;
>> +	struct mem_cgroup *memcg;
>> 	WARN_ON_ONCE(!rcu_read_lock_held());
>>=20
>> 	objcg =3D xa_load(&mem_cgroup_private_ids, id);
>> 	if (!objcg)
>> 		return NULL;
>>=20
>> -	return obj_cgroup_memcg(objcg);
>> +	memcg =3D obj_cgroup_memcg(objcg);
>> +	if (mem_cgroup_private_id(memcg) !=3D id)
>> +		return NULL;
>> +
>> +	return memcg;
>> }
>=20
> Does returning NULL here for reparented memcgs break swapin accounting
> in callers like mem_cgroup_swapin_charge_folio()?
> If an offlined memcg is reparented, its original ID no longer matches =
the
> inheritor's ID. When mem_cgroup_swapin_charge_folio() calls this =
function:
> 	memcg =3D mem_cgroup_from_private_id(id);
> 	if (!memcg || !css_tryget_online(&memcg->css))
> 		memcg =3D get_mem_cgroup_from_mm(mm);
> Would receiving NULL force it to wrongfully charge the faulting task =
instead
> of the parent memcg that inherited the swap charge, creating a =
permanent
> accounting mismatch?
>=20

The original behavior uses css_tryget_online(), which filters out =
offlined
memcgs as well so I suppose no behavioral change here.

And swap (or memsw) counter of the memcg from which the page was swapped =
out
should be uncharged in __mem_cgroup_uncharge_swap() when the swap entry =
is
removed.

I will put this in the commit message to explain it later.

>>=20
>> struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
>> diff --git a/mm/workingset.c b/mm/workingset.c
>> index 7ac2b88c80ae5..4e9b7b163c01e 100644
>> --- a/mm/workingset.c
>> +++ b/mm/workingset.c
>> @@ -470,7 +470,7 @@ bool workingset_test_recent(void *shadow, bool =
file, bool *workingset,
>> 	 * configurations instead.
>> 	 */
>> 	eviction_memcg =3D mem_cgroup_from_private_id(memcgid);
>> -	if (!mem_cgroup_tryget(eviction_memcg))
>> +	if (eviction_memcg && !mem_cgroup_tryget(eviction_memcg))
>> 		eviction_memcg =3D NULL;
>> 	rcu_read_unlock();
>=20
> The commit message states that workingset tests use the root (as the
> comments said in workingset.c:460) when NULL is returned. However, is
> this what actually happens?
> Looking immediately below this diff in workingset_test_recent(), it =
seems
> receiving NULL triggers an early return:
> 	if (!mem_cgroup_disabled() && !eviction_memcg)
> 		return false;
> Does this abort the refault calculation entirely, treating the =
reparented
> shadow entry as cold and causing page cache thrashing?

I didn't make it clear in the commit message here.  For MGLRU the root =
is used.
But for classical LRU, it's just skipped because refault reading of =
other memcgs
should be meaningless in this case.

I will update the commit message to match the behavior...

> Additionally, can this cause an issue in MGLRU lru_gen_test_recent()?
> If mem_cgroup_from_private_id() returns NULL there:
> 	memcg =3D mem_cgroup_from_private_id(memcg_id);
> 	*lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
> Would this silently fall back to the root memcg LRU vector instead of =
the
> correct parent memcg, incorrectly evaluating the child eviction token
> against the root completely unrelated max_seq?
>=20

Yes, but the activation is speculative as documented so it should be =
okay? Are
there better ways to handle this?

But I do think it may be good to keep the two methods behaves =
consistently, to
either skip the check or get a random result for both two cases.

>>=20
>>=20
>> --=20
>> 2.43.7
>>=20
>>=20


