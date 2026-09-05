Received: from outbound.st.icloud.com (st-2005l-snip4-4.eps.apple.com [57.103.79.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931C422FDE6
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 19:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.79.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788636952; cv=none; b=RvsxlCCc1wJBFum/nSc6iMdLN5CaUzfqkfPwyFetYe1+BhCv+oT1n4wyumpgPRGGgdzmP6uu2LE5DlZr9RbogGWNKm0HwLXnLnHYowJNtfqOSzVTttGbnrwKA/Hp54hLji8zg8KHDDYdhPQlJKpEmzgItPdtCBvimqTzfftfNHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788636952; c=relaxed/simple;
	bh=1YO3SgBQak4tGK61FOqQcBJJY6vKG97qYfPdKsjiw1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lyqyzYdxtDrSIZ50my0VpGt7YV5GnVPAcRex5cBiovqSsCVcuZQJeeBREB0KvqN3xprjQIZUjL2r/NJCJVOu1Hva75exNIlwlmY1HP2Har6xDkFmO6lf5HHXsKVD6VeZJxLtRvu/kmr7F5edExDrGPxIc96kSMAkW8KkDVZ9jV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=xYlP7d/H; arc=none smtp.client-ip=57.103.79.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="xYlP7d/H"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-20-percent-1 (Postfix) with ESMTPS id 541171800362;
	Sat, 05 Sep 2026 19:35:46 +0000 (UTC)
X-ICL-RepId: 01a07311-df40-7bc0-814d-5f116123f2c8
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQtPHV4PRQBAC1YGVBcOVk1bHlQYWCtbE1UXRgkZCF0dGR5XUF4IXh9MHB0OWAYSAlpFAlQXA1ccVkVcGEMJXQVXHB0eQ0VbE1UXRgkZCF0dGQhHHwowA0IOVgNDB0UALRkcV1BeCF4fTBwdDlgGEh1QHA5RVhtKBnsRUiBVPVwSDxtFPHcpez5+PnIjcCxnPxQ1cF0JS0YJSR0OBFQHXQVd
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788636950; x=1791228950; bh=5cezDtxlrHR9EE90cG0MGu9l/gtilxYv/wFRi03p5CY=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=xYlP7d/HGHwwS9l4ltBvg+bwAR3UE2k8aaC0n9FRoe2EstONodWFCWhXdzjiXWr5YNGCWihIWyoJNqT4YOMc0V3swB9F3pv+yj58lCdug35TxJU66fv4STV7uVEcjrixwRmFqs9ru2yoZNXafdrcvAJ/OPZwu2BCdfb/y0j/JvVLgqkPNOo1uN2IWylRk6T07drRrZkCoYqPmDnpHGzSTgBn2NG03v8ijztiRonHxgx2J+pYzXOtip8G5rkSZ01Q4BVt2k9/nJdJPH1tlnODon2WwV4mZ4MQ+6JFenbZw3tglu09syklMz0AXySqenX1lx55ybNdAQjRoSB5u4ZZyQ==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-20-percent-1 (Postfix) with ESMTPSA id E677A180009D;
	Sat, 05 Sep 2026 19:35:39 +0000 (UTC)
Date: Sun, 6 Sep 2026 03:35:34 +0800
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
Subject: Re: [PATCH RFC v2 2/6] mm/memcg: get memcgid reference only after
 swap charging success
Message-ID: <apxvBiaMbVnb6cvQ@BINGFANGGUO-MC0>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-2-8edd7f7a7251@tencent.com>
 <a2fb9ea3-78dc-4bee-a64e-0928983961ad@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2fb9ea3-78dc-4bee-a64e-0928983961ad@linux.dev>
X-Proofpoint-GUID: f1AQX1aTWqZN4lSzMnJQFR8nPOtEeKPA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIxOCBTYWx0ZWRfX7iWWTN2q2aep
 YsFgd7msiqRVkD/rJQXi1/QlA+kVGXDWCKtn4WB9tUowU0vkGImtXVZ4hhsoHlCHnd/IeNQ6Dku
 MK+/ttyGh/Yz4c2V2oy06avcjMT6X5x1JnmH0YBw8H2cHoqI7WRSPpMJPj5b70ChIv4s50CGyoQ
 M4uK/OsaiXpI/5gqVECxKvrWAx1zEQuBIPJhVEo2HlaANoslSCHmuSelXpZxUkuZRaqApt27XXm
 SSnMHpLrDdPrLoNWvhXdfyVwA3KSpxgh2avBzAqTKz5u3YYI6pDP/g1EHel+vFvpk8pU0CwHTZi
 Z8j5tULbt0FreMybyaTkgEhknTxXIgdnt21gD0eYd1/9L15hnxH9lMXi9Lgdtc=
X-Authority-Info-Out: v=2.4 cv=F/5at6hN c=1 sm=1 tr=0 ts=6a9c6f14
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=kWxB-xFdqsxXOBgkBTwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: f1AQX1aTWqZN4lSzMnJQFR8nPOtEeKPA
X-JNJ: AAAAAAABQtsNwvohzyHt18T/0XBw4zXFE4+rSf1ZKh25MuxUte1NkrQswCQK75JHel8fA7OxzS92/1Hos834UchYn/lKqif2Zda/FvdlEf2XjL+bRuZsi3HuLgn2RkCfOJiOSByR8BM9/fy/332snyhjR4TsbZKBtWg7bb1oIkNpTKQzV8SeMeo+Qn3yI0m61IGRbpb+jNQNXLeVuNGwfjkHvP8sqZpHpAOrFkgsCtQwiuQZ5ZfEzkJEqkuQVG4Kx/cXOpJM/6M+5yxW7/TGDf2Z8rR3SoqFjIcT7zoq7sAMv6wTG1gcDd7W9mmFCe4olo6YgsjlfULevVzja6q3eek+f2G14qDi0Q8m46NjVAfLpsE11mh4ATE8m+zUClBwsmRwugerTW19PeG9uPRAuhpQZR8ySGZqCUUEpFc1lAkOAFlVg9eQKjsLY/gbT1VN9XInEjtWV23yvVhn+yYLROVcQ0CdTzkzMv/Fu5EkvmGXf99jt8KE1RQvsJKb5uzE11Tl7Dh7u8KR+ZaKHmxbbia6ajjKsBES5KedYxM1Tn3cRYruV5AFKSr3KuCS7V4SlKEeUrl7A0uEMzvUhv1kwIIrIVo2vr6tUaE2FRiwaWUX25bY6UISum/f3h+NcnQR0cN0zvB0yRgY3FlM6nWkW4b/U+EJBDEOnhN6dKx+fHOVEq6COLvQqXC873kXjyuMLLDpBrKTBjCVC2cB6TMyyIqH6q7k3JEthiP0LgqGQmiyx5sqOd5cr96OKQju+nydnCuamVFir597b7+cePYPSUKogHK69US98/eWOH1YxqqpPn9svSEy2sk6kI57wzfaIR9AmhLuNK5tyLbxGWDZKigtShbfmafSe0L4LGWdswZvX2zh7OGrmNWzKoSyyMSOCBz202q6bET2/LGDIc42K4IbAK1GqeR0qpH8GxkB2iYmhB4JgM9yxRtSjD5fH+dPpblA+8t9UQ7CBk4HycWePodsMRxyRk8
 3Srh7gsBITtCb7xOUnRuawvoZwth+eUn9Kr6qyMQtzBJBYuPzaszmj3fKnM1kL47y05+/LqvSlIHM81Z9bPDajhoY5k+EO95NWk5iqKiXiJ6YCKukQm74qK98SRhNfkzR9N6+ADYJUymAboZvbbfUdwCvH7BOZ7bFBuHNMkh92ZrvjdkCj2tRJQknZmKKf21ETJd0m2CcHT960/G+RQr+aKLEPsKlNXns39TnUDVw354HLbH/DlVfrJFJPz9oAnyA1cqhJnMPFt0vljB4c2+N2qfvaKNgZ70d4qf48iMTDQAGoA633zMff+loSJAzXifQhEdBjMHHQ4nWt2s/hWuyjcc6btA9gHiWZIWz4d5SUlMU1mMKCj2GY+i5gfXW3lbufp76dNHQ8V084CR0H42em4wCaK2wCteBf7Tayiwh+a1X+NEE5FfT+yFw0HgqUDCHKMcznaUm7EJ262p8336/H3xhRk/4qi+RCCLamK2gEqwzzw==

On Sat, Sep 05, 2026 at 03:12:19PM +0800, Muchun Song wrote:
> 
> 

Hi, Muchun!  Thanks for your insightful reviews!

> On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > __mem_cgroup_try_charge_swap() pinned the memcg private id before the
> > swap counter was charged and had to undo the pin on the failure path.
> > Hold RCU lock for an extended period (which should be fine,
> > __memcg1_swapout() does this as well) so concurrent memcg release can
> > be avoided, and take the id reference to its online parent only after
> > charging has succeeded.
> > 
> > The failure path is now a plain return, and the id is only pinned for
> > entries that actually end up charged to swap.
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >   mm/memcontrol.c | 15 +++++++++------
> >   1 file changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 31cec9dde55f0..ecb4fb07d7735 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5755,6 +5755,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
> >   	struct page_counter *counter;
> >   	struct mem_cgroup *memcg;
> >   	struct obj_cgroup *objcg;
> > +	unsigned short memcgid;
> >   	if (do_memsw_account())
> >   		return 0;
> > @@ -5772,22 +5773,24 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
> >   		return 0;
> >   	}
> > -	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> > -	/* memcg is pined by memcg ID. */
> > -	rcu_read_unlock();
> > +	while (memcg_is_dying(memcg))
> > +		memcg = parent_mem_cgroup(memcg);
> 
> Since we've already chosen to expand the scope of RCU holding, it
> seems we don't need to check whether the memcg is in a dying state
> here. The upcoming stats updates aren't really tied to whether the
> memcg is dying anyway, right? Why don't we just simplify the code?
> 
> Muchun,
> Thanks.

Yeah, indeed. Whether the memcg is dying doesn't make much
difference, and dying memcgs should be rare so walking up till
some online parent should be useless in most cases. And it does
seem a bit strange to do that here...

So I agree that removing the check would be better as well! I
will make the change in the next version.

Regards,
Bingfang

> >   	if (!mem_cgroup_is_root(memcg) &&
> >   	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
> >   		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
> >   		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> > -		mem_cgroup_private_id_put(memcg, nr_pages);
> > +		rcu_read_unlock();
> >   		return -ENOMEM;
> >   	}
> >   	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
> > +	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
> > +	memcgid = mem_cgroup_private_id(memcg);
> > +	rcu_read_unlock();
> > +
> >   	ci = swap_cluster_get_and_lock(folio);
> > -	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
> > -			  mem_cgroup_private_id(memcg));
> > +	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, memcgid);
> >   	swap_cluster_unlock(ci);
> >   	return 0;
> > 
> 

