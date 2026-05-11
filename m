Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB59617555;
	Mon, 11 May 2026 01:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778464751; cv=none; b=hnp3aqzeQDy3OMpLnRCaGse4gAxnpSR8k8ZHOoOBl7ukKi65khqx3EGrwBzMrRcIHMOPcYgMQeobzhz1ziWCuIBC5D8TO5q+mTROs8oel7TWaxyX/5ndtYVO37lTx3Ta8XDO69a1JM0wZSCeWE9Ex4CVWbrK0HcSeAuP3GJCQ6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778464751; c=relaxed/simple;
	bh=h+uhi/NqA0FdGMn82gWEgw/8zcywPLWzEWQvhat6/88=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=M4JM768JZeHxBNSGDEGNEZX+x5o12X5Xy5fyqFxSOomHg9S/TLLM4mQVAMXtK/eQlEGbVZB2hp3+e5mBrfFRrFmlQ7u0UmbTvFhlhOHALsNrJNHeKccAlsjkI10LYxJjjDYFWqfUIcAm5giQNhreFZqEXcddKKM3/Rhbbfg/Gdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NWOuzoUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NWOuzoUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD6EC2BCB8;
	Mon, 11 May 2026 01:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778464751;
	bh=h+uhi/NqA0FdGMn82gWEgw/8zcywPLWzEWQvhat6/88=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NWOuzoUn82hVqXnprSFfjlPUtCeyVd3ZsBboGucmVmzQ3MRrHhRgZSNzznWgD0AiJ
	 uA7LJPRU3UmJs34ooy9X9DWuXmDf5LwBSN7764Jf11zGoEbXAZmSIw9dsuS+d44GQL
	 u2IlZYRmXAvhPE+yKTn0eREok5p3SlYfXaTVKq18WczPIdv0MnUnqkxVdtxXZhtjYY
	 1MymlfRM/23JnNwW+gjZFB3r9RvFCWX5OezVgasy3XVi7WuksPxI0Ywr8XTs4GbadE
	 9kWLa86jk8Vva3+XSrMvcSEbtHBMMhPg/N5hZsfyT7aPvw/KEAKIxIchFHRsVw/G+Y
	 niYOoriDHTzqw==
Date: Sun, 10 May 2026 15:59:10 -1000
Message-ID: <e6b0da8a53e22257d122096c429a7310@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutný <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>,
 Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>,
 zhangguopeng@kylinos.cn,
 cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: Fix cg_read_strcmp() empty string
 comparison
In-Reply-To: <20260509080328.632007-1-lihongfu@kylinos.cn>
References: <20260509080328.632007-1-lihongfu@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.1-fixes.

Thanks.

--
tejun
