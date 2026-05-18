Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BAF39A050;
	Mon, 18 May 2026 21:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141098; cv=none; b=STAeZNSLoYPu7RO0xkfXHwQ29lkbXZ5gExMK2jbDYF5lqODmM1GYl1/QeUx2fhvuHv9rIiTq3uqbbbbyRJ1perEqzPX4+qNNwF+qJ8wPniT7pVahne/ZMDVbnXkrJXWC8lnIHUs28UPHrsLZgsn6RZHHqQVwTytsjHmIYElyQ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141098; c=relaxed/simple;
	bh=aY0k4+s5LAO5ZCe+6y3wGxrecziQGleYEmIT2C7RsAc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=u2sXWSaGBLBgnUhFtx9DM9f0vtM8VljYUUTgaXTdziTNkLiPnnNhON+qGsYtA8iIgsC+0c2//5TWmFmvT1yX4Tu9ZY0zN6yKNZ0+VRIMO0WuhhwQXy36vSo9V34KEuBD4wIn7qo223DF8EnDZnhqpFdbnCFsD6Cy+ydDEquXtbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V5gIlmRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V5gIlmRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98F4C2BCB7;
	Mon, 18 May 2026 21:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141097;
	bh=aY0k4+s5LAO5ZCe+6y3wGxrecziQGleYEmIT2C7RsAc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=V5gIlmRpxo83oYESxmn2FUqFW16HCxf5eNhXcuYyPf+PrEAtWC3zDMa1wNbKl8Tg9
	 arCFDZ4fP3F18zRuYhePFadE6sbHei0gF577GFhwrtn2saa2mVJuiTANJNlu7s93dL
	 /Ld3d0fEdIJ8N/odDjcPG5/nBV1IMMn8Ox9N0WKg=
Date: Mon, 18 May 2026 14:51:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, Hugh
 Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park
 <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, Roman
 Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Lorenzo Stoakes
 <ljs@kernel.org>, Yosry Ahmed <yosry@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v5 00/12] mm, swap: swap table phase IV: unify
 allocation and reduce static metadata
Message-Id: <20260518145136.8541d74ab64d3d42d9f1a4ce@linux-foundation.org>
In-Reply-To: <CAMgjq7DryNOmJbJ38tiwFadVT3oaMTTtQ3=BxD70s5AVjG8pbw@mail.gmail.com>
References: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
	<CAMgjq7DryNOmJbJ38tiwFadVT3oaMTTtQ3=BxD70s5AVjG8pbw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 19 May 2026 02:11:35 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> On Sun, May 17, 2026 at 11:40 PM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > This series unifies the allocation and charging of anon and shmem swap
> > in folios, provides better synchronization, consolidates the metadata
> > management, hence dropping the static array and map, and improves the
> > performance. The static metadata overhead is now close to zero, and
> > workload performance is slightly improved.
> >
> 
> Sashiko only gave a warning this time (and it's false positive):

Sashiko behaved unusually.  "Note: The format of this report is altered
due to recitation restrictions.  Direct quotes from the original patch
are omitted, and a free-form summary is provided instead.".

	https://sashiko.dev/#/patchset/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com

Roman, what's that all about?

Thanks, I'll add this to mm-new for some testing.  Review is thin at
this time, but we have a large and dedicated band of swap maintainers,
so I'm sure that will change ;)

I understand that there are some architectural/directional differences
amongst the team (or there used to be), so please don't be shy about
weighing in if you think we should be taking things in a different
direction.

