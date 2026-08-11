Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA7D22173D
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 04:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786422726; cv=none; b=pFrYq4PJ4PBLKMYq5Ly+WHK4oq0MGcKop73A0qGOHecNZbvq1Bgg9cbc3h13tROlME+ehITrw+Drx2nYGv676UJJWQiy0PAjm5ULzrmkYg2HFi+Mz8+2UBe84Kk0LANFxix8aAPZX9XtLRtvsBr3VrAxf0y/EGxbtjyjgL5UxBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786422726; c=relaxed/simple;
	bh=T0FyM1LYqn+vS7SpXSEHVKG7ZVE3w/UPZSJUtHqjM+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LoOd/B2RjntT+BNaFJkAkb4CPMyRy+s823s0zXv72TvTts11uEC7IEQ827OHoAFwXTg6TjUQAYoerk8lvjvgCo75fxTmQFRQTPPM8x9LkxWwN19wR/ZfRlQ/j3RcIBti68h8HTvr+idbKsWRiDNSoKsGQ2u1xdoMBGwZeKjALAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=okguh+11; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="okguh+11"
Date: Mon, 10 Aug 2026 21:31:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786422722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GTngnHPe1Gqy+5LwJJcOK53VCVVuZACNEtnsThA2J0k=;
	b=okguh+11lTwJyUXg1H+ENk09yn1C4YYv5gcEpnnolfNwEFUvN58y81/ZkqPfzgCGfrSsVP
	fLapUNRsoeWLcidPHwRgv3+/8wJ+BX1K5FATo71VLkXXpU33P4R2FXIvJs5xP1co+XPgF/
	3IQ/lenlFf7PZDCarqOjSbgleKCLuSQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, akpm@linux-foundation.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] mm: memcg-v1: fix memsw and TCP failcnt accounting
Message-ID: <anqlhbQ8BSJ1AKQ4@linux.dev>
References: <20260811030843.109104-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811030843.109104-1-guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 11, 2026 at 11:08:43AM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
> cgroups") made failcnt accounting conditional on track_failcnt. It
> enabled the flag for memcg->memory, but not for memcg->memsw or
> memcg->tcpmem.
> 
> Consequently, memory.memsw.failcnt remains zero when the memory+swap
> limit is hit. memory.kmem.tcp.limit_in_bytes still sets
> memcg->tcpmem.max, but TCP charge failures are not reflected in
> memory.kmem.tcp.failcnt.
> 
> Enable failcnt accounting for both v1 counters.
> 
> To reproduce memory.memsw.failcnt:
> 
>     CG=/sys/fs/cgroup/memory/memsw-test
>     LIMIT=33554432
>     mkdir "$CG"
>     echo "$LIMIT" > "$CG/memory.limit_in_bytes"
>     echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"
> 
> Start a child process in the cgroup and make it allocate and touch 96 MiB
> of memory, causing a memcg OOM.
> 
>     cat "$CG/memory.memsw.failcnt"
> 
> Without the patch, memory.memsw.failcnt is 0. With the patch,
> memory.memsw.failcnt is greater than 0.
> 
> To reproduce memory.kmem.tcp.failcnt:
> 
>     CG=/sys/fs/cgroup/memory/tcpmem-test
>     LIMIT=65536
>     mkdir "$CG"
>     echo "$LIMIT" > "$CG/memory.kmem.tcp.limit_in_bytes"
> 
> Start a child process in the cgroup, create a TCP socket, and reserve
> 1 MiB of socket memory with SO_RESERVE_MEM. The reservation fails with
> ENOMEM.
> 
>     cat "$CG/memory.kmem.tcp.failcnt"
> 
> Without the patch, memory.kmem.tcp.failcnt is 0. With the patch,
> memory.kmem.tcp.failcnt is greater than 0.
> 
> Closes: https://sashiko.dev/#/patchset/20260810074247.52747-1-guopeng.zhang@linux.dev?part=1
> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
> Cc: stable@vger.kernel.org
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

