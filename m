Received: from cu-ua11p00im-quki08153402.ua.silu.net (cu-ua11p00im-quki08153402.ua.silu.net [123.126.78.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8777484236;
	Thu, 13 Aug 2026 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=123.126.78.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786633804; cv=none; b=oP3sxBbSOiAlb7Wx7yVi9vSXAt/MTeSZmRs3trW+wbwNFlaARcSSzkVZxdZ2IXhqhXCSVz0rrgt6GsYvvdfJDfYJ6i9ux4FHhS7x4CJ45tKlXsViVgL7+VY0mLqh2QKlYC90IxAe1+nBtIKyYlpwFmNY+JIB01vVuGH8m3prExE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786633804; c=relaxed/simple;
	bh=m/desnq0ZmJMiypnLUDNLnOqWqKyqbWIYgozXFHQkPw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=G5NVA56MWmZhLuIlqJcQPRyvbduuc7U+sCruXCe2afLH706J1Tdwg8RE0Bof+A9/7/f0Lgy0MLju392ccbbJFhE5ZZlVCVifQqw5qEmTybD2YDlYIVGoMMbdMD/CZIGYdt5/OukUIUQUGN4N/XLkkl/5g6LciR3Is0of/2GNf/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=s0CEU151; arc=none smtp.client-ip=123.126.78.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="s0CEU151"
Received: from smtpclient.apple (ua11p00im-asmtpcmvip.ua.silu.net [112.19.242.76])
	by ua11p00im-quki08153402.ua.silu.net (Postfix) with ESMTPSA id 6D0552FC00DD;
	Thu, 13 Aug 2026 15:09:49 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786633800; x=1789225800; bh=So0tH2fqum8SdfaChqZY2DjQ5NJqtbjj07yGoxL2G3U=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=s0CEU151B42EBSaY50lHTjeqAPNvjn7DDhgN+3xIxkQDLTzrcB/pIaro000WasqgqY0BIKJND02SUqM7xpi3O9tTZetq9slFia2EOkSffXY89+4KVHSh31QDbfXgUWyLneI/vEI58qu12drP0E1GHx1Ni44SGXdeKGQaOGefSp4aTY24PhaIh/88CCud9RNBbIMsJFYsY+9puyIdHx7NJMkEETDAJlYgmjBduNdYsYWBfqXmx7D3q9tis2xMXBzyClW/Urp/Wi4KCardvzEgI/9hiVNhJCu7Mg4mIAOXOKWKUs4WfKVjW0HqujHKwJuzW5Uf49Ci56nHMYbpwdLdqw==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH RFC 1/5] memcg: move memcg private ID refcount to objcg
From: Bingfang Guo <bfguo@icloud.com>
In-Reply-To: <20260813-memcgid-objcg-v1-1-83d21c685b77@tencent.com>
Date: Thu, 13 Aug 2026 23:09:37 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BAB0F796-0F4E-451A-90F8-6C5DD6D90AAA@icloud.com>
References: <20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com>
 <20260813-memcgid-objcg-v1-1-83d21c685b77@tencent.com>
To: BINGFANG GUO <bingfangguo@tencent.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDA3OCBTYWx0ZWRfXxxd/WxZiD1iw
 dH0g5DjMzi+QS5gBZ+u+blKNwKZeabZoXQdz7iBIQPmSnYNsQRLlbmrPRRcRZWbrINbkQnudw3Z
 cszDcIkusB6ToQN0ukZZbjiyt5Bj0qn8HnPIFPGDehl7vDGbPa03BxNHPTwrCB9+Es/5kQlOTNS
 cj/NodjVSbxfu+EMbNmnRYEDja3y1wDTV20THsYmUfSMYjz0sLUBbHj6G/ITxBYrEZPC/PY2fBE
 h6y3IDM1VoEtjKWXKmCEkwEzj+XXbt9t1ZG7v6B55AdciSy2eouR9dw5v/YcAWJCM4KF8UMt85E
 h1zwHpGHqxjTGJ8WRw/vLe2YyMuJS8LUUPFxs/N9Q==
X-Proofpoint-GUID: tepSP286IyF9e0f7YrGHgd1SSVY3Z8ea
X-Proofpoint-ORIG-GUID: tepSP286IyF9e0f7YrGHgd1SSVY3Z8ea
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_03,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 clxscore=-2147483648 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.22.0-2601150000 definitions=main-2608130078



> 2026=E5=B9=B48=E6=9C=8813=E6=97=A5 16:52=EF=BC=8CBingfang Guo via B4 =
Relay <devnull+bingfangguo.tencent.com@kernel.org> =E5=86=99=E9=81=93=EF=BC=
=9A
>=20
> From: Bingfang Guo <bingfangguo@tencent.com>
>=20
> In the previous series by Muchun Song and Qi Zheng, folios are charged
> to the objcg and reparented as the memcg offlines. Same can be done to
> memcg private ID and its main user: swap entries. Make the memcgid
> xarray hold a pointer and a reference to an objcg of the memcg, which =
is
> used to find the memcg (or its parent) later on. The online state now
> pins the objcg instead of the css, so swapped out pages no longer pin
> the dying memcg.
>=20
> The id reference held by the online state is released in =
css_released()
> after reparenting instead of in css_offline(). This is the key
> invariant the rest of the series builds on: css_offline() runs while
> other css references may still be held, but css_released() only runs
> once the last reference is gone, so a caller holding a memcg reference
> can always count on the id refcount being alive. To prevent races
> between memcgid put in css offline and memcgid get, the release is put
> off till css_released, which could delay the release of the memcgid =
and
> the objcg it pins, but overall it should be fine.
>=20
> After reparenting, the objcg points to a live ancestor, so
> mem_cgroup_from_private_id() now returns that ancestor instead of the
> memcg the ID originally belonged to. Callers that need the exact memcg
> are fixed in patch 5.
>=20
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
> include/linux/memcontrol.h | 10 +++--
> mm/memcontrol.c            | 99 =
++++++++++++++++++++++++++++++++--------------
> 2 files changed, 76 insertions(+), 33 deletions(-)
>=20
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8170bb8066a22..c33ec7efad50b 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -191,6 +191,7 @@ struct obj_cgroup {
> struct rcu_head rcu;
> };
> bool is_root;
> + refcount_t id_ref;
> };
>=20
> /*
> @@ -202,8 +203,8 @@ struct obj_cgroup {
> struct mem_cgroup {
> struct cgroup_subsys_state css;
>=20
> - /* Private memcg ID. Used to ID objects that outlive the cgroup */
> - struct mem_cgroup_private_id id;
> + /* The objcg holding private memcg ID. */
> + struct obj_cgroup *id_objcg;
>=20
> /* Accounted resources */
> struct page_counter memory; /* Both v1 & v2 */
> @@ -270,6 +271,9 @@ struct mem_cgroup {
> #endif
> int kmemcg_id;
>=20
> + /* Private memcg ID. Used to ID objects that outlive the cgroup */
> + int id;
> +
> struct memcg_vmstats_percpu __percpu *vmstats_percpu;
>=20
> #ifdef CONFIG_CGROUP_WRITEBACK
> @@ -820,7 +824,7 @@ static inline unsigned short =
mem_cgroup_private_id(struct mem_cgroup *memcg)
> if (mem_cgroup_disabled())
> return 0;
>=20
> - return memcg->id.id;
> + return memcg->id;
> }
> struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8319ad8c5c23a..5f30e76ee93d7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3697,7 +3697,7 @@ static void memcg_online_kmem(struct mem_cgroup =
*memcg)
>=20
> static_branch_enable(&memcg_kmem_online_key);
>=20
> - memcg->kmemcg_id =3D memcg->id.id;
> + memcg->kmemcg_id =3D memcg->id;
> }
>=20
> static void memcg_offline_kmem(struct mem_cgroup *memcg)
> @@ -3956,25 +3956,40 @@ static =
DEFINE_XARRAY_ALLOC1(mem_cgroup_private_ids);
>=20
> static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
> {
> - if (memcg->id.id > 0) {
> - xa_erase(&mem_cgroup_private_ids, memcg->id.id);
> - memcg->id.id =3D 0;
> + if (memcg->id > 0) {
> + xa_erase(&mem_cgroup_private_ids, memcg->id);
> + memcg->id =3D 0;
> }
> }
>=20
> -static inline void mem_cgroup_private_id_put(struct mem_cgroup =
*memcg, unsigned int n)
> +/**
> + * @objcg: the objcg returned by mem_cgroup_private_id_objcg
> + * @id: the corresponding memcg private id
> + */
> +static void __mem_cgroup_private_id_put(struct obj_cgroup *objcg,
> + unsigned short id, unsigned int n)
> {
> - if (refcount_sub_and_test(n, &memcg->id.ref)) {
> - mem_cgroup_private_id_remove(memcg);
> + struct obj_cgroup *objcg_free;
>=20
> - /* Memcg ID pins CSS */
> - css_put(&memcg->css);
> + if (refcount_sub_and_test(n, &objcg->id_ref)) {
> + objcg_free =3D xa_erase(&mem_cgroup_private_ids, id);
> + VM_WARN_ON(objcg_free !=3D objcg);
> +
> + /* Memcg ID pins the objcg */
> + obj_cgroup_put(objcg);
> }
> }
>=20
> +static inline void mem_cgroup_private_id_put(struct mem_cgroup =
*memcg, unsigned int n)
> +{
> + __mem_cgroup_private_id_put(memcg->id_objcg, memcg->id, n);
> +}
> +
> struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup =
*memcg, unsigned int n)
> {
> - while (!refcount_add_not_zero(n, &memcg->id.ref)) {
> + struct obj_cgroup *objcg =3D memcg->id_objcg;
> +
> + while (!refcount_add_not_zero(n, &objcg->id_ref)) {
> /*
> * The root cgroup cannot be destroyed, so it's refcount must
> * always be >=3D 1.
> @@ -3984,6 +3999,7 @@ struct mem_cgroup =
*mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
> break;
> }
> memcg =3D parent_mem_cgroup(memcg);
> + objcg =3D memcg->id_objcg;
> }
> return memcg;
> }
> @@ -3996,8 +4012,29 @@ struct mem_cgroup =
*mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
>  */
> struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
> {
> + struct obj_cgroup *objcg;
> WARN_ON_ONCE(!rcu_read_lock_held());
> - return xa_load(&mem_cgroup_private_ids, id);
> +
> + objcg =3D xa_load(&mem_cgroup_private_ids, id);
> + if (!objcg)
> + return NULL;
> +
> + return obj_cgroup_memcg(objcg);
> +}
> +
> +static struct mem_cgroup *mem_cgroup_take_from_private_id(unsigned =
short id, unsigned int n)
> +{
> + struct obj_cgroup *objcg;
> + struct mem_cgroup *memcg;
> +
> + objcg =3D xa_load(&mem_cgroup_private_ids, id);
> + if (!objcg)
> + return NULL;
> +
> + memcg =3D get_mem_cgroup_from_objcg(objcg);
> +
> + __mem_cgroup_private_id_put(objcg, id, n);
> + return memcg;
> }
>=20
> struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
> @@ -4098,7 +4135,7 @@ static struct mem_cgroup =
*mem_cgroup_alloc(struct mem_cgroup *parent)
> if (!memcg)
> return ERR_PTR(-ENOMEM);
>=20
> - error =3D xa_alloc(&mem_cgroup_private_ids, &memcg->id.id, NULL,
> + error =3D xa_alloc(&mem_cgroup_private_ids, &memcg->id, NULL,
> XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
> if (error)
> goto fail;
> @@ -4243,9 +4280,10 @@ static int mem_cgroup_css_online(struct =
cgroup_subsys_state *css)
>   FLUSH_TIME);
> lru_gen_online_memcg(memcg);
>=20
> - /* Online state pins memcg ID, memcg ID pins CSS */
> - refcount_set(&memcg->id.ref, 1);
> - css_get(css);
> + /* CSS pins memcg ID, memcg ID pins obj cgroup */
> + memcg->id_objcg =3D memcg->nodeinfo[0]->objcg;
> + refcount_set(&memcg->id_objcg->id_ref, 1);
> + obj_cgroup_get(memcg->id_objcg);
>=20
> /*
> * Ensure mem_cgroup_from_private_id() works once we're fully online.
> @@ -4257,7 +4295,7 @@ static int mem_cgroup_css_online(struct =
cgroup_subsys_state *css)
> * publish it here at the end of onlining. This matches the
> * regular ID destruction during offlining.
> */
> - xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
> + xa_store(&mem_cgroup_private_ids, memcg->id, objcg, GFP_KERNEL);

Sashiko pointed out that objcg here is pointing to the wrong node here.
I made a mistake here while rebasing the patch set. Also the problem =
reported by syzbot and in
patch 2 is also caused by this=E2=80=A6

It should be like this:

@@ -4257,7 +4295,7 @@ static int mem_cgroup_css_online(struct =
cgroup_subsys_state *css)
         * publish it here at the end of onlining. This matches the
         * regular ID destruction during offlining.
         */
-       xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, =
GFP_KERNEL);
+       xa_store(&mem_cgroup_private_ids, memcg->id, memcg->id_objcg, =
GFP_KERNEL);

But it also says that it could go wrong if node 0 is not present on =
sparse NUMA setups, so I
think it might be better to just use the last objcg set up above:

@@ -4294,7 +4295,7 @@ static int mem_cgroup_css_online(struct =
cgroup_subsys_state *css)
        lru_gen_online_memcg(memcg);
=20
        /* CSS pins memcg ID, memcg ID pins obj cgroup */
-       memcg->id_objcg =3D memcg->nodeinfo[0]->objcg;
+       memcg->id_objcg =3D objcg;
        refcount_set(&memcg->id_objcg->id_ref, 1);
        obj_cgroup_get(memcg->id_objcg);

>=20
> return 0;
> free_objcg:
> @@ -4308,8 +4346,6 @@ static void mem_cgroup_css_offline(struct =
cgroup_subsys_state *css)
> lru_gen_offline_memcg(memcg);
>=20
> drain_all_stock(memcg);
> -
> - mem_cgroup_private_id_put(memcg, 1);
> }
>=20
> static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
> @@ -4318,6 +4354,9 @@ static void mem_cgroup_css_released(struct =
cgroup_subsys_state *css)
>=20
> invalidate_reclaim_iterators(memcg);
> lru_gen_release_memcg(memcg);
> +
> + mem_cgroup_private_id_put(memcg, 1);

Sashiko says that if memcg onlining fails early, this could result in =
null pointer dereference.
I think we can fix it like this since mem_cgroup_private_id_put is only =
used in css releasing:

@@ -3980,9 +3980,13 @@ static void __mem_cgroup_private_id_put(struct =
obj_cgroup *objcg,
        }
 }
=20
-static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, =
unsigned int n)
+static inline void mem_cgroup_private_id_release(struct mem_cgroup =
*memcg, unsigned int n)
 {
+       if (!memcg->id_objcg)
+               return;
+
        __mem_cgroup_private_id_put(memcg->id_objcg, memcg->id, n);
+       memcg->id_objcg =3D NULL;
 }
=20
 void mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int =
n)
@@ -4367,9 +4371,7 @@ static void mem_cgroup_css_released(struct =
cgroup_subsys_state *css)
=20
        invalidate_reclaim_iterators(memcg);
        lru_gen_release_memcg(memcg);
-
-       mem_cgroup_private_id_put(memcg, 1);
-       memcg->id_objcg =3D NULL;
+       mem_cgroup_private_id_release(memcg, 1);
 }
=20
 static void mem_cgroup_css_free(struct cgroup_subsys_state *css)

> + memcg->id_objcg =3D NULL;
> }
>=20
> static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
> @@ -5651,19 +5690,19 @@ void __mem_cgroup_uncharge_swap(unsigned short =
id, unsigned int nr_pages)
> {
> struct mem_cgroup *memcg;
>=20
> - rcu_read_lock();
> - memcg =3D mem_cgroup_from_private_id(id);
> - if (memcg) {
> - if (!mem_cgroup_is_root(memcg)) {
> - if (do_memsw_account())
> - page_counter_uncharge(&memcg->memsw, nr_pages);
> - else
> - page_counter_uncharge(&memcg->swap, nr_pages);
> - }
> - mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> - mem_cgroup_private_id_put(memcg, nr_pages);
> + memcg =3D mem_cgroup_take_from_private_id(id, nr_pages);
> + if (!memcg)
> + return;
> +
> + if (!mem_cgroup_is_root(memcg)) {
> + if (do_memsw_account())
> + page_counter_uncharge(&memcg->memsw, nr_pages);
> + else
> + page_counter_uncharge(&memcg->swap, nr_pages);
> }
> - rcu_read_unlock();
> + mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> +
> + mem_cgroup_put(memcg);
> }
>=20
> long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>=20
> --=20
> 2.43.7
>=20
>=20

