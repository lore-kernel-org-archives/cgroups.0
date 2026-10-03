Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE5C3BA237;
	Sat,  3 Oct 2026 23:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791069203; cv=none; b=sDJDUXc5UxhvS1jX3S0K7P62lsKu2rVq6efUj7yCuLRiZhrpwFSZicqImSldvSccwvE3PAKFM2oqWgI/TV0HlQslxz0KRYc+Vx58MwORzD5VkfJJJLMXFaL254oevPisuQxpAf0ksbIJeH4ry897vbyhg3yD+aaRXK1noQsUXqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791069203; c=relaxed/simple;
	bh=G0oGL+SyeENZUjfaXLec6nUv4IaP/Iyw4qX6X5fUGIs=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j0kheP76tX5kKZu1szOynjH3v+T5yp7tH1dRKlWq0wXfa6gX2qByQ6SFhH4IEiTjc/TrMGkk2hDbztvTf5xIC0VpocegKzkeu9G0BnrG7BrJBCbII/YexISH8f0ACh8fQdMN0tydVROYUVQPFi6B2chqrm9zhfgP89bRLlXzle0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fv18U0Kp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fv18U0Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411811F0089B;
	Sat,  3 Oct 2026 23:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791069201;
	bh=AlsuI0g5wl4wG2mDAFWBWSvS7BvDcMYgx3oGRkqxeZk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Fv18U0Kp+rXEEQ16ZfIS7ykQjR0tnzfiqiyvpN9e++N5nYs8CijMVdgvEbo8WpfyH
	 Qn1AO+WLZPbnh8DQlFiKMyDb6GkbH56nlYMVqwg1hfV1l/Dz5WrO+c0vAsHVTA2smr
	 jNyy6acgdu6DBcNk+9zxi5M7K3tqOoaud5HWM2bYlSgvEIf3LdYdTH7WfZxMeSW6If
	 fogWcxJfBiFX9TIPRSIpr91NBrtGRbfyE2igcuTEnePQENjgHZZdH484vFuFT4B6Hz
	 tNIYDYQbW+62+ND/ZhAbO3bybrQlRXiBwaHUJWSXOHkLJ/u7HAszoh4ucf2np8LXVT
	 HYL6juMizCXrw==
Subject: Re: [PATCH net-next v5 4/7] mm/slab: Add tests for the existing
 kmem_buckets behaviour
From: netdev-bot+sashiko@kernel.org
To: kees@kernel.org
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org,
 hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, pfalcato@suse.de,
 kuniyu@google.com, linux-hardening@vger.kernel.org, davem@davemloft.net,
 hannes@cmpxchg.org, mhocko@kernel.org, shakeel.butt@linux.dev,
 muchun.song@linux.dev, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, kerneljasonxing@gmail.com,
 willemb@google.com, almasrymina@google.com, bjorn@kernel.org,
 jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 netdev@vger.kernel.org
Date: Sat, 03 Oct 2026 23:13:19 +0000
Message-ID: <179106919985.434549.3486205470679929261@kernel.org>
In-Reply-To: <20261002231132.1646573-4-kees@kernel.org>
References: <20261002231132.1646573-4-kees@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] test_kmem_buckets_destroy() (lib/tests/slub_kunit.c) can fail
  at random on CONFIG_KFENCE=y kernels.
- [Low] test_kmem_buckets_sizes() (lib/tests/slub_kunit.c) checks less
  than its comment and the commit message say it does.

--

mm/slab: Add tests for the existing kmem_buckets behaviour

This adds KUnit tests to lib/tests/slub_kunit.c for kmem_buckets. They
cover cache isolation, size class routing, default and explicit cache
alignment, the CONFIG_SLAB_BUCKETS=n fallback, and teardown of a set's
caches by kmem_buckets_destroy().

> diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
> index e3b63f0338d5f..3c923a3af825b 100644
> --- a/lib/tests/slub_kunit.c
> +++ b/lib/tests/slub_kunit.c

[ ... ]

> @@ -474,6 +475,251 @@ static int test_init(struct kunit *test)

[ ... ]

> +/*
> + * Every size class gets its own cache in the set, including the ones that
> + * are not powers of two and are filled in from an aligned index. Sizes past
> + * the largest cache are served by the page allocator, bucket set or not.
> + */
> +static void test_kmem_buckets_sizes(struct kunit *test)
> +{
> +	static const size_t sizes[] = { 8, 96, 192, 1024, 4096 };

[ ... ]

> +	for (i = 0; i < ARRAY_SIZE(sizes); i++) {
> +		p = kmem_buckets_alloc(b, sizes[i], GFP_KERNEL);
> +		KUNIT_ASSERT_NOT_NULL(test, p);
> +		c = cache_of(p);
> +		kfree(p);
> +		KUNIT_ASSERT_NOT_NULL(test, c);
> +
> +		KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "sized_buckets-"),
> +				      "size %zu: expected a bucket cache, got %s",
> +				      sizes[i], c->name);
> +		KUNIT_EXPECT_GE(test, c->object_size, sizes[i]);

[Severity: Low]
Is this check strong enough to back up the comment above and the commit
message? The commit message says:

    Each size class is served by the set, including 96 and 192, which are
    not powers of two and are filled in from an aligned index by
    kmem_buckets_create().

The test only checks the name prefix and uses >= on object_size. It would
still pass if a size went to a larger bucket cache, for example 8 bytes
ending up in sized_buckets-8k.

On x86_64, __kmalloc_minalign() returns 8, which is the same as
ARCH_KMALLOC_MINALIGN. So new_kmalloc_cache() aliases nothing, and this
branch in kmem_buckets_create() never runs there:

mm/slab_common.c:kmem_buckets_create() {
    ...
		if (idx != aligned_idx)
			(*b)[idx] = (*b)[aligned_idx];
    ...
}

On configurations where minalign is larger than ARCH_KMALLOC_MINALIGN
(for example arm64 without swiotlb), sizes such as 8 and 96 share a cache
with a larger class. "Every size class gets its own cache" doesn't hold
there, and the >= check hides that.

Would it be tighter to compare c->object_size against
kmalloc_size_roundup(sizes[i]), or against the object_size of the
matching general kmalloc cache? The test also looks unchanged at the end
of the series.

> +	}

[ ... ]

> +/* Destroying a set has to take its caches down, not just free the set. */
> +static void test_kmem_buckets_destroy(struct kunit *test)
> +{

[ ... ]

> +	b = kmem_buckets_create("destroyed_buckets", 0, 0, 0, INT_MAX, NULL);
> +	KUNIT_ASSERT_NOT_NULL(test, b);
> +
> +	/*
> +	 * Deliberately leaked, as test_leak_destroy() leaks its own: the
> +	 * teardown below has to find it. kmem_cache_destroy() unlists the
> +	 * cache either way, so the name is still released.
> +	 */
> +	p = kmem_buckets_alloc(b, 128, GFP_KERNEL);
> +	KUNIT_EXPECT_NOT_NULL(test, p);
> +
> +	kmem_buckets_destroy(b);
> +
> +	KUNIT_EXPECT_EQ(test, 2, slab_errors);

[Severity: Medium]
Can this fail at random on CONFIG_KFENCE=y kernels?

kmem_buckets_create() only adds SLAB_NO_MERGE to the bucket caches.
Nothing sets SLAB_SKIP_KFENCE, so slab_alloc_node()->kfence_alloc() can
serve this 128 byte allocation from the KFENCE pool.

In that case the leaked object is not in any slab on the node partial
list:

kmem_buckets_destroy()
  kmem_cache_destroy()
    __kmem_cache_shutdown()
      free_partial()           <- no in-use slab, so list_slab_objects()
                                  is never called and returns 0
    kmem_cache_release()
      kfence_shutdown_cache()  <- object becomes a zombie, no kunit error

slab_errors would then stay at 0, and the check against 2 would fail.
Whether it fails depends only on the KFENCE sample timer.

The existing test_leak_destroy() avoids this by going through
test_kmem_cache_create(), which does:

	s->flags |= SLAB_SKIP_KFENCE;

Could this test set SLAB_SKIP_KFENCE on the 128 byte bucket cache before
allocating? Another option is to skip or retry when is_kfence_address(p)
is true. This also looks unchanged at the end of the series.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002231120.late.500-kees%40kernel.org
