Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8A73AE704;
	Mon, 21 Sep 2026 07:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789974380; cv=none; b=RoeBr5YiV4FF7R0m9skTmM4sKhYQavQcc0kPhSgY0EYiXKAkiSS4JF9V4WcBztC0hDolP2bwhca4tpjhUuau19Yh+mJeXfENIn6yawqVhFTcTYWmJ4KY9oiuKksOj7tLvb/Wjn5ngEEm8PjC+67dQ3759+wo7FF9aYLLWaHux9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789974380; c=relaxed/simple;
	bh=TLj8sFutufMJiN3IAaR7TuLNFlZlrMDr3iGF+7yceIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MNN1BFLzWclnjtXPZwkpad2SpbPCwOspcQSKfxYXE5j6whtLt3IUE58hGzJNtzA396+lH+FSai+aRwKCL3vJzUsMEhSAJJMY/A1eJ2Fj4JF+nWETHIJ8zH2nb6sIK8GbdIc8RJP2/npKL8KgOqHtTOYP4xDAmcl1xDH6ap73y4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EHQ++RBJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EHQ++RBJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YruYuHsXYeu0Ni058efk89qmFUmonG8oukMq2C+cDTw=; b=EHQ++RBJi623ATzesXnFByagpi
	W5zLALfCy+QiWdW/z+K+duVjojGYX96UxIbgdlmdUT8+AsPwrLjleISvAF5tVQdPUK87xg2zOqZb9
	sCHDyDEKDY53lYG3jMy2IYh2y1kGZFgxdnjbi4Mmf0LbZiT9mSygHFdulVL5dokE0gQJw8kLcddk8
	Ogr+p44fOnmdCLAlaARb5Rr4/ze/TIe8gBWC/u1xaJLmMlemtg5ZX3q1JfFQobFNJKzgWR1QsUXmw
	W7KjmiuXX4msXorAOUNTXbQrXxNtZaO2+iV7+Jk7dwGf33IGIT9BVgH2sMR7ZXhGsgK0hPIeAE6re
	ljewyVmQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8Y6N-000000019eJ-3eau;
	Mon, 21 Sep 2026 07:06:11 +0000
Date: Mon, 21 Sep 2026 00:06:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Tao Cui <cui.tao@linux.dev>, Josef Bacik <josef@toxicpanda.com>,
	josef@toxicopanda.com, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn
Subject: Re: [PATCH v2 1/4] blk-iocost: charge flushes as pageless random
 writes
Message-ID: <arDXYwNm7rGqB7pg@infradead.org>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
 <20260916085304.1080271-2-cui.tao@linux.dev>
 <9575357186118be214d6377dd80a21e8@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9575357186118be214d6377dd80a21e8@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Sep 19, 2026 at 04:59:51AM -1000, Tejun Heo wrote:
> Hello, Tao.
> Pricing a flush as a random write, or as a page where that comes out to
> zero, is as arbitrary as pricing it at zero,

No, it absolutely is not.  For any flush that actually makes here it
is extremely expensive, and 0 is the wrongest possible value.  Even
batching does not change that, as batching is not actually effective
in any normal file system workload.

