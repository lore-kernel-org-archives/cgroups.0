Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA1B3B14A4;
	Tue, 15 Sep 2026 17:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789494321; cv=none; b=siE83XPDn95NE+voNqSgK1lnSDj1eB1aek8+gcb8CPHXbB5lLrjA1j1LRsXo/ek+3GR45LBmMvbvXhtPQfQMV/MGX6K4+tWKsxAMsz9w9uUVP8jKWBZSWjNN9NH6NetDUr3zncWoxfoiHq3LTkO5Sed87YD6B6BldUI+5FS8VlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789494321; c=relaxed/simple;
	bh=8VmRu6URDVDFRDSJizS04tRvucLtnKbX0HNSV/eiELo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jKDgnM/8hDawVb49V3JMdb8LKJsd5maWLh8zSco34BFCFwn8pnHf9hjx2FFBBbLqdKzm0A9G7jb6FymzvUD2L0wIpwgUgKwhK47sN/nE9CDxnLWVstNMBPlHOs41u6yH/1y6rOeblg9PX9pOPpONC5Ub2WA0+r+RJbbouIaifoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M6zO4m1T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M6zO4m1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A411F000FF;
	Tue, 15 Sep 2026 17:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789494318;
	bh=ZzqTBEUN5ZkT4CrwyeKMEtf7VfDqQJ0NB6PSY7rcRwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M6zO4m1TC11BSsF0irVcawKtSRQogofIydoXxhQxk4qLG09/KuXy7jGWTVWv22DR6
	 BhAVjHT7TrcnYBJ4iCY8uU6QFjHoz48wc4JE2eWe9Mti6hH+mZAUBW/5qYi4k3LG7f
	 GywmK+efzf7eEdolU3fq+ciWaGt5eqajGRLKP/jFu27osgtz9XesA3bc2Lu9IdV5q6
	 AchP2rtGdwRT4zdtMcncsPAKQXkxOzp4GcWL3phYnhdVv4f+abfTFI9FZouw2KjWn8
	 SmYeLwJ0qXWdXYFsvxuBCeetvAYH6PDovDolRIwTSBUeNEpNmo2/Fj8nKTfele3upd
	 BXsChq77n4pQQ==
Date: Tue, 15 Sep 2026 07:45:17 -1000
From: Tejun Heo <tj@kernel.org>
To: Junnan Zhang <zhangjn_dev@163.com>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org, mkoutny@suse.com,
	ridong.chen@linux.dev, sunshx@chinatelecom.cn
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in
 cgroup1_pidlist_destroy_all
Message-ID: <aqmELUhfNg1UmeEh@slm.duckdns.org>
References: <20260910061610.91209-1-zhangjn_dev@163.com>
 <20260915124010.18927-1-zhangjn_dev@163.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915124010.18927-1-zhangjn_dev@163.com>

On Tue, Sep 15, 2026 at 08:40:10PM +0800, Junnan Zhang wrote:
...
> To be upfront: I still have not reproduced the full 120s hang in the
> lab; the backlog and per-work latency I can build here remain well
> below the production node's. But the unpatched latency grows with
> exactly the two factors that were larger in production, while the
> patched latency is insensitive to them -- on an otherwise idle
> machine, with no competing workqueue items, no worker-creation stalls
> and no CPU contention.

That's a larger than two orders of magnitude gap. There likely were other, a
lot more important, factors.

Thanks.

-- 
tejun
