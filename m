Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E5125F98A;
	Thu,  3 Sep 2026 01:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788397451; cv=none; b=MDDd+BMvmvOQ33jLW58ycTYSqkbQFOIVsfEfWY3IP+6l/sesbdsO7NA1tedhtfUiFYWJIZk6XT0dmFeQ9kv9fpn+86Am3QwLmuTibRxsI4F8VFdIeIqv02bhV6dgL6Tptk3j9TAXWEnnoYiKUj3duzxGPF1U/Ifiw7r3AO1dYbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788397451; c=relaxed/simple;
	bh=bfrVCWHN1Dv/MDHrzG5R4VEyW2inHXOCByzv7h8fNE4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Ab+btkfILBvz4JM+UGo/3HSJCM24hw6eZVG7T+O+cN445UssqahbM880QIXtBAMz9xtXVHWsCBAoAqCNb9a8j0b6oQ+29GBq7pOHdC5jvyxMky9ZWPt2/qGXYqYoYQR9g7Wd3KiD9DGENyRWxGAgjTXjnbUO4YJ2GJAZCXNSwyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lv6frWmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lv6frWmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D661F000E9;
	Thu,  3 Sep 2026 01:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788397449;
	bh=kNT7Z2FMxt/nfOQZlUflR3zMw2XOgkeNZiCD6ouunac=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Lv6frWmIMBhsZT2PbPJmz9srQDtxWdSn9v59muHBsrLCyGSrOM4BF+Dwp/XHqJ9Hr
	 ZIhqg1lFK5NXXOOVJHWCGB3GvpzX42wDAjbROLuEi8b3RvB1druPR2CWA+ZgLTPwzl
	 XHf38yM4beeoq2eVsBsaiwhmWV0YcnfpmxdTt6Q4=
Date: Wed, 2 Sep 2026 18:04:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry@kernel.org>, Krush Chavan <krushchavan@outlook.com>,
 "Chengming Zhou" <chengming.zhou@linux.dev>, "Tejun Heo" <tj@kernel.org>,
 Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, "Shuah Khan"
 <shuah@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v2] selftests/cgroup: account for zswap shrinker
 writeback
Message-Id: <20260902180408.05b925ce05359cd4d7f96894@linux-foundation.org>
In-Reply-To: <20260902194521.3652178-1-joshua.hahnjy@gmail.com>
References: <20260902194521.3652178-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  2 Sep 2026 12:45:20 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> The test_no_invasive_cgroup_shrink selftest checks that when a cgroup
> has zswapped out more memory than memory.zswap.max, it does not
> trigger writeback for other cgroups. To do this, it compares the
> writeback count in a control cgroup and makes sure that it is 0,
> and then checks the writeback count in an aggressor cgroup who does
> expect to see writeback.
> 
> However, when the zswap shrinker is enabled, the victim cgroup can see
> legitimate writebacks not triggered by the aggressor. In some Meta CI
> tests, we have seen this failure mode happen.
> 
> Instead of checking that the victim cgroup has 0 writeback, compare the
> writeback values before and after the aggressor runs and check that
> the victim cgroup did not perform any additional writeback. Note that
> this can still lead to probabilistic failures if writebacks take longer
> than 5 seconds, but this should fix the systematic failure case.
> 
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")

Thanks.

I do support backporting selftests fixes.  We want selftests to work
well in the kernel with which they are shipped.  But, as ever, we
should include a clear explanation of the userspace-visible runtime
effects of the bug.

Seems the short answer is "false-positive test failures" but we can
perhaps do a little better than that.  Quoting the failure messages
would be a good way - very recognizable.

> Reported-by: Krush Chavan <krushchavan@outlook.com>

Relatedly, is there a Link:/Closes:?
