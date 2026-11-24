Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795494818;
	b=UA9yGiFOyvLvYKlvunHSXU49fPd1hxZPFaglj7oUL9qOQZh4SZGAEL3CczYvt63e4HbG
	 qO6VvprQy8Kzkyu329c4NWKL3OWvSGcm04hGG5knbp6H2TAQVxV8FX6fFhbwnvFwi8BJc
	 EX/t2UAHwL04PtVnJzngk23nr6zNu1MPnkgCJaR8210IEHDBFW/yjXoUuMmDlNnL66nMg
	 /Jol1VK7+7QtBsPTZ13Sn7uiKvnH1iux2yMDqMgOyOPH6Kt0QU9u9mPYEBcD6TGzlwSZx
	 sB9Eh+0WD3ZAiT+ZEUGFmgnkEvit9Z9z5j1ZzhFMibYJFCIohUrG72o8NRvF4ZSA7sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795494818;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qeS+Wqldyca7IlFeTqWB+yHVGIRNOofJMih/xkJzWH0=;
	b=VqB3bWKcjIOQEubGMBGYInqDiZ5mntCZzUXOn5se2ZuzfUKfvcgfhbC2GZQlSHRx9XvP
	 SMhGJV8uAZDr5BN8bMZnyV6oPaiknQUmuQieDa/2IH6vbUyuf0pjwDWtaplVim91ffp2b
	 JgsLehpU9Hz61zWQQH0kRvxDfVvw1pfG4qesYbPgZgHERz1f27tjrxuh/F769UNR6ucEk
	 8aF/H7XJKBw9BYe7lFXosP9m1iL9d1QM2Wz9jpzx6c5MKDKJOQhpcPvHbPWOL7vrW2j35
	 rcBlMC410UQH+ZsHOCyMRJmljwUNOJHND1RYJk3Wld7fVhOXL/GVWEgqDoAIdGYjCuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EChO5xkU;
	arc=none smtp.remote-ip=95.215.58.148
Received: from mta1.migadu.com (out-148.mta1.migadu.com [95.215.58.148])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45417606A321
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 04:33:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45417606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EChO5xkU
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XrJqniAxtYnOjs6qtgcphsG7K6LdaIDb/mHKEP/nTBc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795494815; v=1; x=1796099615;
 b=EChO5xkUCstUOXGGiv9FCZ+/EkSHyKCcChaKP++g+zGEeyhOUnEGUMZvsDHJpcs2y2dHouLE
 b0RxfeAV6fIkbBQc0izTiZA/u8hLON+4WUir1N5L37zz0r5EwLjvahELnjzlOaM76zpU9suNOdu
 JLzoHdnuzLhmAShdbG7m3ZKE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 40e2dd995e1bde24;
	Tue, 24 Nov 2026 04:33:34 +0000
X-Mizu-Trace-ID: 40e2dd995e1bde24
X-Migadu-Flow: FLOW_OUT
Date: Mon, 23 Nov 2026 20:33:33 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
Message-ID: <awUTKy9tx8nWJgXf@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
 <F39B4A81-BB17-4C5D-851E-2740EBBBBA8B@linux.dev>
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
In-Reply-To: <F39B4A81-BB17-4C5D-851E-2740EBBBBA8B@linux.dev>

On Tue, Nov 24, 2026 at 10:50:00AM +0800, Muchun Song wrote:
> 
> 
> > On Nov 24, 2026, at 08:04, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 
[...]
> 
> The leak analysis and the fix look correct to me. However, using
> CSS_RELEASED here makes the private ID cleanup depend on a generic CSS
> teardown state, and adds an accessor solely for this failure path.
> 
> The private ID is not needed until mem_cgroup_css_online(), so could we
> instead reserve it at the beginning of that callback? Failures in
> css_create() before ->css_online() would then never own a private ID,
> while failures after the reservation would continue to use the existing
> mem_cgroup_private_id_remove() cleanup.
> 
> This would also make the private ID lifecycle more explicit: reserve and
> publish it during online, then drop the initial reference during offline.
> It would avoid both the new css_is_released() helper and special handling
> in mem_cgroup_css_free().

Thanks Muchun. Nothing needs the private ID before ->css_online(), so
reserving it there would work. But it moves the out-of-IDs failure from
->css_alloc() to ->css_online(). By then css_create() has linked the
css into the parent's children list and css_idr, so mem_cgroup_iter()
can css_tryget() it and cache it in iter->position. A css that fails
online is freed without ->css_released(), so
invalidate_reclaim_iterators() never runs, and the free does not wait
for those references. Today memcg's ->css_online() fails only when a
small allocation fails. With the move, every mkdir on a system that is
out of IDs would take that path. I would rather keep failing in
->css_alloc(), before anything is visible.

To drop the CSS_RELEASED dependency, I can test the ID's own state:
!memcg->private_id_objcg means the ID was never published and the memcg
still owns the reservation. Let me know if that works for you.

