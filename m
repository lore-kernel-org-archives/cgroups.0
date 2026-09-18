Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF22F4F647C;
	Fri, 18 Sep 2026 13:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789737687; cv=none; b=MyVkNoF/MryaE0YZgjSKoutiEMs/58vBJuHk5ND4uoc4Kv0RvskfWCCeVf0Klu779MNCJu5fb/UM2neoJWEIg3CWdUh8RXSFE1zyJHUq4uRM+KZCuE7JP9mYVYQSwHnrIZdX/yESWK7jL3g0QtPtXsv03vavNmd17HTjRl/1qtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789737687; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AqkaYpG1VcOU1bVLFOgS3pVVhDlMmazCspDKcmAVRUDo3ph4dEeZ7uXEQO8YIZGgQeyXBu2rkAv++9j8rH0z8KNJyHNSkhESjRV+IGm3UaC58zxuwqM4wC/fO7fbmxUuTZ80od4hBZu4ipRBB8V2nFF3K/bqiEN8gnNZNvMYvio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ASCirT2l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ASCirT2l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ASCirT2lFrZ1MGp2tmuPGpf/QH
	TIZ31sfLc+Zvlrzk0PR3rTT8QqEB12CHpbMMxRMknLOkMPg0fEUSv8aRvta3XRlBRmvDrKUBM6Pfs
	g65c+OeGfCATzPEdRb5m/VgiNU9g4Gx5U0QBCJTVyuKeGZKcPLm+PSmeaoZjm+FskuIn7kMWxjBpt
	04pvxgA5rVU5TXVOHIsU0f45EYBo+eH6a87inHEpyZTlVGKv+ETlYKDSBker8SEigwC/m3XZIOLEm
	r1HdZ10lA7Kky622l1934/CQv59GvXG6o3G+c5lhCyScKgMQxDKGZkQv6ZDN1tiHhaM9L7dxtmnJs
	gdcvETVA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7YWn-0000000EUqn-3HqE;
	Fri, 18 Sep 2026 13:21:21 +0000
Date: Fri, 18 Sep 2026 06:21:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
	hch@infradead.org, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn
Subject: Re: [PATCH v2 1/4] blk-iocost: charge flushes as pageless random
 writes
Message-ID: <aq060SAISHbnU5U9@infradead.org>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
 <20260916085304.1080271-2-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916085304.1080271-2-cui.tao@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

