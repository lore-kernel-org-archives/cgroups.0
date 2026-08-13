Received: from mta1.migadu.com (out-86.mta1.migadu.com [95.215.58.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A8828033B
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 01:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786583885; cv=none; b=j4sqgOH3HGQsf5eTBA0ZxASEKw4YMfFY8INcigB1lG2JIzgeEPmxMhGzYSmXScIqxPgQeHLeHHkLLhcqkx8ZhcOVpHINU9223eqV1EU2toz0jTOSyPki/l5uYhXZxPsJLCjnictVbuDOi3sqwqZwvT2khuiY9t/EdLvOOuGVfJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786583885; c=relaxed/simple;
	bh=nE/1oNd9kQaDsPO46DtCOMIjA5Lwh9TsvckbW8AW0ow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a2fAa1thJB3hKrYmYgN45jdbKlS2xR+QpY/s0Hs6aTVWrLFFhGGfRqVjbGHwGyRv8Xvp15Ux6H82bcsIaVRGLUibhqcF3Nsx2EKR0sV7KpiTBKBJ8sDHIzXCA3/jpwvWtyShfxjacOBotgUMXd23FwB+f9mif8inxoDjC1yIWZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D0VtnKEY; arc=none smtp.client-ip=95.215.58.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D0VtnKEY"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nE/1oNd9kQaDsPO46DtCOMIjA5Lwh9TsvckbW8AW0ow=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786583880; v=1; x=1787188680;
 b=D0VtnKEY8fLKdnfPKdllHQJyVbtvO2QxM2CmpqeL41MIGdCYsahM+fb31dMsR2aeI5qb0VO9
 9CQEmsDsXT3fxn9h9c/xUUcgxjzBulATYajSOkzsX7fY72s8dGUWWpexHdSfTfVqOLiuRBOIwgh
 Er/CoYq5IwIsHRQ50OIX0KVc=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [10.63.123.245] (14.29.108.90)
	by smtp.migadu.com with ESMTPS id d068e9a28b48e2fd;
	Thu, 13 Aug 2026 01:18:00 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <5f0e3361-b4e8-4979-9309-2d85e6a9dd54@linux.dev>
Date: Thu, 13 Aug 2026 09:17:52 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm, memcg: fix memory.peak reset clobbering other
 fds' watermark
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cui.tao@linux.dev,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
 <20260807090000.1532495-3-ridong.chen@linux.dev>
 <anyj4GGPnuU-q2AP@cmpxchg.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <anyj4GGPnuU-q2AP@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/13/2026 12:48 AM, Johannes Weiner wrote:
> On Fri, Aug 07, 2026 at 05:00:00PM +0800, Ridong wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Writing to memory.peak resets the peak for that fd only. Each fd is a
>> watcher and reads back max(its own value, the shared local_watermark).
>>
>> peak_write() resets by lowering local_watermark to the current usage.
>> To keep the other watchers' peaks it then walks the watcher list, but it
>> stores the current usage into them instead of the old watermark. So once
>> usage has dropped from a peak, a reset on one fd wrongly drags every
>> other fd's peak down too, even fds that never reset.
>>
>> Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
>> B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
>> collapses to 1060 KB although B never reset. With this patch B keeps
>> reading 410624 KB.
>>
>> Fix: save the old watermark before lowering it and use that to floor the
>> other watchers, so a reset only affects the fd that issued it.
>>
>> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   mm/memcontrol.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 2da55b778ae3..28577beeb3d0 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4746,7 +4746,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>>   			  loff_t off, struct page_counter *pc,
>>   			  struct list_head *watchers)
>>   {
>> -	unsigned long usage;
>> +	unsigned long usage, peer_watermark;
>>   	struct cgroup_of_peak *peer_ctx;
>>   	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
>>   	struct cgroup_of_peak *ofp = of_peak(of);
>> @@ -4754,11 +4754,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>>   	spin_lock(&memcg->peaks_lock);
>>   
>>   	usage = page_counter_read(pc);
>> +	peer_watermark = max(usage, READ_ONCE(pc->local_watermark));
>>   	WRITE_ONCE(pc->local_watermark, usage);
>>   
>>   	list_for_each_entry(peer_ctx, watchers, list)
>> -		if (usage > peer_ctx->value)
>> -			WRITE_ONCE(peer_ctx->value, usage);
>> +		if (peer_ctx != ofp && peer_watermark > peer_ctx->value)
>> +			WRITE_ONCE(peer_ctx->value, peer_watermark);
> 
> Sorry for letting your previous reply sit unanswered. You made a good
> point on the peer_watermark = max(usage, local_watermark) being
> pointless because that's how local_watermark moves to begin with.
> 
> So what you had before was indeed better. It was just me missing that
> detail. Could you please go back to your original? Feel free to
> include:
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Sure, thank you for your review.

-- 
Best regards
Ridong

