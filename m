Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB5251FCC0;
	Thu,  1 Oct 2026 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790877399; cv=none; b=gxhYgB0/VBsjeyenqKebRXPIVqW0FdMoXPdQVgL3ntfn7jlhhVAC28Ub3AinNGqU3FzvD6nLF1oSaF1DcbsMWdj/4PdBv694woc1SG/2RcQTp4VVwBbFu3ghAWgGxZnWVejwOSN+WDtiQjRDyeQdMzC90FkDUZvXtMAoyGFSe6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790877399; c=relaxed/simple;
	bh=Z8MODFbKIDDrvoDt04zQa5qco4SxCWWHkK7Oz4Y0sy4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dBKAOXQcw+/uRztJ1enTsBVw2g1E3Kyk9/MQxUmBE7SKKpOR5w1+HgH9fFJ7YJQqBRrNEOUGqYb8oPhqez5AKJX76cITk+d2tJj9z4e8cgaxEqurvDyZbZJuGyQUq+z/Op9JpiHiR1Wq52U9LniGC22+NvDD4Q5EBge4JwC+Qo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUcRCyG9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUcRCyG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3171F000FF;
	Thu,  1 Oct 2026 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790877389;
	bh=Z8MODFbKIDDrvoDt04zQa5qco4SxCWWHkK7Oz4Y0sy4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZUcRCyG91qi5u6jehSUNqqPIM4UU5FK+Oy57uQATRBt4BETrQpfEUmR28+n+8nN9Z
	 aZnEzP8BKrZQUXXCGKbwnn+UeJXNIlNWwg3FcHn0Has4Uqo8lQi65BkrL0DeFsTDKD
	 2UTB+9UY2XQU3tPy7BNih96V5Isbz5+K1xkV00VnpSoRABFRZDJB8Tz9LxT/8PfOlG
	 GT8L+SL2Th/STCxC4cfWOQubb9dQE90UmycrXO2pqMpsjbLWgIVrVVZq9UNtdPo9NM
	 ywIiQjm6vxtT8h9ji6ghGILeM6jfBON2FiN5qaXSc5vQgcUIPELfoI/NV9LRsTAPQK
	 w0pb+XHxyyM9A==
Date: Thu, 01 Oct 2026 07:56:28 -1000
Message-ID: <aa7f5ccd9fc7a7770336a48f458fee19@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Peng Yu <yupeng0921@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Maurizio Lombardi <mlombard@arkamax.eu>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/2] cgroup: track the effective css in each cgroup
In-Reply-To: <20260929232411.101087-2-yupeng0921@gmail.com>
References: <20260929232411.101087-1-yupeng0921@gmail.com>
 <20260929232411.101087-2-yupeng0921@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Tue, Sep 29, 2026 at 04:24:10PM -0700, Peng Yu wrote:
> cgroup_e_css() and cgroup_get_e_css() find the effective css by walking
> up the hierarchy until they reach a cgroup that has the subsystem
> enabled. Per-I/O users such as nvmet need this lookup to be O(1).
>
> Track the effective css in each cgroup and make cgroup_e_css() and
> cgroup_get_e_css() use it. When a css is brought online or offline,
> update the effective css of its cgroup and of all descendants.

Applied to cgroup/for-7.4 with the subject capitalized.

Thanks.

--
tejun
