Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F334ED1B6;
	Fri, 18 Sep 2026 13:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789737747; cv=none; b=USvOWwk9w7BOUFzVGLvncMWg1qb10pooCpgtzQCLtL0GQFdP/TzG3sPk55ZWxV4AWhkkNWszlXFJY5sMZpdv1YEuvIyRAoZFR90x1t0L8FniJZ37PFeV13DJi78ZjZVcX+QN3bnBgiNHoYw4qbYYXMnx26vCUbLR1Gs5P+QPwSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789737747; c=relaxed/simple;
	bh=bvmz5EnzF4dWerHdSyOcNXSkYsbTRu46p7EsJ6/ubQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D0rGQI3akynWrHPWhmcv1AHOTrRR3K7acdM4QNmhZ+cXwoV0HI30FQQPsGi7dxSIETy0kuDpDeYvEJhEClLBhMyTP2QwBaAw37RT6/RYDpIiACGj68ZRnEQY1KX77BXZg6kBZL+ocviukAmwYD0JaRRxZ6ELNwaiK4KDU/v8Ki4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F72Vi3jU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F72Vi3jU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ob8whmEoBjYZAk/g6zBYhiTErEl8byIcAMA57y+1RKE=; b=F72Vi3jU/2HLXiHp2rYH/Cfom/
	X5x/vF9uhN+yYKZSSPzSSwQZ7jwOukk1DKVY1aIhFv9CHO0LpdYRoAyIZKaw2jmHl52rLIzQKB1wz
	ZPEvz0aDmHcH6G3HiCm8wTMHdoldzXkOUShtZLC5ncvB4OTSw1aI4vFrwekbedOLUCzwE32QiItvV
	QLH94wBRoCTs6QZ0OMG2tTKzotnJEJAO4UBe2JJu+AnysC9SwXouSG6r4yvD67oMyw39qCglSnYZN
	Y2P+RDoD9jmdYBxEwC8s6t+TYBVvDzh7LfvBbzEOLevbptOtFuDAa5RNWemghJT2Sh2K8HAMlKIQz
	DNVw5I3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7YXm-0000000EUz0-3wlq;
	Fri, 18 Sep 2026 13:22:22 +0000
Date: Fri, 18 Sep 2026 06:22:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
	hch@infradead.org, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	cuitao@kylinos.cn
Subject: Re: [PATCH v2 2/4] blk-iocost: charge zone appends as page-counted
 sequential writes
Message-ID: <aq07Di4FPtCUxpAl@infradead.org>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
 <20260916085304.1080271-3-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916085304.1080271-3-cui.tao@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Sep 16, 2026 at 04:53:02PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> Zone append is a primary write operation for zoned devices; zoned
> btrfs and f2fs use it for data writes.

f2fs doesn't.  xfs and btrfs do.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
