Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE79B3B774D;
	Mon, 28 Sep 2026 19:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623179; cv=none; b=FqtKiD4Sv0y9FHvPkmBnVeimWtS628M5NG6TBFkMSDLS5RUfAccEUpRgiXiy3V2yUNw1apscax4pxx2IBKFTifndcAPInkIZwBewOLDCdCt9c+ieYDoK3ZWlFy26MOj8qWb1pUQDfahCjPM4rngN25hnsZLmMFvTnE/C9osG5OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623179; c=relaxed/simple;
	bh=i2nati6hdcx1oxdgTVKEqHv+x+qm//MmCWTE2dPlONM=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OfGn0ERuSi6fYv4g4TTbNy4rcPQMa/O2y+am27vrhKjYNoP7J/z0OHA0X5Nn5lDY+vZ2j12IgQvfO/bTkGzpiJLIk1L42jGiyHuXTB4qFLvsQ8tCe/wFgd/HNFlHG5TKqil0f4i9eddNmA5V0Zj1XtkLLefyRluoIYxQKt2R+VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WAYnUTXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WAYnUTXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BAA1F000FF;
	Mon, 28 Sep 2026 19:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790623178;
	bh=3OTxVK/IdLEHqgZUY95Y42pkKEW+PjtSBC6ONnLsZ9Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WAYnUTXMTXFJKySbFuqmzPeYKgqYlqqRd7oCs3fqws60PvxNF/9klFq7Oc0tur97v
	 v2klAFQ0UtKjB23cHitm4X8qmLcY0tql6Sfay8DLht6bG41WBKFxrtPijuj5XzIKyW
	 /RENMf0MhvCZ9/bNd/7Hx1ljqhzWXqJnaUN1Whoi1WK1/tJWt9JF4rWiswaTBi48Dg
	 EbzImNa1nN+ucQhgWHRlTi0W0x8A6k1dQsXIM67gUPzMXzz75Yg0TfwpDSAqw87viy
	 WUf82vC80QtmXOSQSNGU+hi75dVP8dHJ6WHuEq5Ix6PFeyY0nQ9kBSmTehgred27gu
	 znOwWLZdQ1T7Q==
Date: Mon, 28 Sep 2026 09:19:37 -1000
Message-ID: <ee85445f60194cfbc78897cb6fe744c7@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Xin Yin <yinxin.x@bytedance.com>,
 linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 ian@honeycomb.io,
 stable@vger.kernel.org
Subject: Re: [PATCH] writeback: let foreign flushes reach dying cgwbs
In-Reply-To: <20260926-wb-dying-cgwb-flush-v1-1-a8d898085a3a@honeycomb.io>
References: <20260926-wb-dying-cgwb-flush-v1-1-a8d898085a3a@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello, Liz.

On Sun, Sep 27, 2026 at 05:04:39AM +0000, Liz Fong-Jones wrote:
> Fall back to searching bdi->wb_list, where killed wbs stay until they
> are released. With commit 168a8c13159c ("writeback: size foreign
> flushes by target wb dirty pages"), the flush is then sized from the
> wb's own dirty pages and writes out what the replacement dirtied.

Instead of walking bdi->wb_list, can't we update the lifetime rule so that
a wb stays on bdi->cgwb_tree until it's actually released? That is, remove
it from the tree in cgwb_release_workfn() instead of cgwb_kill() and have
the creation paths skip dying wbs. cgroup_writeback_by_id() would then
find the dying wb through the regular lookup.

Note that the blkcg association check in wb_get_lookup() would have to
move to the creation side. If io is enabled on the removed cgroup,
cgroup_get_e_css() returns an ancestor's io css and a dying wb would never
match.

> Fixes: d62241c7a406 ("writeback, memcg: Implement cgroup_writeback_by_id()")
> Cc: stable@vger.kernel.org

I don't think this qualifies as a fix. Can you drop the Fixes: and stable
tags?

Thanks.

-- 
tejun
