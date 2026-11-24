Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795497885;
	b=zF9hmD5uDrXB2b0BxS47f7W4mFSzzhcjlGcTRxk9E2zD0xUEteCdPrkokmGhoV39oXcM
	 7/2Ok+SqhMSMNLuvf93n2c2VBpnbKsaT87H6NYfRBSmQB/68+kjkHBfkutfnIqlhaIKzq
	 75czJ9kk42PThkZqoNY+gtlTwJV6LF6U+lxDgCN6n7DovCbt1PDWrOqkbrjD5pTmPyphm
	 1j05t0NILkQ1wwID7CPSZjsBtGskKCUvGHjoiOlLzxomi4KSRXmUZOKyvAUzsVRkVPlCK
	 ypOm9LTpNxcw5HLhbgeqYhmPwAXrGZTaSYdLCMI0z//hkCfanW4/XlqUNqxODRbRKZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795497885;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=EUbnCTk25H/cREetncbitvhF60S/wmbBZLPLU9DM/r4=;
	b=lLLkkk4MxWt14QBMkqiKl2day8WhRloKpqZnAozWjK6tDlQK3Iqu4n9drvtd5c8BLebV
	 DmPWk8oWxiD112QM+ka1nRqfIavOOuS2Wtsteja9YjLeK3xqOr3JsM2ZwkDAjVwgSIHYT
	 AYiyxRcu44b1JPgAzvwheZSFqJF1h0yX9BI89DcMHq2d4ui2FLp62aNTAg5+rZN8KR6aP
	 YzvCt5xQtyayQKc2kXZ8uzdzofYuP1bGfFunL+rsp4S4+2Qo2FYT+3HC+nItdakS1D2F5
	 Bv2akPcVJj41Xwa9F0y9+lI7LieM4tBvlXsETKB8rOau4Wl2ABwIfRe3RqLS/iBa8og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="QNX3vM/p";
	arc=none smtp.remote-ip=95.215.58.135
Received: from mta1.migadu.com (out-135.mta1.migadu.com [95.215.58.135])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EB3606A32A
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 05:24:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0EB3606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QNX3vM/p
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=g2dnbFx4/3WtLU6XELgiDkbskvVUDKsGs2lr4KoV968=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795497883; v=1; x=1796102683;
 b=QNX3vM/pO7Ddnq9SZyliltoXQPCTpFiMrafpRJUQJ4ummQ5OZgeZAIyDNhEsecZxu22a4RtG
 kXED4xYSIWFj6voFqLjhfc/+r6IwPQ0qnKJzwaIHmHDh5wkyWvkmo8dAixpGf+0ECJowReVqcdw
 33WtObDgte8okttvGkKsJadA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4bed5c34e88d1cd2;
	Tue, 24 Nov 2026 05:24:42 +0000
X-Mizu-Trace-ID: 4bed5c34e88d1cd2
X-Migadu-Flow: FLOW_OUT
Date: Mon, 23 Nov 2026 21:24:37 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
Message-ID: <20261124052054.GC555944@shakeel.butt@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
 <F39B4A81-BB17-4C5D-851E-2740EBBBBA8B@linux.dev>
 <awUTKy9tx8nWJgXf@linux.dev>
 <2FE2D209-FB57-4191-A324-F179B2394DB1@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2FE2D209-FB57-4191-A324-F179B2394DB1@linux.dev>

On Tue, Nov 24, 2026 at 12:52:41PM +0800, Muchun Song wrote:
> 
> 
> > On Nov 24, 2026, at 12:33, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 
> > On Tue, Nov 24, 2026 at 10:50:00AM +0800, Muchun Song wrote:
> >> 
> >> 
> >>> On Nov 24, 2026, at 08:04, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >>> 
> > [...]
> >> 
> >> The leak analysis and the fix look correct to me. However, using
> >> CSS_RELEASED here makes the private ID cleanup depend on a generic CSS
> >> teardown state, and adds an accessor solely for this failure path.
> >> 
> >> The private ID is not needed until mem_cgroup_css_online(), so could we
> >> instead reserve it at the beginning of that callback? Failures in
> >> css_create() before ->css_online() would then never own a private ID,
> >> while failures after the reservation would continue to use the existing
> >> mem_cgroup_private_id_remove() cleanup.
> >> 
> >> This would also make the private ID lifecycle more explicit: reserve and
> >> publish it during online, then drop the initial reference during offline.
> >> It would avoid both the new css_is_released() helper and special handling
> >> in mem_cgroup_css_free().
> > 
> > Thanks Muchun. Nothing needs the private ID before ->css_online(), so
> > reserving it there would work. But it moves the out-of-IDs failure from
> > ->css_alloc() to ->css_online(). By then css_create() has linked the
> > css into the parent's children list and css_idr, so mem_cgroup_iter()
> > can css_tryget() it and cache it in iter->position. A css that fails
> > online is freed without ->css_released(), so
> > invalidate_reclaim_iterators() never runs, and the free does not wait
> > for those references. Today memcg's ->css_online() fails only when a
> > small allocation fails. With the move, every mkdir on a system that is
> > out of IDs would take that path. I would rather keep failing in
> > ->css_alloc(), before anything is visible.
> > 
> > To drop the CSS_RELEASED dependency, I can test the ID's own state:
> > !memcg->private_id_objcg means the ID was never published and the memcg
> > still owns the reservation. Let me know if that works for you.
> 
> You're right. I missed that the css is visible to mem_cgroup_iter()
> before ->css_online() completes. Using private_id_objcg to track whether
> the reservation was published makes sense to me. Thanks Shakeel!
> 

Oh I just noticed that private_id_objcg is introduced in 7.4, so to
backport the fix to previous stable kernels, we will still need to use
CSS_RELEASED or something else there.
