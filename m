Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F5D18A6DB;
	Fri, 28 Aug 2026 03:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787886439; cv=none; b=GwM5Gj39/R9zbTa+03TPlwsOFL6IXIj0mHEgP8cBLycI0kv6EM7Y4TB8uBiCByx4RUU3zfIEeQ1wbe0bJIe+708P5gs60t8YnIWf2j/omgM+0/FGZYyCGG5Bgfqp/W1Tio2qgTtVclWVmG8355bjqsc8KYSjX81ndfEJytJPJxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787886439; c=relaxed/simple;
	bh=Vk13ylbq2XTaCbis4+HpHrTF1zhROa0YXnhjXOcmLkg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=nAK19Bi6l64xKFIqEdaMwhk3mpkVH08Fs79WKP1L/ew/sfPyMos9HsJdcUA+QsDLIVEdNA+Bkn6tEBZdYFOrQBqsfyZGdiZ5YvjlTssZM1T0GW4rCsRnwcoVUUuqZqNSrVGpDTrzv/9exADu6jx34sbzzJ+euwD5ulHgxnXCytI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ogwjESZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ogwjESZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ADF1F000E9;
	Fri, 28 Aug 2026 03:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787886438;
	bh=Gt76UcTPmzHLWuOwKDbCamUsSovytLsnrvRwSJBIAoo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ogwjESZ5/FbCSjjrCLy5uiofj6a3BXR3/ZKpajdm5ZCo9aB8+asfXzXiazHR/vJcs
	 ggzMBp1ivVxgK7aGvpICf/s7db/rIy8wvidccRF4T05SSed7qjdRnmJlI+KxOyFki7
	 2kC+NR2EW8bFE+6fZhpAnLQZXcj8BYnklmn+9FVA=
Date: Thu, 27 Aug 2026 20:07:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 yosry@kernel.org, david@kernel.org, muchun.song@linux.dev,
 shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
 youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, riel@surriel.com, gourry@gourry.net,
 haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com,
 skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v4 00/11] Virtual Swap Space (Swap Table Edition)
Message-Id: <20260827200716.97881447f243c4afd275144e@linux-foundation.org>
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Aug 2026 08:32:26 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> Currently, when an anon page is swapped out, a slot in a backing swap
> device is allocated and stored in the page table entries that refer to
> the original page. This slot is also used as the "key" to find the
> swapped out content, as well as the index to swap data structures, such
> as the swap cache, or the swap cgroup mapping. Tying a swap entry to its
> backing slot in this way is performant and efficient when swap is purely
> just disk space, and swapoff is rare.
> 
> However, the advent of many swap optimizations has exposed major
> drawbacks of this design. The first problem is that we occupy a physical
> slot in the swap space, even for pages that are NEVER expected to hit
> the disk: pages compressed and stored in the zswap pool, zero-filled
> pages, or pages rejected by both of these optimizations when zswap
> writeback is disabled. This is arguably the central shortcoming of
> zswap:

Thanks.

I asked Gemini for a tl;dr and was told

: Introduce Virtual Swap Space (vswap) to decouple swap entry management
: from physical disk slots by using dynamically allocated virtual
: clusters that back swap entries on demand via zswap, zero-filled pages,
: or physical disk.  Eliminate wasted storage space, remove the need for
: static swapfile provisioning, and enable in-memory swap features on
: diskless systems without degrading performance.

I'll take no action at this time - let's see what the other swap
developers make of this.

Sashiko was talkative, as usual:
	https://sashiko.dev/#/patchset/20260825153238.2695446-1-nphamcs@gmail.com

There are a few pre-existing things in among this, They look legit to
me, from a quick read.  SWAP_USAGE_OFFLIST_BIT should use
BITS_PER_TYPE(atomic_long_t)?

