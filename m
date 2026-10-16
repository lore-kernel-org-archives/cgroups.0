Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AE6595753;
	Fri, 16 Oct 2026 17:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792172998; cv=none; b=NdULRdsQsDbXbSc66zT2Kp0PsBdnHIWfP6jnsd64m96VA4uQUElPYkf1y03WmYeI1XuMOdTKn2CZCHA0O8GiWhdW5EgQm2JjSiTeILT4R5E938JE6pDCAnXvEwSI+GGDpUzyEf37GFLHgioEJBptmUNVt3jlNIkAXpfIo2YQcDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792172998; c=relaxed/simple;
	bh=TCWVUYgdfhbIPGqiAJQj4pVR70VsU88wzgjT23wv86c=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sY4y3gS0QYS2kuVopmClBLOejMIEkeMDpFEkfEU+AFaWBtYz/YKM5jceuYENovC2hqrLe6e9h49d1pEQBAI7LtQtAWSqWoXPydgFzMeM8k/WsnYoCt1s8E6E2TZHWbQ/jfrEJB39770rA6oXfGP7WYoD0roqNWPAuQ99QtgShxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bLI/OXrx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bLI/OXrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53581F000C4;
	Fri, 16 Oct 2026 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792172997;
	bh=B4PeTj6Q0POYPtLt1HzphkMNewcTU33h3r/eSaBZD/4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bLI/OXrx0Izfx9V+ePEEkOXECvkM+38aGifuQhkC/VDidNJpo4e1h720dIXeWGX0c
	 gobz+OGX8YJmx6VkvS/mtXG0PD1AsAN6AOFd8fFo3UaIA/qxLoaQHQr5cPZY5twgKH
	 vV9nISidLZg9vb9DtN8iAFEZPzawqdjfwMjjxOZg1K/sAwii0m3F0OCIXzyTW8xW8m
	 Ex1GCQXwALB7S43zT2BzBBo4sznoUloG/3DjDaun/FUUQisMt9WmwYokbkEKF69pmb
	 Jk1NFfnT2qvSmnndiWCgFgz2kFu9tBsR90BAGp7FAoVxJ0uzmL3yfSRUuSQxLdzwGo
	 e1vFPFvChfZJw==
Date: Fri, 16 Oct 2026 07:49:56 -1000
Message-ID: <47611e3e8a2bfbdce1dfd9a1fe2c5019@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com, ast@kernel.org,
 daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v10 2/4] selftests/bpf: add iocost cost model test
In-Reply-To: <20261003124045.1289305-3-cui.tao@linux.dev>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
 <20261003124045.1289305-3-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Tao.

On Sat, 03 Oct 2026 20:40:43 +0800, Tao Cui wrote:
> +	dev = getenv("IOCOST_TEST_DEV");

Nothing in the tree sets IOCOST_TEST_DEV, so both tests always skip in CI.
The null_blk instance the v11 removal test creates could serve these two
as well.

> +		if (ASSERT_OK(err, "readback"))
> +			ASSERT_EQ(strcmp(model, "bpf"), 0, "model_bpf");

ASSERT_STREQ() prints both strings on failure.

> +		bpf_link__destroy(skel->links.iocost_2x);
> +		/* cleared, or the skeleton destroy below detaches again */
> +		skel->links.iocost_2x = NULL;

Without clearing, the skeleton destroy would call bpf_link__destroy() on
the freed link. It wouldn't detach again.

> + * The cursor handling follows the builtin: a zero cursor means "no
> + * previous IO", and the cursor is advanced for bios the builtin
> + * prices (READ/WRITE with a non-zero size; the builtin skips the
> + * whole update when the cost is zero), so flushes and discards
> + * leave it alone and long merged streams do not drift past the
> + * 16MB seek threshold.

The model advances the cursor for every merged READ or WRITE bio.
ioc_rqos_merge() only moves it on a back merge into the request ending at
the cursor, so a front merge leaves the builtin's cursor alone and moves
the model's.

> +	} else {
> +		base = randio;
> +		for (i = 1; i < NSLOTS; i++) {
> +			if (s->stamp[i] < s->stamp[victim])
> +				victim = i;
> +		}

A merged bio which matches no slot, e.g. a front merge or a merge into
another stream's request, takes the LRU slot and can evict a live stream.
Maybe skip the slot replacement for IOCOST_COST_F_MERGE?

Thanks.

-- 
tejun
