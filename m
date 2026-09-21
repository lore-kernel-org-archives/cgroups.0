Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFF047B43B;
	Mon, 21 Sep 2026 18:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790016078; cv=none; b=ud3IA+XZRwh5x3N2ZFFZQSG+xQJzKGx6NMi5cBqNNVkl3ceHnGPqe8qA0eUQWEQzOfHmKM0jno0v5uz7Z9P/h608jGmjkWizb4kFaTgp1TmLznHYljC1HjS6DtLxhnIQCvIf02YKFhrHJksNO/NiOYEep1VQgQSD6ol05k/kuJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790016078; c=relaxed/simple;
	bh=7w5YobZ4XBmdbOX4FISTGzM+7PrIIyHWz+pHyJGncPs=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=NIFQNa2rNmrrkMmsXuYYWCfSNjBBayVT6zCQgw3Mz7fV4NNE8ti8O1nMFa6+zbv2Aw6Wzt5I2+nv8bbV3Q4qiUm+JInAa5ITK4+CFeHXHxGV4e0O8O0Y4O1r+QUsK4sYcAwr0y3TSuXWXy0q/euLOkkITRi60nPw5kjjYa+aExE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LdInN+YE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LdInN+YE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CC91F00893;
	Mon, 21 Sep 2026 18:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790016076;
	bh=orlWzdJhQKuC8O40EXsYgdzLtw4tS7YImxxkerXGWsM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LdInN+YE1gfJLEsn1SQsezO3RiawM/+JYyf1jX3cx0rDqN3nuFchISHKoxwrdZ59j
	 VWoHvSP0Rw238KGihtd+h43kCkB4BbxbmrUu5KEmzELVDDxexYrYedoUzfAFe4/7yE
	 6pm5lQzhrIIu8W1I8SktaxOmIFuWAQFpggfvIGRwHDug4ACKy0/WZOYyjmeLH2TWNa
	 HgAbkK1h539A3UO2JPspDZuJBm/okef9mArTH6aqGeVWraQONF/pcfQFsIoAGo0yMb
	 M6BxXuBWohsmZlG7cSiPb1hcjFIA/7z3Ur495QOwUtinqzMwWy1eJ/+X3TeTh8iXV8
	 3xyTx/+TdNjBA==
Date: Mon, 21 Sep 2026 08:41:16 -1000
Message-ID: <8d777202a64f3a02f7d13d90ee97c4e7@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 cuitao@kylinos.cn, tj@kernel.org
Subject: Re: [PATCH v3 0/4] blk-iocost: charge flushes and zone appends
In-Reply-To: <20260921033453.1912971-1-cui.tao@linux.dev>
References: <20260921033453.1912971-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Tao.

On Mon, Sep 21, 2026 at 11:34:49AM +0800, Tao Cui wrote:
> While testing iocost's weight-based throttling under concurrent IO, we
> observed that a cgroup limited to 1% weight could issue an unbounded
> number of flushes without being throttled: an fsync loop produced ~510k
> flushes in 12s with cost.usage staying at zero the entire time.  The
> device was monopolized while iocost reported no activity.  Zone appends
> were in the same position: the builtin linear cost model defines
> coefficients only for READ and WRITE, so REQ_OP_ZONE_APPEND is priced
> at zero and excluded from the latency statistics as well.

Looks good to me. A few nits:

- 1/4: REQ_PREFLUSH and REQ_FUA are in REQ_NOMERGE_FLAGS, so !is_merge is
  always true there. Can you drop the wrapper and the separate flush_cost
  accumulator? Adding to cost before the empty bio check gives the same
  result, and the FUA condition fits on one line.

- 1/4: The comment mostly restates the two ifs and the coefficient
  formula. The FUA condition is the only non-obvious part. Can it be
  trimmed to that?

- 1/4: Pending pre-flushes get coalesced into one device flush, so the
  charge doesn't quite mirror what the block layer issues. It's a
  per-request policy charge, which the description already says. The
  other iops coefficients also have the page cost subtracted, so they
  aren't translated the same way. There's also a short broken line in
  that paragraph.

- 1/4: cgroup-v2.rst doesn't use REQ_* names anywhere else. Maybe
  describe them as a write with a preceding cache flush and a FUA write?
  The table row could follow its siblings too ("The maximum ... per
  second").

For the series,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
