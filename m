Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793901927;
	b=Qb/iVRxtdoXQpnnSURX2QVMw5U3ulET06BhGTVX5J0AN1KoJA2J9yqftitxzmgk2i6wT
	 YTeqsWrY/pDWAQP3kqobXqlnnU3CMydqS1d0XibO60zkExMm52UJtLrmpLLO9Fv7K1IfK
	 vihNoMPeJkTLr+Th9y+rngzg/cs6WekaPQDPrrJ7GWeb76G/dW8uIRfrNfYFHer9qYj4C
	 z9yq1fKWvQA8qcbkjctKp4mJxBqgYuVkEVAVetlTtELGkNBp5Ryq26kFw1tv1xf02SWta
	 qVdMFDMPTU235ayzEtUNEwRrscPnYMfN0UWf1GvJaBhCdcAJp1xixLGJZGMaR7iFmLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901927;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ALDUjukQn90c8plhnXd5UWf0s2jDaG+QLzStybDAxvU=;
	b=s/VLgcK/P7iXaQ2T2c13rbQ46mGqe8Hkv/ggFVwBBAZBEuhxJZyNpMGduhNgw8nAdsJs
	 KpeT68mf5RicgAbO/mzGem8075/HjvMV0aI81c+emYKJNz10/abC7DhUwj03Tcd8v08yo
	 v7W4exiG03PIGCvjD6lWbB+jcR2gmxtGgWvKBpm0CmLxGyGPFDAzeL+Qr+DaXZwcCbvAm
	 iZgtveYWI45zEw01UNQ5+V02PM40L+vVXA/ymJKxYldwhVs8hLYuIyaMllXXQysKvjTQm
	 E4iiZH+EwVkynIGqFGVbJu13+I0j6OFtpcJ9r9DkRtlVh04SF8IlQXCE2WMCeaSELUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XcZpWGYr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F066606A31B;
	Thu,  5 Nov 2026 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XcZpWGYr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5721F000C1;
	Thu,  5 Nov 2026 18:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793901927;
	bh=ALDUjukQn90c8plhnXd5UWf0s2jDaG+QLzStybDAxvU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XcZpWGYrmNgblvSx24uVbzmvGwKCaE7eCfZiFujGLwxlHGkFlDuhnP2W00/4tUIAh
	 Yq9MtEc3BEeZMckScHefyJ9aNB/BlA4uAj05C9xk2y70JuTFr42tl9Y4X4FBqX0nVd
	 oSoE6090VHTinysPKCRbwJM8jJn8KaT+zgOQbndv18Ittytksb3f2arUKaMjBq/wP0
	 XN/xMD5aS0p2hoMtJIoIXAS5aaUE0jxDEqgH5L9vIac+cSkw1mLBUyud4qrPTZTZYP
	 Q7kSc+m+YWYFxJv5wxkTASzdRIkwFwtSRly+o4exrOLhUEZi8cggRb7HSAnLojizuy
	 KL7UUuPy1jLgg==
Date: Thu, 05 Nov 2026 08:05:26 -1000
Message-ID: <a61b8a78da90b18890e3d9bef43b462d@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Mani Tofigh <mt4022@columbia.edu>
Cc: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu,
 stable@vger.kernel.org, Tao Cui <cui.tao@linux.dev>
Subject: Re: [PATCH] cgroup/freezer: walk exiting tasks in the v1 freezer
In-Reply-To: <20261103-cgroup-freezer-exiting-v1-1-00d43b443747@columbia.edu>
References: <20261103-cgroup-freezer-exiting-v1-1-00d43b443747@columbia.edu>
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

Applied to cgroup/for-7.4-fixes with v7.1+ added to the stable tag and the following tags added:

  Reviewed-by: Tao Cui <cuitao@kylinos.cn>
  Tested-by: Tao Cui <cuitao@kylinos.cn>

Thanks.

--
tejun
