Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE1535CB6F
	for <cgroups@vger.kernel.org>; Thu, 11 Jun 2026 05:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781155587; cv=none; b=eI4zsM1QCdPbz3ZainxQjz52i7Ovw+LNOG7HSb6/t3V9XxqKNVbLBES0utBLXJG+iRCHJbO5VwfuFBDVBNZ2p3pUDyKYXZoBpmUNA6utRY1P6jzPex2iYotlt6SlabGTuQoAhkAj18D3NAncSt1rAqRh/7DCi9P+v4ImO6zS0Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781155587; c=relaxed/simple;
	bh=KWQqS8gV2CPteH4a+zKxTE85D/3pI+ltsiFq8cmqFKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QauyCgEpKBQZeqAw8lCUJbVIcKzC9uBE2U52ZmYrai/mVLDIIf8+Iry+TX4ct8mWLHxxulKWfzgHRHPYec5IzOnIiAsFR7MFsHv1aYnHRu+fxl9NfjVMxreqJf9Qu2Z+1IH8pEdJvqvx4l5SqRWWA9yf+3N+IGh9UKpnMhosP0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GxqslFYr; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GxqslFYr"
Message-ID: <0b1099e8-e124-4073-a0e8-2d4e85bc26dc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781155576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=34u/gf0ccNs0AJS7sbBUEsTt849laT5bFT+HM9Xyi74=;
	b=GxqslFYrILbXOQlWHj8igI1eCbxWd1zxelDqBdx7jfsco16NQTduCUecWvKi8JXiwGhR2U
	fcyNmuKDL8Hez8SmareSvLt+vsPOAq6pnWt4NhCCCwTCnbLTZl+b6fUds4yDWlVbmx/hVk
	7DgSIqPlyAmQvtyvqZRiud1HlGLddWM=
Date: Thu, 11 Jun 2026 13:25:54 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] cgroup: rdma: free idle pools during cgroup teardown
To: Ren Wei <n05ec@lzu.edu.cn>, cgroups@vger.kernel.org
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 pandit.parav@gmail.com, yuantan098@gmail.com, zcliangcn@gmail.com,
 bird@lzu.edu.cn, tr0jan@lzu.edu.cn, d4n.for.sec@gmail.com
References: <cover.1781092143.git.d4n.for.sec@gmail.com>
 <9eb365a37ab83f38686007f8a61a656759d39bd7.1781092143.git.d4n.for.sec@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <9eb365a37ab83f38686007f8a61a656759d39bd7.1781092143.git.d4n.for.sec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi,

在 2026/6/11 02:13, Ren Wei 写道:
> From: Daming Li <d4n.for.sec@gmail.com>
> 
> rdmacg_css_offline() converts each pool to all-max limits so the
> existing reclaim path can free it after the last uncharge. However,
> zero-usage pools are already reclaimable at that point and leaving them
> linked until rdmacg_css_free() lets later device teardown hit a
> use-after-free when free_cg_rpool_locked() deletes cg_node from a freed
> cgroup list head.
> 
> Free zero-usage pools directly from rdmacg_css_offline() while holding
> rdmacg_mutex. This keeps the existing reclaim rule, avoids new lifetime
> states, and ensures a cgroup cannot be freed with reclaimable rdmacg
> pools still attached.
Looks good to me.

One minor note: the offline path skips rpool_has_persistent_state()
and frees idle pools unconditionally. This means peak/event stats are
lost earlier than before (at offline vs. at free). This is fine given
the cgroup is dying, and css_free() cleans up remaining pools anyway.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>

Thanks,
--
Tao
