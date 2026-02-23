Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4D6340286
	for <cgroups@vger.kernel.org>; Mon, 23 Feb 2026 19:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771874660; cv=none; b=eGkAhthX/aXnvk067fKGjs9akcLRt3gvjanFbhWtHAdzD7mmiCrv0zUWuEvg1gz2PXnER5yOuorUGD8okGeNEsux6f8fNqn/4p2UO1WiFCMVSxZub8xh0Vkq9Iu7+vv1j/BLVKqham4cF1aevhJLeyqqEo7iWG1RR5Egm09cWWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771874660; c=relaxed/simple;
	bh=6TZd4+pJn+8hGb0V7noqVqCLrSSpO83Rz3N2TUwk/QI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ht4L67QDgQpqojvmdnCEg8VDAJzxcM/8e/JrPRZ4eEehXy0ZicToCukZmF+xJ4guNH4w5G8S3SSOFuI4iYKT/csHoP+YiQs/6JnLwySKASLmIyeRNsvmKD1O/LDyGXX81QQdvzdoj/H7ZR2IVwLqHyVBWni7r9uAZ5NVs6E30Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eiTbXIzA; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eiTbXIzA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771874657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6TZd4+pJn+8hGb0V7noqVqCLrSSpO83Rz3N2TUwk/QI=;
	b=eiTbXIzAMiOrRPGqqLUCeGzU1qIn/7nfvwRHMTsf+6ADaVvbUQuCmG8QkQ0s/YhYUcPgMh
	k3KR5O76ASPjnsZDPRm+owgHRxHesiy+ruAUz41AjdsabQSazBODovejgRiqE8HdYQ5L2n
	xHfjKDc4WIg4ekbfBc81O48PrPNnRAc=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Uladzislau Rezki
 <urezki@gmail.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Michal Hocko
 <mhocko@suse.com>,  Shakeel Butt <shakeel.butt@linux.dev>,  Muchun Song
 <muchun.song@linux.dev>,  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: memcontrol: switch to native NR_VMALLOC
 vmstat counter
In-Reply-To: <20260223160147.3792777-2-hannes@cmpxchg.org> (Johannes Weiner's
	message of "Mon, 23 Feb 2026 11:01:07 -0500")
References: <20260223160147.3792777-1-hannes@cmpxchg.org>
	<20260223160147.3792777-2-hannes@cmpxchg.org>
Date: Mon, 23 Feb 2026 11:24:03 -0800
Message-ID: <87h5r78drg.fsf@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT

Johannes Weiner <hannes@cmpxchg.org> writes:

> Eliminates the custom memcg counter and results in a single,
> consolidated accounting call in vmalloc code.
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>

Nice series!

Thanks
