Received: from outbound.ms.icloud.com (ms-2001f-snip4-10.eps.apple.com [57.103.73.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097243D7A18
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 19:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.73.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789758859; cv=none; b=niqhIDeFlsinw4P5h4/JvX7FxJK5UD5C5FfUdRYCdjbmnDDmVGiCv0s+yS5IIitR0Eqs6mqf8iNrA8OWvQuHWasDkKQfaJtkiTTNs9tS4axohFSVp5CQn2RsIqxWEutQc5/+LjnC2Fg01AElz9A+sNjz4dBn4Jy911i+3IYRO18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789758859; c=relaxed/simple;
	bh=iMm9vMK9Xe+ef0KAk20+7SWzlYZ+nDsyks61rfIqBVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DemVr/gC1mPO6/9ybskDWA1pDIJ+mgB8/W9CtTB/EjM/u0rv+W6dxzYvVpzXqB+iXdBxZ0D52Uh3Am+9vf1O5/jffL9ibf7s+ALRaPQBGnxfR1DEPA4wPHqEAOSjo+S/5nRFvVfHv1THGMMpARcCaEupFPdoctr2KJPg3AH/gZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=Js38DULw; arc=none smtp.client-ip=57.103.73.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="Js38DULw"
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-2 (Postfix) with ESMTPS id C4116180014C;
	Fri, 18 Sep 2026 19:14:10 +0000 (UTC)
X-ICL-RepId: 01a0b5f0-c68c-78d1-94b1-522a552173d3
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQhOAEMGWQdeCEwCQwZYClBcHA4PUQxHH3kRUAFYHlZeWhdeTVEPDxlaFFwYU0VRH1RYQQ4KWgtQUR1fAgoERwRbF0YDU0VfAxcRUAFYHlZeWhdeTUcfQE1iSQFaGVscQBdKbk1TDw8ZWhRcGFNFUR9UWF4EU1YOEUhKeQlALUc7ai18XwMIbTB7MX0qcSp8N34tfEB6KAJOGQxKHVJWWxNVF0YJ
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789758854; x=1792350854; bh=zWqcj/x6eWYWbBAL8kl/ymZLuNhjh0BA6RJ6N290BcI=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=Js38DULwrukcCRSoJMjJBXBKxGgeLw2rwtAxJYs0TLF9Na00R3xPywULitqV1dAH6hG73N0k72FAgaJYgFGsncbGSuI+RvhOpYRwQkXiAVgMMOpHOdQlVOztqBTerafBroDU8kvXsEmNphsptgJ+pzkNyabexOnwe+ZD6e7L4YLz5fgqY/IdYhHXb9/WRAvXdij3RUOxy2/y+rxW4YZI7eKLrKr9d1DWPx6Jov63+R8hxYJlKjDaYrtiWuq8lEcBXxoDywAtPAQmDVWE7TD2R2E67wRd+Vv7bdt6o/X1RDOo0Sh59RxkNOeAeFyJZdoEPdOwH9KEu0ELDRD4CB98yA==
mail-alias-created-date: 1772519804199
Received: from BINGFANGGUO-MC0 (unknown [17.156.208.39])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-2 (Postfix) with ESMTPSA id A4764180017D;
	Fri, 18 Sep 2026 19:14:04 +0000 (UTC)
Date: Sat, 19 Sep 2026 03:14:00 +0800
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
Subject: Re: [PATCH 4/4] memcg: move memcg private ID refcount to objcg
Message-ID: <aq2JdwFuKSUO24c_@BINGFANGGUO-MC0>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-4-5bbf3220d88f@tencent.com>
 <aq2AUmRISe3Nmfft@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq2AUmRISe3Nmfft@linux.dev>
X-Proofpoint-GUID: lM56lfooGkGx8VqIDgjmfZIh95NUhIJw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDI3NyBTYWx0ZWRfXw7vRgnkvLACs
 zCN9QZxssgzuh/otDe5TsLrV1j+RR+aXz5C/AlQGc+eBg5RVjrPSMWEOK8+Ktae5tgqd4ywDH37
 W1YHLn5DonaEl1PJUiwPi0qyCXkvDnZBYCS7vPCPlKvGbix4+EL4Jy9tmR/AkkEpRwu71GJj1uJ
 GySFC9LJT1u4Bd2pSs1l2WE/B7et7oFkkyQBwB9v3kS0GyGtneOtuXFFQPZZFzoF1g0bwnMAaf9
 vu1v03YJQgLBtqgV1yfI0DjFTFwYIkMfv3lDparQW2tyimjwCquGrccSIgdRocjpmjLCUKAQ7vf
 cc6ZTS3g8VVJ+HZwtNNYKNSPCZhYsX4kQXnGggh/c1bjHrS58b5VvyUcW2hUaY=
X-Proofpoint-ORIG-GUID: lM56lfooGkGx8VqIDgjmfZIh95NUhIJw
X-Authority-Info-Out: v=2.4 cv=fPA0HJae c=1 sm=1 tr=0 ts=6aad8d85
 cx=c_apl:c_pps:t_out a=kRaGL2Q7qLiahLf3O6OaIA==:117
 a=kRaGL2Q7qLiahLf3O6OaIA==:17 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10
 a=x7bEGLp0ZPQA:10 a=vu5NlEYW-o8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=N-mGDGxclJDxHLb_ER0A:9 a=CjuIK1q_8ugA:10
X-JNJ: AAAAAAAB9jBc8wj8EuzGQJhAEc7+fSE+eTWbzq4/kImKkp555YMA7pXJyMEHsIEiaBAwrrL+zdncb89SvcQeTok9aX6ho0IGdn+BHJZ1jnZht8gj8eoiOGEkjJbIelVreiusVq8TGn9y4rZfSTg5bzCJ/zbUxDY/ssVTTCdhqho3xGGq0tb0ff1cOyDyPcWk3WdbFGa99CdjxY0XYmSGBn6oMh7C+BxOgXGIah0DhmTy8DYkt2ZKOAfTKG9Ua9VnXs2aH1gcT0qtD9NKMl7Ow8yBfxQWOdz4G4ofFlxJ5v04EkV82npleTwRn0pws8OYxNqDFUNoENuCjnwRTClH5nPHmRwlaCwSX3OGKY6in60vYO/A5bY1ds7z2Y8Zl55Gr6coQ+qaDw/00G6DMvp/Y4/r/GdplsjtHf6Wu93dVBs5ig758oOwgdq4UMnQDuVcvxRvQYfcu5DsEJK9WOxQtqn97pORomY38HCambcTn6xPcr54CnodGRrtCVWfKPZJjS2dJMLUPbqo2JHcB1feHWE34JftOkDsJ7dpZy00tXanoSyjrHl61wUw5OucAJzA65n6xv2/LnMObSP02FmEFXViXx+Owxe2J4B0zugC1Uw8RRcnaunfjIs0udGXt+DjtlUN45Oq3xr3LnO7GjsKxLpctoRnlzI1xf3vqpee2G1MCa+mJApmEhDLscvv1GopeqiTwN5UyIeeAxNDhYVcfXoFaasn/tgtUZrhLhv/bVVUTzmu5e5QG/q1hwGNXtAPPoxY/1NnUKuRJ3sCPgwSyF2Kq0aBpSz+TfXbCBqKBzoagZTxYlI++3iIu4H8MZshwBlydK+aw2/ixHJgJj6aY1neadshe+JaLBzjmELoLC7V8ie8HXo7ZizDNrymDRSgaog4qcgkz+aRnssRTEd4/gsxeHoyrJjTI3Ot6k6WBYXpI7Ieef01WnCiSDxFnvl6RbIwSVA8RT0U5WvQYlKStsewlv2TAXE
 zOCZHjy9lcQkkQdAzKTFad0qOh39Wr8GtgaAtvcOFupjc7jAI2LzMrd0pMLyIMJCK+3sLoI7hkCuTReukfp9OZl0AMPtjEs9LQvg4kDhc9m3PBI8HLJQASYVv9KCTr3OYbG9ispm4a2t9mXvhLWk3v6FhlwOx/scAXsFu3+AGgKrdprn8VEldZmmbFkCbCJHN1wddOO62TUV7gjKjKtnEhNxEzRnIzw39eP5pAIIKG2ytEl64aNp65RJnSy4fCtLoHes8E/e5gObzX+TxdBU2Z5ynVpyQ7xyCBauoDZpwf+lmO+aSetFqx8emV/YqkZWq10gacwOX386B8M4eyVeZ3r5srv+aVpz8z/+ZzTdcQ2fMsGqI704PjO9fB1IGPtcxGuKYgLeWHTaLX5bSsKrCClS9EOEAwCmX46lHUSZcElhVgEJFioQDPGWd1K3n207FZ/mci6eeYrzWsfD9YA==

On Fri, Sep 18, 2026 at 11:19:08AM +0800, Shakeel Butt wrote:
> On Fri, Sep 18, 2026 at 05:18:43PM +0800, Bingfang Guo via B4 Relay wrote:
> > From: Bingfang Guo <bingfangguo@tencent.com>
> > 
> > diff --git a/mm/workingset.c b/mm/workingset.c
> > index 8412f4840ae35..7e4fbc5a786d6 100644
> > --- a/mm/workingset.c
> > +++ b/mm/workingset.c
> > @@ -281,6 +281,9 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
> >  	unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);
> >  
> >  	memcg = mem_cgroup_from_private_id(memcg_id);
> > +	if (!memcg)
> > +		return false;
> 
> You can not return here without initializing *lruvec as it might be used in the
> caller. Also mem_cgroup_lruvec() can handle null memcg and will substitute with
> root_mem_cgroup.
> 

Oops. Thanks! Nice catch!

I made a mistake here and it managed to work so I didn't notice
it...

In the previous patch I left here unchanged and used the root.
But then it struck me that maybe it is more consistent to make
the classical LRU and MGLRU behave similarly by skipping the
recency check for both of them.

I'd like to hear about your suggestions:  Whether to simply
remove the if statement and use the root only for MGLRU? Or to
use the root and keep the test speculative for both the two?

Thanks
Bingfang

> > +
> >  	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
> >  
> >  	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
> > @@ -470,7 +473,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
> >  	 * configurations instead.
> >  	 */
> >  	eviction_memcg = mem_cgroup_from_private_id(memcgid);
> > -	if (!mem_cgroup_tryget(eviction_memcg))
> > +	if (eviction_memcg && !mem_cgroup_tryget(eviction_memcg))
> >  		eviction_memcg = NULL;
> >  	rcu_read_unlock();
> >  
> > 
> > -- 
> > 2.43.7
> > 
> > 
