Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5593A6402;
	Tue, 17 Mar 2026 11:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773745846; cv=none; b=HKOaxhp6OgFEJYIAAIienDc623zZ0vGSrvfXiYSxVjVfl08VDYS1aopXNI7vv/WH3fR4jt8z5R7QmqtdX2Oxn5kXdFmT9igX4kkD+19md3P+LsdWi5c/BVW/QditzsTx9u9QpMJDOvk9D1ADVevcwjDPm0wPPStV/QQUGOZla4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773745846; c=relaxed/simple;
	bh=h+iIk4sKTg71YTACb73pQNi/1+OjRYcdvjHoMwjgIaY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=pP5IPqEhWnbBfWY0axN0Fz2MjtjYXrM8QoU6up12gbx8XDntWfYbI03qFgaRfwEr6wXJzMRkOipOmKEKgIaaGUQSItu/62esC25Mwz/p4BouZz3FZaVR8QjasNApLjuIqWmqERLedppu/M/S0X45x4n9lEwoIDuUDCAvamagv4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s6pNrlBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6pNrlBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086A6C19425;
	Tue, 17 Mar 2026 11:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745846;
	bh=h+iIk4sKTg71YTACb73pQNi/1+OjRYcdvjHoMwjgIaY=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=s6pNrlBct8GJbRVqxmGYx17KCxR0NHWfkJJWindVrjfCwJE1vpER1+XNeY9qgu8W/
	 6QCuUvoCkST7h2tb1pn93TlZNhZuM2BCOdpcXIXRWopGwcJZ6ZeWQrS1FqyX1ABljP
	 oxp2LuSVjUOE/P/St3jv3qXXAGgOu7dQlaTSicNG1J7LTAIqvB6gFDw+/GRCNoesbS
	 zW/QyvYYbbjB05GlcSDOjAJK30QJILKDoP9QDBF8VUOZfxdC9qUJ7sxs7XutOV9oVQ
	 13aZwnoWCaG+8XsMbNG8r2ykyqmePvMWePzAUvwWlMPy2K59aUEiWGWdN/35eyOTC9
	 WQjgj7oorP6FA==
Message-ID: <48ad9d08-157b-426f-86f4-69793f3537fc@kernel.org>
Date: Tue, 17 Mar 2026 12:10:36 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
Content-Language: en-US
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
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
 <c4e5cc3c-5daa-404e-8c55-cface8aa969d@linux.dev>
 <87sea0o55p.fsf@DESKTOP-5N7EMDA>
 <0d66401f-9874-4047-971b-632723b0b7ee@linux.dev>
 <87a4w7x8d0.fsf@DESKTOP-5N7EMDA>
In-Reply-To: <87a4w7x8d0.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/17/26 07:44, Huang, Ying wrote:
> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
> 
>>>>
>>>> It's an interesting thought. Looking into these existing counters more,
>>>> the in-kernel direct node allocations, which don't fall under any
>>>> mempolicy, are also included in these stats. One good example might be
>>>> include/linux/skbuff.h, where __dev_alloc_pages() calls
>>>> alloc_pages_node_noprof(NUMA_NO_NODE, ...) which eventually reaches
>>>> zone_statistics() and increments the stats.
>>> IIUC, the default memory policy is used here, that is, MPOL_LOCAL.
>>
>> I'm not seeing that. zone_statistics() is eventually reached.
>> alloc_pages_mpol() is not.
> 
> Yes.  The page isn't allocated through alloc_pages_mpol().  For example,
> if we want to allocate pages for the kernel instead of user space
> applications.  However, IMHO, the equivalent memory policy is
> MPOL_LOCAL, that is, allocate from local node firstly, then fallback to
> other nodes.  I don't think that alloc_pages_mpol() is so special.

Agree, it's equivalent to MPOL_LOCAL.

> ---
> Best Regards,
> Huang, Ying

