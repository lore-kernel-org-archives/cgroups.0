Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E612BE656;
	Thu, 10 Sep 2026 05:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789018753; cv=none; b=u+45IPnyTXCKIZiQuea8VEv0OgakEOzJd6lmdZ/heayevLmj5JqmqO7mOklEbxIl5DMX/yTkeZjhQsjX48t4amnF+3z/ZNvynBV0LOiUx7TW+JUGkmj2hj1aDEK32MnwMBgXBsTtGCMkFObncNmdRzXIXBe3Kih3NWlFXJkI0jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789018753; c=relaxed/simple;
	bh=OK88M1/w1xDs5+APXMfyCeaTxKJdYXDAiLn/gXkzfRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1rRavOMzsUjWE3mk9Re6Rgfsem1orOi/geMO8hTAZkI7tIgXI/ACqToNAFpQP6PRLbCHLIV1ID1FjhONaiei9LmNIg4jJ2vpO1he4+XvQZSaF+gID/B9mNwUaZ45NgdNO0c5hdw39gs8Bkz2Nznfu9q2MJkGqBPOKaFAHc8wuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QBzcqB1L; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QBzcqB1L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oszG6Yozd8N5jNz/rkRiKyu9b+AdIv/YTlup5lbZcNw=; b=QBzcqB1LxOWocuqp9x7HSTLFG4
	rvX9Q3M507n8aXS4MD76KCXryjjkYY9SwdsFq1Fr+vqJzlTtKU64Sp/EFSRn8HgUUChAHvJuDfTvt
	CFHlZfUszMDfLccLeFhxIHlvfCDmEY/uW5tzasVIR/AkJwxMq6sXrXNXgJXbCJNV3Dtx4GzhaEZUC
	XrLaA808VK1D8I+pRrYEKUdqQ961ED2AnTwasc6D8ZdGVDtASTYIVhKKHAgJF1BI0H1eGZQ9N3SWb
	ZtGUdDt4zME8V8mADEIhGeGwTwj7gUqsvU3oM616EATRP2zztrALcXnIV6ibZvoWylqhbKNQzMiHr
	FoKJlxOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4XV7-0000000DSt1-0jdR;
	Thu, 10 Sep 2026 05:39:09 +0000
Date: Wed, 9 Sep 2026 22:39:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
	cgroups@vger.kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH 3/4] blk-iocost: account zone append completions in
 latency stats
Message-ID: <aqJCfZ8CNf1tVhM1@infradead.org>
References: <20260908022135.1429281-1-cui.tao@linux.dev>
 <20260908022135.1429281-4-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908022135.1429281-4-cui.tao@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 08, 2026 at 10:21:34AM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> ioc_rqos_done() only accounts READ and WRITE completions, so zone
> append completions are excluded from the latency window: the vrate
> feedback loop cannot see ZA-induced latency, leaving it unable to
> respond to device saturation caused by zone appends.  Similarly,
> calc_size_vtime_cost_builtin() does not classify zone append as a
> write operation.
> 
> Charging (the cost model) and feedback (the latency window) are
> separate mechanisms, so this is not covered by the previous patch
> that prices zone appends.
> 
> Treat zone append as WRITE for both latency accounting and cost
> classification.

Can you add a blktests for this and the flush case?

