Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFC442E8DC;
	Sun, 20 Sep 2026 12:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789906807; cv=none; b=RcD4UVCtimNwlkNzTBeELNCPCQCbhQ3lRaR9F20DHLo1TTU2RajTwsHDJr97KnpTWeMjOA/tzt4DF/6UJdzKZdzupXbDSm3ejHfKMpLCiJ/HWhDY8M12i3J8elto4lw5ANkWuFVYe764swgdTFP9+SSbDNWfabbx0CRO2zku5e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789906807; c=relaxed/simple;
	bh=uOEIUBi92LAoldEHq0qG0nrK6Z0ZkPVcCo9zyO1Q5Uw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oU06+a5FWR4AMrCQIgHmlaU3duE29w07bWY7lq3s+CWTBdV4v0rmH1V9bEvVwBW45wLJEgtvGWBlBK79RZxSCon2FqSGvmar11KMw1lCfQ1c5PFNQn2mFC362bVhguoCAGKXMxYLQFwEN3CNMJOyi/pLowr9YZP/db4Rq3QLTuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otcBX9Ht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otcBX9Ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860F31F000FF;
	Sun, 20 Sep 2026 12:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789906789;
	bh=Svk4L5cDHMtLgep2YoNuEEWGdeb2Zz4e/QITxKb6sHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=otcBX9HttddOdIlD3wPl6wWjoInbnKfWuJoXIh8tnLEpUbXECbwhbpEwWSbcL00jN
	 6CxXa5G5weyvh1G/17/iw/j7cxhtmXGJoUp9sLa3tZP1juaFM31638dgCsMxdA1d+j
	 KT81cvgeM9u0p1tsON+qu8gFbyP2NiGQJt54LScdextXXOPwat2UANNSLOOfhNgJaC
	 NDwmAOV8dDFirxYu1No+fXFIGSsVyKmtCkmAn7HTFt0GHxuZFdbvQjBsqzDaxd3t2w
	 cxxZ7Vcd8h78RfHHFy1IyCLOAn3FPtUM18Os7ntfPCc1VNfdMT/LibiYPo99ZJO1WP
	 tBnaH/0AYwnBQ==
Date: Sun, 20 Sep 2026 02:19:48 -1000
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: Josef Bacik <josef@toxicpanda.com>, josef@toxicopanda.com,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
	cgroups@vger.kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH v2 1/4] blk-iocost: charge flushes as pageless random
 writes
Message-ID: <aq_PZAB74FWXrON9@slm.duckdns.org>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
 <20260916085304.1080271-2-cui.tao@linux.dev>
 <9575357186118be214d6377dd80a21e8@kernel.org>
 <ab72a564-108c-4b74-adf3-1eadbbf01084@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab72a564-108c-4b74-adf3-1eadbbf01084@linux.dev>

Hello,

On Sun, Sep 20, 2026 at 03:08:54PM +0800, Tao Cui wrote:
> One remaining question is whether builtin profiles should eventually carry
> measured flushiops values, or whether flushiops is expected to remain
> user-configured.  This series leaves it at zero because I don't have
> reliable measurements for the existing profiles.

The cost of a flush is more a function of what came before the flush how
long ago than anything else. The linear model is too dumb to estimate that.
You can tune this to suit a particular use case and maybe one can argue that
charging a small cost to penalize unnecessarily frequent flushes would be a
reasonable default policy, but, I don't know, what the default model can do
is pretty limited, so I'm not sure it matters that much one way or the
other.

If getting this right is actually useful, stateful BPF model is probably the
right way.

Thanks.

-- 
tejun
