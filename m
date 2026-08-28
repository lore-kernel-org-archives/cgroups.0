Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E627D305699;
	Fri, 28 Aug 2026 23:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787959183; cv=none; b=HnUzGygS8p3mRJPnwcv5JPJUYkQ/9qbmy/nqMwD+146DpuHeRAwS3WGc64Zt+kP3BEtPmivPi7jNFLr8FTEY+cxdaSzB4mIx0/xTDduPdttm50TZooNNR8An2+zCUh9SxRIQwZXjpgbTptnrsiW/u1mrgeCBvguWMWEnFywkR1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787959183; c=relaxed/simple;
	bh=zTrPZ5twPN1sLhY3sbL8sKUc5MsAXTW86f5F2d3lJ6I=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=TF4DPOWvPNiowhRTY+RbtfUgYLQhcK8urK+qSSt6rD3iROPyVu6Ej0TKr0cXcKxLrLGmGgdqo2QxKAGOrQ37XH1vpnMw+c9vrj339IGTMYt9SLT9Ze29BzoGyHEHJ6ofCoi5Ys5aAGDxAqlkg1xodVnsiq73ApxbewPeVRmrX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OyaMlNeG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OyaMlNeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBB51F000E9;
	Fri, 28 Aug 2026 23:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787959182;
	bh=wGTIcEOa8Bl/ys+CrMwubJJ+e1El5YPJ5H0B806NNM0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OyaMlNeGv29cOVIgzSDrI3H6wGxTi2yI9Obbhxt+DwrreAxbryAnDVJORfl8SFd3V
	 /kAvbZsPefzV20UYas1yLsr3mJHRbaImT/12+z7SvKQSH7GdrkVb9G0PyZUJRENAD9
	 XlkjMAd/hkCHTzcXNNDeZc4WDw1ZedHHBXDsana8=
Date: Fri, 28 Aug 2026 16:19:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Ridong Chen <ridong.chen@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v3 0/6] mm/mglru: clean up folio counters and flag usage
Message-Id: <20260828161941.def8f7a319f6b435aad62d69@linux-foundation.org>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Aug 2026 01:53:33 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> This is a cleanup series separated out from the MGLRU-FG series [1]. As
> that series is getting too long in following updates, seperate out the
> clean up part for easier review and merge.
> 
> No feature change is intended, except one bugfix. It mostly replaces
> the open-coded bit operations scattered throughout the MGLRU code with
> new helpers, with proper kdocs, sanity debug checks, and hardens a few
> MGLRU functions.
> 
> A subtle generation counter leak is also found during the refactoring
> and the fix is included.
> 
> Also collected review feedbacks on the cleanup part from the posted
> series.

Thanks, I queued this for testing and further review.


I included a few notes-to-self:

- Unaddressed review comments:
	https://lore.kernel.org/fbb40ab7-6942-4983-9621-ab8d5d50474f@linux.alibaba.com
	https://lore.kernel.org/20260828052949.52874-1-lianux.mm@gmail.com

- [6/6] is pending review
