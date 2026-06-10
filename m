Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A93D14BF92;
	Wed, 10 Jun 2026 00:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781050787; cv=none; b=oL4fS4sX+dCrzGMY0uUOS/7V/ns3E0JXC2EV4wkZ1xwJbbX61HUNwKeOYgs/y39KichsziG5xSH94oOP4aTlvaCqs9wnLsUPFUofe8Vqi5WoHWbNBTeBgtW6t8Ni1E541+ZBT60bweeLQ7lie5WLC7tIaKZuLVnTLW5qswvhl9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781050787; c=relaxed/simple;
	bh=rcnhI1gz6rGDI3MpjmQm1cY9tN+OOLMVWD2/8jEkC2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ch7F5YWSfwDRz+QYhh2EK6kkRKG6aON1XQt3MkVbjOtqWf9Gy8bGhvqKeUVBbOVjXCp+AI8yz1kTP3nBwXwBOUh3rhpIbm+7e84J3Q2G0X7GEmoZsgqB6jZ8nZkDRF3tGmSriLDqov91rLX4FxNRQCNMWOGit4TCGWD2Z8U0jeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nJP47KD1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nJP47KD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C647E1F00893;
	Wed, 10 Jun 2026 00:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781050786;
	bh=J6Qec06ssPjZ8KBpX5bHjrDWkBPXABIpPVj+yD4nsUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJP47KD1xmj0+wbmArvRXxtJ0OtvRFbtwrAedhff3E+nr1a58A3hIDqqqkqDT2JbT
	 nWpaYSf9JEt9lRb/4xCqkqelm5WcHsEteiw26d3UAo1recuw6shcpx07tO9Z9S5GON
	 0gGNmsfODaPOMYQlArenuEs02ePfW4TfUIbQgekopwCiYj/XodVIsLDtRD3j3CprW3
	 MwoSH997YlEx00d1lBpFzB0Bwg9uLHA/awmtrFqI4880OSAET7y07GguP9dERmkPxb
	 wJWeR0mSFBFH89RYA8exc1D2TGfjGwpWtL+5pnJVKw6YQKOy+/HweqsNih5bK2wnBm
	 cx0VK6Rk5KnjQ==
From: SeongJae Park <sj@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	chenridong@huaweicloud.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rientjes@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and alloc_context nodemask
Date: Tue,  9 Jun 2026 17:19:36 -0700
Message-ID: <20260610001937.77371-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260609002919.3967782-1-gourry@gourry.net>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon,  8 Jun 2026 20:29:19 -0400 Gregory Price <gourry@gourry.net> wrote:

> The nodemasks in these structures may come from a variety of sources,
> including tasks and cpusets - and should never be modified by any code
> when being passed around inside another context.

Nice work, I also confirmed I can built the kernel with this patch.

> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

Tested-by: SeongJae Park <sj@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>

[...]
>  	/*
>  	 * The memory cgroup that hit its limit and as a result is the
> @@ -6599,7 +6599,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
>   * happens, the page allocator should not consider triggering the OOM killer.
>   */
>  static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
> -					nodemask_t *nodemask)
> +				    const nodemask_t *nodemask)

Seems the above indentation has changed for a rason that I have no clue, and
also introduced a line having both spaces and tabs.

Just thinking loud.


Thanks,
SJ

[...]
