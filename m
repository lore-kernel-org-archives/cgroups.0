Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC673A2572;
	Thu, 10 Sep 2026 05:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789018895; cv=none; b=AUXZxg1YVMSRxyk/5RIF+kfGLJFRJFHMQrt+XaNdZVCwds3kjJC4DeXFTWqO/UIoZ+KmvcKS7mnyTLRyoKEBWTsvK3vbFX1TVXYdEJY+K96iUO1hxwnyWT5V57MVMkJdYAxkCrrjuCX1o4OKdNqTn9I2pjFUihsHTQjqXnhk1xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789018895; c=relaxed/simple;
	bh=QTe1maqDB5loOzncoTs+Y0dn6EHlYTRJncmuVOdTIu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHJ+Op/hSe6Psz9wF3qOnxQoGn2TVLYMcRjElSh9ZwCKbGYaIRkjvmdJJuRCX+8pCkMQByNItsBh585IWikzmeUxcHyd3B+OcrcQMpzYugwg4ZKRP48Qc3xi0WK66StPgV3g4B6Iyvl7sbOD2yCsL35e5UyPJypfEOFEdSzPoPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RmexEMbB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RmexEMbB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Pmlf15rJxZgO7eQQkJpIuKwAVLruLNQvd8UgNwztSEo=; b=RmexEMbBNFMTs50rFaEKMYszrh
	wWpR52U0Rl2PnvFs48ssHfTr4Ve8ziX8uzWnzndnndAvrSY3Szm15wogstHD+zoviXR230d7XLo1x
	6rYETcn0EI7gkl2lR/KhT2GEsZbO261EaLEfCgl6gwizb6M+LIMPH7quj05A2AP/G86Y3fwcj5GP8
	iNbGA7D3zw5hxGFOl+wwX2gcTQeAiaoMW8N8YGfCf6dPwNDh0Cb+kmZ0FYroDqxVmGGvNfgHC4Z6H
	v7aSPx4DPpMJOk7dW+EXj9pDA+c1JOtXjZyGQN0msRG0QqWpTProH16y8swABORTZNVkYqKoSLaJp
	WffHRnhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4XXO-0000000DT3s-1mkS;
	Thu, 10 Sep 2026 05:41:30 +0000
Date: Wed, 9 Sep 2026 22:41:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
	cgroups@vger.kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH 1/4] blk-iocost: charge flushes as pageless random writes
Message-ID: <aqJDCtbWqXlPu0X9@infradead.org>
References: <20260908022135.1429281-1-cui.tao@linux.dev>
 <20260908022135.1429281-2-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908022135.1429281-2-cui.tao@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 08, 2026 at 10:21:32AM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> Standalone flushes issued by blkdev_issue_flush() are represented as
> dataless REQ_OP_WRITE | REQ_PREFLUSH bios, which
> calc_vtime_cost_builtin() prices at zero.  The flush component of
> flush-heavy workloads such as database commits, journal flushes, and
> metadata sync is thus neither charged nor throttled: a cgroup at 1% weight
> can issue ~510k flushes per 12s, monopolizing the device while iocost
> reports zero usage.
> 
> Price them as pageless random writes (LCOEF_WRANDIO), which provides
> an approximation of the device time consumed by a flush.  For
> profiles where WRANDIO clamps to zero (ssd_dfl / ssd_fast), use a
> one-page floor (LCOEF_WPAGE).  After this patch, the same 1%-weight
> cgroup is limited to 24 flushes per 12s; on ext4, write+fsync
> workloads are correctly accounted through the journal layer (~2.2us
> per flush on the ssd_fast profile).

Flushes are actually a really interesting case.  For devics with
a non-volatile write cache they are no-ops, but submit_bio should
ensure we never see them here.  But devices with a volatile write
cache they are significantly more expensive than any kind of write.
If we touch this we should probably figure out a way to model that.
Note that this includes standalone flushes and PREFLUSH ones,
so this patch might be a good start, but still is missing a very
important part.

