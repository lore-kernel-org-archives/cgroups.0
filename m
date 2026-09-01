Received: from outbound.ci.icloud.com (ci-2004l-snip4-2.eps.apple.com [57.103.89.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5741343C7C4
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.89.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788278334; cv=none; b=j+l3wGZHkOGEcNC4mdeZ1cuN6JoJGMguLj3qTY116K3wiMeEMnmB5t1gjq7N2xiSssCWi9c2fis7n2Nq1PWtR/Hx3X5EzTBCZKx3kOwA2OyX6OJS4TyH7sBapTA7+o3fIxodw8ux/6E0OcZ7SqRAqNBtKFu6jPn3blgXkNcOfkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788278334; c=relaxed/simple;
	bh=czLxTHbA0QReQA1WjgvS3aqpZx35QrDPL4xHH69b3Fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p77iP7x+QGfQ21QHJxxh0rh2mqd1gV1nGQyjqX+dtRMNF/QDziB9GujzKbBNtsFwd05QUTtOod249oICuI/wrbxbPP5zfm3CSz9gqR/N4boXGZayMrZstIxpl1/+HtMfTKx6VkI6EsX1ce3Qy4eXkzW0Jsurhk6/TDQal9BYyJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=YpsQsOIF; arc=none smtp.client-ip=57.103.89.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="YpsQsOIF"
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-60-percent-6 (Postfix) with ESMTPS id 131A51800103;
	Tue, 01 Sep 2026 15:58:48 +0000 (UTC)
X-ICL-RepId: 01a05db1-cb06-7078-bd79-5be0a932770f
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQtPHV4PRQNECFYCVAVLVxQEGlUKQgRyGVoUXBhTRVEfVFhVCQoCURxWDVdDVARfUEsbDlwOS1oVVRcOAkIfUB9MFldDVAIcGVoUXBhTRVEfVFhDGUVWaUELTx1dGVscQmRYVwkKAlEcVg1XQ1QEX1BUEVdQCwpCEglLSylhUgQyUx9fJnorcDl3P3UseSx1JXZVfi4HVRIEQAhWUF4IXh9MHA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788278331; x=1790870331; bh=ybQXHOgwqQY3giufa/UxVrNvxC3cSoVBlqpWl4wWBxk=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=YpsQsOIFj3l9XE15NFhq0Ln3oKgj3N51FPAyjexqoDPo5gesvujX+vcqV3/Kwk8Nlkg4bKWelvS7OeBl/Z0YJvH7uPxQl/COGkXURBeCGyqjztYLpJYWzhgcxe43cF0j/ndgdHNE1Qi9iiMovzGju/QHeWcrRIR5sa89SAaHreASFnnQPgqf7x78JJ2H6++igZdE6Ws+7n6w4rGfBKgHm5xWsHh8a6wjAhNN3QbSLyqr8tL/+tfGe6YjDQbnRSY0DlkvcuAVCKdlMlbuW8HNnP7aI5g8FD5miqHLmStT34/Hup8ny8eHeNuzioI0PqCvrustVyHR1wscp/cSL9g10w==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-60-percent-6 (Postfix) with ESMTPSA id 44FEB180017F;
	Tue, 01 Sep 2026 15:58:42 +0000 (UTC)
Date: Tue, 1 Sep 2026 23:58:37 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: bingfangguo@tencent.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 4/6] mm/memcg: return the memcg when putting
 memcgid
Message-ID: <apb03xDV96BjglKM@BINGFANGGUO-MC0>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-4-8edd7f7a7251@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-4-8edd7f7a7251@tencent.com>
X-Proofpoint-ORIG-GUID: 23wBunoIQJWpTUzCIm1_BOyVJK2MfEsk
X-Authority-Info-Out: v=2.4 cv=SMZPlevH c=1 sm=1 tr=0 ts=6a96f638
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=8EPpdoJjjQM0g-z0e8YA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 23wBunoIQJWpTUzCIm1_BOyVJK2MfEsk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDE0MSBTYWx0ZWRfXzb6H9RiVBKJy
 5IPQESsxcN6TbFCP0T8WL7QvR85Tb6136y5zaTjXrRAebeWP+K5BW3rNTHizbkW7P1FUmZap0kY
 g9q81wu3NcYfB3+D0buq5HA7roso/as1lLEzucZLkVcZAtwtsGCQJ+I8/Bz26pyuRJ8YHAeR6yX
 2qaORIczwi8sc4m/9iPHEmM80AxDgt2YA+5lYcix2Rh5d1PDY16pY40sOlJBjYF5/r4RtMIFeaK
 i/C+mfutvIRRfbAFOG5LuK4oCgwNYcJSZd57OPTqXMYUWy+UJziXcH8fqIuTWQpYhvQbMvL1n5E
 LO4Ms8wp8+lXVoxqdINYemP8M+Jmk/pawTZWhqtI5xC+Y0tl3IH+BOQYhabSgE=
X-JNJ: AAAAAAABwh+PmhrxwrDgdqcD9N3PP1q4zbD1FFu9zXZwZnW14cEq8RH21X8eski700mgmcf1yFDlBzIqQZDTwUaAXPnyVE1UwmJigB/VeSFU2yvZNARqsbdB4p1HSwYdaQO51zDNKW0iRS77eO+m0NQKVVWKPadep+N0PKpApshDnUP7TEe9W4J2x87A2RsQzAr2WSE+3ar6VLQmqAqKS026HrK7++71jcJsBSGblgiHdnRZ6M3Qj19odyn/A6qEsENrxRmeGN6vsthY9DmvVgcCj0888+cpMjDpv6GiYppqgbLKMDCYtktCqnKwEc+/LKNtFyZVHnwbnf3Btqf4aByLLfoNpZxMAGgVOmtxrWsqOVBn4AipAdzGkE4/7iGw+fUmbc981ZlB/9Bclitc0af0W1c2avdni2SSIoRs5EeKzzHopLlLx8VeLBXuPh/y8JL4+kNJLN8hXwpjwUTDd7vc80EOgQoQ40MbnGu/1Cw/Eo9qwVlWDWYSkikurw3gwDgoV07k43qf1q5UzW1ZMfs6cH0imeB4xnFRv48KS0ZdvtaOp6U3cBRkzyL4nYPwYZvJTwZK9mIP/+z4UG7ffB2LvRvqHm70stFUtP+tCLBu1K0+gf7fh/BIY77eHEJcYRdsQG89iGYvYywyKMHkoyc7Mj5zrb0blWZGemv+pwOJiEt5uy8M31Hb5zjjjq/a4grG3fWgedOAcoMT2PMJrnKACQ+zP+DYaOysWZEGBvr9kwUlWKx1VW6m+WYCiXvFXxR0Fhzo4ty7HO34yG0y1AOyu5RJT/Z0Zu0jSb3bqPspcQlkk/SPIJsh7neqkmpAU1w9+dACXJxDHFt6GzAeq5H8bpbrNNYYgEFMRkWC5ZaLXdTHKn6MjYmMthxRhYPRKXSwjCNLOOwEAh+vrnC14cQKVK3Ane0A3BQncJyLuKjeOC4uzpheZH9eaub/ApdnpOeJyyQO7r0umWD1XN+dLEbBQO2ZHed
 QWxxRRCnOID6fx4+7DhOV9ATiuxVeC9VZCh18wo/uIrAWyA02IAYObPT4CsIqKbCazATV926T49ttAyuENNXqF/SzJVe12tPtohKU/Knrx67T8OiORKzu4yHoE+631KsQ5IYUVL7wTkomR8LNBgQgBYSQxsDE5iYEUDV09Vk/DDLHol/Nw3DLMs53VwwyAmUzgIjC/a+j5KVlgmO5d1oiAoGpx97nFsoqDzIC3oUkdGVveNhM/oiKfCeoZXlTtLZJomrRJH1KnOohxIAABtKzbODkHkHWzH0MspX7pHoKBnwvC4DQmnl4mGUy0XxrHlorkDAWdWuiu7kxbAHAkRBA4uzbqYEuMt31i5byPXE8M0rxUfinGWnKb0kpcsQYsztegetPt+ECm15aUioIc/ZT2bLebGlFst5PrnVquucpXE4SFlN8sJZlPze9TqCIEZKn4YSxeiLqkVCjm6LtSA==

Forwarding review from Sashiko:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > __mem_cgroup_uncharge_swap() needs both the memcg and the id refcount
> > drop.  Right now it looks the memcg up by id, uncharges it, then looks
> > it up again inside mem_cgroup_private_id_put() to drop the reference.
> > 
> > Make mem_cgroup_private_id_put() resolve the id once, drop the
> > reference, and return the nearest online memcg with a reference held for
> > the caller.  __mem_cgroup_uncharge_swap() then uses that memcg directly
> > and drops the reference after uncharging, avoiding the second xarray
> > lookup.
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >  mm/memcontrol.c | 20 +++++++++++++++++---
> >  1 file changed, 17 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 048c9bb0fad79..f0503a1e5492d 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4048,14 +4048,28 @@ static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n
> >  	}
> >  }
> >  
> > -static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> > +/**
> > + * mem_cgroup_private_id_put - put memcgid and get the nearest online memcg
> > + * @id: the memcg private id got from mem_cgroup_id_get_online
> > + * @n: count of references to put
> > + */
> > +static struct mem_cgroup *mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> >  {
> >  	struct mem_cgroup *memcg;
> >  
> >  	rcu_read_lock();
> >  	memcg = mem_cgroup_from_private_id(id);
> > +	if (!memcg)
> > +		goto out;
> > +
> >  	__mem_cgroup_private_id_put(memcg, n);
> > +
> > +	while (memcg_is_dying(memcg) || !mem_cgroup_tryget(memcg))
> > +		memcg = parent_mem_cgroup(memcg);
> 
> Does returning the nearest online ancestor instead of the originally recorded
> dying memcg cause issues for callers that need to uncharge the exact memcg
> that was charged?

This seems to be a false positive?

The page counters are charged recursively to the root. When we get some ancestor
of the dying (or dead) memcg, the dead ones will never be accessed again so just
uncharging the online parents should be enough? And these counters are also left
untouched when the memcg is offline and pages are reparented to the ancestors
together with the objcg.  So I think this should be fine.

> > +
> > +out:
> >  	rcu_read_unlock();
> > +	return memcg;
> >  }
> >  
> >  static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
> > @@ -5816,7 +5830,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
> >  	struct mem_cgroup *memcg;
> >  
> >  	rcu_read_lock();
> > -	memcg = mem_cgroup_from_private_id(id);
> > +	memcg = mem_cgroup_private_id_put(id, nr_pages);
> >  	if (memcg) {
> >  		if (!mem_cgroup_is_root(memcg)) {
> >  			if (do_memsw_account())
> > @@ -5825,10 +5839,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
> >  				page_counter_uncharge(&memcg->swap, nr_pages);
> >  		}
> >  		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> 
> When a swap entry is charged while a memcg is online, the original memcg's
> local MEMCG_SWAP per-cpu stat is incremented and its swap page_counter is
> charged.
> If this memcg is subsequently offlined, it becomes dying. When the swap is
> eventually freed, mem_cgroup_private_id_put() now returns the nearest
> online ancestor instead of the original dying memcg.
> Will applying the uncharge to this ancestor permanently leak the counter in
> the original dying memcg?
> Furthermore, does this erroneously decrement the ancestor's local MEMCG_SWAP
> stat, causing a permanent stat underflow since the ancestor did not receive
> the corresponding local charge?
> 

We are holding rcu read lock and checked !memcg_is_dying(memcg) in
mem_cgroup_private_id_put(). When the css is being offlined, CSS_DYING is first
set and then mem_cgroup_css_offline() is called behind call_rcu, so no
concurrent offlining of this memcg can take place here.

For cgroup v1, MEMCG_SWAP stats will be reparented so eventually we will get
consistent result. And for cgroup v2, the stat is not visible (and therefore not
reparented) so no problem as well.

> > -		mem_cgroup_private_id_put(id, nr_pages);
> >  	}
> >  	rcu_read_unlock();
> >  
> > +	mem_cgroup_put(memcg);
> >  }
> >  
> >  long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
> > 
> > -- 
> > 2.43.7
> > 
> > 



