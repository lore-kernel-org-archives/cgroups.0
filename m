Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266634908D3;
	Mon, 28 Sep 2026 09:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790588664; cv=none; b=ZUSc2ysd8JhcoHHsO7S203tAlMxiojBCwnVHJD6KAiKRx7FaMwrkHQt6jNjyqbUWdBLocdxY78MEOCfOWgSCBzCO9MYZcli0Ckm66zCbTJAJTE49S44m9aWPmf+OCSWLA1Y9pwZuDqy+De0Kk6zlKSvjXJFazl9vx6ySLBnDv58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790588664; c=relaxed/simple;
	bh=OfBQeEb4/whL4XDdQz0rMoFKPAV//Cg22cZIdq+SVPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dfy9wM1f1VxXZ7/NXsvui5/YGGMoUY/zbkeKCv/d6y4HxFjuou6RxPE2bJo1laguXUdD8ri9g6tUXqstD37xbpNLvqThM6V7HeMVxwA/KfKvlgoZ9RICXAFOPWPcmF317oQOuMaBAGl+Mys+D9g5EosTwSrJJXibPFi+Zrg4cLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1rEYD66R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1rEYD66R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V3vCuvsycw4sSgqHUBL1WfDqs61oYOwO3Ein0oVSivE=; b=1rEYD66RCoxQv8dyttaZqn4T2b
	cGVC3QeEfZMFjzIypKtPj10LdufhjRiwK9cumWHnXjqAq3gzCbGz1S11J+FGrzRNiSMWGgVtZoU4b
	1J1zg9aBJPueRkygKndaJ3a45ogFTQ7xCF4p0NObKYV4ZMooVHXvFvJKwDPsudGFKardWbS2WY27e
	PW/aS3LXbqebHbFo/rMtSMHXC3x5k9qQpeKmgMoB8kMDgl7EcXqrxqo3CtNyHN1u6P5umoT2TY8Wv
	o3R0udwwAvmD/rO2iTENnsQ/RVucAZoxqgBvzz2GD9zNFhT/okLs2AoZjf6xskZgZr1u+JWK7VNwE
	mEUyyR2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB7uD-00000000G5s-14j6;
	Mon, 28 Sep 2026 09:44:17 +0000
Date: Mon, 28 Sep 2026 02:44:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
Message-ID: <aro28ZGuYgmNg_n5@infradead.org>
References: <20260928081900.4187482-1-alex@ghiti.fr>
 <20260928081900.4187482-2-alex@ghiti.fr>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928081900.4187482-2-alex@ghiti.fr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Sep 28, 2026 at 10:18:36AM +0200, Alexandre Ghiti wrote:
> bio_issue_as_root_blkg() issues every REQ_SWAP bio as root, bypassing
> the cgroup IO controllers, because reclaim cannot stall indefinitely on
> swap writes. Some swap writes are not urgent though: zswap writeback is
> best effort.
> 
> Such a bio cannot simply drop REQ_SWAP: dm-crypt and dm-thin rely on it
> for limit_swap_bios, which caps in-flight swap bios to avoid a memory
> deadlock, see commit a666e5c05e7c ("dm: fix deadlock when swapping to
> encrypted device").

Is that true?  REQ_BACKGROUND very much implies the I/O can the throttled
and thus better not be foreground paging, and thus the caller should be
able to tolerate a failure.
