Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9F53AFD0B;
	Thu,  9 Jul 2026 06:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783577633; cv=none; b=B5ibgjNiDA3YGvdZT5s8L7lvUW09YnqO1gFvT85L+sHojmlbLgPoj/RojIBZJQ1dhStGfu1lVB+SM4O3glKo0RIuOtUAFmTO0npWwK32H5xKomHbIuCZgobqSc4TJfIXV9+jDuwf6sULBD2h0QjsP1pQPrVpsgzzWt4ezgPNQ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783577633; c=relaxed/simple;
	bh=F3tE97i/sw9pxZ8n+2THUTFo7Mv5gBPBkLr/PxHPkvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E8MYcit713M7CZkykzotZYHrkO/NXIT7IwBZFFeQ0AEOKjaIOdzZ4JdooNkpKa8h/+pjVfWRcKzcW14ulz7AZWvKjRcg+818sfvdjlBkxqgAfSY9K8Ww83NqGRxuyEbs/iNOM8Z3hE94R9Xdk2mFsnPUIQOev+QA4RuBQhBGOi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5B41F68CFE; Thu,  9 Jul 2026 08:13:49 +0200 (CEST)
Date: Thu, 9 Jul 2026 08:13:49 +0200
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
	dm-devel@lists.linux.dev, linux-bcache@vger.kernel.org
Subject: Re: [RFC PATCH v1 06/17] blk-cgroup: support non-blocking bio
 association
Message-ID: <20260709061349.GD16504@lst.de>
References: <20260704195124.1375075-1-yukuai@kernel.org> <20260704195124.1375075-7-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704195124.1375075-7-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 05, 2026 at 03:51:13AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai@fygo.io>
> 
> Allow bio association helpers to be called from non-blocking paths by
> returning whether the association succeeded and by taking a nowait argument.
> The normal callers pass nowait=false and keep the existing behavior of
> creating missing blkgs.
> 
> For nowait=true, the helper only succeeds when the needed blkg already
> exists.  This lets callers set or clone a bio's bdev without entering the
> sleepable missing-blkg creation path.

I think this is not needed once we kill nonblocking bio allocations,
but if not please have a clearly visible separate API for the
non-blocking version.

