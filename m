Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D314F3EAF;
	Fri, 18 Sep 2026 13:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789737772; cv=none; b=jkG4CdcDn7vcr14iOU9/VHm1Dwsn/7aIr61rpcmvg4mnq92hbPsUtWcCFP4zXSFqbgDgZXJevN7M7DR256H6mxjF1y9RXal7TchbLbLAKYs+rfuzq514TP8CKdTgiKJNTEYCnwvE29+6HHN1zPAyJhSCNMbSXjACClgigr7hDN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789737772; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rasZuNqdMlMI2BOZRah//j636zy5nIcUOlDwQnIoGOfkEwbhtkAoEi8hNVUOiGmd3WDtctdetolx3ddEOWujrxNlkjuZ9gNLb1UQaLAeqI4iRHANn3FIZd7EjgjPy7mjUUK16gzST1fP+13HgH/uwmzZaPPBMk+Y/qsRHQ1D51o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I+hZV8td; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I+hZV8td"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=I+hZV8td6X8Ad9r2zx8CIOr40+
	BWgbu5ea1Xwaa0mTHBhMnP3PECRGDdYAOXn+QGFtDgorIEicNK0TUZR2HGK6fpk5YGzhOCyKastyp
	YRmFfKxUKBI/ULoH9zKxav9UeHP+3xjnhMQai1oq3Pq0Yb0LrqFjrzkMvNt9sD7K0EzRzn0wwpeX0
	XWBWXR+F59w3fwwANv/FhuKMmaYIU4wvY/xOLVrHES9w6jG713bHT2mA8okH2CQK4hFY2vA/2glf+
	7Ts0/o/a4BdrMdPjIDspXrcQB9qQeYr2pHDuANglgzbbSdvNQsy9UdRynvmQrpz4TXJ5m8pQoGDvF
	5kQj1oPQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7YYC-0000000EV2n-3hQu;
	Fri, 18 Sep 2026 13:22:48 +0000
Date: Fri, 18 Sep 2026 06:22:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
	hch@infradead.org, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn
Subject: Re: [PATCH v2 3/4] blk-iocost: account zone append completions in
 latency stats
Message-ID: <aq07KC1RWXUUd62X@infradead.org>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
 <20260916085304.1080271-4-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916085304.1080271-4-cui.tao@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

