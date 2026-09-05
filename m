Received: from outbound.ms.icloud.com (ms-2003j-snip4-3.eps.apple.com [57.103.72.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B62D30C618
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 19:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.72.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788637754; cv=none; b=ojRr10XIKUB0bppn6XpB/qNaS/yFB6nIAhwb0tQ6T3Hdf2hnB526y+9BTQQJecVgErlDuvWcWULzfGr1D+BRLADngUeuNI0yUdGhCv7ZuEWf2UcJnqLzZHorpFZ1x8rDmiCEmZH9vu+Hb83JkNMXFEDHfVMMA3YZjzskrsuOI9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788637754; c=relaxed/simple;
	bh=yHtMGdEibt9/wPnLm72bkt/fBDmqS24Ax+Bi5yCGwWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JR9Vl7W1TU9vgOR7wY1gGiETOTVrpPiQp3FBp/RxUNHxJrZE2aaR2KBMd6bQeRQ+A/2naAgcS86ogG8gm9mYspsH4cjU16lU285drObOKOHdgpyWbsBNTuSAlhbD37FgVVif+FAYMxnLI8/UDyzyeaR2oQLmoR0/yU2Ivht/gSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=PlL1aLc4; arc=none smtp.client-ip=57.103.72.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="PlL1aLc4"
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-1 (Postfix) with ESMTPS id D572D18000B9;
	Sat, 05 Sep 2026 19:49:09 +0000 (UTC)
X-ICL-RepId: 01a0731e-222b-7a26-bab1-9d9516fb4bf8
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQtPHV4PRQBAC1YGVBcOVk1bHlQYWCtbE1UXRgkZCF0dGR5XUF4IXh9MHB0OWAYSAlpFAlQXA1ccVkVcGEMJXQVXHB0AREVbE1UXRgkZCF0dGQhHHwowA0IOVgNDB0UALRkcV1BeCF4fTBwdDlgGEh1QHA5RVhtKCXIPBjgAIAoGcSlFF3cpez5+PnIjcCxnPxQ1cF0JS0YJSR0OBFQHXQVd
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1788637752; x=1791229752; bh=NSqzY4DKPEYhVMjHXh3bB0AeqlXjegvLRaBRjDJ/2A0=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=PlL1aLc4Lj5TJqea0XzRA4TYqIMemmIrh/Omi9jldmCChXsJAsfHDTbsq6ymr4ZMRFTOquJTL1sVbRRjI4rJrlMmME3pMPScY31KFnXziUB5gb6c6oiWNCmjBNpiPKi/QEL0MEh00gytgW86dVemjlGoOSEgQmau8rOfI4xqywVLG+aeJFTpf+CW3/tPVH0KLZYoi/uafuPSaJmZErvv4qHeVwPGqalYTkmEDzjbeinjBcCgNqm133w/JXvy5LNmd2MPNUx/T6VcRCS4rG49vABGpokXwOQlKprdwY5FiQRVchC84HSa2uCFd68HfC/E8TvHr/TPsyMMrwo7IAVDmg==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.156.208.39])
	by p00-icloudmta-asmtp-us-west-3a-60-percent-1 (Postfix) with ESMTPSA id 77D861800092;
	Sat, 05 Sep 2026 19:49:04 +0000 (UTC)
Date: Sun, 6 Sep 2026 03:48:59 +0800
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
Subject: Re: [PATCH RFC v2 3/6] mm/memcg: pass the id itself instead of memcg
 for putting ID
Message-ID: <apxyKw5U7K8vHQvz@BINGFANGGUO-MC0>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-3-8edd7f7a7251@tencent.com>
 <29c98946-cb26-4b1e-8a95-fbdc9c9671ad@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29c98946-cb26-4b1e-8a95-fbdc9c9671ad@linux.dev>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDIyMSBTYWx0ZWRfX+r8YXH+6kE2+
 LkMhQYJcn7RqdUGCjmgTxUyMDpiGHZ6p6hY6DcUXjjdBv99hwzamKg1KjW2+dsicPO+EMAErERB
 oCJCfTimHAhgRBbS9TDHcmvxX0o2vfmOvfYGstlvzZRK2OGzqw0Iq7TN4HsCmEpYhwxUmX++Z+c
 QJSWqpiTrxNATzjxQtQeaC+BtznlImOULA1DwZdKUz4qM4knaN42kpS6hEXyWxZR4WK6QtB+V81
 j8lwp41XX2/nRqhlRp5IeDAlgwLm8pF+U6gFOxd7GdqSt9w7yCHsKmfUnGWT/scR8RXRP3EUDht
 BEBogSbVa3963CfV/4RFJbqvg0uY0NlH72sslMYV+lBkRgDfLrmYsJ832O7f5I=
X-Authority-Info-Out: v=2.4 cv=c5amgB9l c=1 sm=1 tr=0 ts=6a9c7237
 cx=c_apl:c_pps:t_out a=kRaGL2Q7qLiahLf3O6OaIA==:117
 a=kRaGL2Q7qLiahLf3O6OaIA==:17 a=8nJEP1OIZ-IA:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=a9KCvqYYD0B343YQoQUA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-GUID: UAb-OiatKCEAumbAE3iT0thEjCIwt-H_
X-Proofpoint-ORIG-GUID: UAb-OiatKCEAumbAE3iT0thEjCIwt-H_
X-JNJ: AAAAAAABKSO1Yh2vZJFH/bxtvBq4L6Ui/bHz9sbiU40hpU2dt0rtaGXJaicnXSr8z2DbgpqhLhIPJHyREvs6sucghTGDi62CFEvM1ayJKF0IcbqGc97/pY2x8ft/LF/E+QFaUM4vf+2VRyz+5CQs4YxB8oteTP3eP9wrkE8g5c/CJPsU5aSc1JYeTmbP70p9vYcsmgVEjb/uCvudol8mYLdC5NOc+eKPY30vDQi0IyKL2l3PDVf8bnFOsa5B6OnMg8q3o0S4w2eVMTWCZty0VThfU9vrMwpkgeTVOi7WL8IHmAdhSfkF7WS08V66zAnWAcxvu8f6K3pG3NSGeGU5Zb6oZsL5urcXElMu86kjoAeLIpCXoFH45mRfALdifNaDSnWm88VKOrxAuRBt6joAeE4WiormWo/N5zz+si4RjUEzWvZRHZTAFS2gv5G3QAuwlgaOKt1mH9NblDXol7WfORUBDrmZZXmtgfEpmvRkc3vu82pFtn3X/v2W/R7TmMZxzjPk6QO4Gr9KJE2OgyI7GqK1CdrRFN2PipogWWaudqr1gnAdrfAPaH5M4tK+we/NLg4spo8D2zqQvgoJAs/1iRKR07IZLznhjJTy+8K4gqk2WQaIAf5BAq2Boz1mVWusQl6gSlvCZ18v1raTiaRuxNKQ9hMdjdM9hkOSG2WxlO/HkZB0h00kHZrk4TD+SNjJvqP1ndmfyX1yamnQnMxGSX1Q90ODtHkd1iMKwg6qZfhoA5MJGnsMCrMxQ8piOnfqxQToH342bwj988/NfObCCQSJeENHRje8fcMcTH+g5zMbZzOXf0h15kBQxD794IY/62zgvmIdEoOlMZLCvVgMNQOTzrMDw0Cms2VVgQYoFoN3YyLH8PPn7AyIopQP5GqJSTkSjPUIF4VSHZgtPIIelktl6035h/5jrK0gMlcR7ZezPWJjflzrAIVIjkW7O8AMaYiKjwTLIU7oqyCxIw62kJgAcuvtHGg
 wlU5gRKszLiRdtmSpJp/kE+FKj1MwUgwF7pwuPGU+BqM8aBpslkQ80Don+N1lsPyf/NWkP34TBvB+iniK4eai62ME6ppTGl+yqONf/1MUiIos6V3AvJ8M51Lz1xkkLvvDwJHoHVYTRBLt2xcdE4LqMC4xEFKQ6zMWjgVjB4+PPkiGCbXKM+4ewVTrlkzSTAPjBHKqWHaFvGIxXzIbylHNMva1linl5KY8DN5EffPMSqtAGbN951S/+nbmuF/UWr5ByG9MiQvlaaucKpKSLhvEMemawvIOHeCtA8pSaG9rPOyC0wtkbCiU5aAyhkNNiKefjQtnR+Se0MGsPxS3Q1tKuyQ7I//Qt2AU6BHx03u1QOGZl+y/uVsokGnEp6WMKAKuHO6rzzDTuPAlXU6c342x6RvBJiIUGnKf3y1VriNJ+pnEUgdjfuXNUmX2TodMOTGvk/xx63qWiYqPZCTvLm536or3JIWXfU83znCIfHOgR/OQNChT8Xq/YPvKyw==

On Sat, Sep 05, 2026 at 06:01:44PM +0800, Muchun Song wrote:
> 
> 
> On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > Swap uncharge knows the memcg only by its private id, and the id can
> > outlive the memcg it used to belong to after we rebind memcgid to
> > objcgs.  Make mem_cgroup_private_id_put() take the id and resolve the
> > memcg containing the refcount internally, and keep the underlying
> > __mem_cgroup_private_id_put() for the offline path that still holds a
> > memcg pointer.
> > 
> > In the uncharge path, the memcg pointer will have to be read from the
> > xarray twice, but we'll fix that later by returning the memcg from the
> > put path, so the uncharge path can obtain a reference in the same step.
> > 
> > Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> > ---
> >   mm/memcontrol.c | 17 ++++++++++++++---
> >   1 file changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index ecb4fb07d7735..048c9bb0fad79 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4038,7 +4038,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
> >   	}
> >   }
> > -static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> > +static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
> >   {
> >   	if (refcount_sub_and_test(n, &memcg->id.ref)) {
> >   		mem_cgroup_private_id_remove(memcg);
> > @@ -4048,9 +4048,19 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
> >   	}
> >   }
> > +static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> > +{
> > +	struct mem_cgroup *memcg;
> > +
> > +	rcu_read_lock();
> > +	memcg = mem_cgroup_from_private_id(id);
> > +	__mem_cgroup_private_id_put(memcg, n);
> > +	rcu_read_unlock();
> > +}
> 
> To me, the direction of this change makes sense. At the same
> time, I would also suggest applying a similar change to the get
> function, for example: change mem_cgroup_private_id_get_online
> to:
> 
>     unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg,
>                                              unsigned int n);
> 
> Have it return a private ID. That way, I think the two interfaces
> look much more symmetrical overall.
> 
> Based on this change, it should be easier to implement the
> direction of my last suggestion in Patch 5.

Sure, I will take that.

Again, thanks for your suggestions and reviews! It's very
inspiring to me.

Regards,
Bingfang

> 
> Muchun,
> Thanks.
> 
> > +
> >   static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
> >   {
> > -	mem_cgroup_private_id_put(memcg, 1);
> > +	__mem_cgroup_private_id_put(memcg, 1);
> >   }
> >   struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
> > @@ -5815,9 +5825,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
> >   				page_counter_uncharge(&memcg->swap, nr_pages);
> >   		}
> >   		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> > -		mem_cgroup_private_id_put(memcg, nr_pages);
> > +		mem_cgroup_private_id_put(id, nr_pages);
> >   	}
> >   	rcu_read_unlock();
> > +
> >   }
> >   long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
> > 
> 

