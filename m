Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B61951EDE8;
	Wed, 30 Sep 2026 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789864; cv=none; b=tNXucSS0IRNAWkRhEJHCiSQjR3RumhRpu/n+AULqLJLhJ86V2iGQXMwb0xerZRtIWvcQTrXxt2Al51FRrnJ0Dl8Tby73vybajPw9Ss06GAguedBUnzurxu8GSCkqIbHhxHnQOYYqiyrAp1yoF5m0RLg/lH/mxuZBLBdaxpOKqCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789864; c=relaxed/simple;
	bh=OOHXwjjqofWI2p15QebT6RXB/+E5sINkxdRSi/ohQvc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=myPGFgxVRvfJJx3b4K/9IVNNy9ejOdXGZYFhjJ70IWy3IfdlsajKx5wgX4pNoQrRIyFmDFTHK8SZuoVylfCeoih6yhJlzr6uWoIGFUjcG61sLVJh6dfQK/p7zlrNVeDU4BVo1bMMPLSL0+i1M9IJYv8FnT8B62//flgtZw+ceCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5UicTKb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5UicTKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDF41F00899;
	Wed, 30 Sep 2026 17:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790789863;
	bh=OOHXwjjqofWI2p15QebT6RXB/+E5sINkxdRSi/ohQvc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=F5UicTKbsin8O6giS5dZ1VvcNggz+CkrnYjMTtLY08rWCswaWr1t70zvxTMT20JgV
	 vK8ukYjEjShPETKVJ2pbZUBZYnacZi09pyYZusLSy3H7S74IxmGRNv+4WhgfAjVSHJ
	 np8ezaguaWOvE9U8lsc2rEoUc0wxpj68+wJVT2ggtPeKNfUw7oztuKC2xtM0/dWxsk
	 Qs55aF5tBHruDwjpFTurdFgTai2XODxVyPcdoNONaJunAAB8wUBKoCBVOcLY+se2WJ
	 KIX1VCC34fOH2FCuONyqrU6QTW7vxisJIpecgl2K/IXlSkAD2GCdajdnDft3UAfPDK
	 njvp3T5U/bi2Q==
Date: Wed, 30 Sep 2026 07:37:42 -1000
Message-ID: <961be6d0a3b65badf879fb84824bade8@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrea Righi <arighi@nvidia.com>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: Use cpuset_v2() in cpuset_num_cpus()
In-Reply-To: <20260930154800.698360-1-longman@redhat.com>
References: <20260930154800.698360-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.4 with the "hierachies" typos in the description
fixed.

Thanks.

--
tejun
