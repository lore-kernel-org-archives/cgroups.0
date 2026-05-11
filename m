Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD8432AADC;
	Mon, 11 May 2026 21:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778533971; cv=none; b=ayTI+nqF+HCCrsVi/7PLj3anLupF0w2Vkyaobr4ZUwP9L3GKrrJ9LuSgXsj7PhAmfA6mZXox5aKlZzFepLIwJAMVgc9zxQ23hl7BGGrquF2Kw2Zd6nUPKBg/gnLmn3ZXi0okm+jUMHOqE2g6pYVi5oj4StBIaU5Icbo2HVj241Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778533971; c=relaxed/simple;
	bh=NM9hT8Fsvi3n2nwRZxfAVFQAf1Vhq3vLs0fNanGuwkU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=uR5q9ByPji6P72mciBBAFvNEfjUMu7b4TpW+twd2lC+zEcymZj4j455h1UMxEX3Bi8QYScljNcwHFqC59yqPFihnxYtLfwwf56VKcm9lAhjAyp/TF535QPhoisa6zYkaNUIJjGJ04NcCFOVzUGCBm2MmpTlUnBL4ngq3Az2hQmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RUll7hu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RUll7hu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5417FC2BCB0;
	Mon, 11 May 2026 21:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778533971;
	bh=NM9hT8Fsvi3n2nwRZxfAVFQAf1Vhq3vLs0fNanGuwkU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RUll7hu/kdrsdt56J2K8L+DJt83t2yMVr1lZoc0E4pitUX/J4KfTZJD35PxJzib0c
	 kIkKF4Xe4uB2qoNVQP2RKU9sikQ+MwmKkF5VMPF14Wmojg7PF8evmZ9ly9qi0Bn7G2
	 gTo5iL2Pn2FKCLyxBouo+H6LtHuViXNhwgR7ehHw=
Date: Mon, 11 May 2026 14:12:49 -0700
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
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed
 <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain
 <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Michal Hocko
 <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH v3 00/12] mm, swap: swap table phase IV: unify
 allocation and reduce static metadata
Message-Id: <20260511141249.eac1426fee41c9fe463e7e23@linux-foundation.org>
In-Reply-To: <CAMgjq7CJ8Are6m7X2UxUoJ=77c_oSpdG8-bzkmdRzwey2Cp1gQ@mail.gmail.com>
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
	<CAMgjq7CJ8Are6m7X2UxUoJ=77c_oSpdG8-bzkmdRzwey2Cp1gQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 25 Apr 2026 02:11:47 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> > base-commit: f1541b40cd422d7e22273be9b7e9edfc9ea4f0d7
> > change-id: 20260111-swap-table-p4-98ee92baa7c4
> >
> > Best regards,
> > --
> > Kairui Song <kasong@tencent.com>
> >
> >
> 
> I checked sashiko's review, it seems sashiko itself is bugged or
> something wrong, Most patched end up with:
> Tool error: Review tool timed out (active time exceeded)
> 
> The rest of the results are all false positives, maybe I can add a few
> more comments in the code or commit so it can understand the code
> better.
> 
> And checking V2's review:
> https://sashiko.dev/#/patchset/20260417-swap-table-p4-v2-0-17f5d1015428%40tencent.com
> 
> Which are mostly false positives and I've fixed the two real but
> trivial issues already. Things should be fine.

Sashiko review of v3:

	https://sashiko.dev/#/patchset/20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com

appears to be complete, so perhaps it went back and figured it out.

It claims to have several "critical" and "high" things, so please
recheck?

From your replies in this thread, I believe that we'll be seeing a v4
series?

