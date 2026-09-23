Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2407130F52B;
	Wed, 23 Sep 2026 01:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790127350; cv=none; b=qZl65FTZFX+VLu7lcVMdGRwOLvo9zk8qd3hfY62yG6PAsLxQHuYvFbBN0B6OwOh4BnoDfVHbd6Vbw8I3THkjd0Iy06PpXcwUmmz076t4/UUUEXV6/NE05USXmA8u6nuNAAxvQ+oliXhafhDJPL8FKqXEJPOtVjoihCOFa70b8LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790127350; c=relaxed/simple;
	bh=GSvwV+BI3zcsHFisEBD1yR4dyKdVRN3dWpBGs6N79Qk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=tk9cW9b/H3gSc8a/081C+g7gpCdRsizgVCr98rgEwOZpqARqFVS2/fWquZl0obRYGn1ixOHDGF13lzVYJTfLMbhZbGtwGvNMqeXIwt3tEQHSPpLKtHQxhK6a5s7YR8Bm37aKWQmoRJdtsUOeEDEl56O+XMNf6T+dE9n8CIFyrc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VrtS+bkq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VrtS+bkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB94F1F000FF;
	Wed, 23 Sep 2026 01:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790127348;
	bh=ngMEIbTaabSp9OnaFNAXRZtKwgGuZEQbttwH5KAHvBk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VrtS+bkq7nbM/bIMJ1aDsy5TOCMtXDAWqmICbzzFXOyzo+Xl/TnMj9cikpTsEP2Fs
	 Vi4hqUuSxKGP8/51jriiXvpx+EcM3Ip1RQ9t4PioTGwo+tIqpk1JSEnnTb6OJXCdnv
	 byODjXSdYQxzfu/bygzI/sweUUKWhpkN9ktqYMQI=
Date: Tue, 22 Sep 2026 18:35:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Michal
 =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Usama Arif <usama.arif@linux.dev>, Dave
 Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed
 <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Xunlei Pang <xlpang@linux.alibaba.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
Message-Id: <20260922183547.788d21b89868bf820e94cc62@linux-foundation.org>
In-Reply-To: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Sep 2026 16:07:18 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:

> With cgroup.memory=nokmem, the THP deferred split shrinker and the
> zswap shrinker are degraded in two ways.

Obvious question which may have recently been addressed:

Why are we keeping nokmem around?  How useful are its memory savings
and is anyone actually using it?

Clearly it isn't well tested and it increases our testing space (beyond
out testing resources, apparently).

If the right answer here is "kill it" then this patchset is introducing
risk into the main codepaths in order to fix codepaths which shouldn't
be there anyway, yes?

