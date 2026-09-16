Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BAC4AA1DC;
	Wed, 16 Sep 2026 21:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789595672; cv=none; b=TN18ZFagxvIE8Wn3WxCi61vgX8/JA6d2fhZukrMoT8xnHszjmTUtQK/6adxEkOw1+lhH1RRbqJwVkp2cy2ws7qlFxfwhA+Pul/A/FYv6kzPSrAlx1ZlfnjtxEwplSbeEC6Wf6oWmGAoGh7yOnLDCSkJZF/1ptvIIOogMdOnjwRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789595672; c=relaxed/simple;
	bh=Gq1BSVOd53w9Y4VTYbQG4e9I+kizPM18DZDm9eCVhdU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=rvph49oRJ0OXTrahx2ya7TxpB77M/Vhi0EybVCpT8NHj6j+RlL14gTX/Vk6VC0QrR0JAdLrysosNSRStlwwGRd9Rxnai6hxmbIf8XgCX0RcXps+PyhkPBT9mp/GC2uSg1Q7ZaXcqAkCYj13yoZUlcg/1b1Pv0RLijpM6hTjj7s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DXzi1Jf9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DXzi1Jf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EF61F000FF;
	Wed, 16 Sep 2026 21:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789595667;
	bh=Gq1BSVOd53w9Y4VTYbQG4e9I+kizPM18DZDm9eCVhdU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DXzi1Jf96OLH9mzlC+Z5obvnvpHb/ZDWwIzCLNCaNsi+TNnrzFfyXW+w5XiTOUoI/
	 crDZki6Tt8rNNAZcBvTz5zYdnpXNHx8wist5Qdrk4vXEUglaQ0w9SKuJDidOiHkfH8
	 4a6UpbJl70OpgLCl+g3JXSTj2CrcPsyoyKX1uRXc=
Date: Wed, 16 Sep 2026 14:54:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Youngjun Park
 <youngjun.park@lge.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/11] mm: memcontrol: constify the read side of the
 memcg API
Message-Id: <20260916145425.32f739ea91f242e05e835560@linux-foundation.org>
In-Reply-To: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Sep 2026 19:20:04 -0400 Tal Zussman <tz2294@columbia.edu> wrote:

> The memcg accessors, lruvec helpers, and stat readers only read from
> the memcg, folio, or lruvec they are given, but take non-const
> pointers. Constify them, along with the page_counter readers and the
> swap I/O blkg helpers along the way.

Thanks, all queued in mm.git's mm-new branch.
