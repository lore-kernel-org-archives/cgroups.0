Received: from outbound.mr.icloud.com (mr-2004f-snip4-11.eps.apple.com [57.103.69.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EA65208AC
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 18:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.69.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789757234; cv=none; b=qqPY92dQOr7lS3MHopYqD/xnVE6tCTnIiSnKBsOfi1S210BfJPKplxoM35rljs8qLyahcl7jUB6ILG99lEvnkZLGrAeQF+VC48bwsdLbb6xGFXrEqyOy7ESbqWz9AGjNnkP0luUX/AjLb+eR5gZdYXYtH0z0YtVo/AETPhMGDOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789757234; c=relaxed/simple;
	bh=FWMZubCus3Ppx6yn7MF3pFHO8/amHPYcvVx8qC1eu2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jE0Ku06sccJ+md3RwUrM8wKY8IViNMYqQkvn1dwVxiLx2lDQbDOL4khQedvjpT+ftWeqZpOhLGM0Si1nyW13+0tzstihVoN5WzndE0vaaI5jkulL6S5nHZe7N1oxVxFvJwCHf4jwvOGPl9JvUr3sJVJa6jjwhwEaSuMhWNh2O/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=ubOPqoMp; arc=none smtp.client-ip=57.103.69.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="ubOPqoMp"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-5 (Postfix) with ESMTPS id 6A3DE180060B;
	Fri, 18 Sep 2026 18:47:04 +0000 (UTC)
X-ICL-RepId: 01a0b5d7-f56b-7dff-a0c5-f60fe72f6cd7
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhOAEMGWQdeCEwCQwZYClBcHA4PUQxHH3kRUAFYHlZeWhdeTVEPDxlaFFwYU0VRH1RYQQ4KWgtQUR1fAgoERwRbF0YDU0VfAhcRUAFYHlZeWhdeTUcfQE1iSQFaGVscQBdKbk1TDw8ZWhRcGFNFUR9UWF4EU1YOEUhKcQtuD38CZkB5CG40YzB7MX0qcSp8N34tfEB6KAJOGQxKHVJWWxNVF0YJ
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789757229; x=1792349229; bh=98HzfH5LQbU4THhLy0oNL83Rvid2RqxSwBxj16wy9gY=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=ubOPqoMp/atbHlEh7GHc6fkUdCug91L6fesDjA6beg98TEIkbxnkqW64zNi7QS6KThnW9mX7aZMSjP1gGcnfiayB7UxtrBp13xWDJZ4cOdoKSjiz6ubNQabPlSWUBN8ra7RTPRw2j5SB+dOvag9cYenoZrSiKzW8npirQ3+Qtc051R1HO4by91xgU8cBZQmdWh2dY6ICzjBcjK0PAjZS2Op6OT+sWH/hw9fMmSCaUa9TZ/A7mE7foRMHAuLnrJbV5Pc6a1m4fkRakdF4J3hAMfVAnEVK8Sdd0FYBwcz3wsW5fEvigJCrBokq3gBBRnkGdXqVDd3mKQ2v617TD50CkQ==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.156.200.36])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-5 (Postfix) with ESMTPSA id 91FE918002DA;
	Fri, 18 Sep 2026 18:46:56 +0000 (UTC)
Date: Sat, 19 Sep 2026 02:46:52 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: bingfangguo@tencent.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] memcg: manipulate memcg private ID references by ID
Message-ID: <aq2BfYdMr_8JeY_Q@BINGFANGGUO-MC0>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
 <aq1_Qhid7-62pHcW@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq1_Qhid7-62pHcW@linux.dev>
X-Proofpoint-GUID: DGpDKgWQtL7ACZVDH7PUneR8AkuGP2kz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDI3MCBTYWx0ZWRfX9q2xu2/8WnDX
 gJD8ZkG00jeCoe0rzAEw64JkJfAcT/YyR4S7u9g7wA3hvTRlslRE6UDJoJ9VPp0PXHXmb4XDL+C
 8mGY5kZMHjiO6No9vsrzNwD97RhtcJWboI3JNyPEkJ8oe2roJG2jpf+15ic8/xEwbFuhKD0ARll
 rVXTo4Q73JIA2Wmgn9+RBxHFDSLLbkzXPe29V8OSpjAoRaP98aCjfNMDwL3u97w9DyV1QotNuRD
 rJkSefYNP1zBrG/GcsAGPOR/CMn0An2HDJJABCSPSrg+PwAsZHkCR8DQU1YGNc4ZGN8A4Klc+YD
 Cmp9YT+xh1WsDWZFR5K92G6vmBsyJSVmOEdm076ofPXX/FdY2mpfhVPwyy1s6I=
X-Authority-Info-Out: v=2.4 cv=JKs2csKb c=1 sm=1 tr=0 ts=6aad872b
 cx=c_apl:c_pps:t_out a=9mRn2PO/+PIrVdEbaIuMPg==:117
 a=9mRn2PO/+PIrVdEbaIuMPg==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=3QkjYGG84asobQ1p_Z0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: DGpDKgWQtL7ACZVDH7PUneR8AkuGP2kz
X-JNJ: AAAAAAABYKIPoNpk7LFkdDOy59FPlsFhtV47gyHdpz71DZgqVoRGYu0K9OfYrOjcmMz76jCIkiHhnpBl+Ux09JnNE0D6CUc7qYXKgQehab3QS/t+pWFlYlxonXppmqrFyLcdKAgpI953wGS8VqbwbZDK8v2N9P20QQZB7q+Zu1BpwKGOL7IjVyoAGxnWqZPQs0ScRyzq3G59Lo7L6Gr7cnvVlR6Xt5Tt485I5IZ1SQnNbv1bWEFxS+VXzg2quB1Myvm3hpL0DoxTMQ/nUjlp9APywyE5mvlmpiSyN6XGu3CQm3sJiM1JOxsqSj2D7pcwlPqdx1NcLo5R1gaxkHLH3mPl/LC0JbAvosNEpmUZoAcD1Q08pVV2VcHcnHtwQISuFKrUAhrL2871mlzAM79h00oPJ50OicDFEA3TjTvaBOMJZJIYqfJ68HxmhFXk+ZlCMTs1kExBKJqUYVECAsondqho3DAEa34e8i1Oyd2lwpi3e/08tDHw0s7eya3CzildvCMUSg1ADVBvB3NdOSHuvTlsirThOQpTPxgnDiSSmpsn8L3XjgtQEnBOlTpxgXjVScYMZZuI0s0qpJESSBNro5aHzBFJ20eU5BFvhpbtDAF/xOQfQanJ7tIja6PumdARVCZP7HLzhXOLAfN/OyeQx9tTsc3yh8NmbLH0xVW5fl/AYI4jo/Th8aIzW8hXwTnz+kOHrreUJklnMEZuDs5EXt9laTtHbpohB0kmoQ/GdTtAUgcQ+eGqea34QXPXddw/IzAceSa3igZHXn1RiW3XEGAr06Zit8lEzMAG8NOoT5aYP2SUGKVNKZLigb9GNk6oGQLyI2gteG5fyJ0EeSWa+46aJP+6La0vK9/CmQGqBcUsmTHCl5ZIQldeUxOJfvdwWMob+Qtn1ag2+6uQwqYsGCu7SbKllSL1d4KSqVVx2J0pbKS6xYs7jODUWh+zBFE7TE6jo2NqNsBrVFZmkUtf6ClBJV3T6sO
 K304d4Rw6abEawg2hkGqKnVM1+dhbjLSKcVCsv7uZZHHZekt6zbLymL+fzt4JNxV7rynWl/JcS1FiERU0YKJURhXGAwe1MVx+/OL/YbAZaOi1/s/y9rQxXCKLZxF64+gll2OQHABZX4390necIlIrH5dJA2elEG3JWUDMJ7mzn2OZYDKk2FVyCIzR3OBImnD2vEILiYWXcwAiDDfyJpUKpCeFOo4bbQjsWMhIJN3dMOSFcPgPz2sxedTyi2P4vxAp8dDJQjLUaEM6BweRW1xaSAqlqdTs1wI97lxTgMV4ZS1MMj3E0DRBevR/nmTm7G5zJ6a/jUB4gnmbhTcNXjlEkbYE8P2mi0hLnTHoFRy6ZyxO28WAnkiyFkAU0iYIEP9lbhh8v4MkTKhBBwrwqPMEnwpnp9AUGkJBV+pHQPdmJDgJDtyY5vpEchuLclSrH5qJ+EEuviPVHE4=

On Fri, Sep 18, 2026 at 11:14:03AM +0800, Shakeel Butt wrote:
> On Fri, Sep 18, 2026 at 05:18:42PM +0800, Bingfang Guo via B4 Relay wrote:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > This is a preparatory work for moving memcgid from memcg to objcg.
> > 
> > Swap entries retain a private ID rather than a memcg pointer. Once
> > private ID references are moved to objcgs, the ID can also outlive the
> > memcg to which it was originally assigned.  So it's better to make the
> > get and put functions accept the ID itself instead of the memcg.
> > 
> > Rename mem_cgroup_private_id_get_online() to
> > mem_cgroup_private_id_get(), and make it return the ID only.  If the
> > memcg is already dying, the dying memcg will still be used for charging
> > and stats accounting in v2 swap charging path. But they are hierarchical
> > and will be reparented after offlining so it doesn't matter.
> > 
> > Make mem_cgroup_private_id_put() take the ID and resolve the reference
> > holder internally. Convert swap uncharge and charge rollback to release
> > the reference using that ID.  This introduces an extra xarray lookup for
> > now, which will be removed in the final patch.
> > 
> > Separate the online-state reference release into
> > mem_cgroup_private_id_kill(). The offline path already has the memcg
> > pointer and can call the underlying put helper directly.
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >  mm/memcontrol-v1.c |  7 +++----
> >  mm/memcontrol-v1.h |  3 +--
> >  mm/memcontrol.c    | 32 +++++++++++++++++++++++---------
> >  3 files changed, 27 insertions(+), 15 deletions(-)
> > 
> > diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> > index ed015fdd95123..b7f2868885071 100644
> > --- a/mm/memcontrol-v1.c
> > +++ b/mm/memcontrol-v1.c
> > @@ -268,7 +268,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
> >   */
> >  void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
> >  {
> > -	struct mem_cgroup *memcg, *swap_memcg;
> > +	struct mem_cgroup *memcg;
> >  	struct obj_cgroup *objcg;
> >  	unsigned int nr_entries;
> >  	unsigned short private_id;
> > @@ -298,9 +298,8 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
> >  	 * if the ID refers to the root memcg.
> >  	 */
> >  	nr_entries = folio_nr_pages(folio);
> > -	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
> > -	private_id = mem_cgroup_private_id(swap_memcg);
> > -	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
> > +	private_id = mem_cgroup_private_id_get(memcg, nr_entries);
> > +	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
> >  
> >  	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
> >  
> > diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> > index 23be2512702dc..281425273ea97 100644
> > --- a/mm/memcontrol-v1.h
> > +++ b/mm/memcontrol-v1.h
> > @@ -27,8 +27,7 @@ static inline bool mem_cgroup_private_id_is_root(unsigned short id)
> >  	return id == mem_cgroup_private_id(root_mem_cgroup);
> >  }
> >  
> > -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
> > -						    unsigned int n);
> > +unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n);
> >  
> >  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> >  				       struct mem_cgroup *parent, int idx);
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index bfe53e4392f09..ed44b3e7ac938 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4082,7 +4082,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
> >  	}
> >  }
> >  
> > -static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> > +static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> >  {
> >  	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
> >  		mem_cgroup_private_id_remove(memcg);
> > @@ -4092,7 +4092,22 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
> >  	}
> >  }
> >  
> > -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
> > +static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> > +{
> > +	struct mem_cgroup *memcg;
> > +
> > +	rcu_read_lock();
> 
> Use lockdep_assert_in_rcu_read_lock() here instead of taking rcu as both callers
> already taking rcu read lock.
> 

Thanks for pointing out this.

Agreed.  Both two callers are already holding the rcu lock so
taking the lock here is unnecessary. So I will drop the
rcu_read_lock() and use that in the next version!

My concern is that: mem_cgroup_private_id_put() looks like a
universal put function, requiring rcu held (which is true today)
is not that obvious to the users.  So I think adding a short kdoc
comment to make it clear later might be a good idea.
