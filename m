Received: from mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BE34457A4
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 11:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788433799; cv=none; b=TOWtN3gmwv+tBdp5AZCHNpw17Uxaa88/Dnh6ovXwEvO0NiXeYXkQvn9/jU+bA5wUkJ//1Fuz2lfY4CF0LgChUPXFg/eJvCpBicyrowdQ4jZPrgBY594VtsiMK329gbl6dWcYF7bT4+GeBn4N/DmBryHTprbhZF4xjXYuo3l7vbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788433799; c=relaxed/simple;
	bh=5otrudvUze2byo+X815NSeEZwrE2DUwXDl2b42bC0BU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=OG20dAuJTaoVARWnhAkfI4YVq74pPmhyEZvqQ8TOrRkktwOLrJLbXsa3DcPJh0aHBDhh9QnIShSzbCYmom50xwavqA2L/gixmchK54M1V/IemkLchUFQO4OHzurWln47ZQAixGP8obf3OkZXoHHTr9Swp77MGv/kh51HTvE4A2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GvGdq7J3; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GvGdq7J3"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5otrudvUze2byo+X815NSeEZwrE2DUwXDl2b42bC0BU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788433794; v=1; x=1789038594;
 b=GvGdq7J3AGy8BMy1urk+qW+IrkNwHkBzKQr3cGnPk2RtVJczqBn5Z8Y4zJ6qfSl9JY98TI9P
 60nTI6v6hMXSN00zBSUEIit//OF/JWPUO5vYq1OhOF4AKJB0tzbGUGgz7Iitivu791wmyNPwgju
 youxdkAMi0ZWGKyToj1SE4Cw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id f00607339005c6f4;
	Thu, 03 Sep 2026 11:09:54 +0000
X-Mizu-Trace-ID: f00607339005c6f4
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb: charge folios to the target mm's memcg
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260903075048.3316-1-zhoujinmeng@bytedance.com>
Date: Thu, 3 Sep 2026 19:09:30 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nhat Pham <nphamcs@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Jinmeng Zhou <zhoujinmeng@bytedance.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A65A41D3-3C00-4EC4-A34A-716C7FFCD2FA@linux.dev>
References: <20260903075048.3316-1-zhoujinmeng@bytedance.com>
To: Jinmeng Zhou <jinmengzhou22@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 3, 2026, at 15:50, Jinmeng Zhou <jinmengzhou22@gmail.com> =
wrote:
>=20
> HugeTLB folios are currently charged to the memcg of the allocating
> task.  This gives the wrong result when a userfaultfd handler =
populates a
> HugeTLB VMA that belongs to another process.  The UFFDIO_COPY ioctl
> operates on the userfaultfd context's mm, but =
get_mem_cgroup_from_current()
> charges the folio to the handler's memcg instead.
>=20
> This can be reproduced by placing the faulting process and its =
userfaultfd
> handler in different memory cgroups.  Have the target process register =
a
> HugeTLB mapping with userfaultfd, trigger a missing fault, and let the
> handler resolve it with UFFDIO_COPY.  The hugepage usage is then =
reported
> in the handler's memory.current instead of the target's.
>=20
> The generic userfaultfd population path avoids this problem by =
charging
> folios to dst_vma->vm_mm.
>=20
> Pass the target mm through hugetlb_alloc_folio() and charge the folio =
by
> using get_mem_cgroup_from_mm().  This preserves the existing charge =
timing
> and error handling while making HugeTLB userfaultfd population =
consistent
> with the generic path.
>=20
> Fixes: 8cba9576df60 ("hugetlb: memcg: account hugetlb-backed memory in =
memory controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.

