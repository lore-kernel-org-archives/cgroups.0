Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723C03806D0;
	Mon,  5 Oct 2026 08:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791188619; cv=none; b=cixgOUFwAnfcvYVlkoq1f5Shp9O5L8/NxnfzK7sZMVoXt2guVRC2XjEC3jC/CACjQLaojLGV5zL0I+siO9R+SDdBzSkCLtrjRoecbNSibVjZEmiCnEiGgfE2duejK9iqSqs6XldcS8ZgofTzdgYhozzUIPQDB3hapNHxNXyv6fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791188619; c=relaxed/simple;
	bh=huvwHf6b6kpQy5qa5RyvFFPMRCNF22BZPSUsHgW1VMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GMaEARzl+i0uHIkyjMGa53y7FQA/khMSbfdqzRhpAoF2Ql2X0usPkYsDSKYhW8kbWZAFHxRkXTso+MOAD0zeLowtRD9dphOLNvIWipTzUUtVKnohQr5cut6PPfaapBwL0qZHwq9VcGlH57ewhmmi6LZgz327iCHM+UdPiar6Syo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YqNqHgSG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YqNqHgSG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z6VraAbnd2mT0BKdlhv+L+o2/2Wa3LZYIp6gFv/bUHI=; b=YqNqHgSGGmvFI3iveGjHa2tQ2L
	/jV3Ue8G5JbgDOIW+Gk4sFHwIF2YOp+16iyTnT9RAjDCE+Yqtx7kTfP0FJcXsNz2o8T05Vm9rVD+G
	1psAI2EuqbDvwbuvfVYIESVhuvVi5w+VRMVb9Lamqgt1kIxqVmFPYRAcWxWE0cH0khMrZlahHqj8/
	EEnFIEoASG2pNz5gA6XfR3c0TlJyU5I8OhDTddikXAVOMQwcysbo+fJvWSO2venfdD18/pjs8wOOl
	q5o7G+o3NxhQbKCXPhbFIZygzSFInSBjkGaRHlVZFrAscdKwbjawO+gzny9tYUcY7koj9JTMvZh+V
	jC0O0gKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDdyk-0000000FsEH-47BZ;
	Mon, 05 Oct 2026 08:23:23 +0000
Date: Mon, 5 Oct 2026 01:23:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alexandre Ghiti <alexghiti@meta.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>
Subject: Re: [RFC PATCH 1/4] block: do not issue background swap bios as root
Message-ID: <asNeenTiIme0kzI6@infradead.org>
References: <20260928081900.4187482-1-alex@ghiti.fr>
 <20260928081900.4187482-2-alex@ghiti.fr>
 <aro28ZGuYgmNg_n5@infradead.org>
 <CAEmasaX-6v_EpwAxHtnhA5SXk=jGW8+Lm4m8zAC=+f0yXmiCxw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEmasaX-6v_EpwAxHtnhA5SXk=jGW8+Lm4m8zAC=+f0yXmiCxw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 29, 2026 at 11:16:03AM +0200, Alexandre Ghiti wrote:
> > >
> > > Such a bio cannot simply drop REQ_SWAP: dm-crypt and dm-thin rely on it
> > > for limit_swap_bios, which caps in-flight swap bios to avoid a memory
> > > deadlock, see commit a666e5c05e7c ("dm: fix deadlock when swapping to
> > > encrypted device").
> >
> > Is that true?  REQ_BACKGROUND very much implies the I/O can the throttled
> > and thus better not be foreground paging, and thus the caller should be
> > able to tolerate a failure.
> >
> 
> Yes, I agree, zswap writebacks are only best effort and in case of
> failure, the compressed entry still lives. I don't see how
> REQ_BACKGROUND could be an issue there?

The issue is that by definition it doesn't need REQ_SWAP then.

Then again the whole concept of REQ_SWAP looks sketchy to me, non-swap
paging can be just as important for forward progress, so if a driver
needs it, it has other issues anyway.
