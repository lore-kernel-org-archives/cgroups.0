Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA4F34887B;
	Mon, 28 Sep 2026 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616641; cv=none; b=eLi2cSKbU2pDKpkgZcFFG+mH/OKDHBt9turi5Oc2fogDPpoGdHKfe5xFU/RalS2c2FsBBppF5QGIUWFpuqe22kt49cXVXV7oRobpkWT6kOBqGNbuUWxcF5aL7bupZlOFiwY5fbxbIxTlbPQAJJBqIcGfuJtIQ7anpMGF8oAf4/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616641; c=relaxed/simple;
	bh=XyHFBNcK2+GRBgSI6++eOWm/Z+m0T3srm0wPiCaR08g=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tI92JOBAEfrAH+gtURwaeuCLdRwEHmmkK62+FdAGeSJPZMImIQae+eJm4b+S1hMZ27FB2kUaBTTVAuhUVyq/tO8bDfHhCQG0Vy+/sSPOLZbs9LGBHo9jjnOG3Z2EFCjKS47xxBqlolBWWt6P4XZyP16COiAJCErJ0ABkPGBJ0DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EJQA+wu5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EJQA+wu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BD31F000FF;
	Mon, 28 Sep 2026 17:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616639;
	bh=Fxq0gLjHHRTreXBdZslExAAHYHdWKT1hfYN6yf+KCXU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EJQA+wu5EvxWK8s7rjFmleZjhGPiL9Gdq7pYC2YRMIFJ3VSgk7VnO08lN1nuG8t++
	 el2sCC8L8jztOBC3VYEJ1qVNddpM2x0h2yDEXiXGiLqcIdD3rQBPb/w1SLlOI6rfiV
	 isR0Sqwdsy/QyOYccrAa7NhG1ITCev6lw90CWNB9Jvlf4EoMiOEU4IetWF5nINYDjd
	 fEdpwI1aGn/ezzKb8Qp9Qjrf3R6FqZIreeU2JV5MU8WPtMqRgRMRmdAzMEZp58pMqF
	 adCIkfOKAG/4sFezBpVlA1ITSVo+DH1QePVYwfajYVT8x0vs5moeLo5FhBc+uTYaIB
	 +pVfxMzgEznWA==
Date: Mon, 28 Sep 2026 07:30:38 -1000
Message-ID: <990954c20586117100f2a527ebc02820@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hui Peng <benquike@gmail.com>, Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
 Guopeng Zhang <guopeng.zhang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>,
 Chen Ridong <chenridong@huawei.com>,
 cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v4 3/3] cgroup/cpuset: check sibling effective_xcpus in
 cpus_excl_conflict()
In-Reply-To: <20260924042729.1908863-4-benquike@gmail.com>
References: <20260924042729.1908863-1-benquike@gmail.com>
 <20260924042729.1908863-4-benquike@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello, Hui.

The following is a Claude-generated review.

On Thu, Sep 24, 2026 at 04:27:29AM +0000, Hui Peng wrote:
> In cpus_excl_conflict(), when a valid local partition A1 uses implicit
> exclusive CPUs (cpuset.cpus set without cpuset.cpus.exclusive, so
> sibling->exclusive_cpus is empty while sibling->effective_xcpus is
> populated), a sibling cgroup B1 can still set cpuset.cpus.exclusive on
> the same CPUs because cpus_excl_conflict() only checks
> sibling->exclusive_cpus.

update_exclusive_cpumask() runs compute_trialcs_excpus() before
validate_change(), and rm_siblings_excl_cpus() already falls back to the
sibling's effective_xcpus when its exclusive_cpus is empty:

	sibling_xcpus = cpumask_empty(sibling->exclusive_cpus)
		      ? sibling->effective_xcpus
		      : sibling->exclusive_cpus;

	if (cpumask_intersects(excpus, sibling_xcpus)) {
		cpumask_andnot(excpus, excpus, sibling_xcpus);
		retval++;
	}

With A1 a valid partition on 0-3, B1's write of 3-5 hits CPU 3 there and
fails with -EINVAL before cpus_excl_conflict() is reached, so the added
check doesn't change the outcome and the new test row should pass without
the kernel change. Was the write observed to succeed somewhere? That check
also predates 2a3602030d80, so the Fixes tag wouldn't hold either.

Thanks.

--
tejun
