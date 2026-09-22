Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE09560AB7;
	Tue, 22 Sep 2026 15:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790092409; cv=none; b=S/VzluFDNGGbwr0yvHkDAyz7dCkOHX39Mp052fwzr42L6kAOc0KXu8keRrW/PPwGpDbc5iGhHWwBvL9CZ6vWWsFRrgVrM53XNmBtDpS1bt6i1WGisNKih6Dv0Ii9e7d1nCAXEHD+MQ1fnveqU1hy0GKqt53WJ450tPwueKeW4ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790092409; c=relaxed/simple;
	bh=wB0aNeEbuCMFPHnriodNEd2XAmMGFzXY19Re9KGMJSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oIhgeObNr0m+SOUh+tB4qQlm9AJo1kRREmDFpjNR+b6gPSKP8vPa6TskEWh9V0CARHNFUMxI26SjqqddD+ONE9zS0cMLdbqdkg55uy1siaf2x9Zwrxs8ENRgMKR6TYfNiVkcOWmN72610q9a8qJorZ2RFOsCl5ti16LdG3Qaz4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3RxkiWK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3RxkiWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7903B1F000FF;
	Tue, 22 Sep 2026 15:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790092405;
	bh=cOoptst2ZoEH8nVl0gkhYSEwxHVp5gsU3BDINyMPqCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L3RxkiWKuROFiw8J6LgOeWwybKXn/pxST7eaRsKu9zbMuQCmcYr65EAki0pMmLGsY
	 QUnb1BPV09sM7D1bFA2bKnGLSB7AwqLsxKbt9PIO7p9uzvx/q+SK+SeHtm644Yiuxg
	 17lcVpXlyKlVCcMpVaqNBkaTnOkeDJzXqYDnw2/YhohjTtAzpZSHD13XMfpZqfCRBL
	 wWoxESvTFgzXA6rqIQ4ltkXf+AN7zzarNPQYkokHpPwaDb9gdVV1HigU7KlMvwRm+b
	 Dt+OkORRzZ3i/hIcAfUad0sq3sBkC72jD6fvb3nVn3XNeYPurIstKX/lZ8Nsev9lVu
	 tq+HaVv6ccheQ==
Date: Tue, 22 Sep 2026 05:53:24 -1000
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	yukuai@fygo.io, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [RFC PATCH 1/1] block: charge passthrough requests to the
 submitter's cgroup
Message-ID: <arKkdCkRGilTypb7@slm.duckdns.org>
References: <20260921070647.1928289-1-cui.tao@linux.dev>
 <20260921070647.1928289-2-cui.tao@linux.dev>
 <arFgjkKUwYGWbV8H@slm.duckdns.org>
 <acd79732-1ef3-47d5-96fc-4dd3ff3eee27@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acd79732-1ef3-47d5-96fc-4dd3ff3eee27@linux.dev>

Hello,

On Tue, Sep 22, 2026 at 04:09:57PM +0800, Tao Cui wrote:
> I don't have a specific passthrough workload that triggered this in
> production. I ran into it while testing blk-iocost accounting coverage.
> 
> The relevant concern here is cgroup IO isolation. The expectation of
> blkcg IO control is that the IO consumed by a cgroup is reflected in its
> accounting and subject to blkcg IO policies. Today that is true for IO
> going through submit_bio(), but not for passthrough requests.
> 
> The concrete observation was that the same cgroup issuing equivalent
> writes through two paths gets different results: normal bio IO is
> accounted in io.stat and subject to blkcg IO policies, while SG_IO
> writes consume device bandwidth without accounting or blkcg IO control.
> 
> So the motivation is not a particular SG_IO application, but whether
> passthrough IO should be considered part of the IO usage controlled by
> blkcg.
> 
> I don't know yet whether the right answer is always-on behavior or an
> opt-in mechanism. The RFC was mainly to discuss whether passthrough
> paths should be covered by blkcg accounting/enforcement at all.

SG_IO requires CAP_RAW_IO, so any kind of isolation isn't gonna work out
that well. This is an imaginary use case. Please stop until it become an
actual one.

Thanks.

-- 
tejun
