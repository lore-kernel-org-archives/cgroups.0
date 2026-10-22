Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792675803;
	b=FEwPni9sCFUCgx1nLG/QYZeShAinSkb2BlN34RGRCOOyAgvvpTdpVsSw3cXd8Hjvv4xU
	 Z5VFfFoi7s6IfvRdVCGo7MpzkDJ5+SW2+Tetgj7kIvXpEjEB5iRYX1nVYDAiEL49DbL6M
	 dtM7h3vUXEmA0LKrk4XiCaRxQOa+pPkGFRo7Pa+vj7mhtAqgvgCRKTuFqm+Pbm809u9+w
	 /EgcmZJ+dehmJ73fM8MAIMDf/cPL2gMMYt/igiUclGqk4fYi0MwZa6bOoD0S1NqZgEBEN
	 ADCxTXNYW4ybb7H7+9DjQMdiUbCgbYCRYJnGizqOIsuNL1MEOrvr+UmDG0bF/eTU4GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792675803;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=XV80Isb48rhCe67QpRyL+NnkWgJVKMQPGAnoYcJ7HWE=;
	b=2ICC+SEo8Yy+v0S52t68KevFGxkiBWBfNGyIwJAXIqdNcVWV9uyZzeaYnyyGTYlen5eD
	 a98gKb3upNqzvCbJ80Xg/kbsjQ6XMnpDR0PdO+csOn4kRxZB9gL/kXnjcpzwrtwuK6L5I
	 KXgeCYs68tUNPLtXxJwq1Z6TlvHjNJy3WcXEe6PNxYD0pGTXCOjY2g18ILDcXqwnaXz/1
	 8b0bXhr8MuOHH769Wx47PdxW4BANy3z/vD8mbeQ63Z9p66Tf/ynN14jUQLn2E4gld7tjw
	 CXSvwJICnWG12cKZWv7HFEXQWYXkQ4HvYku/IVhIfwuv3Z+vZAx5e5Yl0jTHi+zZyRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ox5NoZFN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5D460A2612;
	Thu, 22 Oct 2026 13:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ox5NoZFN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EA21F000C5;
	Thu, 22 Oct 2026 13:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792675802;
	bh=XV80Isb48rhCe67QpRyL+NnkWgJVKMQPGAnoYcJ7HWE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ox5NoZFNPKf5euJsj3WqbrtGiAH0rZgiD+vLpWFNMUuzG/tmQcpG0aGSLAJqZl1Ng
	 WAG40IUgNd5U0sWyR7crjZjHsCcop6lWxHiapZ5c9g0jZ3cbnbPr60awgcUdE3ZJvY
	 3pyrKRbjjrSrSz6hJAfL1Tc6O4btQkIOpbZjjvpyyTOqnvzCadEhdmKpu9gUyJLJ7o
	 Y3hRDE5ro1nsEWwkK7452RtmDFeWFxVke3Z6h3gCOISIKIDiirS2P2yqVOW4wIKRQr
	 7FfJaoppJeqXC8Rsrxn0y895grbxwDWIxH51ic75OddrP335kGR2hQGK3D5UNvWTft
	 dHDzmJlRyKGOw==
Date: Thu, 22 Oct 2026 03:30:01 -1000
Message-ID: <fe55e9784e246b4f1d65ad320b584a91@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Waiman Long <longman@redhat.com>, ridong.chen@linux.dev, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] cgroup/cpuset: Fix task checking when enabling a partition
In-Reply-To: <20261020133615.124373-1-guopeng.zhang@linux.dev>
References: <20261020133615.124373-1-guopeng.zhang@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Applied to cgroup/for-7.4-fixes with the following tags added:

    Cc: stable@vger.kernel.org # v6.19+
    Reviewed-by: Waiman Long <longman@redhat.com>

Thanks.

--
tejun
