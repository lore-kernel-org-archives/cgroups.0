Received: from outbound.pv.icloud.com (pv-2006e-snip4-4.eps.apple.com [57.103.67.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B87E44E64A
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 17:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.67.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789753930; cv=none; b=h7ylUySF2Lwbt+G677xGiJYn1PPc5HKBfbDTcbcb7849MKa80WzGqXyigOevSrLRxJmPT4twZYhzDM0tYCILtbnb6fRyBCO47GWtwiZKdotXC0eBJpATKtQoUQYKrzKNl/mmZaUzb8yUHmOux2Dn8DluLkSRuqenZT47wMZQ7UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789753930; c=relaxed/simple;
	bh=S9joy9VXuLCBQC/XTvQApnhAB4n3cV8UtRq15XXV/PI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HEkM5/jO2eC7h9zxnV8bU8PewqIDxTiAk0IPJGyBCp/eR83eUYJyh/0oUzxIDlztoJP66tR7SpMRvh1hwbWhB5XqWVSI20qP8PQYOGUzsZZDRQ8T1PFSZoHbjJ73Cl0SuaI1q09HoaVMSL6VDmpqV8+TFQ/Jc5/+WAjGBETaoPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=h+wBuvz5; arc=none smtp.client-ip=57.103.67.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="h+wBuvz5"
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPS id 674CF1800129;
	Fri, 18 Sep 2026 17:52:00 +0000 (UTC)
X-ICL-RepId: 01a0b5a5-8b8c-7eb9-9063-5a7d1cf93b47
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhOAEMGWQdeCEwCQwZYClBcHA4PUQxHH3kRUAFYHlZeWhdeTVEPDxlaFFwYU0VRH1RYQQ4KWgtQUR1fAgoERwRbF0YDU0VCBhcRUAFYHlZeWhdeTUcfQE1iSQFaGVscQBdKbk1TDw8ZWhRcGFNFUR9UWF4EU1YOEUhJBSNiEnwkfBV3PFo7SjB7MX0qcSp8N34tfEB6KAJOGQxKHVJWWxNVF0YJ
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789753921; x=1792345921; bh=7LBbzHTkFaCBQX5XE30CFYaJt4ycrCQUuP75OzRZKK0=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=h+wBuvz5TjM3UJFsobLYuvoJS3YevTdzxuY7iWRm7Fyo1rdauiIdGGsKwmH8dCmpapPw35EsoqkVEEz7hUcTbvlqCZVa2TT8CYoWiVEp7Ca3DMoTOwxAjXsswsoqzYy0JBZuaQVYP/7ae8lpxhqI6EZk9C2lA1M+DfZO/le+Vd36HaK2BkgFc7vSifamE3mHmDsKtNyq6ZDrPLkqqv/g6o0AnsT4rsFC7qWX9x9AW/SDStiEIQSzlKIuYU8dWK+SL4pOkhYeDBpzOVxfOfsHIBHiF451Yb5M4XKOo1XMgLnEUIP89ieg8IjNpiJVip1mHUbeW+Rhwpx1Zy3stlRTVw==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPSA id AE94618000B7;
	Fri, 18 Sep 2026 17:51:54 +0000 (UTC)
Date: Sat, 19 Sep 2026 01:51:49 +0800
From: Bingfang Guo <bfguo@icloud.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: bingfangguo@tencent.com, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] memcg: keep swap charging under RCU protection
Message-ID: <aq16NUyNTEmDQmPx@BINGFANGGUO-MC0>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-1-5bbf3220d88f@tencent.com>
 <aq1qj7Owhuk2BQsv@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq1qj7Owhuk2BQsv@linux.dev>
X-Authority-Info-Out: v=2.4 cv=KOpXzVFo c=1 sm=1 tr=0 ts=6aad7a40
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=pb9MNQf3OW9oSO2XpcAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Rw08J6G-psqXahF495GT95dTwOoiL6V0
X-Proofpoint-ORIG-GUID: Rw08J6G-psqXahF495GT95dTwOoiL6V0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDI1NiBTYWx0ZWRfX9vXqa8M6eOE6
 /yM357GhFu8cUzzxGSazpp4GH1bpjI+z3aarcpSirBIAjCL28L1PoPTD0zjuomTYKePPIdUISU3
 yiF++4s24VGSsZrpVDwRBxTjp19hLocUhqJ72rEu+iVkiPYx9LXVwCmWOaCqAPa9bMJuxMpHnCa
 I4mH6/kMPxrLmR8b+IWGzv7YBCYoTUt0FnFXM8ZX/zUFfvl4nNsKE+7+EsFEnywQ2z7KmVud1iZ
 YRi+ChzjEGjkivpA39W7iOY9RgBII7AXdBHpamERn/PjveIJ0BpyqD0B9x6rDTZSHwfhdiemu1Y
 uAd8poqknaIa5QGUigL/Iza9zcyF8uU+MQwE0Kuig++VmjrMlZuWwnGGCnFtTg=
X-JNJ: AAAAAAABTX1bygvuXCKE1uqtLnv6DoY6RuVkFeGF6oB9mf3GmrUhZQkKSNQyKOP/T7PSUdsS21klhKbJVRg+50yJBLHYpVKryExKrAnzF1rcApNToIJKjLWExg+/YXuuZN2r8Zu6ST49v5bp1FuKTgIBhCbyUGMPI8q5buEuJdXIj1u+4rq9T5nowMKkHkOWFI0wIy7OgGXrM+TU6XygjGxqeQB6OmjAgIVoPrc/hXggzV34W1xBtyDKtWmOLYwplEuVuJ0d2c4wUDSiNmeTX8+1jy5K6uwDCWcUtCJ57UzLhZq3TtHk6H1Bsr4txi/q7h3BKCJ07iyF/d++2tSA1zH2ZONh9obKin2jAivpGJ0lmwuujMfi20DAnnlzJPTF41MTtM3gPwRWsdOGnj0/BrWCrt5oJTyzbqiTOt+2IV1GQpe7VJ7xh/SxmOmxGcdZ9iuY1mBCMdQAVdeRJGGrvPq+0xbBfeb7eM6+PcrIXFUp9EPAU8UqTp9ugVOfw7hYsY8KKNn8IzOrEkw9V0NopvArQcTbWs5LzEICUBpIcNNyzUyHImi2xY3t4QgApYxrBuoEyUcBEcIK8SBNY2Hk30FOHJvwB01bGIw+fhe6SQJVHUUQ90uINAv8ofnT9V0qcMIt0mX7lgVJy6IwsbXSgLu0/pEQL5MUoCy6BXI5BPuv65RALBOwTyYegF2jM/eI80misUtPQwLldKOpc/0q4WQQe1ds+KlKKhe4pkNix3lYexJ4aqX2O1PDRuxKRpIenE2I4SUHYwJR8bsZ3cml2Zr/0IZGjyT85RBGmP9XFDHP4V8Hm17GE9pC1ZZp73d96g7aSnULXU8AOkPw0xl6Mu9p4X1QZ/UsgejPH0ZWn2Y01TWyAeEgKB+BnNEBzN0BsjEWv0gj49ApYWTNtzssuNovKZiNi0HskcbwM7DUzpwueDGEGg5FcAuWelOBr41/1TFO4gxOAFVxqF9ZPCL8Aq4y0Al/H/3
 nOgNPgPnzuDXeIPPIXE3aClmb89ekZZ6oPJcEQ6zZu0c3Fgxr8Ye9EUebfV4gTauJ37SALA1FiWOTkHKQIqD99If6hoetfwSaO1Fh3TaAJ5ikJuTeVyb3Twi/kChYFobtXe8gktS8Lzkj6+Z0p+Wd16apsakxP30Mphey+WDU7raPPYex2MoeSBnEWfim5LSR9Ejlsct/IPepbRoaX6VuuwzHADAnnxmrVyd++WAvS1oF6gLmG7M86FW3QzS3BglSWT2mTza0KjJytv+pnk+NLJ/uGFalUZDuRzeO6dNpv2cmkYOoqLhVIGB3aLDtbA4XFFCx3VbL8OaVXNO0pr3WJHtB6Uw075fOVIH/jhkO4sI0MRMSiJiKQZfQNb4BICFQVrK4uoW4USxsgB/g74Hvm+0WJxkySuJaCsQzLsshggh+13WzVjb8xlFtB1nPMMJIt4cI

On Fri, Sep 18, 2026 at 09:46:47AM -0700, Shakeel Butt wrote:
> On Fri, Sep 18, 2026 at 05:18:40PM +0800, Bingfang Guo via B4 Relay wrote:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > This is a preparatory work for unbinding memcgid from memcg. No
> > functional change.
> > 
> > The swap charging path currently drops its RCU read lock after acquiring
> > a private ID reference. This is safe because the ID reference pins the
> > memcg's CSS.
> > 
> > Moving private ID references to objcgs will remove that lifetime
> > guarantee. Keep the RCU read lock held while accessing the memcg for
> > counter charging, statistics and failure handling. (This matches what
> > __memcg1_swapout() already does.).
> > 
> > Save the private ID before dropping the RCU read lock, and use the saved
> > value when recording the swap entry. The swap cluster locking remains
> > outside the RCU read-side critical section.
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >  mm/memcontrol.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 791e536efaebe..72522ec827c9a 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5954,6 +5954,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
> >  	struct page_counter *counter;
> >  	struct mem_cgroup *memcg;
> >  	struct obj_cgroup *objcg;
> > +	unsigned short private_id;
> >  
> >  	if (do_memsw_account())
> >  		return 0;
> > @@ -5973,20 +5974,21 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
> >  
> 
> If there is one more spin of this patch, I think scoped_guard(rcu) would be more
> readable here, so please use that here.
> 

Hi, Shakeel. Thanks for your review and suggestion!

It looks like a good idea. I will include that in the next version!

> >  	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> >  	/* memcg is pined by memcg ID. */
> > -	rcu_read_unlock();
> > +	private_id = mem_cgroup_private_id(memcg);
> >  
> >  	if (!mem_cgroup_is_root(memcg) &&
> >  	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
> >  		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
> >  		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> >  		mem_cgroup_private_id_put(memcg, nr_pages);
> > +		rcu_read_unlock();
> >  		return -ENOMEM;
> >  	}
> >  	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
> > +	rcu_read_unlock();
> >  
> >  	ci = swap_cluster_get_and_lock(folio);
> > -	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
> > -			  mem_cgroup_private_id(memcg));
> > +	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, private_id);
> >  	swap_cluster_unlock(ci);
> >  
> >  	return 0;
> > 
> > -- 
> > 2.43.7
> > 
> > 
