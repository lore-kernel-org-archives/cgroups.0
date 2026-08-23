Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4295041A8F;
	Sun, 23 Aug 2026 07:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787468568; cv=none; b=qJ2UeC0HKs4cViP+2Ao7RxZTH3JUY+oj4F7fv+36JCrPh+G3L95qBBe8+gMbTngiLSov5PJVGxca6n3waEev+r69g9+HuKV61vYRWNweeWQgoWORVFDjcSOn5KCl+KrwYrBy9FwJy8xZE49zD9qGjC/gywBWSH3wTQZh7+oHWi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787468568; c=relaxed/simple;
	bh=IemGmC5QHGxqIa52cAgBD6AUQlItqfq9FZxNptqBRYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2Rgel6u3BKo5Ht8m5DLb8Xm3pcnIkBzlhjwE4FFOM31JLGiJ5dEPp1AYCR4W7JX9ng/ruusX+Bv8rMCfM+j2y8SX08NwmWserqTIXCITdD1vSFCfF7EMJZwJzYhMxGebg0sceLZ+2DVBdwUCPZSa13lmivFsO/aiQMgNLvplKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFJQKJeu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFJQKJeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494EA1F000E9;
	Sun, 23 Aug 2026 07:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787468566;
	bh=rrlgIqfpPIHSqK0RV/eGVXjNicOZIO8LbhcffvSifZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oFJQKJeuMZncT+e8e6YlISEmXQB11x8W66x7n4X6TulTEx/Z/wSdBmu2qLZBRJdRj
	 hyv9pUZkXZGvwchBnoquA4Y7L35ecs8ywXwbsHaxds0oalhGkNLv/249xUUE9zMQuo
	 IjIbTp2qTGvB5RyopS41bYK1ZuYRwwGC1eHMND1csjVOtylehQWDtdSgz4TAzwa7+h
	 s8alwQI4JXTl62GPqwXqaZjP1MQzSWgK32bkAq55xEd4hXId/GgDn4a5fV15qdAmHX
	 BRD1RGczq74PXBAn+PSR8v6Pc3PTnQ5jSEL4AjkciyRkWpdTBuGZzJcb/G3q2XUIjI
	 LsA+P1uDfWK+Q==
Date: Sun, 23 Aug 2026 10:02:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <aoqbCyX-32doBJwd@kernel.org>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>

Hi Eric,

On Fri, Aug 21, 2026 at 02:56:52PM -0400, Eric Chanudet wrote:
> CMA allocations are currently unaccounted for by cgroup memory
> controllers. As system resources, they should fall under memcg, but CMA
> areas partition the available space for different purposes and memcg
> doesn't have a good representation for that.
> 
> Add a memory_cma_accounting cgroupfs option in preparation for the
> following new behavior. Make it disabled by default since it will
> account for CMA allocations in memcg which may affect existing systems.
> 
> Provide CMA charge/uncharge functions to memcg that introduce a CMA area
> specific counter per CMA area. Charges are issued to memcg and to a page
> counter for the CMA area used. The allocation's folios are marked with
> the cgroup via commit_charge() (once for large folios, per-page for
> 0-order ones) so they can be later uncharged correctly.
> 
> Add the new memcg calls into the cma allocator under __cma_alloc_frozen,
> for both cma and hugetlb_cma allocations accounting.
> 
> Finally register the per-area usage counters in the cgroupfs. Each CMA
> area creates a memory.cma.<area>.{current,max} pair for reporting and
> limitation for each area.
> 
> Selftests and a vmtest script are added to this series for convenience.
> The tests are simple accounting and limit enforcement verification using
> the default reserved CMA area (cma=) and hugetlb_cma.
> 
> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> ---
> Eric Chanudet (11):
>       mm/cma: drop const for struct page on release API
>       mm/cma: include linux/cma.h in cma.h
>       cgroup: add memory_cma_accounting mount option
>       memcg: add cma charge/uncharge functions for area counters
>       mm/cma: charge cma allocation to memcg per area counters
>       memcg: register per-area usage counters in cgroupfs
>       selftests: cgroup: add cma configs for cgroup selftest suite
>       selftests: cgroup: add memcg cma tests
>       selftests: cgroup: add a vmtest script for memcg
>       selftests: cgroup: add memcg hugetlb_cma tests
>       selftests: cgroup: amend vmtest-memcg to run the hugetlb cma tests

CI found issues:
 
https://github.com/linux-mm/linux-mm/actions/runs/32519133924

>  Documentation/admin-guide/cgroup-v2.rst         |  35 +++
>  include/linux/cgroup-defs.h                     |   5 +
>  include/linux/cma.h                             |   4 +-
>  include/linux/memcontrol.h                      |  19 ++
>  kernel/cgroup/cgroup.c                          |  15 +-
>  mm/cma.c                                        |  14 +-
>  mm/cma.h                                        |   6 +
>  mm/cma_debug.c                                  |   1 -
>  mm/cma_sysfs.c                                  |   1 -
>  mm/memcontrol.c                                 | 205 ++++++++++++
>  tools/testing/selftests/cgroup/.gitignore       |   1 +
>  tools/testing/selftests/cgroup/Makefile         |   2 +
>  tools/testing/selftests/cgroup/config           |   5 +
>  tools/testing/selftests/cgroup/test_cma_memcg.c | 402 ++++++++++++++++++++++++
>  tools/testing/selftests/cgroup/vmtest-memcg.sh  | 197 ++++++++++++
>  15 files changed, 903 insertions(+), 9 deletions(-)
> ---
> base-commit: 98f21c54f99519329c18e2625b0ea6db14524d09
> change-id: 20260706-cma-memcg-regions-696cb5ef7998
> 
> Best regards,
> -- 
> Eric Chanudet <echanude@redhat.com>
> 

-- 
Sincerely yours,
Mike.
