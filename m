Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785913;
	b=bZBd6u8bjIxHLgz0+O2x3Yn2wh4ea1wu2IR2M+Zj7ROQFQ2fO8KantqtE2Hr+mHYKKZk
	 yRLya8yFF9r8Mck11yFYsygJoiD/4+K3WP9ygHGUsFATT0FxwvwAInZ2afk6SS002JhLF
	 UKJ6qNUnje+xPBukkEpFsliJa0N162RNnGGpRi2aAsH0z618tqLkj2KACfNSj2xTUxe/O
	 L5+JUaKuyyiDupW1Q4aJ/euDBZR3dT68ozjS5jaoS0h+W4iPzwKRFS5brLL3ogMYS+6D3
	 SuvFTVg84C0XPAW4Tw6qBoQiOD8/ZqmA3xPt6TGfQW8DdEUMaZGPTa1qWTYUs2Ag0IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785913;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References;
	bh=NMpzoe28Li6scyvq7gG95vJno5EdAW6a0YsgQjZX2q0=;
	b=KeyKytHOSKohge4GEa9yl2C8JQvGIxuGdIo78FrLv+JB0UHtw9yjoRtnkDV/xiOUT7GL
	 QhW8zuNqwvyY9rOac5jlbBDkNQfT44ElVSNJ8TXn0qxd+lLs+e8SPP8jP4vQCzLstSbka
	 MQtgS64HiDHXpM4WDjQ71sVH1YyPKIbbwqvBOHB0CA60V2PdUgNPcMc7C0TrtkhMdOz33
	 DVpa+DLMH8SMXByyxJbqjLOmcLFwhQS0qq/Ux5Os1ARX31rAXO1XzX0n3OzwfuxAwIY2a
	 uswGChTv7WXviCgHr4N5rl+LobQPAQtcLRH8gSxvgNHMwccCYScmwBsHCzxoz1tXXrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BGve7nPZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CDE606A31A;
	Fri, 23 Oct 2026 20:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BGve7nPZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813B61F01825;
	Fri, 23 Oct 2026 20:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792785912;
	bh=NMpzoe28Li6scyvq7gG95vJno5EdAW6a0YsgQjZX2q0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BGve7nPZbSwa2LqTQNHByaYKCoffL8elEuhk+jlz/gI5i7hV1ZK7iwu/qtmG9KnfW
	 qDLQ6u36lWhx7UicKyDcMUNChfBFrWn3JenrDFldoBbRTNPnoVuGnXK7yry9/I+UhS
	 MWE4pDnSM609ghIOhSw3yImpZyKuDOHWSrhjgRD5US80G6Qkq1oMwCM7PasP4Odoa5
	 eWESoT+iBiqSqRyLeo/eyLiBZIlzhddfENhxpqe5rRVvDNGrCXD9ZfhommNweBCA6Y
	 MohZtgivmb5EyOPKL9f0ST9iqF4qVtUezx3RIOK809+Ej3U/6BhD3Jc4as7eFyeM2/
	 DlEx8t9aemyMg==
Date: Fri, 23 Oct 2026 10:05:11 -1000
Message-ID: <100602397eadeaae2e3206e1d9aae55e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: convert cg_read_key_*() helpers to s64
In-Reply-To: <20261022042921.711624-1-wfelipe@google.com>
References: <20261022042921.711624-1-wfelipe@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

Hello, Wilson.

The following is a Claude-generated review.

On Thu, Oct 22, 2026 at 04:28:57AM +0000, Wilson Felipe Pereira wrote:
> On 32-bit platforms, cg_read_key_long() relies on atol(), which returns a
> 32-bit signed long. When values in memory.stat or event counters exceed
> 2.14GB (such as on 32-bit systems with large memory), the parsed value
> overflows and wraps into negative numbers, leading to subtle bugs and
> false test failures.

On 32-bit, glibc's atol() saturates at LONG_MAX instead of wrapping:
atol("3000000000") returns 2147483647. Event counters are counts, not
bytes. No test reads a value near 2^31 from its cgroups, so the false
failures are hypothetical. Can the description be updated to match?

cg_read_long() and cg_read_long_fd() still use atol() and return long.
They read memory.current, memory.peak and the swap counters, which the
same reasoning covers.

> - Migrate helper functions (get_cg_wb_count(), get_zswpout(),
>   get_zswap_incomp(), wait_for_writeback(), and cg_check_freezetime())
>   and their callers to s64.

In test_freezer.c, only test_cgfreezer_time_empty() is converted.
test_cgfreezer_time_simple(), _populate(), _migrate(), _parent(),
_child() and _nested() still store cg_check_freezetime() results in
long and print them with %ld. In test_cpu.c, overprovision_validate()
still computes "long delta" from two s64 usage values. A 32-bit build
with -Wshorten-64-to-32 flags all of these.

>     rebased on top of mm-stable to complete the s64 conversion across the
>     cgroup selftests (including updating test_no_kmem_bypass() to s64).

This doesn't apply to mainline. The test_zswap.c hunks depend on the
test_zswap fixes in mm-stable, which aren't in mainline yet. The
tcp_client() hunk in test_memcontrol.c conflicts with eb69e955de7b
("selftests: cgroup: make test_memcg_sock check flushed sock stats"),
which went in through the cgroup tree for v7.4. Can it be rebased on
v7.4-rc1 once that's out?

> +typedef signed long long s64;

This is the main problem. The KVM selftests build libcgroup too:
kvm/Makefile.kvm includes ../cgroup/lib/libcgroup.mk and links
cgroup_util.o into every KVM test, and access_tracking_perf_test.c
includes cgroup_util.h. That build uses -I tools/include, and
tools/include/linux/types.h has "typedef int64_t s64;", which is long
on 64-bit.

cgroup_util.c then fails with "typedef redefinition with different
types ('long long' vs 'int64_t' (aka 'long'))", so none of the KVM
selftests build on 64-bit. Maybe use int64_t with PRId64 from
<inttypes.h> instead of the local typedef and %lld?

> -
>  	ret = KSFT_PASS;

The blank line removal is unrelated to the conversion, same for the one
in test_cpu.c.

> +		ksft_print_msg("debug: zswpout=%lld zswapped=%lld zswap_b=%lld\n",
> +				zswpout, zswapped, zswap_b);

The continuation line was aligned with the opening parenthesis before
and now isn't.

Thanks.

--
tejun
