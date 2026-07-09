Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24AA3AFAE0;
	Thu,  9 Jul 2026 06:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783577532; cv=none; b=ckF3gjHsH+6EF9g0e1wWixCC6pA7d8A0RrnnMpKWlqjY/8yoWHx/CvCTgd2IUSp/AujW71ejbG6N91gMmpNfbjF7coW0DsLx2DNs6KdWanjmhu8Y1JizlP0dE6sCcRyl+eBFJxjtMPMJFJO9OCN0WvMd74hJ8CRSAx3KtTxSfF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783577532; c=relaxed/simple;
	bh=4wKB2FReSHOYxifI0c50K522ehsaXrCCoiB0NObCy9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y7uXocKPjOYd9P+Vya+Qia96jQbtgWlcr7qT3R//YisknCCsv0PjgxYcpCqSnA91IVpK2h9CmX+TvFMHdqpnLhcutVd4XoCZPrVipt6mA+P0Q4aI4/EZl30bMRni6lmtX1JJZkHnROgQQIQuLsQrG0hBY+S82C1KtbgSILs1VTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D915468CFE; Thu,  9 Jul 2026 08:12:07 +0200 (CEST)
Date: Thu, 9 Jul 2026 08:12:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, Alasdair Kergon <agk@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Josef Bacik <josef@toxicpanda.com>, Yu Kuai <yukuai@fygo.io>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-nvme@lists.infradead.org,
	dm-devel@lists.linux.dev,
	"linux-bcache@vger.kernel.org Joseph Qi" <joseph.qi@linux.alibaba.com>
Subject: Re: [RFC PATCH v1 05/17] block: add bio_alloc_atomic() for atomic
 bio users
Message-ID: <20260709061207.GC16504@lst.de>
References: <20260704195124.1375075-1-yukuai@kernel.org> <20260704195124.1375075-6-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704195124.1375075-6-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 05, 2026 at 03:51:12AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai@fygo.io>
> 
> Add bio_alloc_atomic() for callers that need a GFP_ATOMIC bio from the
> default bio set but cannot safely pass a bdev during allocation. The
> helper returns an unattached bio, leaving callers to set bi_bdev and
> attach blkcg state explicitly before submission.
> 
> Use the helper for virtio-pmem flush child bios and OCFS2 heartbeat I/O.
> Both allocate bios from atomic paths and must avoid creating missing blkgs
> once blkg creation is protected by q->blkcg_mutex. virtio-pmem clones the
> parent bio's blkg association; OCFS2 binds heartbeat I/O to the root blkg.

Let's kill off the concept of atomic bio allocations instead.
Joseph already has an outstanding patch for nd_virtio that needs a little
bit more work, and ocfs2 should be easy enough as well.

