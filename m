Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1A629E114
	for <cgroups@vger.kernel.org>; Wed, 18 Feb 2026 19:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771444403; cv=none; b=ePdOM/Q/CgNBSwqBpqAYjxFsRGIQGVVeIWxZV3Jl40FkHTJ4txqvgsFJEX4Hams0QiYuTMCvI2XFioL6J6U24AgCv3DBTi5zHkt8nPsNFptQffuufs4V6A03pthA73RDcq6mf1Iys4bhsLnCD6MPg/KPBGVkuFGrJlEpcakvsc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771444403; c=relaxed/simple;
	bh=G60IxpbYhanmXgFlCPIUDQdnvr93vQ+OEcTO0tgAS/o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MlHDExkYIpwvvBZIeMmiVLqnGibcu21/N50V3gThS7DhF4DyN5OoEGoIt6drJZpKFa5oQ0HoVaz+Gx2rOMYs7Oa5kAtftXl0Bw1ID1HQ7vKyNE06lZ+T0XZwoMaYtl/jbMM/W63Jr9q2byiSb2XJ2BZwHInYFDFMbCHxYhGWbfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V/H6/jAe; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V/H6/jAe"
Message-ID: <2397f4cd-367b-421c-b4f0-9c023f6cd546@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771444398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdnOU1vGQA1zKpk8kTMZsw9c7ygfqJl1OhsRupZBpf4=;
	b=V/H6/jAeNBwT5tg4U5BLn/eRMm0dPifz25S3hPq141ITU5c0PWXjdPTF9DGOYil3JLG5j+
	Zg9OGti2fviCFqs+oDIJ0JIwa/ctAUUTxVZyVwbNDChuLvtnfkczZH1sVIHbZIdXvkl8y9
	O45YbBEP+0PZLGANix+9dkY2yESN61w=
Date: Wed, 18 Feb 2026 11:53:09 -0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: move pgscan and pgsteal to node stats
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 mst@redhat.com, mhocko@suse.com, vbabka@suse.cz
Cc: apopple@nvidia.com, akpm@linux-foundation.org, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, rppt@kernel.org, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, surenb@google.com, virtualization@lists.linux.dev,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260218032941.225439-1-jp.kobryn@linux.dev>
 <10434f89-fe2a-4cfc-9b29-1cd2ed2bbb7e@kernel.org>
 <fbcd6770-f555-443c-b5f2-fe5e73722118@linux.dev>
Content-Language: en-US
In-Reply-To: <fbcd6770-f555-443c-b5f2-fe5e73722118@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2/18/26 10:02 AM, JP Kobryn (Meta) wrote:
> On 2/18/26 12:54 AM, Vlastimil Babka (SUSE) wrote:
>> On 2/18/26 04:29, JP Kobryn (Meta) wrote:
>>> From: JP Kobryn <jp.kobryn@linux.dev>
>>>
>>> There are situations where reclaim kicks in on a system with free 
>>> memory.
>>> One possible cause is a NUMA imbalance scenario where one or more 
>>> nodes are
>>> under pressure. It would help if we could easily identify such nodes.
>>>
>>> Move the pgscan and pgsteal counters from vm_event_item to 
>>> node_stat_item
>>> to provide per-node reclaim visibility. With these counters as node 
>>> stats,
>>> the values are now displayed in the per-node section of /proc/zoneinfo,
>>> which allows for quick identification of the affected nodes.
>>>
>>> /proc/vmstat continues to report the same counters, aggregated across 
>>> all
>>> nodes. But the ordering of these items within the readout changes as 
>>> they
>>> move from the vm events section to the node stats section.
>>>
>>> Memcg accounting of these counters is preserved. The relocated counters
>>> remain visible in memory.stat alongside the existing aggregate pgscan 
>>> and
>>> pgsteal counters.
>>>
>>> However, this change affects how the global counters are accumulated.
>>> Previously, the global event count update was gated on ! 
>>> cgroup_reclaim(),
>>> excluding memcg-based reclaim from /proc/vmstat. Now that
>>> mod_lruvec_state() is being used to update the counters, the global
>>> counters will include all reclaim. This is consistent with how pgdemote
>>> counters are already tracked.
>>
>> Hm so that leaves PGREFILL (scanned in the active list) the odd one out,
>> right? Not being per-node and gated on !cgroup_reclaim() for global 
>> stats.
>> Should we change it too for full consistency?
> 
> I'm fine with adding coverage for the active list side as well. For
> completeness, I could also include PGDEACTIVATE.

Actually, I see PGDEACTIVATE is not gated so I'll leave that one out.
I'll send v3 and include PGREFILL.
