Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C253DD53B
	for <cgroups@vger.kernel.org>; Fri, 13 Mar 2026 18:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773426561; cv=none; b=t8gZjYtKZGAoLNa5WlTcB5NWnV4BBFXaPYJt/jmSTtV/A9UPNqB3Ab+HhlsgpbD66rmhRAyYj82gMrSahfcUkTXq00gdIOUwa/AT3jJ0kHDutwRb9FjN/MzKy2ims/3GTcmVB+ug74O+N7bKBq9rARtoBekoO2tPyST2tQuTiAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773426561; c=relaxed/simple;
	bh=beT3slSxigQWpRi2wAgooEEIOo5XJcpPrhDfU9dsQZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ief7uPwYYRSC82lyMo4Dbk5vpaqnYpf54mxiaFgpkygJzmJq0L3JkmJa63pzdtOYOW5L6XHGFKNSpN2U6gvyGsf2/QzWYsnuK/HtUTd2YdgMBF0oHQm2jsLwz18RdGAEeIgDB72u87vjPSZGNwjQIFxmyD8JZg+b4ABMZgsuqmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gOjsee/7; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gOjsee/7"
Message-ID: <cdc56556-2f69-46b7-8a7c-0f144a36004c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773426547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pv/nqWXHkfj7NbNE0aFGYmPjuMP96PKFI4ITkk92xic=;
	b=gOjsee/7ePXLg2aXVQRCN98jWrWOJGc7S6Od5X5MCK2XmZiOGkbnjW7aiGdNYAKZEniFby
	yIlBZdhFvB+0R6tKrR+2QHRw41SgEFGPECC6cQR00lVPRhhcghOc3/uCGAMO4OCyycW0lq
	ZTmH8SsM0A6v+7eY3IHoq5fzhd3ix7E=
Date: Fri, 13 Mar 2026 11:28:52 -0700
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
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
 <60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org>
 <87zf4cnkip.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <87zf4cnkip.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 3/13/26 2:31 AM, Huang, Ying wrote:
> "Vlastimil Babka (SUSE)" <vbabka@kernel.org> writes:
> 
>> On 3/13/26 07:14, JP Kobryn (Meta) wrote:
>>> On 3/12/26 10:07 PM, Huang, Ying wrote:
>>>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>>>>
>>>>> On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
>>>>>
>>>>> How about I change from per-policy hit/miss/foreign triplets to a single
>>>>> aggregated policy triplet (i.e. just 3 new counters which account for
>>>>> all policies)? They would follow the same hit/miss/foreign semantics
>>>>> already proposed (visible in quoted text above). This would still
>>>>> provide the otherwise missing signal of whether policy-driven
>>>>> allocations to a node are intentional or fallback.
>>>>>
>>>>> Note that I am also planning on moving the stats off of the memcg so the
>>>>> 3 new counters will be global per-node in response to similar feedback.
>>>>
>>>> Emm, what's the difference between these newly added counters and the
>>>> existing numa_hit/miss/foreign counters?
>>>
>>> The existing counters don't account for node masks in the policies that
>>> make use of them. An allocation can land on a node in the mask and still
>>> be considered a miss because it wasn't the preferred node.
>>
>> That sounds like we could just a new counter e.g. numa_hit_preferred and
>> adjust definitions accordingly? Or some other variant that fills the gap?
> 
> Or can we adjust the semantics of numa_hit/miss/foreign to consider the
> preferred nodemask instead of the preferred node?  Is there some
> programs to depends on the current behavior?

Good question. I think it comes down to whether the existing semantics
are correct with respect to policies that make use of node masks. I gave
some thoughts on this in the previous reply to Vlastimil. That
correctness may be outside of the scope of this patch, but I can give
that a try afterward. I'd like to send a revision that reduces the new
counters to just 3 and moves them off of the memcg (as previously
mentioned in thread).

I know numastat is one consumer of the existing stats. It seems up to
the user on the interpretation of the data. Not sure about others.
