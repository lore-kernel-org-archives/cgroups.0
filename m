Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793969814;
	b=jyPeICfuIYF8JW8iDL5jjJo0H3XtfzZdvjMmKmIqlrsBlEJ1/iQTHKeE2wrVii8vwIGa
	 2pylbRsAg4q1Z+F6plJFfcBtGfc5INSYb7GnhwDraPvmVAd4CbB8HRUYyk6J7WtkP156s
	 bDnyixs8wkkpVBtKNM5NU3Fu+N0q77g1jkimrktq4he30DS37cSOfEs9zl1Tw/qZ4Tfs7
	 yJ9i27bQWt6/BgkinEA7ePFRSoSJ6nNaUgeYUUpc6eQXtHVS4XdxEk8dODuhlcC7h5XD+
	 7CdZ7msTr7aFEHRfkPiZQppljmaUl6NshL+YROhPkHJHhTTQ3tRn9M4FNAwqWq4Aolw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793969814;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=ovnYpUVr+IdQBtBnTvW85eyzWvjLk9RyflmM2dhK/t0=;
	b=fWZqdEx+2v19ch6GjoSGCtf/f8rV3w8L7kLRJOXaj7IAPqiOivTZOF9tHpGegMnIvVuK
	 y9aBK7MSKyWDPiXFwhE+Zrki8ruuFs+FcLXoJkjFHArRDESUNvdsYwJTHlzTLGnSJAb+J
	 MDEchjcpznwPcOgJnihltK0Rbpiot5MnQ44Hkb0PFsryRLrqwbQP2qseZfhzKkHrBHfv3
	 47w/yqJWKz5ySHkM38lkSIEbFTXB+hSDYI9+0JdLd7MxuggqlO67GIouAREhWKheKmfge
	 FQEYtK+G7hshfGN2d2M6bCD/kOkOw14IiDKq2XjtnNMowKxB9JE54c/KHPfXa03lOYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hS6VoyOt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D20606A32C;
	Fri,  6 Nov 2026 12:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hS6VoyOt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26CB1F008A4;
	Fri,  6 Nov 2026 12:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793969814;
	bh=ovnYpUVr+IdQBtBnTvW85eyzWvjLk9RyflmM2dhK/t0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=hS6VoyOtgic16aZ0AgveOu3XhsVKgcvrasGkriV1nlFg8fTTyU8OpjY5SIhNGiWlO
	 aymV9/0GO7jbB7dwbvaGBSpqXo40vQMInfuvrzXQA0jZ/CD3I1yrYyxCO/VrEU7DAo
	 7TuKPASb4g/afkDwDT2TZqjvmUD1sm795roDYGVic28HkkEHAt2tbPrJkQIe8ZNKHw
	 SoZNj4RTK2DlNNmwsJYj1diYFFjt8V0dZigW5aZW4WBcTHI9aorDcuQizm7z3/4zZl
	 me196IJssApCckaMtEz5GF8fLlJv9TQG5fqKCwDgNw/BmCb2/dfIP56OntSpmyeoLz
	 5vZGIoCOsHnSw==
Content-Type: multipart/mixed; boundary="===============7160097930942034138=="
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <3c8441b7a6884f0f66bf3fb4e00fd9fa675654b71b59dfb3966537c19d3e7989@mail.kernel.org>
In-Reply-To: <20261106122356.3224638-4-cui.tao@linux.dev>
References: <20261106122356.3224638-4-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v13 3/4] selftests/bpf: add iocost cost model test
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk,alexei.starovoitov@gmail.com
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri,  6 Nov 2026 12:56:53 +0000 (UTC)

--===============7160097930942034138==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: add iocost cost model test

TL;DR: Nits only in the iocost selftest models: stale deviation comments,
macros duplicated across both progs, and a redundant op check in iocost_ms.c.

> diff --git a/tools/testing/selftests/bpf/progs/iocost_model.c b/tools/testing/selftests/bpf/progs/iocost_model.c
> new file mode 100644
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/iocost_model.c

[ ... ]

> + * One known deviation, mispricing only: the builtin does not move its cursor
> + * for an IO whose cgroup fails to activate; this model does not see the
> + * activation result. Another, narrower one: with "flushiops"
> + * configured, the builtin also advances its cursor for a
> + * preflushed discard, which this model still ignores.

This isn't a bug, but submit_bio_noacct() already fails any bio carrying
REQ_PREFLUSH or REQ_FUA unless its op is REQ_OP_WRITE or
REQ_OP_ZONE_APPEND:

    if (WARN_ON_ONCE(bio_op(bio) != REQ_OP_WRITE &&
                     bio_op(bio) != REQ_OP_ZONE_APPEND))
            goto end_io;

so a preflushed discard never reaches iocost.  Could the deviation lists
in the header comments of both progs be trimmed to the cases that can
actually happen?  The same "flushiops" sentence is repeated in the
iocost_ms.c header, which also carries the "measured 89x overcharge,
12.9x throughput collapse" and "measured 107x undercharge" figures that
might fit better in the changelog.

[ ... ]

> +#define IOCOST_REQ_OP_MASK	0xff		/* REQ_OP_MASK, not in BTF */
> +
> +/*
> + * DIV64_U64_ROUND_UP / DIV_ROUND_UP_ULL equivalents, folded at
> + * compile time
> + */
> +#define RU(x, y)		((x) / (y) + (((x) % (y)) ? 1 : 0))
> +
> +#define RBPS	174019176ULL
> +#define RSEQIOPS	41708ULL
> +#define RRANDIOPS	370ULL
> +#define WBPS	178075866ULL
> +#define WSEQIOPS	42705ULL
> +#define WRANDIOPS	378ULL
> +
> +#define RPAGE	(RU(VTIME_PER_SEC, RU(RBPS, IOC_PAGE_SIZE)))
> +#define RSEQIO	(RU(VTIME_PER_SEC, RSEQIOPS) - RPAGE)
> +#define RRANDIO	(RU(VTIME_PER_SEC, RRANDIOPS) - RPAGE)
> +#define WPAGE	(RU(VTIME_PER_SEC, RU(WBPS, IOC_PAGE_SIZE)))
> +#define WSEQIO	(RU(VTIME_PER_SEC, WSEQIOPS) - WPAGE)
> +#define WRANDIO	(RU(VTIME_PER_SEC, WRANDIOPS) - WPAGE)

This isn't a bug, but these macros (IOCOST_REQ_OP_MASK, RU(), the six
AUTOP_HDD parameters and the derived coefficients) and the
READ/WRITE/ZONE_APPEND classification in calc_cost() appear verbatim in
both progs/iocost_model.c and progs/iocost_ms.c.

Could they go into a small progs/iocost_common.h, the way
bpf_qdisc_common.h is shared by bpf_qdisc_fifo.c and bpf_qdisc_fq.c, so
the two models don't drift apart?

[ ... ]

> diff --git a/tools/testing/selftests/bpf/progs/iocost_ms.c b/tools/testing/selftests/bpf/progs/iocost_ms.c

[ ... ]

> +	/*
> +	 * only bios the builtin prices participate in stream tracking;
> +	 * the early return below skips the merge discount, which only
> +	 * applies to tracked data bios
> +	 */
> +	if (!(((opf & IOCOST_REQ_OP_MASK) == REQ_OP_READ ||
> +	       (opf & IOCOST_REQ_OP_MASK) == REQ_OP_WRITE ||
> +	       (opf & IOCOST_REQ_OP_MASK) == REQ_OP_ZONE_APPEND) && nbytes)) {

This isn't a bug, but the earlier if/else chain in iocost_ms_calc_cost()
already returns 0 for every op other than REQ_OP_READ, REQ_OP_WRITE and
REQ_OP_ZONE_APPEND.  By this point the three-way op test is always true,
so could this condition just be:

    if (!nbytes) {

?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/42219005018
--===============7160097930942034138==--
