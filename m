Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794289855;
	b=ROTK8UyWQFT6kiWdNcao+ofKj+TH66QkXns/biJzNtaiLoWJanYiNgIg9E96ZcIi4MWe
	 BHkmFKW58YA4dwV+hl6PrBzkIH5TF7RCedSpmB/oqx+xMq8kR5zH2xGs0gJelBYqSeTaf
	 0tI9nrgcTwJMInfRaSGHYqy8n3Jv04y5WmQL/8mUEk5v7dxAh5aVN/RJCI1LppljQmWoH
	 dX3+isjsiZBxLIcv/FNFLt0Gn0ogAPi68pxPwLHaL8enpCefBc9CCL2O5CgGV8HkoSzt9
	 ZXP7GvM0dA4mzuD1jKFLgkoQJMelNEKKOC3ukxBuyaSRKpANgQ7RNvhkntndH4XdafA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794289855;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=6ZEWtGySM5+QQdruouC1viwqoN2MmrPWa2xX8Qe0HyY=;
	b=5D8ELMrsJ6BY7NsWp+coxnnsgEo6KyBSVdxe6nnx4LY61q/FZDdQpo9gARkzRKdJum+h
	 pkZ6M6xc4m2/AknuWjUsx5QigSoN7xWBTyh7jyRQrZMCmF5ZusBwWYUJe+R8gV0Xbebwl
	 c2cvgmsQ5no5cpKz8vzFx3CVwmeTu3vldkfPklv1iz2WPspVoVAZL2spYPW2d/dhYEsWC
	 lf+VvXW74Inm7YedLdgYPivu+A7JP9i67r0SY0IPXrhXvJ11uY53IoAHvPqgIEeJYR4Ix
	 y15WTrXzjnE0kH/5G6uYq3B9+qtK0fHbY4F8jiqJQ/bRo/I4o+qAFSnz+0i50QOM46A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F1BIbj2f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0962A606A338;
	Tue, 10 Nov 2026 05:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F1BIbj2f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54C71F0089F;
	Tue, 10 Nov 2026 05:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794289854;
	bh=6ZEWtGySM5+QQdruouC1viwqoN2MmrPWa2xX8Qe0HyY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=F1BIbj2fUIITKtbEId63TpSMq4PqBsEJ6k7T00RQXzEtLuknjZHkZ70W0/3Gaab3i
	 i+HafO1XRfpoNvd6AFGVuIdzHI0jxAGHLKgIF5nRyAGZzPUpdLSsrv1lxXrIHqDEjj
	 kXyrWLMn0/9fWfaRvi6HT+APEqk1sf29Un2oYSuA=
Date: Mon, 9 Nov 2026 21:50:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
 david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 RESEND 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
Message-Id: <20261109215053.85df5685da951ab47ef858f1@linux-foundation.org>
In-Reply-To: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  5 Nov 2026 17:22:28 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:

> With cgroup.memory=nokmem, the THP deferred split shrinker and the
> zswap shrinker are degraded in two ways.
> 
> First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
> shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
> limit-induced reclaim of a cgroup neither splits its partially
> unmapped THPs nor writes back its zswapped pages.  v1 of this series
> [1] restored the flag to fix that.
> 
> However, as Sashiko's review of v1 pointed out [2], the flag alone
> is not enough.  __list_lru_init() also collapses every list_lru into
> per-node lists under nokmem, so even with the flag restored, the
> objects of all cgroups share one list per node: the per-memcg
> shrinker bit is only set for whichever memcg happens to repopulate
> the empty list, so pressure in other cgroups may not even trigger
> the scan, and when it does, the scan walks everyone's objects.

Thanks.  Sashiko still has significant-sounding things to say:

	https://sashiko.dev/#/patchset/20261105092233.3558950-1-qinyuntan@linux.alibaba.com

It also says "failed" for reasons I don't understand and it doesn't
seem to have emailed anyone.  Please check it out?
