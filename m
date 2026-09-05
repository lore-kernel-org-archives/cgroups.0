Received: from outbound.qs.icloud.com (qs-2002l-snip4-11.eps.apple.com [57.103.87.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB4823EAAA
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 19:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.87.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788637498; cv=none; b=gP/PK5ADuriFbKwlMtSbz5+vTt/STW/8ciPrXZZ3PebjS+KbIUQtoOaaAARMsdNlyj7VKVoUIJSFwrH92baURf/tdpRByU5DFgka0DWuOi5w5WFnVZPAmi3LSnrYS72QC01mAaktf+FwGm3iBTTWgtGz4sXIk9FBGWYvZ3fvjHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788637498; c=relaxed/simple;
	bh=eP98WoQdGuRZV4yLqaRc2FbsUMGPZfeXMjHjcDPSBHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PGwtvoI/PanhjQptHT0ZY7eS2QSTqeyJNoNfoUm4+Us/Z1mpggU+MwGhmfMha8Z/YYHVoLydMd9LrS9c8wJkSWM4RlO8+4XqzlFeyW+SjXP/rE0NbpmF+Kmyskbx7HKLG4531JwLoBEADii3wI03tSbJZcr3TDygsYtwhXgS3sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=MyoG0xMw; arc=none smtp.client-ip=57.103.87.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="MyoG0xMw"
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 634DE180021D;
	Sat, 05 Sep 2026 19:44:54 +0000 (UTC)
X-ICL-RepId: 01a0731a-3c74-7ec7-b86a-3a754c9da115
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQtPHV4PRQBAC1YGVBcOVk1bHlQYWCtbE1UXRgkZCF0dGR5XUF4IXh9MHB0OWAYSAlpFAlQXA1ccVkVcGEMJXQVXHB0cREVbE1UXRgkZCF0dGQhHHwowA0IOVgNDB0UALRkcV1BeCF4fTBwdDlgGEh1QHA5RVhtKCHJAfS9VNH0ScDR6F3cpez5+PnIjcCxnPxQ1cF0JS0YJSR0OBFQHXQVd
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788637495; x=1791229495; bh=vgZ1W85NEnq1A+vi0kFHRhJG3UFYJ5R0koCjzl4BPsg=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=MyoG0xMwKrXYmaS9RkvxbTKHLUfHOFg60wR31WAACVAlc7rB06PCF9xwpyoSH9B15CBd7WFKGOUdugPhSpl9DBmmIzfa0uJGILU1I6Ev7NojIWb684WMM0+A5SxvCdXN9eHED5VphoCWDW6giA4Nuj4c659gnT3yTmXyyMTbe5RLq0T5OvNqItAaiIIJ2/zgwuGfkgHvAZ9yqjWwUNC0eMI7PjsQaS21IfA+I0FvyXyq60V5KjOzLJWlFHhVdgjmv+f1g32x5uYUQV1vBtwFQWFDp4GGEFzH4kuaI2k/qIVBQ58HnYzQInndBtGvanhr5UdUKDfLAPwspk+qaqxJNw==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 67D5D180022B;
	Sat, 05 Sep 2026 19:44:48 +0000 (UTC)
Date: Sun, 6 Sep 2026 03:44:43 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: bingfangguo@tencent.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [PATCH RFC v2 5/6] mm/memcg: move memcg private ID refcount to
 objcg
Message-ID: <apxxK8NBb_ObILIz@BINGFANGGUO-MC0>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-5-8edd7f7a7251@tencent.com>
 <bfbfbed6-2946-4e85-830b-7a2505f316db@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bfbfbed6-2946-4e85-830b-7a2505f316db@linux.dev>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIyMCBTYWx0ZWRfXzQpnDgQ1a+ir
 cJpYO9COsrNB0sW+5uKHBjzmZB3QGFC+STgvt2k3rBE28uFtkGRYvebHHLCBggBfinRzoatljme
 /SEPtYNCF5UEu8h3v5jljkQoVAkqUbAEyJgAZSv5XlwvfmvnlwBGiiDo1+KKXmaNo6vKWB0VWxS
 ddKRzbGb8SXGbqB966OtZew0dBZHc5UJB7JSaiMYTjF1Ol1rZahAjfDYs2yW00t9LWFFAC9WKxk
 S2DMhdZbZhSNZdTKAbj3RLfi9H04lkrP087DDul/0/LV161q4yXm5TDNZss2GQrKJ65hFnr2i9O
 23pX6t/eIGukeIZlXV7v7U1oXAOymzPOJ6Psatc7XhlveOHyJftrg0PzydsLiQ=
X-Proofpoint-GUID: jsMkpzEOxl_tdh33T3SnsJKtZQ4lcWV5
X-Authority-Info-Out: v=2.4 cv=f8hFxeyM c=1 sm=1 tr=0 ts=6a9c7136
 cx=c_apl:c_pps:t_out a=bsP7O+dXZ5uKcj+dsLqiMw==:117
 a=bsP7O+dXZ5uKcj+dsLqiMw==:17 a=8nJEP1OIZ-IA:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=UXXNyEDf_6Bw8tBy6J0A:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-ORIG-GUID: jsMkpzEOxl_tdh33T3SnsJKtZQ4lcWV5
X-JNJ: AAAAAAABbwEHuEKc5p1z86aCudLojf1tUZXKlml7AnkP6o7v66FGMgH0lAxwJnz3NOjz/XAS+KjSV3qBWm0XrLoR9ae8pdwZzhNvt1DlaAPvzKAgEKhVKG3c7cpdTVIYKkU06ErYNb1881llKB6nPpSiyUHt5wqK3tr3Tt1SAeqBe/++QuUcf4AGe5PHYiAJ2qvXuBQ+GiLWIBDLZ8RF01ITTn9DvUg5+TT+5iRTs/QHho5LJ2ldtn/Z8jt7y7IuUeDcVhFuIPXfRrbzVLS3qmpBQLwiMTvCDgjYcxfmfRZ0bkVeHSyVaxrF1LSvGCDJOFlLSjsO7oByow6iHPD/TKoHmgoG17viGop9EjT0nNWT1vE0sh0UwVGSFmq7j7teh7c85qoTIAF1tlyk7CbwnzzYowEtwveedK+fumnKr7W9Zxxsn+0nRtjoHVnGmM9qwfmWHLx7+xmrKmIvxjjEYzztxLKReLkaSyXUYzTvC9j7vy0dFv7F586kFVQBVE6pq8pmc+TSqJ3uJz3uc3grslZA8qP7bidnkv6EtTmks8oLXPqOcM7smEpQKsqRtFaGCI2MtyYkqmRYPlV+To/Mb4A5Y1X65EktBW+BshM09PWZyHDXHM5aJkaCfC2xICYNYSOsUSKpBtW9lQCkrVRtDdIV2zqpnTXuTB6tEo+HFxhttEnJvRJiOFJs2E+R4GySs0nr9GXqfq8sj3N8JkDsg0WQ452hxZI5yIgtifuLnhfD352or7RJ0zEQhaG4c8mHXP4BEi5tvDmgravhK6EzfMKnNt+OXTUnbTrnSISv+rYnPg1r2uN3wIuLxKmSTlueD48eLqkUY063u/OWrl7Xda63YqUOjt9Dqv4Y7mHGYysYfeJU/GErTazFnSA8y4jNiqKVOu4Cbv8Oav7cwWjCSJJo0kFF76I7jB1snYETeRgnP/QtZ2syvDAZXiOaykW0ctqbny/yB3CfcfNpcnVpNmRcz1inR7f
 WI28fAFIf+uK7biakQ/ocl7fSxIWml0MRI+6Bd946SsihZ0Y9MGvjBigxnGPGHqUV1MI7GSKQhk/VW2x7drQsbfiDPV3W17bbmepZR7g5zx7wT+2DFDuOX7O1V4mZDzdk/SJsxw3tK3Q6oUeLsGcuKAjbJtl0Pu7idhv4AkeicbJkzNxJ0WvVFm5Rm2vNkoQ+WsPZXLSrYpYqUudAaDp3cGLOg+NxwJsuV04BSKieDdFtsWG6p5yui/DbdkEOXg4B3jUNagV2cdQQlTZ1n5RorcJ4vwOEACR/v40yPKHTRdmkjifsxtC/9Lexm5bB2x27pHMPmApTCFGskS2rlRjKhFSkuiHKjDTwTihr7jkKH3suTtJtHGy18UTG0HyZNS0r9wxfWjfv060Ti0RDYRUPS66C9pCY2vZ2sH072+2FbvRqiZd5E7YkRzSrVBq5wyqAgCXu5lubaBNjj6MmNFATleG3Ld9MhNPsUuZroLUgHnZ4Vc64Nt8XV32o

On Sat, Sep 05, 2026 at 04:46:30PM +0800, Muchun Song wrote:
> 
> 
> On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > The memcg private ID is used by objects that can't afford storing a
> > whole pointer and can outlive memcgs to track the memcg (notably swap
> > entries). The current design holds a refcount to the css, preventing the
> > memcg from being freed.  This patch unbinds the lifetime of memcgid from
> > the memcg so it can be freed.
> > 
> > The idea is to move the refcount of memcgid to one of the memcg's objcg
> > and hold a pointer and a reference to the objcg in the global memcgid
> > xarray. No more css reference to the memcg so swapped out pages no
> > longer pin the dying memcg.
> > 
> > When retrieving the online memcg from the id, the objcg is taken out of
> > the xarray, and resolves to the online parent memcg naturally, which is
> > exactly what is expected in normal swapin folio charging path.  For swap
> > uncharging, the objcg is used for putting the id refcount and getting
> > the online ancestor in one go.
> > 
> > The exceptions are list_lru and workingset recent test, which require
> > exact the memcg the id points to. Those callers are fixed in the next
> > patch.
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >   include/linux/memcontrol.h | 15 +++++-----
> >   mm/memcontrol.c            | 71 +++++++++++++++++++++++++++++++---------------
> >   2 files changed, 55 insertions(+), 31 deletions(-)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index f227348a3f24a..eafc817ff244c 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -66,11 +66,6 @@ struct mem_cgroup_reclaim_cookie {
> >   #define MEM_CGROUP_ID_SHIFT	16
> > -struct mem_cgroup_private_id {
> > -	int id;
> > -	refcount_t ref;
> > -};
> > -
> >   struct memcg_vmstats_percpu;
> >   struct memcg1_events_percpu;
> >   struct memcg_vmstats;
> > @@ -173,6 +168,7 @@ struct obj_cgroup {
> >   	struct percpu_ref refcnt;
> >   	struct mem_cgroup *memcg;
> >   	atomic_t nr_charged_bytes;
> > +	refcount_t memcgid_ref;
> 
> Since all the interfaces now include the private field, the name I'd
> recommend here is private_id_refcnt.
> 
> >   	union {
> >   		struct list_head list; /* protected by objcg_lock */
> >   		struct rcu_head rcu;
> > @@ -189,8 +185,8 @@ struct obj_cgroup {
> >   struct mem_cgroup {
> >   	struct cgroup_subsys_state css;
> > -	/* Private memcg ID. Used to ID objects that outlive the cgroup */
> > -	struct mem_cgroup_private_id id;
> > +	/* The objcg holding private memcg ID. */
> > +	struct obj_cgroup *id_objcg;
> 
> By the same logic, rename it to private_id_objcg.
> 
> >   	/* Accounted resources */
> >   	struct page_counter memory;		/* Both v1 & v2 */
> > @@ -255,6 +251,9 @@ struct mem_cgroup {
> >   #endif
> >   	int kmemcg_id;
> > +	/* Private memcg ID. Used to ID objects that outlive the cgroup */
> > +	int id;
> 
> Same, private_id. To better reflect the range that this private ID can
> express, I suggest defining it as an unsigned short.
> 

Sure, I will take that in the next version. It's more consistent
and clear that way.

> > +
> >   #ifdef CONFIG_CGROUP_WRITEBACK
> >   	struct list_head cgwb_list;
> >   #endif
> > @@ -810,7 +809,7 @@ static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
> >   	if (mem_cgroup_disabled())
> >   		return 0;
> > -	return memcg->id.id;
> > +	return memcg->id;
> >   }
> >   struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index f0503a1e5492d..38d2b00657a7a 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3773,7 +3773,7 @@ static void memcg_online_kmem(struct mem_cgroup *memcg)
> >   	static_branch_enable(&memcg_kmem_online_key);
> > -	memcg->kmemcg_id = memcg->id.id;
> > +	memcg->kmemcg_id = memcg->id;
> >   }
> >   static void memcg_offline_kmem(struct mem_cgroup *memcg)
> > @@ -4032,19 +4032,23 @@ static DEFINE_XARRAY_ALLOC1(mem_cgroup_private_ids);
> >   static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
> >   {
> > -	if (memcg->id.id > 0) {
> > -		xa_erase(&mem_cgroup_private_ids, memcg->id.id);
> > -		memcg->id.id = 0;
> > +	if (memcg->id > 0) {
> > +		xa_erase(&mem_cgroup_private_ids, memcg->id);
> > +		memcg->id = 0;
> >   	}
> >   }
> > -static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> > +static void __mem_cgroup_private_id_put(struct obj_cgroup *objcg,
> > +		unsigned short id, unsigned int n)
> >   {
> > -	if (refcount_sub_and_test(n, &memcg->id.ref)) {
> > -		mem_cgroup_private_id_remove(memcg);
> > +	struct obj_cgroup *objcg_free;
> > -		/* Memcg ID pins CSS */
> > -		css_put(&memcg->css);
> > +	if (refcount_sub_and_test(n, &objcg->memcgid_ref)) {
> > +		objcg_free = xa_erase(&mem_cgroup_private_ids, id);
> > +		VM_WARN_ON(objcg_free != objcg);
> > +
> > +		/* Memcg ID pins the objcg */
> > +		obj_cgroup_put(objcg);
> >   	}
> >   }
> > @@ -4055,18 +4059,20 @@ static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n
> >    */
> >   static struct mem_cgroup *mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> >   {
> > -	struct mem_cgroup *memcg;
> > +	struct mem_cgroup *memcg = NULL;
> > +	struct obj_cgroup *objcg;
> >   	rcu_read_lock();
> > -	memcg = mem_cgroup_from_private_id(id);
> > -	if (!memcg)
> > +	objcg = xa_load(&mem_cgroup_private_ids, id);
> > +	if (unlikely(!objcg))
> >   		goto out;
> > -	__mem_cgroup_private_id_put(memcg, n);
> > -
> > +	memcg = obj_cgroup_memcg(objcg);
> >   	while (memcg_is_dying(memcg) || !mem_cgroup_tryget(memcg))
> >   		memcg = parent_mem_cgroup(memcg);
> > +	__mem_cgroup_private_id_put(objcg, id, n);
> > +
> >   out:
> >   	rcu_read_unlock();
> >   	return memcg;
> > @@ -4074,12 +4080,17 @@ static struct mem_cgroup *mem_cgroup_private_id_put(unsigned short id, unsigned
> >   static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
> >   {
> > -	__mem_cgroup_private_id_put(memcg, 1);
> > +	__mem_cgroup_private_id_put(memcg->id_objcg, memcg->id, 1);
> >   }
> >   struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
> >   {
> > -	while (!refcount_add_not_zero(n, &memcg->id.ref)) {
> > +	struct obj_cgroup *objcg;
> > +
> > +	rcu_read_lock();
> 
> I think we need to make it mandatory here for the caller to hold the RCU
> lock.
> Otherwise, if we don't enforce that, we would have to require that the
> passed
> memcg holds at least one reference count. But either way-whether it's
> holding
> the RCU lock or holding a reference count-the RCU read lock you added here
> is
> useless. I suggest changing it to:
> 
>     lockdep_assert_once(rcu_read_lock_held());

That's a good idea! I was thinking that offlined memcgs with css
refcount held might cause issues, which proves to be wrong.  So
RCU lock will be enough here!

> 
> Of course, I could be missing your point here, so please correct me if I'm
> wrong.
> 
> > +	objcg = memcg->id_objcg;
> 
> BTW, as long as the memcg isn't released, the objcg won't be released
> either, because the memcg holds a reference to the objcg.
> 

Oh yes... I missed that point. Thanks for your reminding!  The
RCU lock can be removed from here.

> > +
> > +	while (!refcount_add_not_zero(n, &objcg->memcgid_ref)) {
> >   		/*
> >   		 * The root cgroup cannot be destroyed, so it's refcount must
> >   		 * always be >= 1.
> > @@ -4089,7 +4100,10 @@ struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
> >   			break;
> >   		}
> >   		memcg = parent_mem_cgroup(memcg);
> > +		objcg = memcg->id_objcg;
> >   	}
> > +
> > +	rcu_read_unlock();
> >   	return memcg;
> >   }
> > @@ -4101,8 +4115,14 @@ struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
> >    */
> >   struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
> >   {
> > +	struct obj_cgroup *objcg;
> >   	WARN_ON_ONCE(!rcu_read_lock_held());
> > -	return xa_load(&mem_cgroup_private_ids, id);
> > +
> > +	objcg = xa_load(&mem_cgroup_private_ids, id);
> > +	if (!objcg)
> > +		return NULL;
> > +
> > +	return obj_cgroup_memcg(objcg);
> >   }
> >   struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
> > @@ -4203,7 +4223,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
> >   	if (!memcg)
> >   		return ERR_PTR(-ENOMEM);
> > -	error = xa_alloc(&mem_cgroup_private_ids, &memcg->id.id, NULL,
> > +	error = xa_alloc(&mem_cgroup_private_ids, &memcg->id, NULL,
> >   			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
> >   	if (error)
> >   		goto fail;
> > @@ -4348,9 +4368,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
> >   				   FLUSH_TIME);
> >   	lru_gen_online_memcg(memcg);
> > -	/* Online state pins memcg ID, memcg ID pins CSS */
> > -	refcount_set(&memcg->id.ref, 1);
> > -	css_get(css);
> > +	/* CSS pins memcg ID, memcg ID pins obj cgroup */
> > +	memcg->id_objcg = objcg;
> > +	refcount_set(&memcg->id_objcg->memcgid_ref, 1);
> > +	obj_cgroup_get(memcg->id_objcg);
> >   	/*
> >   	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
> > @@ -4362,7 +4383,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
> >   	 * publish it here at the end of onlining. This matches the
> >   	 * regular ID destruction during offlining.
> >   	 */
> > -	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
> > +	xa_store(&mem_cgroup_private_ids, memcg->id, memcg->id_objcg, GFP_KERNEL);
> >   	return 0;
> >   free_objcg:
> > @@ -5832,7 +5853,11 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
> >   	rcu_read_lock();
> >   	memcg = mem_cgroup_private_id_put(id, nr_pages);
> >   	if (memcg) {
> > -		if (!mem_cgroup_is_root(memcg)) {
> > +		/*
> > +		 * If the memcg was offline and reparented to root, swap needs
> > +		 * uncharging as well. We check this by comparing the memcgid.
> > +		 */
> > +		if (!mem_cgroup_is_root(memcg) || id != mem_cgroup_private_id(memcg)) {
> 
> Swap accounting should be based on whether the associated objcg is a root
> objcg,
> rather than whether its current memcg is the root memcg. Since an objcg may
> be
> reparented while retaining its original root status, using
> obj_cgroup_is_root()
> provides a stable criterion. Applying the same criterion in both the charge
> and
> uncharge paths makes the accounting symmetric and avoids having to infer the
> original state through memcg ID comparisons.

I certainly agree. A really clean way!

So as long as we are good with getting objcg from the ID, we can
move to that.

After the change, we can use obj_cgroup_from_private_id() if the
original memcg's root status or parent is needed. And
mem_cgroup_from_private_id() can be used if we'd like to get
exactly the same memcg the ID refers to. Returning NULL indicates
that it's not online anymore.

Regards,
Bingfang

> 
> Muchun,
> Thanks.
> 
> >   			if (do_memsw_account())
> >   				page_counter_uncharge(&memcg->memsw, nr_pages);
> >   			else
> > 
> 

