Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B169B33F5BA;
	Thu,  9 Jul 2026 06:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783577922; cv=none; b=DN48T/imd5FSbw1hkC1Bul7CJiDKcGQsoSS9/6+7PFIalAA/AxWU3pzsmmfw2FmvSD3mC6Vzt7KC15Dkeh1nTEe/R/mSd3ge4aqDQGuGKVCf5dbbAx67zBV7DIXQeanDMralCkXIafNtz8eFRsxhVEhZq7lE+BlzldfMql9iACs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783577922; c=relaxed/simple;
	bh=V5Wb+Qi9rgMh8qejn5k1CJF1acbyGHbJi/MwTPkPgb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KZkCeq5kl8bPVB9vYsz2EN6M3Natd/ixSySlPoPORc2YIeAH+59b0WFCbJmVq01T2NtY6CvrmLKArX/Uy391EGjF/IYZmLoAXti9w3yiMHzZ/RiR3Es8VCAqxVR/4DtUOiqklY94K5qVo0u9mOv/JE5Oqn10REti+Y7ki2bkY4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A266168BFE; Thu,  9 Jul 2026 08:18:37 +0200 (CEST)
Date: Thu, 9 Jul 2026 08:18:37 +0200
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
Subject: Re: [RFC PATCH v1 15/17] blk-cgroup: remove blkg radix tree
 preloading
Message-ID: <20260709061837.GF16504@lst.de>
References: <20260704195124.1375075-1-yukuai@kernel.org> <20260704195124.1375075-16-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704195124.1375075-16-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 05, 2026 at 03:51:22AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai@fygo.io>
> 
> blkg creation is now serialized by q->blkcg_mutex and no longer runs
> under q->queue_lock.  The radix tree is initialized with GFP_NOWAIT, so
> radix_tree_insert() cannot sleep while blkcg->lock is held and the old
> preload dance is no longer needed.
> 
> Remove the preload calls and the associated unwind path.

Isn't the GFP_NOWAIT a bit of a problem because it can fail way too
easy?

What about converting both the radix tree and list to an xarray
using the internal xarray to deal with sleeping allocations?

