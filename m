Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792630401;
	b=ZVX8iwviUPn6+GaiLUUcxDD0CLNJwR1z0QbziwaQLk6CP832crkzZsJKwKaDC9KyvYos
	 VzdGtrk096bpuSwpyhK8i/908iTd5pA3QzvmpVtzsObxCJOX5VRLioR//c7BZotOCGwuM
	 zdb/blviZhwYN6BeJuWxLu58rpifcY1esdw4qcIi3yS58RSAL8W6RfkaxcoLUsd/V+PGv
	 FuEMx+czZXIArirJIMwKRSw7h7Qfb0w67ghkCa8BnLj9//3wO1V5lZDYVeIm7vKTZZbu9
	 Rgmns8NLsPlECPGaCAf/PC735339V7HfPyPU6HlFJrFbj/m1UcwlWzrAzVywX+d2O7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792630401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8b5nCz8QSeUyyC9CYP5Soi2IAEV97jGZySiEE6BlXEc=;
	b=LBw5taLyygSYSWaifTfYIbHwFihZWUa61NUxrQPObNJSXWdXehqGdoXxWcF/319s8uge
	 IW4bXx7RGUgpT+augyCP95rjkZhqD6SKVnydghpaJBwJ8XQL6YVfmq4v9aNmVir0fZ0Kw
	 2BLvhPjGsjzKjFLPBCQoBmgUlc2aRcGwrNk6PpHvbClx71Qc77/mQ6h9uFaMna/+oFEfh
	 7UsinS+hm+vxew9YKfBf/iqAdcSs2KzKLbxld0B8ssLCM15v+NnRXz4nMFBKWK8mINp0E
	 l590r7+vGf7NRcpO1NbbPNWF12e6E5yN7zDtcGFDYJTLfopwfeSwOeDns/v0JUZU6wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U0eKPT7E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FF0606A322;
	Thu, 22 Oct 2026 00:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U0eKPT7E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CDE1F000C2;
	Thu, 22 Oct 2026 00:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792630400;
	bh=8b5nCz8QSeUyyC9CYP5Soi2IAEV97jGZySiEE6BlXEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U0eKPT7EPpYXONbxlYhXtXDGL7X5L2m43GmogPVtOg17umKScJgZ8YdquJHumGuFK
	 ggLyc/z8oMM1C9+OLEUqYZhWw+pfaSpKzfuOjs7y4WQE4DHsjQOaYWQSM2rCJllppf
	 gydKVr1xuEC9Fp8AkI4OMyg6GghywwulDc9pPxIsXxQy3GrQ3pbHtoiaIA82sUoodc
	 +rNyQS/q1YZt0kivdQPNMjdYzlu3KYMJz/qPQcTfiAWyme2FlZiv/Z4HgPuFZpGUUE
	 ijeBDQKPnPIiGegcdDlGDlMDXdXexLTp95egJGPMnL5dS+I8DKv6CWlYb6l7OfMS3U
	 BdDG85kk6t5BQ==
From: SJ Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Down <chris@chrisdown.name>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/page_counter: use WRITE_ONCE() for emin/elow when parent is the root
Date: Wed, 21 Oct 2026 17:53:07 -0700
Message-ID: <20261022005307.87910-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261021204818.3431099-1-shakeel.butt@linux.dev>
References: 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 21 Oct 2026 13:48:18 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> page_counter_calculate_protection() runs without locks. Several
> reclaimers can update the same counter's emin and elow at the same
> time, and readers such as mem_cgroup_below_min(), mem_cgroup_protection()
> and the dmem eviction code load them with READ_ONCE().
> 
> Commit b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store
> tearing") made the main path store emin and elow with WRITE_ONCE(), but
> it missed the early return for a counter whose parent is the reclaim
> root. Those two stores are the only plain accesses to emin and elow
> left.
> 
> With CONFIG_KCSAN_STRICT=y, a few tasks writing to the same cgroup's
> memory.reclaim trigger reports like this within seconds:
> 
>   BUG: KCSAN: data-race in page_counter_calculate_protection / shrink_node
> 
>   read (marked) to 0xff1f91b146d40e40 of 8 bytes by task 163 on cpu 4:
>    shrink_node+0x57a/0x1210
>    do_try_to_free_pages+0x194/0x930
>    try_to_free_mem_cgroup_pages+0x204/0x3f0
>    user_proactive_reclaim+0x28a/0x4d0
>    memory_reclaim+0x35/0x50
>    ...
> 
>   write to 0xff1f91b146d40e40 of 8 bytes by task 167 on cpu 6:
>    page_counter_calculate_protection+0x1fa/0x360
>    mem_cgroup_calculate_protection+0x4e/0x70
>    shrink_node+0x53e/0x1210
>    ...
> 
> The default KCSAN config does not report it, because it treats aligned
> word-sized plain writes as atomic.
> 
> Use WRITE_ONCE() for these two stores as well.
> 
> There is no functional change. Readers already accept stale values, and
> compilers emit a single word-sized store either way: with GCC 14 the
> x86-64 object code is the same before and after this change.

Makes sense to me.

> 
> Fixes: b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store tearing")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]
