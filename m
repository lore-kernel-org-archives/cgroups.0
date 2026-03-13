Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1957D29AAF3;
	Fri, 13 Mar 2026 07:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773387307; cv=none; b=RqIze0SE0nSZw0cy+DWUnHHEPQMp6s57Ouno/NCbzshz3F5DZHdFHhbDoyDDLSw8GaSKjNp+sFWr8F+vn5Lz65IuKasONX+7x3R8MTRTTkJu9QPqqvJCJ+W1xd9NMXNZ8yUXlNxKOqenPJhq5fNJIKnCc2xh2z7E0OOBMnPBSrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773387307; c=relaxed/simple;
	bh=Hy/mm2FsSo89H25fWq5uQIiSYeWoevbFUmwsH1lsJuw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=KxcwwaV6/819vB2TV1aXA6cOZDKqwBSoS4rIMm2hHlG32joWqfzRXe4rN6gA7WI6NDvi8akaQ3Mi/h2Dlvo+0aF35ho3ZrI9KKKyL4zx7/zxa0aBW+KcdkW+DhpyyjeZ9o5Ua+icvIr+1sop4W0ZcL7JzlvdE9iJgMzMMaP7Kok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N83u8HMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N83u8HMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EFCC19421;
	Fri, 13 Mar 2026 07:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773387306;
	bh=Hy/mm2FsSo89H25fWq5uQIiSYeWoevbFUmwsH1lsJuw=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=N83u8HMXtvCVLJvM0Qtnh7rp8ZYDXDV3zSGJJlxrw7EO3LdCgXskApIiDntE5QLWE
	 bgvfmNy0YBMtskCCSui9ml1GBpso1MZIueVAoF+Crq4Uo97+18N5Da0FjBEyTZU7UH
	 +z0QgiUzwBrp1E3eViLT81M1Lx4SAjJpt7A9PktX3lcrRynB9HARv3ed2ExqZYkTDs
	 chrUBFgVqgbd76j9tINjsN6Q1aWl4Qs/5ymqHl8BSA6KIAf0qywEbAiyV+3pU9vv8l
	 SK59nFuiWD3WE/Xs8NmRQFmBNJPc3CmZXelLF+2VnEL56i7aQwpcl+JZgWaj8+yDWZ
	 6lSMNBz2xwgZQ==
Message-ID: <60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org>
Date: Fri, 13 Mar 2026 08:34:58 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
 apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com,
 cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com,
 gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org,
 joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
 <343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
 <874imkpba1.fsf@DESKTOP-5N7EMDA>
 <cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
Content-Language: en-US
In-Reply-To: <cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/26 07:14, JP Kobryn (Meta) wrote:
> On 3/12/26 10:07 PM, Huang, Ying wrote:
>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>> 
>>> On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
>>>
>>> How about I change from per-policy hit/miss/foreign triplets to a single
>>> aggregated policy triplet (i.e. just 3 new counters which account for
>>> all policies)? They would follow the same hit/miss/foreign semantics
>>> already proposed (visible in quoted text above). This would still
>>> provide the otherwise missing signal of whether policy-driven
>>> allocations to a node are intentional or fallback.
>>>
>>> Note that I am also planning on moving the stats off of the memcg so the
>>> 3 new counters will be global per-node in response to similar feedback.
>> 
>> Emm, what's the difference between these newly added counters and the
>> existing numa_hit/miss/foreign counters?
> 
> The existing counters don't account for node masks in the policies that
> make use of them. An allocation can land on a node in the mask and still
> be considered a miss because it wasn't the preferred node.

That sounds like we could just a new counter e.g. numa_hit_preferred and
adjust definitions accordingly? Or some other variant that fills the gap?
