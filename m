Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4C13AFD08;
	Mon, 21 Sep 2026 19:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790019438; cv=none; b=JzJJ33bjkIa7SSDuboj9Jt7RYFVevDmHaUrt5wvMJ7aoHR9VS0yjiA9TM8TDC+o28nfELh5QL/HpyhQT0Z+BPj28zX8yUHluhr4z4zP8ODxbJ48WVGhO6YvkvAhZ4R7hhwvgq9WK2zEpZwhzHo9ey8xwPVedJuWUf27F+tSi5Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790019438; c=relaxed/simple;
	bh=UEhp+M6uzGZAoB1SP2XF8MMdYUEVtqe4WaLWbKs/7U4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D4yCKjM+dCxXSvVe1u8FPNVewozDrn+xjFdGzk3cmB8DYcW1N7msFDmrfokvAMTISJyPIwdgEBRMVny+11tm0v51uW7qBmoGpPqZv4DmrzMqoKqygb0lbymbT1zKl+yDJ/OudbiSYWuFfqIjUiUWQrEvheG5kIajjDpVSqaDwwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b68eWj3Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b68eWj3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90E21F000FF;
	Mon, 21 Sep 2026 19:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790019437;
	bh=D4BUo3gWAt0lmzTIDyeCjhR1jQ3mSGxnxe6GUia/2CQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=b68eWj3ZD68iF7854hRzWquQQGmKfF6p3mP1x5Jb4S1039H7EnPt/hUPkCRZN8glz
	 B32zhonmRE88enzDEdMg86t2B06HC54jGkUl4QY4pvAI1ASQS9NYehm+z4feP8ktEu
	 uj/raKc6UlTeCUenbXq8VQzvyeCa92EKu7M5IT6mygzj3O4wTiditpqBeydFao7Z11
	 rG2ZguL6UOI/cdkx3wsQcy9UKLnHCqbQkHZ8y0sI1P31IQY4F0QFvcl7ovaTnqfxxA
	 c8zl5GeTxy/ncdPLT6AuYEpsaYxUI3+Jsr6v13BJDUmmoG0YgaxYjw43pTLO/bsX0O
	 Uxz04TGI2Ezyw==
Date: Mon, 21 Sep 2026 09:37:16 -1000
Message-ID: <7203f0453d62336bb1ca712c8e7cf569@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
 ameryhung@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH v6 3/5] blk-iocost: add iocost_ioc_tick tracepoint for
 per-period device summary
In-Reply-To: <20260918055001.1273840-4-cui.tao@linux.dev>
References: <20260918055001.1273840-1-cui.tao@linux.dev>
 <20260918055001.1273840-4-cui.tao@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello, Tao.

On Fri, 18 Sep 2026 13:49:59 +0800, Tao Cui wrote:

> +	/*
> +	 * vrate and period_us change right below; snapshot the values
> +	 * this period ran in so the tick below reports the period's own
> +	 * parameters instead of the next period's.
> +	 */
> +	tick_period_us = ioc->period_us;
> +	tick_vrate = ioc->vtime_base_rate;

Everything the tick reports is already final at this point. busy_level
was just computed, running and cur_period haven't changed yet, and
nr_active and usage_us_sum are complete. Can you emit the tracepoint here
instead and drop the snapshots? The event can then read the fields
directly and the only cost outside the static key is the nr_active
increment.

Looks fine otherwise.

Thanks.

--
tejun
