Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5504C97
	for <cgroups@vger.kernel.org>; Fri, 31 Jul 2026 01:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785462400; cv=none; b=l41Xr5Jvk1TdJAOe8bfJEFLc25gpfc3T5fIycC6Kf3KeVdq4fZbd9j5tNPd/GOAEg3q0WPUVoOOCmaqIMJAptYw9RS4MCI/21zBEjjtivrIstXIMKQLim6ukUg4paO4cxKxsWrp2eyWWtCXrbSlbL918LfxnfaMdj5U0fBfuPwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785462400; c=relaxed/simple;
	bh=d7wDrgq5/SQzvRHR2hZLOz2rVDC43+bvaUYIDszxqVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gab2EllFM8YtfRaSZbxU2xh/2EwXCf+awosyAPTZ9l/emZoAlinPnWF8jgwtjSVCVWmvimcrE7GhMEwjzbwR/wBiKg1BEOePC6HySmE8yedTjtwk+JpTwiyzbvGZRTpr07fmwcW0fo7g+owF65lwmz4yPvn7yYQLvYokURPuaUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V65hgF+X; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V65hgF+X"
Message-ID: <d0fa85a4-53bd-4af9-b275-856ca073bc96@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785462395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dO3PkdIRMlkezl62as+Q47Bf7B4brhEm4xLqBToECdg=;
	b=V65hgF+XXbx2tPBla+Wuz8xT9Y54R7Zr/SDapDPrGfg0JMMAg+szspXIoIhsNQMdGmEuEy
	TyvjspXsx/f0HdoLsZZ5XwcwHi9XfjLXcxZ/fIXGgSVGSHKizWRaUTrmA7BnlLZoE7h76o
	45W2UH6GaTcN/VDi96TczreZcCScRuI=
Date: Fri, 31 Jul 2026 09:46:27 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] mm, memcg: fix memory.peak reset clobbering other fds'
 watermark
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Finkel <davidf@vimeo.com>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tejun Heo
 <tj@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260730115314.1069089-1-ridong.chen@linux.dev>
 <amt140aXu5tYZxln@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <amt140aXu5tYZxln@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 7/31/2026 12:03 AM, Johannes Weiner wrote:
> On Thu, Jul 30, 2026 at 07:53:14PM +0800, Ridong wrote:
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
>> index 60145aadfc5e..881e7c459c64 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4692,7 +4692,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>>   			  loff_t off, struct page_counter *pc,
>>   			  struct list_head *watchers)
>>   {
>> -	unsigned long usage;
>> +	unsigned long usage, old_watermark;
>>   	struct cgroup_of_peak *peer_ctx;
>>   	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
>>   	struct cgroup_of_peak *ofp = of_peak(of);
>> @@ -4700,11 +4700,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>>   	spin_lock(&memcg->peaks_lock);
>>   
>>   	usage = page_counter_read(pc);
>> +	old_watermark = READ_ONCE(pc->local_watermark);
>>   	WRITE_ONCE(pc->local_watermark, usage);
>>   
>>   	list_for_each_entry(peer_ctx, watchers, list)
>> -		if (usage > peer_ctx->value)
>> -			WRITE_ONCE(peer_ctx->value, usage);
>> +		if (peer_ctx != ofp && old_watermark > peer_ctx->value)
>> +			WRITE_ONCE(peer_ctx->value, old_watermark);
> 

Hi Johannes,

Thank you for your reply.

> Ah, because B was previously reporting the higher local_watermark, and
> its peer_ctx->value was actually low. Fixing it to current usage is
> wrong in that case. It must remember local_watermark.
> 
> What about if usage is bigger than old_watermark? Then we don't update
> the peer_ctx just yet. local_watermark is updated and propagated into
> the peers on the next reset. I guess it's correct, but it's kind of
> tricky to follow.
> 

IIUC, usage > old_watermark shouldn't actually happen, because local_watermark 
is a running peak maintained by the charge path:

page_counter_charge() {
[...]
	if (new > READ_ONCE(c->local_watermark))
		WRITE_ONCE(c->local_watermark, new);
[...]
}

> Would it be easier to understand if we mirrored the max() from
> peak_show() here?
> 
> 	usage = page_counter_read(pc);
> 	local_watermark = READ_ONCE(pc->local_watermark);
> 	WRITE_ONCE(pc->local_watermark, usage);
> 
> 	peer_watermark = max(usage, local_watermark);

In peak_show() the max we have is:
	peak = max(fd_peak, local_watermark);

I'd like to clarify that fd_peak here is a different thing from usage. fd_peak 
is the peak recorded by this fd (ofp->value), not the current usage. So 
max(usage, local_watermark) isn't really mirroring the max() in peak_show(). 
it's a different expression.

> 	list_for_each_entry(...)
> 		if (peer_ctx != ofp && peer_watermark > peer_ctx->value)
> 			WRITE_ONCE(peer_ctx->value, peer_watermark);
> 
> This code hurts my head. No strong feelings either way ;)

-- 
Best regards
Ridong

