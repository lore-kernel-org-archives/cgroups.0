Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E78353A79
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 13:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784899925; cv=none; b=kb4x3/SxH8kXqJAl8giYF0nYrua44kWBy6L0IzjloFQEBQNdC+zyTQd2ItOECTZKq7Xkj4A7gmypTpwgn8bMPQKaQ3wfM42EYDEUEHxQTkK3kzRaYYkYTlgJmfiaxLgSe8s82D2rbHhJTms7KGSq7g50MgqM6y75LmL6vKnHv+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784899925; c=relaxed/simple;
	bh=Q3VmA1rpaXdbeHbqRihP1SXGAlCIJhLMZnZiUJD7miI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i6He8lSEaI8LkLy9RasVS5pPdaryXlsvqiyUgGzYOXfUtDuBjN1R5WWe1jQojIhJ2ZE5Hfro2QEMlMFHz2eOSL1UPCAxQswQVduCDqQhqg6daocpb6XJpgHEK+R1p8CpAQo3JBupbBK42FjQNBRg/Ge00Olv2RxRPwyoXTwnnzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jSYp83tW; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jSYp83tW"
Message-ID: <fb6b983e-843d-454c-bfa1-ec802228f981@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784899912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0L14fpsDjK7+KbfhNaWx2JjhNpl8Qbr0apeF37K42Uc=;
	b=jSYp83tWZQIV6kKKIgu/juSKjF6BY5bm7gikrfI/fIOwDQL6r8L4HWUN0Fade11N9zar4E
	l4mS+UfVZ/mb7Db9jfrbc5B5IirlKduEBGG2NLHImr9CD/20BXJ80YZPjPrDPuoPxgA3mi
	SBmFW/AO83AMMm8uTAXutSlMsPIZynw=
Date: Fri, 24 Jul 2026 14:31:12 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, chrisl@kernel.org,
 nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com,
 hannes@cmpxchg.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 rientjes@google.com, kernel-team@meta.com
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260723133548.2e12b638bd629ef63b935113@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260723133548.2e12b638bd629ef63b935113@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 23/07/2026 21:35, Andrew Morton wrote:
> On Mon, 20 Jul 2026 09:41:21 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
>> The anon/file scan balance heuristic in get_scan_count() is fed by two
>> scalars in struct lruvec (anon_cost, file_cost) that every reclaim
>> producer updates under lruvec->lru_lock. The cost-recording work
>> itself is trivial, but it both contends for and contributes to
>> contention on lru_lock - which is often a contention point on
>> memory-pressured workloads. Specifically:
>>
>> - shrink_inactive_list() re-acquires lru_lock at function exit just
>>   to call lru_note_cost_unlock_irq().
>> - shrink_active_list() does the same after rotation accounting.
>> - workingset_refault() takes folio_lruvec_lock_irq() purely to
>>   record the refault cost.
>> - prepare_scan_control() snapshots anon_cost/file_cost under
>>   lru_lock.
>> - lru_note_cost_unlock_irq() itself walks parent_lruvec() and
>>   re-acquires lru_lock on every ancestor, multiplying the cost
>>   of every update by memcg-hierarchy depth.
>>
>> This series removes those producer-side acquisitions entirely.
> 
> Thanks.  We're still awaiting review of [2/2].  I'll get this under
> test in order to parallelize things.

Thanks Andrew! Yes I think we have the reviews, but just 1 outstanding
comment from Shakeel and need to shorten commit message as Johannes
mentioned. Hopefully we will have a final version next week.

> 
>> Measurement is a 30 s `perf lock record -a` window
>> over otherwise-idle hardware.
>>
>> Workload rates are identical on both kernels (the bench drives the
>> same memory pressure):
>>
>>                           baseline    patched      delta
>>   pgscan_direct  / s      172,662     171,817      ~0%
>>   pgsteal_direct / s       67,162      66,306      ~0%
>>   workingset_refault_anon / s
>>                            40,696      39,830      ~0%
>>
>> perf lock contention (total wait per 30 s window):
>>
>>   Lock Name                Before      After     % change
>>   shrink_lruvec+0x770     722.84 ms    0         -100% (eliminated)
>>         (= lru_note_cost_unlock_irq)
>>   workingset_refault+0x167 385.26 ms   0         -100% (eliminated)
>>         (= lru_note_cost_refault)
>>   shrink_node+0x4ad       689.43 ms    26.95 ms  -96%
>>   shrink_active_list      208.34 ms    15.97 ms  -92%
>>   lru_add_drain_cpu+0x34    1.96 s    917.71 ms  -53%
>>
>>   Total LRU lock wait      ~4.23 s     ~1.66 s   -61%
> 
> So it saves 2.5 seconds out of 30 seconds?

Yes 2.5 seconds total CPU time in the 30 second perf record.

