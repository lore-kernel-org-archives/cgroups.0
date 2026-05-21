Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B293DB332
	for <cgroups@vger.kernel.org>; Thu, 21 May 2026 17:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779384344; cv=none; b=q+uBma7rw5KB7dhtJ7qBv5I6NHJ0YjzlihredCRzP+W73sazOqi8MnJ37fu//B4cJYmuaEpdfYJLknD556Kg6x1Ob5S4cocyfcQnpCagYGTRQpqA3IAhF1A0q7/ZF4sVyQYbp50e8i/jM2MR1oyJZXPCwS9mxlqVDjxvLiRlBJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779384344; c=relaxed/simple;
	bh=mRLF46kf7HA8naZ3dQNeBQ9NbsNWENZ8rBEdJoXY+EE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jRv/K8vJrvbRC3fRyPTtdIJks45Jv6K/IiVlQe191QgJULnrAH96vfpnr9HmvOoFbcFzUexep5cMkuuBytRjuROVlJaqTPlCEjFRXojgmNh3iqJOFDmkLeI090caQixKOwm+nHp0w3qKnX6/Hp8xQXkjQM6Vt5ZNRhyVpG8tLuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YmVIoM7s; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YmVIoM7s"
Date: Thu, 21 May 2026 10:25:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779384326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iMwxwYsInnQKNuZpDpS5C1/ioRJ+8U1UfRBdgFKYaUc=;
	b=YmVIoM7sBMemQ/wGQmebFrGGn3b1FfSmy2xsVZhLKgadJl+TMfwx4qj3xmAFBd4E5nekDc
	qZiao4IOLB0FhuCE9ppf8VD/37qOpevXEKQ6RTy4DnpjmnURHE2K3CHi7tKyi1RYR0UnjA
	4xAEDOf3Cz7+ibx+oPvAZmOIYpIeHlA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Minchan Kim <minchan@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Wei Xu <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 2/8] mm: percpu: charge obj_exts allocation with
 __GFP_ACCOUNT
Message-ID: <ag8-Dfoco9qQho0A@linux.dev>
References: <20260511202136.330358-1-alex@ghiti.fr>
 <20260511202136.330358-3-alex@ghiti.fr>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511202136.330358-3-alex@ghiti.fr>
X-Migadu-Flow: FLOW_OUT

On Mon, May 11, 2026 at 10:20:37PM +0200, Alexandre Ghiti wrote:
> This is a preparatory patch for upcoming per-memcg-per-node kmem
> accounting.
> 
> pcpu allocations are always fully charged at once using
> pcpu_obj_full_size(), which returns the size of the pcpu "metadata" +
> pcpu "payload". But metadata and payload may not be allocated on the
> same numa node, so charge the metadata independently from the payload.
> 
> Do this by explicitly passing __GFP_ACCOUNT to the obj_exts allocation
> and remove its accounting in pcpu_memcg_pre_alloc_hook().

Will all the entries in obj_exts array be for the same memcg? If not then why we
are charging the whole array to the one which happen to allocate the array?

Sorry I don't know the details of percpu allocator, so asking some dumb
questions:

1. Does the alloc_percpu() (& similar functions) allocate the underlying on a
   single node or does it allocate memory for each cpu on their local node?
   For slub, it is on the same node, so the situation is easier to handle.

2. On a typical system how much memory is consumed by obj_exts for the percpu
   allocator chunks? I am wondering if we don't charge it, how much will we
   loose?

3. What would be side effect on assuming that obj_exts is on the same node as
   the given chunk?
