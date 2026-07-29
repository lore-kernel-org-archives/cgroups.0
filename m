Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4791EE7C6;
	Wed, 29 Jul 2026 08:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785314160; cv=none; b=c5dXHub+Nhdn18jFqViqIh/5DNwthTor8aOxYFwuJg7kFzfGtntSd0PtQJ00wPoGvYEYrtyvsgX6++fqzq5wwJwyF7Y3LH0NgAJpUU2GV99ugx2PGDWln41be0X1pfUzIT4SyrV7IC99hKrksr6gazBKMQ/XqMCDniFoWG5Swbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785314160; c=relaxed/simple;
	bh=ev60u0OX8utLdgCF0U8/TsGdhZQG/gNpT1VbTkSfNE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jvSZwx4pP/ahTXGagXBKtEyBvPT9sIKoVJrm4ETOX7wp5DWGVGSLVlT7ucGbOo94sg/Y3spx3M8nuNPz1fKrkuk8armQ+W8mAtYAGcJVUSEVWYH2/LKgDS1gNGvz88Bbrzkyl/uXUhw92HRuNYrzBBjyMh7oEPmpLBgu8UoOQck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7308868AFE; Wed, 29 Jul 2026 10:35:51 +0200 (CEST)
Date: Wed, 29 Jul 2026 10:35:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: yu kuai <yukuai@fygo.io>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, tj@kernel.org,
	dongsheng.yang@linux.dev, cengku@gmail.com, josef@toxicpanda.com,
	nilay@linux.ibm.com, ming.lei@redhat.com,
	linux-block@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/8] block: associate blkg in submit_bio instead
 of bio_set_dev
Message-ID: <20260729083551.GA16932@lst.de>
References: <20260724123037.3004560-1-yukuai@kernel.org> <20260724123037.3004560-2-yukuai@kernel.org> <933b4285-1c85-4076-831a-0501d5c38e16@fygo.io> <20260728042313.GA19817@lst.de> <169a04be-2af6-4df3-9308-e2c0d5d4334a@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169a04be-2af6-4df3-9308-e2c0d5d4334a@fygo.io>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 29, 2026 at 04:28:10PM +0800, yu kuai wrote:
> the blkg slow path radix tree lookup should be fine, because when we enable blkcg policies,
> it's expected performance should already be affected.

Note that eventually we need to migrate everyone off the radix-tree
as we plan to remove it.  And a hash table seems like a better
data structure than the radix-tree/xarray anyway.

> The only problem I see is rq_qos_merge(), where bi_blkg is deference with elevator spinlock
> held. However, I think this can be avoided as well, we can only do fast path blkg lookup, and
> skip merge if blkg do not exist, as we only require same blkcg bio merge, there is no IO to merge
> if this bio is the first blkcg bio.

> 
> If you agree, I'll start to cook a new pre-set to convert bi_blkg to bi_blkcg, and then convert
> queuelock to blkcg_mutex.

Yes, I'd love to see that if it works out.

