Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CCA3B14BE;
	Thu,  9 Jul 2026 06:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783577705; cv=none; b=M/yiKAnLaVgHxZHmaQJzU8dbj19exOND5dRtT40THvbVflIMRRJSgvE3y/QBbAYM+ml2wPGBnWzH+ZtTGJv/VdEJ4T3lvRLj0BvQv9Uat4VcjxzLX9P+duE7Es4gAcB2MzYSfwhk16fGtJ7L/JFI32qDa0X5isXyeTSA77v0O9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783577705; c=relaxed/simple;
	bh=lV8qSQPQMKExral5jcuzL4Ze+TskJln6WWCwKG1lwKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qtDZjnUhaW0du84HAUH2BbDwoo1KkiyYnGpEE1phjJJZev+q+gOXePSvfYttlSo3tP7P311XG5xuWPwLLaotpARX8DZkJA3IVvIzZO4/YhOS13B6UKi4BsQ2jiefNsjEk27nofwwg2BWyuACB/araRBg8Nxn34EOiA1lX2MH1s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2FED568CFE; Thu,  9 Jul 2026 08:15:01 +0200 (CEST)
Date: Thu, 9 Jul 2026 08:15:00 +0200
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
Subject: Re: [RFC PATCH v1 07/17] block: support non-blocking bio
 allocation with a bdev
Message-ID: <20260709061500.GE16504@lst.de>
References: <20260704195124.1375075-1-yukuai@kernel.org> <20260704195124.1375075-8-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704195124.1375075-8-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Maybe we should just move the blkcg allocation back to bio_submit where
we know we can sleep?

