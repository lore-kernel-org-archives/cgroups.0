Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFED440A13;
	Tue,  1 Sep 2026 03:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788233983; cv=none; b=QNaXGHAQsU2MHyfE7PGxbPWEh337Uhn9ua2yWHH3wFUdOoUovI5legr7+EBSJ0B/LWhD5Lh84DyXQTtbJKE60L+RcJfKLYD5NCykl7fEEyEIqUCoyV/ciKZDBvf45vAlPNlEIicIpmnLCDLsV5WoaJEzY6qFs+RcqOR0bvhWFLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788233983; c=relaxed/simple;
	bh=9C29zMQh6XvAxTYsbh+zSOZLACrNP1gRRlQwmbrm4xc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=ESQpRR3LosRxgKiE43nxRldtztRds5eRxHBNfSiglA967gXKjCX8EYVKJxs1aH52YPg9+FAfXkfSew7SnDHlWtWv5z6pIV6FQgL5C4PqYbajcmI6mizkWI/wpwRnbMhtFxv9QYHKG47+uhKj17uy8VFS8LETIWXw0C35MRYvrHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s8TuZ3sM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s8TuZ3sM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF6A1F000E9;
	Tue,  1 Sep 2026 03:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788233982;
	bh=a/VdIQLDigMrM7krqqQaGYUq1ryWMzorWYseQH/iXOM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=s8TuZ3sMsrRpghZI9kxLPKwAUVdjRcqEKdGL2Di6vTOV1OvhiapGGrrfBi7LF42Jr
	 VEDNeu9y9aekgIegPW2vy9W1t+RxkKnLWDLTZlWctGjQ66pDWJgSaddgva8snMpyON
	 PWM3/ZNw8hXIBbY+WXSYx4ovLvoq2GZgPWEEI/i4=
Date: Mon, 31 Aug 2026 20:39:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, baohua@kernel.org,
 hannes@cmpxchg.org, ryncsn@gmail.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, hughd@google.com, chrisl@kernel.org,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, ljs@kernel.org
Subject: Re: [PATCH v7 0/4] mm: avoid large folio splits when swap is
 unavailable
Message-Id: <20260831203941.0ba48ca2d794d6903d232e5f@linux-foundation.org>
In-Reply-To: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
References: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 30 Aug 2026 12:29:16 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:

> This is v7 of Barry's original RFC patch, "mm: Avoiding split large
> folios if swap has no space":
> 
> https://lore.kernel.org/r/20260618221720.71768-1-baohua@kernel.org
> 
> Barry's RFC showed the no-swap case with MADV_PAGEOUT on 16KB mTHP: the
> large-folio split counter increased by 1024 even though no swapout
> progress was possible. Skipping the split in that case kept the counter
> at 0.
> 
> This series makes folio_alloc_swap() classify failures according to
> whether splitting a large folio might allow swapout to make progress.
> Callers can then avoid destroying the large folio when neither global
> swap availability nor the folio's memcg swap hierarchy has capacity for
> even a smaller folio.

Thanks.  Sashiko had a question which didn't occur against v6:

	https://sashiko.dev/#/patchset/20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu
