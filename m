Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BE9275AFD;
	Mon, 17 Aug 2026 17:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786988623; cv=none; b=MATdM2XFrjdkm3uM1rljycPDZ46E3I02gIVAnqX0VXyYvpE5J/JjPVgvd/1E2NeCb+yvTwv7bUKUFIQHNiCkuK/mPmAb5qnzkCgIi9l92kcBqJkjX/xjRF+IYjO1wSu8csFRMQrsqXLrfvfubVKNkz0aa588xwhibleLXNaVJmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786988623; c=relaxed/simple;
	bh=q2U33ppGzZLHqMJv8GbdK0iRGZq+sl5FL9ofjRkoavE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=W8LW2Bp3hV7QQBV6LrUwRwkaxrcTlJEIeqQz3hdCrpzCVHmZJjEt+zGeb3R78dO89wOjUzkHCaEGAUvpEiJeIgMcmnflwQdflW/BlGzYpYaBTfl+8SRDaagFOT22C6p1DMZgDaikkMjSNY34WPYbtrsdFy7mmdJIdozYTqlerTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eKkxo1KR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eKkxo1KR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA561F000E9;
	Mon, 17 Aug 2026 17:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786988621;
	bh=ljlKfunao6ScN++sYA+g1iZ+XV/2BXLfKcwWuV93qQQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eKkxo1KRikpizP51WbuqCMzjbpsMC2EB66RDsQvKs8ZF6hUQ2yzOxhKRJwpwRk0RM
	 SvRpNBy0qrEWJRYHQvfYbb1gFQvJzRVbAKrWOX+MYnlTSghqalzzxK+zA3VajtvzZO
	 mx/iPyqBLKgzIfRv2Gax1+Ob7z8N7wH2yITp70mc=
Date: Mon, 17 Aug 2026 10:43:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: shakeel.butt@linux.dev, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
 muchun.song@linux.dev, roman.gushchin@linux.dev, david@kernel.org,
 kernel-team@meta.com, kernel test robot <yi1.lai@intel.com>
Subject: Re: [PATCH] mm/memcontrol: avoid false sharing between vmstats and
 events
Message-Id: <20260817104340.c9bd2dae70d4fa31fd66b216@linux-foundation.org>
In-Reply-To: <20260817103835.2937733-1-usama.arif@linux.dev>
References: <20260817103835.2937733-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Aug 2026 03:38:35 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
> struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
> This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
> vmstats_percpu pointer onto the same cacheline.
> 
> The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
> disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
> 60-second run on a 176-CPU test system.  Those writes bounce the line
> while memcg statistics paths load vmstats_percpu.
> 
> Move cgwb_list into the existing alignment gap and cacheline-align
> vmstats_percpu.  This separates the pointer from the event counters
> without increasing the size of struct mem_cgroup in the tested
> configuration.
> 
> The blamed commit reduced median mremap throughput by 4.38% on the
> test system with one socket. The patched kernel brings the performance
> to within 0.5% of the parent which is within the observed boot-to-boot
> spread (up to 1.2%).

Cool, thanks.

> Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")

That's in mm-stable so I'll squeeze this fix into next week's 7.3-rc1
merge pile.


