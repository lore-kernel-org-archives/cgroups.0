Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42B441A90F;
	Tue,  4 Aug 2026 06:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785825733; cv=none; b=f2WWKowr7DeM6HUrgfQm2YYjMh7Ef9EbHPC9hm0DR/ITJnPWT1GOJlPJ0hpBP2dIhuW1WwFXYU5d0MllOWp9zC4hrVh9VS88P90CpRRPi1FJx6x5kqmK8eCKiZKJ/WsK/65wERZR3CiXGtRRzYjARwiIv1VJFegH5EzlDM7jL3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785825733; c=relaxed/simple;
	bh=7o9Q7tCtCO8aBexHY8oOQQlyZGnGWROdUlh7smopJmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=biKolZcbwYObA/Xq3/j79QsnLCZWKVcM90v14Zo/20AyBahzIV6esvI05PlS7e3+qzaZNDGw7O7rZZ/d1kYKP/fVvuUfy9i8Kq7M/pMwCm1ghRmXaMZPv0YCeUOc8jfaTqBrRJHaQtmpohTPYxtnZJNspdKOCIiVTy+L8ts+9p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OVT+gB5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OVT+gB5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C061F000E9;
	Tue,  4 Aug 2026 06:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785825732;
	bh=huKePqtjcexK29SuqJiiQzSq65pPX+WtW/Qxb5eH4/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OVT+gB5qtwY+Lm6wnXLNda6EXui9BiIC7LTUH52nzFYNYjMDx0qcSk5VG7IWXCG1g
	 40X5Oh9MUTNSaPPIrNKf8TeOynwK0VJMXlxjullNCsvgKWY2Kp9qk3nsL+WPoNVbgD
	 ok+MtVU6eE6wikZwi/PP5T8DDmMqj6cxdA/yxvpniKKi5RUi2zl0r9MCQCY9lG5L7o
	 6n4TgVmaeBaMl9ulyzpAUUZWNZ08O8Ui0Au8ADA+sm0mwogPTWAmOy9Vd3R6tr1PSw
	 5WOgLcRLflKbygb6RN+VyyNUFgx+mJ3UTyewCkY+TfZ9oWHHje2J2MaIhaThweUjWT
	 WN8KrYF9Ozosg==
Date: Mon, 3 Aug 2026 20:42:11 -1000
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: axboe@kernel.dk, josef@toxicpanda.com, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v3] block/blk-iocost: annotate ioc_pd_stat reads with
 data_race()
Message-ID: <anGJw59r98X_inKi@slm.duckdns.org>
References: <20260804054120.161933-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260804054120.161933-1-cui.tao@linux.dev>

On Tue, Aug 04, 2026 at 01:41:20PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> ioc_pd_stat() reads ioc->enabled, ioc->vtime_base_rate, and
> iocg->last_stat without holding ioc->lock, which trips KCSAN since
> ioc_adjust_base_vrate() and iocg_flush_stat_upward() write those
> fields under ioc->lock.
> 
> Commit 35198e323001 fixed the same issue in ioc_qos_prfill() and
> ioc_cost_model_prfill() by adding spin_lock_irq(&ioc->lock).  However,
> those functions read configuration parameters (qos/model) that need
> synchronized reads.  In contrast, ioc_pd_stat() only reads stat
> values (vrate, usage) where stale reads are harmless, so data_race()
> is more appropriate — it silences the KCSAN warning without adding
> lock contention during high-frequency stat reads.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
