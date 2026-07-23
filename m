Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD9513D886;
	Thu, 23 Jul 2026 01:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784771674; cv=none; b=tZWUJkVeFFlC/iey2axxsIfI7xcgD5CmHCNbb0MgkPGFKs+E9miX+nWU9EG8EkCQmTE4lK04UhGVrzeJVQdXskBtZGo1LlCTVXWGTekEay32Xclth6+foVR1Gp5xKVx2VOmwlSmJkLXDKFXKnXt1DcEkMYN7RUI2Xi2Y4rrsZDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784771674; c=relaxed/simple;
	bh=BI9bGrhI+iytcA2ST/K8yYCkTf7E0PCtg/e4yUN6LiQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=B3vpER0F69vrqkho+x5VRKLpkwe26eOUxNVadr78lfQBSWGGEjPREqDSzrNkS/NrYFl9yjHf7k/F3OD0N2kbcb2tCyEQKpbZJFsXw5UkCgJPaX72unt2p+885xN7gK53s0xQ5A/oCRBH8l3mUKeny5/Prlr4axQSXLPcRQxWVQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C+uY7cJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C+uY7cJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCAB1F000E9;
	Thu, 23 Jul 2026 01:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784771673;
	bh=N6wjuTbPtxAIgqgnGjPxKaJ4seR3kbUIOBOKDIE0hX0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=C+uY7cJC1rLCcXQ9uonp8jtS1Q/1LHUvA2TMk43kckRVih0eSZwmuXLsHwSONPqo6
	 GvAxfZBNdFl5rPvNa5r7NFm2f7Eq6zKdVB/LQP8T91JxGVo3y9K0kulkUhQKib9IBw
	 DvRz6jbpHeyoFaR0+V2GSmOW8bVdbPqttuECU6Kg=
Date: Wed, 22 Jul 2026 18:54:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Muchun Song <muchun.song@linux.dev>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 0/2] mm: fix node reclaim swappiness handling
Message-Id: <20260722185432.12d549d77cbacd8d5e2829f6@linux-foundation.org>
In-Reply-To: <56fcb7bf-5e0b-46ad-84e5-12b2d00b7a34@linux.dev>
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
	<56fcb7bf-5e0b-46ad-84e5-12b2d00b7a34@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jul 2026 09:13:27 +0800 Ridong Chen <ridong.chen@linux.dev> wrote:

> >   include/linux/memcontrol.h |  4 ++--
> >   include/linux/swap.h       | 19 -------------------
> >   mm/memcontrol.c            |  4 ++--
> >   mm/swap.h                  | 20 ++++++++++++++++++++
> >   mm/vmscan.c                | 19 +++++++------------
> >   5 files changed, 31 insertions(+), 35 deletions(-)
> > 
> 
> Hello all,
> 
> Can this series be applied?
> 
> Just a reminder in case this gets buried.

Got it, and thanks for the poke.

It seems that kvack.org sent me two of the emails from this 13 email
thread.  This is becoming a problem.
