Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B893538886A;
	Mon,  5 Oct 2026 08:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791188858; cv=none; b=NeYBSfqgmG52otQkLRlhhtd5WGyJSvcpnlQpVihdZUnDokMzyhdG6H9Ipo6fBwI/ACOHE0xKa//Y0j94Y1LUJF+lwf/ftKrZtLRbHdOQNK9RuAuxvZ7u8sEG8UUNrJiaSyq1nqBhkgpE7oK5kn6yhUsN1j/YOC3o2HttaER+YN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791188858; c=relaxed/simple;
	bh=8X8AyjGJezhXg2/quolg72VYhJ3P5AViyggCu0d7uYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZnMjXTEAUqMm/97X8N+TN2Bj6asGzgEYigYiKPfAbU72Eax9FBbEpGIOwIgL/KBXhgwkReBuScZ2Ye805bwLO40euYYT2BdsYdV2r2HtOwDtufpHJsulowowLiesH6Cb7IVTGqfp+91WwBGwBfZI/0I4qlr4TpWYneQbFwsgCgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G4VXDLj5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G4VXDLj5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8X8AyjGJezhXg2/quolg72VYhJ3P5AViyggCu0d7uYw=; b=G4VXDLj5GqKnej0EeZbmuWSaA/
	A+0i8Ht6NTm9K5qlFft2BDVJ/S4luUWFYMnS18jnBnJELhWxZA6jlqbFSq2e3RMlcZGMDDOKBto/e
	8qZrrw08U46vh0v6vNgPPYbRP3hDcA9IotVoN8rzaD82c0d2Ay/O995uj+9uSWbacZAXUyDTZp0RD
	5t6e+z3QAzYWR6yzGCWxAt8GpGr/mMMT8Ib1CRpWYdmk+N92ndE7UKD7AxUcNGGoNpv0ec1nnW0lA
	w3rz5MnD9pr4wV19KdIMYpmRzdq3wKOLaF4qzCKxHALsW6qXeJU9miWVdbYDtl04nGthVyT7ohRW/
	sSV6eXJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDe2m-0000000Fsip-20HA;
	Mon, 05 Oct 2026 08:27:32 +0000
Date: Mon, 5 Oct 2026 01:27:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
	tj@kernel.org, akpm@linux-foundation.org,
	Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <asNfdOfgN5z20jBT@infradead.org>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <903dd25b-7af3-44cc-9425-9499f50d5750@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <903dd25b-7af3-44cc-9425-9499f50d5750@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 02, 2026 at 05:23:54PM +0800, Julian Sun wrote:
> Could you elaborate on your concern about adding another
> blkdev_get_no_open() user here? Is it specific to this helper, or to
> submitting writeback with a temporary bdev reference without opening
> the device?

Both, really.

