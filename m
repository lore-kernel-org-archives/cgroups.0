Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72484E7816;
	Mon, 21 Sep 2026 16:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790009886; cv=none; b=gD6s4bxE1KzlEBcHA0j/51hR45EWNzbTTP/TwPAW7sjdXSXgFBFJ4/E4vxbkLJwfvy/5ayQrI4/V4gcEp0juLuyFNGQFkWoa+DIQi5f/KkmDF781Aa48WQFWaKxSoZzWSG0pSG5HM8I/0MW7BTBsRKf3h422qJ+IP4xYE7eg3Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790009886; c=relaxed/simple;
	bh=afGAL0eN2aT15hmVo46YjA/ygEuBUt/5G7tioYm+Iuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iP3JoJwP7J3XPaZIlEy/HpOhq7EYLAh7KwZybsB1kROpUUAiV8HNRa2rY9asCDnQB4j1yKreBOKats8QzFagfCN0zl9kKtYlX2CCvVjbBPRh5d728AFGV9/rwtkSnhuOTuTBJeTgdZFOjjIrWG7JYzxi96f8V4so0YAWte1Smww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ahwz/ahK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ahwz/ahK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B23C1F000FF;
	Mon, 21 Sep 2026 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790009884;
	bh=luSYIHzcViVqgBUn2upjQ2Gx8TpV50Xj9G/k+/YEy7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ahwz/ahKbMoR1vjpIYwxO2R5Tlw43jvCFLWQPr5xat+RfHEBrAR/E6bqf1oxiNT5e
	 DpgPAej2aayWMlhQkjuDFGaTzBi1CcgDyCrUwtmymZe9yYQcKO04ilquxWmi2eqrUn
	 LrZZcTQXojHLVXlTokHgore2LROhMWWuY0Gfaeizz+cv7ia3kg6pKeUfK+6qDwGOKy
	 f5OGUkoSbxyYBzWj82jaZoyHAXG0/lE0SZTSVQ8dGihk9B+eZ2bLjmJHnnLxBWoQAt
	 ikN9eXxWFqcCyvS9pf7DfTRpryoAyKVfo9sXbxR0ada11kY+TOuFDHn01vda7jTIB/
	 FjxCelD53W9Zw==
Date: Mon, 21 Sep 2026 06:58:03 -1000
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tao Cui <cui.tao@linux.dev>, Josef Bacik <josef@toxicpanda.com>,
	josef@toxicopanda.com, Jens Axboe <axboe@kernel.dk>,
	cgroups@vger.kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH v2 1/4] blk-iocost: charge flushes as pageless random
 writes
Message-ID: <arFiG4sJJGjyoHT3@slm.duckdns.org>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
 <20260916085304.1080271-2-cui.tao@linux.dev>
 <9575357186118be214d6377dd80a21e8@kernel.org>
 <arDXYwNm7rGqB7pg@infradead.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arDXYwNm7rGqB7pg@infradead.org>

On Mon, Sep 21, 2026 at 12:06:11AM -0700, Christoph Hellwig wrote:
> On Sat, Sep 19, 2026 at 04:59:51AM -1000, Tejun Heo wrote:
> > Hello, Tao.
> > Pricing a flush as a random write, or as a page where that comes out to
> > zero, is as arbitrary as pricing it at zero,
> 
> No, it absolutely is not.  For any flush that actually makes here it
> is extremely expensive, and 0 is the wrongest possible value.  Even
> batching does not change that, as batching is not actually effective
> in any normal file system workload.

I see. I don't think the default value matters all that much given how crude
a tool the default model is. We can set it to a page. I don't think we
should impose it on existing users that are configuring custom models.

Thanks.

-- 
tejun
