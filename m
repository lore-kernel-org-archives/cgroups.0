Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0318036A03B
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 03:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790048074; cv=none; b=QmHLkdmwtjoSTGr2NX8ULq3qTiJZIfv3rlyvfj+SRRyPpc4JdEVr5BpUuJn0yW8/4J0hJbG+igmAuCZVD8uAZ0t4Kb+4DS5M9agEyeuT1ixRt1qYv8VQdRTCWQsiN5gyXteHvL7UGd7HqKzQIA163xj56+9/n+Mo2Yxss1ueHBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790048074; c=relaxed/simple;
	bh=CjIp01xrNtfOBxRn61B9UTZFA1lm/a/pyrDp80PRKmc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=k6ebaijkqqVVaKl31OHp7dyyvunGNL1gZPkCZ1S7FWMbVHB7BB4Un1KCto6XB4sEf74fBESVmSm8SoTeYO0k4RmhR+zQ9oPkAWWbrCNCVbuqMBZZTOO6BAzCV3tCmT6MSywWQXZ9kHnDvH6gKjgzvKzsqtyb2A63bEpTPR8uQvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MfoHUeli; arc=none smtp.client-ip=91.218.175.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MfoHUeli"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=CjIp01xrNtfOBxRn61B9UTZFA1lm/a/pyrDp80PRKmc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790048064; v=1; x=1790652864;
 b=MfoHUelik4u6D6Wo2HiRbVtk/8AH0OSVn5inWpfUPNnLkZZALD96JKRcNngp52DWgZco/1gH
 NLFS14P++YmNAnXz/2NbabIVzsxQLCUlZnDJGVJ7HGOQPj0SX32bURLTEAvbRRflWnvSvu8Grq7
 NK0Ee0xrfReA8nKLtT5XvQrg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id cd004a5251b8e779;
	Tue, 22 Sep 2026 03:34:24 +0000
X-Mizu-Trace-ID: cd004a5251b8e779
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/2] mm/hugetlb: account migration target folio in
 per-node NR_HUGETLB vmstat
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260921223544.2401052-1-joshua.hahnjy@gmail.com>
Date: Tue, 22 Sep 2026 11:34:06 +0800
Cc: Hongfu Li <hongfu.li@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>,
 Chris Down <chris@chrisdown.name>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <5FE0FD2F-4F8D-4EF9-BD78-2AB97E10B687@linux.dev>
References: <20260921223544.2401052-1-joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 22, 2026, at 06:35, Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> On Mon, 21 Sep 2026 17:12:34 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:
> 
> Hi Hongfu,
> 
> Thanks for this fix. From the cover letter I was frowning because I was
> thinking to myself "surely there's no way hugetlb accounting is this
> broken..." but it seems like indeed it is. 
> 
>> From: Hongfu Li <lihongfu@kylinos.cn>
>> 
>> The NR_HUGETLB vmstat counter is maintained per folio's node: incremented
>> when a huge page is handed to a user via hugetlb_alloc_folio() and
>> decremented when it is returned to the pool via free_huge_folio().
>> 
>> A folio obtained by alloc_hugetlb_folio_nodemask() never goes through
>> hugetlb_alloc_folio(), so it is never accounted, while its free always
>> is.
> 
> That's pretty scary! Glad that you caught it here.
> 
>> For a migration target this means the target node gets no matching
>> increment for the decrement on the old node, so the global nr_hugetlb in
>> /proc/vmstat drops by nr_pages for each migration. The same asymmetry
>> affects the failed migration path, which frees the target again right
>> away, and the temporary folio hugetlb_mfill_atomic_pte() takes from the
>> same helper.
>> 
>> alloc_hugetlb_folio_reserve(), used to preallocate the memfd page cache
>> folios, has the same asymmetry: the folio is handed to a user without
>> being accounted, while its free is accounted through free_huge_folio().
>> 
>> Account the folio where it is obtained, in alloc_hugetlb_folio_nodemask()
>> and alloc_hugetlb_folio_reserve(), so that the increment pairs with the
>> decrement in free_huge_folio(): a successful migration hands the folio
>> to a user, a failed one frees it again.
> 
> The changes look good to me, and I was able to reproduce the issue on
> my host and confirm that after this change, the missing charge is
> fully accounted for.
> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> Again, I'm super surprised that a problem this big has gone unnoticed
> for so long. Thanks again for working on this fix!

I think a migration for HugeTLB is very rare. That's probably why it
took us so long to find this issue.

Thanks.

> 
> I hope you have a great day : -)
> Joshua
> 
>> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>> ---


