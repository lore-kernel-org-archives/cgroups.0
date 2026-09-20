Received: from cu-ua11p00im-quki07171502.ua.silu.net (cu-ua11p00im-quki07171502.ua.silu.net [123.126.78.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F653E7BBD;
	Sun, 20 Sep 2026 10:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=123.126.78.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789898941; cv=none; b=nvrafDpK3bBwumNu9IfISDa+7AdpqC7JqaZGY419E08nDYi1wiGcIznqTu62i6rmMq5bEkbiucQzWwVE2kSGeKJ1UMRg08M/w/w3z4cgxpnUV18O5NtbiZ+4hZ8F1feXrH+N5aJAc2bATNy/dcQ8mEVt2utj5qRspTpjQLdrZEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789898941; c=relaxed/simple;
	bh=zVwqC9sDT8iT4cZnfl7fIUX2cpiqxQFzMG7jws0aRKc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=bXHh4siN3wYSXWo1x/0i5C5ezYN/ysHfO9h7PUF1HVKMmqlAetL99BEG5cnv8HwQ9qiT+3aWWrqBAV2l4p+Jujkm6JbgMmYdPftKFeY1J+a/3l9edXEK7dZCXeREKxuzK+PlQEj6c+OaHCDxyv2EYO8nCM/ZIpF73Ay+82ZZ7jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=HpRb3uLx; arc=none smtp.client-ip=123.126.78.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="HpRb3uLx"
Received: from smtpclient.apple (ua11p00im-asmtpcmvip.ua.silu.net [112.19.242.76])
	by ua11p00im-quki07171502.ua.silu.net (Postfix) with ESMTPSA id 30E2C28C00AC;
	Sun, 20 Sep 2026 10:08:55 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789898937; x=1792490937; bh=gUNUCXQmhH4kI3t+BNIkGcDm4X/J8a37GO7LRD4XxoA=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=HpRb3uLxViN2U57wiuAbkzodOPIOPvoTLCOHjqQOcaec+Y38e+4ECN5c/00K8gJUutSdjMzEejG1mxtYnhy0veCpIGkoBFJCHjdMci1xXNbDqWIzqqmHpO9jvpViTmE4v3xElVEN9d40s9Xbj9F4Qt12LXLV/OUKw0EaQTMORE2tMcB8yCj8QxaCwpd7C3JghLe1bNT6wc+DK0A4y0jYs6VM8kfe3vtncIq5bnUpHisMDnUnNn+tqFeZmkJQorWA2EhEu7MdTH3htuOJDwS2/1MqXUwiLsvAqdixHdW6vViyZ8zj5lfSZ4gVecc6tfWOmz6ciasGBSisRf32wEPYDQ==
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH 4/4] memcg: move memcg private ID refcount to objcg
From: Bingfang Guo <bfguo@icloud.com>
In-Reply-To: <e4ec1370-27cf-40db-ba4e-b46fe54fa882@linux.dev>
Date: Sun, 20 Sep 2026 18:08:44 +0800
Cc: bingfangguo@tencent.com,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DAF7F09A-A8C1-4D7F-95AD-984C92E9A644@icloud.com>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-4-5bbf3220d88f@tencent.com>
 <e4ec1370-27cf-40db-ba4e-b46fe54fa882@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Proofpoint-GUID: MR4iIZWIkumUQ3noL8yNVsxKDQM1EfSz
X-Proofpoint-ORIG-GUID: MR4iIZWIkumUQ3noL8yNVsxKDQM1EfSz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDM1MCBTYWx0ZWRfXzH90LqzTYXjj
 kW7VSrDg1+ggGAu2W7bALGKZtyBr5vpNyGZ3RjDHkBE8v2ePYXlwHvRmNR5K9vSKZXa44jILun0
 7nlUOdNWcYyEEMe7EyX+a/f4V/wSztqZJUOCgY+XFEwwm9LtdRdwKtbu7Jyf52Lke6kz+ImUGCA
 ysQSxPI2Fo8y6AmWYAlBgSqkCzDt65MjA7PIrq94ZPF8ZeWKHF28NYcLpfQPJkzYNtTu157l/Xz
 Foj9U5HoNQ0uocVSkcbx0wf/bNtaSdm3ACgluQqnFPak/U2NcqscH1CU1KtLyM1BA5Z1d52KRxX
 5TwS45JcO6d5UEh+pMC3moBziDNMEhcd71FwrqJKA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-19_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 spamscore=0 malwarescore=0
 clxscore=-2147483648 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2609190350

On Sat, Sep 19, 2026 at 11:32:46AM +0800, Muchun Song wrote:
>=20
>=20
> On 2026/9/18 17:18, Bingfang Guo via B4 Relay wrote:
>> From: Bingfang Guo <bingfangguo@tencent.com>
>>=20
>> The memcg private ID is used by objects that can't afford storing a
>> whole pointer and can outlive memcgs to track the memcg (notably swap
>> entries). The current design holds a refcount to the css, preventing =
the
>> memcg from being freed.
>>=20
>> This patch unbinds the lifetime of memcgid from the memcg so it can =
be
>> freed.  The idea is to move the refcount of memcgid to one of the
>> memcg's objcg. The objcg is stored in the global memcgid xarray =
instead
>> and used for retrieving the online memcg from it.  So swapped out =
pages
>> no longer pin the dying memcg.
>>=20
>> After the change, a memcgid can refer to a non present memcg. To =
handle
>> this situation, when trying to get the original memcg from the id,
>> compare the memcgid passed in with that of the memcg, and return NULL =
to
>> indicate its death if they differ. NULL checks are added for
>> list_lru_walk_node(), workingset_test_recent() and =
lru_gen_test_recent()
>> to skip dead memcgs.
>>=20
>> In the earlier patch, an extra xarray lookup was introduced in swap
>> uncharging path.  Now that we have the objcg pointer in the function,
>> the extra overhead can be removed by using it for putting directly.
>>=20
>> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
>> ---
>>  include/linux/memcontrol.h |  9 +++---
>>  mm/list_lru.c              |  2 +-
>>  mm/memcontrol.c            | 81 =
++++++++++++++++++++++++++++++++++------------
>>  mm/workingset.c            |  5 ++-
>>  4 files changed, 71 insertions(+), 26 deletions(-)
>>=20
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 46bf724cae7af..3fb18191cfbd1 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -180,6 +180,7 @@ struct obj_cgroup {
>>  	struct percpu_ref refcnt;
>>  	struct mem_cgroup *memcg;
>>  	atomic_t nr_charged_bytes;
>> +	refcount_t private_id_ref;
>>  	union {
>>  		struct list_head list; /* protected by objcg_lock */
>>  		struct rcu_head rcu;
>> @@ -225,9 +226,6 @@ struct mem_cgroup {
>>  	/* vmpressure notifications. Written on every reclaim iteration. =
*/
>>  	struct vmpressure vmpressure;
>> -	/* Written on every swap charge and uncharge. */
>> -	refcount_t private_id_ref;
>> -
>>  #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
>>  	/* MEMCG_KMEM for nmi context */
>>  	atomic_t		kmem_stat;
>> @@ -324,8 +322,11 @@ struct mem_cgroup {
>>  	unsigned long zswap_max;
>>  #endif
>> +	/* The objcg holding private memcg ID. */
>> +	struct obj_cgroup *private_id_objcg;
>> +
>>  	/* Private memcg ID. Used to ID objects that outlive the cgroup =
*/
>> -	int private_id;
>> +	unsigned short private_id;
>>  	int kmemcg_id;
>> diff --git a/mm/list_lru.c b/mm/list_lru.c
>> index 8a6dd0a489e12..7edd79113cc56 100644
>> --- a/mm/list_lru.c
>> +++ b/mm/list_lru.c
>> @@ -428,7 +428,7 @@ unsigned long list_lru_walk_node(struct list_lru =
*lru, int nid,
>>  		xa_for_each(&lru->xa, index, mlru) {
>>  			rcu_read_lock();
>>  			memcg =3D mem_cgroup_from_private_id(index);
>> -			if (!mem_cgroup_tryget(memcg)) {
>> +			if (!memcg || !mem_cgroup_tryget(memcg)) {
>>  				rcu_read_unlock();
>>  				continue;
>>  			}
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index ed44b3e7ac938..22deee8312856 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4074,6 +4074,18 @@ static void =
memcg_wb_domain_size_changed(struct mem_cgroup *memcg)
>>  #define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
>>  static DEFINE_XARRAY_ALLOC1(mem_cgroup_private_ids);
>> +/**
>> + * obj_cgroup_from_private_id - look up the objcg holding the memcg =
id.
>> + * @id: the memcg id to look up
>> + *
>> + * Caller must hold rcu_read_lock().
>=20
> This comment is really redundant since you already include a lockdep
> assertion. My advice for writing good comments: when the code is
> self-explanatory, explain why rather than what.
>=20

Get it! I'll remove this.

>> + */
>> +static inline struct obj_cgroup *obj_cgroup_from_private_id(unsigned =
short id)
>> +{
>> +	lockdep_assert_once(rcu_read_lock_held());
>> +	return xa_load(&mem_cgroup_private_ids, id);
>> +}
>> +
>>  static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
>>  {
>>  	if (memcg->private_id > 0) {
>> @@ -4082,34 +4094,43 @@ static void =
mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
>>  	}
>>  }
>> -static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, =
unsigned int n)
>> +static void __mem_cgroup_private_id_put(struct obj_cgroup *objcg,
>> +		unsigned short id, unsigned int n)
>>  {
>> -	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
>> -		mem_cgroup_private_id_remove(memcg);
>> +	struct obj_cgroup *objcg_free;
>> -		/* Memcg ID pins CSS */
>> -		css_put(&memcg->css);
>> +	if (refcount_sub_and_test(n, &objcg->private_id_ref)) {
>> +		objcg_free =3D xa_erase(&mem_cgroup_private_ids, id);
>> +		VM_WARN_ON(objcg_free !=3D objcg);
>> +
>> +		/* Memcg ID pins the objcg */
>> +		obj_cgroup_put(objcg);
>>  	}
>>  }
>>  static inline void mem_cgroup_private_id_put(unsigned short id, =
unsigned int n)
>>  {
>> -	struct mem_cgroup *memcg;
>> +	struct obj_cgroup *objcg;
>>  	rcu_read_lock();
>> -	memcg =3D mem_cgroup_from_private_id(id);
>> -	__mem_cgroup_private_id_put(memcg, n);
>> +	objcg =3D obj_cgroup_from_private_id(id);
>> +	__mem_cgroup_private_id_put(objcg, id, n);
>>  	rcu_read_unlock();
>>  }
>>  static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
>>  {
>> -	__mem_cgroup_private_id_put(memcg, 1);
>> +	__mem_cgroup_private_id_put(memcg->private_id_objcg, =
memcg->private_id, 1);
>>  }
>>  unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, =
unsigned int n)
>>  {
>> -	while (!refcount_add_not_zero(n, &memcg->private_id_ref)) {
>> +	struct obj_cgroup *objcg;
>=20
> Please add a blank line between the variable definition and the =
assertion.
>=20
>> +	lockdep_assert_once(rcu_read_lock_held());
>> +
>> +	objcg =3D memcg->private_id_objcg;
>> +
>> +	while (!refcount_add_not_zero(n, &objcg->private_id_ref)) {
>>  		/*
>>  		 * The root cgroup cannot be destroyed, so it's refcount =
must
>>  		 * always be >=3D 1.
>> @@ -4119,6 +4140,7 @@ unsigned short mem_cgroup_private_id_get(struct =
mem_cgroup *memcg, unsigned int
>>  			break;
>>  		}
>>  		memcg =3D parent_mem_cgroup(memcg);
>> +		objcg =3D memcg->private_id_objcg;
>>  	}
>>  	return mem_cgroup_private_id(memcg);
>> @@ -4129,11 +4151,24 @@ unsigned short =
mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int
>>   * @id: the memcg id to look up
>>   *
>>   * Caller must hold rcu_read_lock().
>> + *
>> + * @return: the memcg, or NULL if the memcg referred to is already =
dead.
>>   */
>>  struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
>>  {
>> +	struct obj_cgroup *objcg;
>> +	struct mem_cgroup *memcg;
>=20
> It would be better to add a blank line here as well.
>=20

Sure. Same above.

>>  	WARN_ON_ONCE(!rcu_read_lock_held());
>> -	return xa_load(&mem_cgroup_private_ids, id);
>> +
>> +	objcg =3D obj_cgroup_from_private_id(id);
>> +	if (!objcg)
>> +		return NULL;
>> +
>> +	memcg =3D obj_cgroup_memcg(objcg);
>> +	if (mem_cgroup_private_id(memcg) !=3D id)
>> +		return NULL;
>> +
>> +	return memcg;
>>  }
>>  struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
>> @@ -4228,18 +4263,21 @@ static struct mem_cgroup =
*mem_cgroup_alloc(struct mem_cgroup *parent)
>>  	struct mem_cgroup *memcg;
>>  	int node, cpu;
>>  	int __maybe_unused i;
>> +	unsigned int private_id;
>=20
> This could be a separate cleanup patch.
>=20

Okay.

I think I can send this in a separate patch later for simplicity.

>>  	long error;
>>  	memcg =3D kmem_cache_zalloc(memcg_cachep, GFP_KERNEL);
>>  	if (!memcg)
>>  		return ERR_PTR(-ENOMEM);
>> -	error =3D xa_alloc(&mem_cgroup_private_ids, &memcg->private_id, =
NULL,
>> +	error =3D xa_alloc(&mem_cgroup_private_ids, &private_id, NULL,
>>  			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
>>  	if (error)
>>  		goto fail;
>>  	error =3D -ENOMEM;
>> +	memcg->private_id =3D private_id;
>> +
>>  	memcg->vmstats =3D kzalloc_obj(struct memcg_vmstats, =
GFP_KERNEL_ACCOUNT);
>>  	if (!memcg->vmstats)
>>  		goto fail;
>> @@ -4380,9 +4418,10 @@ static int mem_cgroup_css_online(struct =
cgroup_subsys_state *css)
>>  				   FLUSH_TIME);
>>  	lru_gen_online_memcg(memcg);
>> -	/* Online state pins memcg ID, memcg ID pins CSS */
>> -	refcount_set(&memcg->private_id_ref, 1);
>> -	css_get(css);
>> +	/* CSS pins memcg ID, memcg ID pins obj cgroup */
>> +	memcg->private_id_objcg =3D objcg;
>> +	refcount_set(&memcg->private_id_objcg->private_id_ref, 1);
>> +	obj_cgroup_get(memcg->private_id_objcg);
>>  	/*
>>  	 * Ensure mem_cgroup_from_private_id() works once we're fully =
online.
>> @@ -4394,7 +4433,7 @@ static int mem_cgroup_css_online(struct =
cgroup_subsys_state *css)
>>  	 * publish it here at the end of onlining. This matches the
>>  	 * regular ID destruction during offlining.
>>  	 */
>> -	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg, =
GFP_KERNEL);
>> +	xa_store(&mem_cgroup_private_ids, memcg->private_id, =
memcg->private_id_objcg, GFP_KERNEL);
>>  	return 0;
>>  free_objcg:
>> @@ -5832,8 +5871,6 @@ static void __init memcg_struct_check(void)
>>  				      memory_events_local);
>>  	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, =
memcg_write_hot,
>>  				      vmpressure);
>> -	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, =
memcg_write_hot,
>> -				      private_id_ref);
>>  #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
>>  	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, =
memcg_write_hot,
>>  				      kmem_stat);
>> @@ -5878,6 +5915,8 @@ static void __init memcg_struct_check(void)
>>  	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, =
memcg_read_mostly,
>>  				      zswap_writeback);
>>  #endif
>> +	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, =
memcg_read_mostly,
>> +				      private_id_objcg);
>>  	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, =
memcg_read_mostly,
>>  				      private_id);
>>  	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, =
memcg_read_mostly,
>> @@ -6015,10 +6054,12 @@ int __mem_cgroup_try_charge_swap(struct folio =
*folio)
>>   */
>>  void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int =
nr_pages)
>>  {
>> +	struct obj_cgroup *objcg;
>>  	struct mem_cgroup *memcg;
>>  	rcu_read_lock();
>> -	memcg =3D mem_cgroup_from_private_id(id);
>> +	objcg =3D obj_cgroup_from_private_id(id);
>> +	memcg =3D obj_cgroup_memcg(objcg);
>>  	if (memcg) {
>>  		if (!mem_cgroup_private_id_is_root(id)) {
>>  			if (do_memsw_account())
>> @@ -6027,7 +6068,7 @@ void __mem_cgroup_uncharge_swap(unsigned short =
id, unsigned int nr_pages)
>>  				page_counter_uncharge(&memcg->swap, =
nr_pages);
>>  		}
>>  		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
>> -		mem_cgroup_private_id_put(id, nr_pages);
>> +		__mem_cgroup_private_id_put(objcg, id, nr_pages);
>>  	}
>>  	rcu_read_unlock();
>>  }
>> diff --git a/mm/workingset.c b/mm/workingset.c
>> index 8412f4840ae35..7e4fbc5a786d6 100644
>> --- a/mm/workingset.c
>> +++ b/mm/workingset.c
>> @@ -281,6 +281,9 @@ static bool lru_gen_test_recent(void *shadow, =
struct lruvec **lruvec,
>>  	unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);
>>  	memcg =3D mem_cgroup_from_private_id(memcg_id);
>> +	if (!memcg)
>> +		return false;
>> +
>>  	*lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>>  	max_seq =3D READ_ONCE((*lruvec)->lrugen.max_seq);
>> @@ -470,7 +473,7 @@ bool workingset_test_recent(void *shadow, bool =
file, bool *workingset,
>>  	 * configurations instead.
>>  	 */
>>  	eviction_memcg =3D mem_cgroup_from_private_id(memcgid);
>> -	if (!mem_cgroup_tryget(eviction_memcg))
>> +	if (eviction_memcg && !mem_cgroup_tryget(eviction_memcg))
>>  		eviction_memcg =3D NULL;
>>  	rcu_read_unlock();
>>=20
>=20

