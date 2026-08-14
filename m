Received: from mta0.migadu.com (out-162.mta0.migadu.com [91.218.175.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E330E2F8EA5
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 02:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786674339; cv=none; b=aPMe+BKowESeXVpd79ePc7bMGT8E/04YJPkyuO8jIoFT5ysCbMyosl88U/HCDZWMrcesS0K0Mic3pVY2WFVEgI3s1fTUVXg6IL4Vy4JAPFpopsCyG2h5Ojv4M6DxGl9hRQ6SZ4IFy8lu3rMRrHSTnVdKMIK7lmuvk+ZbShrzOuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786674339; c=relaxed/simple;
	bh=5zVwaIiED/lldV1BAfSynde5Phrd17ahcbOlsOuj4XM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oXpOUfLVJVlyKSUaWl02FgZclt50QZjqzryioROtGTdHgY5hxxB2kvZzBvBf4vBvPFK0nfIYZopyb8MgZmR8P4hUDeobeH+3xtKxf+SBnqFTtjLlIk5UgU+0pH44v1RyAodw+Bu+Tt6TJlJTdjU0ATz/y50Mz+NsUkfnbBNRLl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h0ZEm4gs; arc=none smtp.client-ip=91.218.175.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h0ZEm4gs"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5zVwaIiED/lldV1BAfSynde5Phrd17ahcbOlsOuj4XM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786674336; v=1; x=1787279136;
 b=h0ZEm4gsoqsoGhGG6E9HCvBkjOWTJok+wfj8w1/WjcxHjuubTMdNR1rYt5V6RZ8M6NNXoHHZ
 HwmgXCeZ+LebfzG0ZSwKg9MYIlaDMbWwaybEWHz2H9VKBv9OM/Rnxn7BoyUt8ul7SFjFMcK2sU6
 nTCF1gVX47QG3V3aMH7imLH0=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [10.63.123.245] (14.29.108.90)
	by smtp.migadu.com with ESMTPS id 736a32a2e0ccae00;
	Fri, 14 Aug 2026 02:25:35 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <3c487b6d-c510-473f-b708-0fc699a23459@linux.dev>
Date: Fri, 14 Aug 2026 10:25:30 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] memcg: acquire peaks_lock when reading memory.peak
To: Muchun Song <muchun.song@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
 David Finkel <davidf@vimeo.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
References: <20260814012924.2388613-1-ridong.chen@linux.dev>
 <20260814012924.2388613-2-ridong.chen@linux.dev>
 <811C3A33-6B05-40D5-8448-19D5BE882A83@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <811C3A33-6B05-40D5-8448-19D5BE882A83@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/14/2026 10:12 AM, Muchun Song wrote:
> 
> 
>> On Aug 14, 2026, at 09:29, Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Sashiko reported that a reader can transiently observe a lower peak
>> within a race window [1]. peak_show() returns
>> max(local_watermark, ofp->value), but peak_write() updates those two
>> under peaks_lock while the reader takes no lock. The interleaving is:
>>
>>   writer (reset on fd A)                 reader (fd B)
>>   ----------------------                 -------------
>>   usage = page_counter_read(pc)
>>   WRITE_ONCE(local_watermark, usage)
>>   // watermark lowered to usage
>>                                          lw  = READ_ONCE(local_watermark)
>>                                          // sees the lowered usage
>>                                          val = READ_ONCE(ofp->value)
>>                                          // B's value not updated yet
>>                                          return max(lw, val)
>>                                          // both low -> low peak
>>   WRITE_ONCE(peer_ctx->value, usage)
>>   // B updated, but too late
>>
>> Fix it by acquiring peaks_lock when reading the peak, so the reader sees
>> a consistent snapshot of local_watermark and the per-fd values. The same
>> race applies to memory.swap.peak, which shares peaks_lock and the
>> peak_write() path, so take the lock there as well.
>>
>> [1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
>> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> ---
>> mm/memcontrol.c | 14 ++++++++++++--
>> 1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 17da1f43b7d3..6dd8756870ff 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4713,8 +4713,13 @@ static int peak_show(struct seq_file *sf, void *v, struct page_counter *pc)
>> static int memory_peak_show(struct seq_file *sf, void *v)
>> {
>> 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
>> + 	int ret;
>>
>> - 	return peak_show(sf, v, &memcg->memory);
>> + 	spin_lock(&memcg->peaks_lock);
> 
> Why not to use guard(spinlock)(&memcg->peaks_lock) to simplify the code.
> 
> Muchun,
> Thanks.
> 

Good idea. Will update.

>> + 	ret = peak_show(sf, v, &memcg->memory);
>> + 	spin_unlock(&memcg->peaks_lock);
>> +
>> + 	return ret;
>> }
>>
>> static int peak_open(struct kernfs_open_file *of)
>> @@ -5858,8 +5863,13 @@ static u64 swap_current_read(struct cgroup_subsys_state *css,
>> static int swap_peak_show(struct seq_file *sf, void *v)
>> {
>> 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
>> + 	int ret;
>>
>> - 	return peak_show(sf, v, &memcg->swap);
>> + 	spin_lock(&memcg->peaks_lock);
>> + 	ret = peak_show(sf, v, &memcg->swap);
>> + 	spin_unlock(&memcg->peaks_lock);
>> +
>> + 	return ret;
>> }
>>
>> static ssize_t swap_peak_write(struct kernfs_open_file *of, char *buf,
>> -- 
>> 2.34.1
>>
> 

-- 
Best regards
Ridong

