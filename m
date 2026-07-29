Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA984908DE
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 13:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330620; cv=none; b=nbQkAAjFnYcYMrE9zPK4FrxKNtO2qesyfk+H9XSVzMkZd7AOxvM0PTm2xTW1lkQ59ZAnlqpzMvnSBeDk9tpP1HCUN/Q220o38MRKfIODt/s0d824L8xjS2IAfdJnssNfeVD7F75eThjAHVFWjYq+uvHurz9njkRsbMyEWzNBabM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330620; c=relaxed/simple;
	bh=AId9DENR1a3jP5xUxQ+g0jHT9Xym2fxuN12VEQwjACg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhyFPN8oSyfDQEFAYCnUvt5P+Cb7WP0S0/hMtVNwQB34m2H2YMZ/0blDs1wL2BNCuufJfYtbrcH3WmNJ7vhJVyeZA6kJg5iWLRC8oRq8Mc91/hAl6uh5Toa+cMBlimhuzCnUd9OTLoHqyHuTu0s3s7/y6dpu9RNPmxiNuQZ3YsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g1T5ekvL; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g1T5ekvL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785330605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWBDvpD2lxRj16Xz0kQcWw+PNFk2I/UmPNdP3Qw4xio=;
	b=g1T5ekvL+CSLqzeTNQQxWvE4/zmkHJt0Mb5cOMd9Diyx7nToR43X1gbDbceFRU7SOZN6DD
	/pBPtCM80ZwPuhy+9SuYkSqLCZhC6uLs3i9AEDYx/YwS5VSNJTMBE4SSiOir+4aOsU7MMX
	7SLA5RnDMbWlS7aY1Mu+s45qlXYF5GQ=
From: Usama Arif <usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Subject: Re: [PATCH v5 2/3] mm/vmscan: add pgrotate_anon and pgrotate_file vmstat counters
Date: Wed, 29 Jul 2026 06:09:57 -0700
Message-ID: <20260729130958.3728209-1-usama.arif@linux.dev>
In-Reply-To: <20260727162550.2032-3-usama.arif@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 27 Jul 2026 09:23:24 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Reclaim can spend substantial work on an LRU type without immediately
> reclaiming or demoting a corresponding amount of memory. Record this
> work in PGROTATE_ANON and PGROTATE_FILE.
> 
> For classic LRU reclaim:
> 
>   - Inactive-list reclaim adds nr_scanned - nr_reclaimed to the
>     corresponding anon/file counter when isolation succeeds.
>   - Active-list reclaim adds referenced executable file folios that
>     are retained on the active list to PGROTATE_FILE. Active anon
>     reclaim does not contribute this component.
> 
> For MGLRU, add the number of initially isolated pages that remain
> unreclaimed after both the initial and retry passes to the counter for
> the selected anon/file type.
> 
> These counters are distinct from the existing pgrotated vm event.
> pgrotated records an actual move to the inactive-list tail, primarily
> after reclaim-marked writeback completes or failed invalidation leaves
> a folio for accelerated reclaim. PGROTATE_ANON and PGROTATE_FILE
> measure reclaim cost and do not imply that a folio moved to an LRU tail.
> 
> A subsequent patch will consume these counters for anon/file scan
> balancing.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  include/linux/mmzone.h |  2 ++
>  mm/memcontrol.c        |  2 ++
>  mm/vmscan.c            | 14 +++++++++++++-
>  mm/vmstat.c            |  2 ++
>  4 files changed, 19 insertions(+), 1 deletion(-)
>

I do think the sashiko reviews in [1] about MGLRU are not correct.

I am going to ignore those unless the MGLRU maintainers think its an issue.

[1] https://sashiko.dev/#/patchset/20260727162550.2032-1-usama.arif%40linux.dev 
