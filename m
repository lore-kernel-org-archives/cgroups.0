Received: from outbound.ci.icloud.com (ci-2006d-snip4-6.eps.apple.com [57.103.90.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA79249EB
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 19:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.90.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788637014; cv=none; b=fLS+vQoGVW36cZnu4aL9ImpbhVA8u7Vz34tIFhwqsgGAum+io8VNvqAG8mPcq8Ue819E0yo1VAlXLc2k0A/ffpUinWK4lliF2dF1rytclfHURToh//L3XS58+V2pZqtXhEf7qzKQT24X3/sKxnVSXZ4PS7a6PyjcaNB2UPDe6Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788637014; c=relaxed/simple;
	bh=zdXtOZ1SO1lQyyqwXzUvMZBovFQSVGaoO+E7TQaA7eA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KP1zSxgoEHf2N9OanA4Nj6laSWFxd7gyaZYcSMqZd/gHiztJ66k3t7/Y9Y8JN7mL+iKfoCxdBfOqyvVNH0YrCmZtYAARffW3z8DZcu59Nw2RWI7HKbOrggR5ECvTb+3xs6Wli1eSM4Enkl/Ri3icnHoejWOP3DE0wLJHpUzTPHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=jofXPMkk; arc=none smtp.client-ip=57.103.90.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="jofXPMkk"
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-7 (Postfix) with ESMTPS id E9BAB1800163;
	Sat, 05 Sep 2026 19:36:48 +0000 (UTC)
X-ICL-RepId: 01a07312-d3dd-7743-a70e-6a22db0e2eca
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQtPHV4PRQBAC1YGVBcOVk1bHlQYWCtbE1UXRgkZCF0dGR5XUF4IXh9MHB0OWAYSAlpFAlQXA1ccVkVcGEMJXQVXHB0OXkVbE1UXRgkZCF0dGQhHHwowA0IOVgNDB0UALRkcV1BeCF4fTBwdDlgGEh1QHA5RVhtKBmssfglaAkZHXSFYWHcpez5+PnIjcCxnPxQ1cF0JS0YJSR0OBFQHXQVd
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788637012; x=1791229012; bh=PC2pRNtqdy7kEe5lF1ZHl4XVumVkfLLoGiTBdLWhYp4=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=jofXPMkk0lhwcEGgNW8GLnZK/gJwnbofuMabnYZOtTIYi97y2+EhoJDxgphVegR0whRwyqleEvSxSOXwqIH8LgQWdsL8w6Qy43A17cxMln7jvsdb0g6IEaEPBy6wN/kNnNGx6su3o4DqvLpAQTdIkm/CpAxA1noQwNGkXnqKnuFs0a2J441WwpcgjE0iwdCei+KgHhSBOn5XItF1u87UsfcsqzBzd3sBf1cVTcP5w/pqJ6O37NGMCl8pYo0RUNQ+3iuvnJ2XDgV2FuZXCqgOeSOfYZNp8BXob+wasgkLsx4tdw6OcR+MOWBTuDFDJH8sRb/shpANlnSZ9iJdvI7Siw==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-7 (Postfix) with ESMTPSA id E8AFC18000A1;
	Sat, 05 Sep 2026 19:36:42 +0000 (UTC)
Date: Sun, 6 Sep 2026 03:36:37 +0800
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
Subject: Re: [PATCH RFC v2 4/6] mm/memcg: return the memcg when putting
 memcgid
Message-ID: <apxvRTMdmit7dYk5@BINGFANGGUO-MC0>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-4-8edd7f7a7251@tencent.com>
 <c3bec318-ef9d-4d96-8a98-a68717c17201@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3bec318-ef9d-4d96-8a98-a68717c17201@linux.dev>
X-Authority-Info-Out: v=2.4 cv=Is0Tsb/g c=1 sm=1 tr=0 ts=6a9c6f52
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=RnMKIuOpERM8nik1lK0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: p4Q2hJtHhTaNPS4UtdXOLTXi8dG3hPFG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIxOSBTYWx0ZWRfXzpXclV0Pypgr
 AFFQcokQv+YX1+N3s0m2/roHny8krnmks5UKgPChWkp+woS7DjP2G52jOKv5+TkXb7qElQ0TVUi
 8vBCoLVDQg5sfbki19T/lKsJRhfsLOcKYWsCmelP+LgvpezHn9U6QdH+PhHlM16O6X6cDNmfmuZ
 LJeuFLR56KmvV6tDK7oCVyOWCmoOneAX89impebxv6WRYJBM10sibqznDZ4DQkk+oBnPuqyARIk
 HtdXqXpwAcxyRWxWQB9yCsDqqjC4bh0rwEB8A1HHGUDO78eQhRK4257IiC8xr8iiYevtNkQKRFB
 ipH91XIpuZkL8B8VGzp2GbxXNHCSc7nxZ6CzICl7S9d6jmqhtO6KLyhATrZVIk=
X-Proofpoint-ORIG-GUID: p4Q2hJtHhTaNPS4UtdXOLTXi8dG3hPFG
X-JNJ: AAAAAAAB1YHLZMnlLxriG8Q7OGpKoLkFgHiy/8fjVXrZqLZKdCkWLwiHorGiXqxdIj3FtBwHEUD+14/XM5YakMsDnzA+McYXxHHYAXP48LuRVFPGVA3Y4vSBRpdrL/oIThuKYI7Wf3SA5BuQtBB9Ted71IMlC+1Ng3oz7y3LkRwgh09ezwiNycI6MuoT+PitUDK0Xx+Pz1ujH8fAbPk0vDaDMAIcJQobo+2Cv+BC7nfd5nANPCRmeKtpRIySrl/iFQzolJnSaQHAbrtr6XhxibQKtAj51l8x4KWCiYMfTQNE6ndfw/27tTP3wOfYPQJ1hcmJrAMJqCM37CIYqf2+eCLBTGR3wwg9zZ5skBPM7VW9ax3MGJ8gExLVO24aPGe4x1z2j8b8yJMYT8gJCGZRFmihlg5Bkryn1P4r4vwlrs0WamABIinJXKqPY2n97xLw0g8ZiUpPHmJe+Eq9kG2lt3dBdAlApg4j6Yf7JbnvbNPzCDpAhZ1sAlo0AndqmYH1l1w/+3Ssk9L0uT/AJDLeS0h2iaUEsxDJBQlLuPWrQLwrJ1BBhjgJPsc+utDRoJT97MQciC7ehi+puWZkyr/+HrEjZbj9lHl6udY7NErRex1pDFdGxgSxp+QG05yu4bXmQ4lPn3KS4mVZKaJuvIMOH/llWc8fBsQcQQ3ktbfy/iZZIs9vvFlWOIe1wO5bwQFe/5ICuIqSQS9J4ktxmPDbOz7Xy5CwE8tRFCGcU6A79KqL0uOBTbyPusCwKD2Rz02twx911x8cAQ+T/daNX9lvccVUffWisBGMFf6cZPjLxzWlU0kGyUIfp0X8QZ6eZeeTnTynmOjD90DntpkWEWRUBRsI7ALAldTjZdQQz4/uHBndWXa3lwWBdyfHbXp9+OkU9/ImJ5VXdQGMIfn8BuNGOm7vWa5Q1fRBlDcvmcRhBbyeW+fuu2LC0D9KVtUjLrxNf+kZC5+9usKbPIll8XC0k7ri4jrkz7g
 cVOnDvIFH1Xc8JPLdb74XdcE1wOjERW7pg5nXwh0WjGPpkwhkzfOt+t+vhHu3IGuUcMYwfhS7A1o8NNRr3W4iuOrS7LxqdlaIrCK4tJi9S7QZKE+6TL0pMRiMSG0tLc7qtjQFBzxX+oDp5s7tFNo6RjsiRfSRjVUqwlnjUTiubrvE8hAOxaMo1lixH+G77GlIX7VVG0k6zki6+IDZTuEQAzNw/WjWvW53hQu8294Lagpd/0NzAibiZor0OLEdQgMe2qVwEace8PNymUAv05nwGIH0M+uRG4wtlZP1M7kZTRMmFxI03yocBgu9dOJKUsaC7c+3ydnBYBw/FZi05tDcJsSEmVonxHBwwVGanM0VdQacq24tQ42Wwbr01xpfUQdyJ4SAT6ksXWcpgQOWGobZBvpD+UJq71NmE6Hg50w+8ZVVHxxISGvzu8KM0rcIRbbLg5djObeyT1kHTX9T

On Sat, Sep 05, 2026 at 03:28:50PM +0800, Muchun Song wrote:
> 

Hi, Muchun!

> 
> On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
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
> >   mm/memcontrol.c | 20 +++++++++++++++++---
> >   1 file changed, 17 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 048c9bb0fad79..f0503a1e5492d 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4048,14 +4048,28 @@ static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n
> >   	}
> >   }
> > -static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> > +/**
> > + * mem_cgroup_private_id_put - put memcgid and get the nearest online memcg
> > + * @id: the memcg private id got from mem_cgroup_id_get_online
> > + * @n: count of references to put
> > + */
> > +static struct mem_cgroup *mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> 
> Having an API that put reference-counted resources return a struct pointer
> is a very strange design. Please don't do that.

That's true.

> 
> >   {
> >   	struct mem_cgroup *memcg;
> >   	rcu_read_lock();
> >   	memcg = mem_cgroup_from_private_id(id);
> > +	if (!memcg)
> > +		goto out;
> > +
> >   	__mem_cgroup_private_id_put(memcg, n);
> > +
> > +	while (memcg_is_dying(memcg) || !mem_cgroup_tryget(memcg))
> > +		memcg = parent_mem_cgroup(memcg);
> > +
> > +out:
> >   	rcu_read_unlock();
> > +	return memcg;
> >   }
> >   static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
> > @@ -5816,7 +5830,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
> >   	struct mem_cgroup *memcg;
> >   	rcu_read_lock();
> > -	memcg = mem_cgroup_from_private_id(id);
> 
> I think we can introduce a new helper like obj_cgroup_from_private_id(),
> We can use the ID to get the corresponding obj_cgroup, and then get the
> mem_cgroup.

I actually did this in some local versions but gave up in the end
because the ID should be referring to some memcg and I was not
sure if getting some objcg from a memcgid looks normal.

So if that is acceptable, I think it's a great idea to do like
that! And the put can look less weird then.

Thanks for your idea!

Regards,
Bingfang

> 
> Muhcun,
> Thanks.
> > +	memcg = mem_cgroup_private_id_put(id, nr_pages);
> >   	if (memcg) {
> >   		if (!mem_cgroup_is_root(memcg)) {
> >   			if (do_memsw_account())
> > @@ -5825,10 +5839,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
> >   				page_counter_uncharge(&memcg->swap, nr_pages);
> >   		}
> >   		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> > -		mem_cgroup_private_id_put(id, nr_pages);
> >   	}
> >   	rcu_read_unlock();
> > +	mem_cgroup_put(memcg);
> >   }
> >   long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
> > 
> 

