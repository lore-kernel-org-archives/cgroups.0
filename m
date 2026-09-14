Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1E23101A7
	for <cgroups@vger.kernel.org>; Mon, 14 Sep 2026 02:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789352318; cv=none; b=K+Aig7+kQs96xJAML7KNywGimJN0NlyCLx1WP5BpYTlOpEpUElVv7i5AuHYjJNBRysbv1LPXS3lJSMbiZXwUJVkLQNjKUkuFrQmmkpDBJOVNfWZ0UHgfDgpShQl0sfdcnN0jo3Ohkoyqbbfx9QRFRv+gdVrPHpzSJLOqv/WYFSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789352318; c=relaxed/simple;
	bh=pZGDrroNHqjdFZupRzGuVRROHlFvliLkvG4+Plg0fdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lbdszdZ9e3OfWWJefN6Z5ng4UrQvdeMeyCv3TPncvCg7EOht/DWVNyMVKd+K7bbH9DUoz7U1ZMGHoKIEvmo+EZggl9aRMOugpN52lALdZtgJt+VwkkRFDLjV2XzaKN/NgaTXKVmTFe4s7pyWVkNQTPuGxRYXs7us287yWSjEbWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Q392KOCo; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Q392KOCo"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-853f8c34ba4so3756854b3a.0
        for <cgroups@vger.kernel.org>; Sun, 13 Sep 2026 19:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789352314; x=1789957114; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DxBEauNnCmvuxYQWGMnLgbbVInndKO4lO+HSKGFpeVU=;
        b=Q392KOCoJRUrGLcdxPCt1OpEPiHzU1w3EdPxu+KLQEK4Oce9o2/EGndlVgR6I3n3ZC
         iebcnhyNE/JplxLfu3PlTgs8SAQHKD3aY+2mlBBPNNPmRIgixkyvDn5s38qk2NoWtKJu
         fDMkD1e2vWlQTPS70+m4/aAlHjPqM7wS7cOJXhAL+iLDd6iT1v3AACyU9Sh0Nh7VxLSp
         7UuDqpjps2vcQNOWCeVn2r7tUzNJGwDiwOTATYqWqb/stipcL3aNF+jK1/uQAAHqBcn4
         yYrG28A7M43VV+pGR8ZLazVwaDsehbSpzGL+c2lifUJIYiJVCcC9jse/Rsy6LCB5p7Xv
         fDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789352314; x=1789957114;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DxBEauNnCmvuxYQWGMnLgbbVInndKO4lO+HSKGFpeVU=;
        b=VauqHycfVzsldjSOCxygLsgYSWPhJ7js9vwLg+RIOXwQdSBaVczU27w6WmYCpGqO9H
         qF+C8KsE99Do9YLlaah20d6mx/+tFjD83lMR3gd1n6JwykTYAFPFW2KYtAjxzD0mP3ut
         1aoMdV/+d3lL5STGP0J7jif9JeJnovje26UMu2VaAx4V6PkcpMk4IN8LeCeanK4KOYVu
         lhgCSnzfdKt26uLqxtWiFqvFGouexHlkFpChUSeiH+D8ImAvqRJSM5jNxQnT4rp/BD3U
         Fp2iFfPwZGordRE/WA9Ef591LaW9gi50Oi84sKIGz3v869kiWVuMRgsze8xHhqHGuCdS
         LNfw==
X-Forwarded-Encrypted: i=1; AKwUvBwQ3Yzd5IFB4yZ1k6AK9LcXGz+yp6/95Uh4XwaYeQSum+ujCtI+M//YdLH8B4SuDfwZDnhqxUKZ@vger.kernel.org
X-Gm-Message-State: AFuF++nwTnRfbjVcQboHmuIBUQGcDHXuw9lf/RKQwxd5BtSsx7DiPO3d
	Rv9pqnQ8BuzVYjlULkLWrlAUubbqie55SXPzp0oGy/G6oOb7HOS4g8Piiiao1+5tsbg=
X-Gm-Gg: AYBFou2xVfXoT+dlGj0d5odzOISWM6GzRc9ZoXodNutzpjck8xT6LJ0l38vywmbA7am
	h6oAbZ/ewTXAXQYQ0qZPjQmye6M5drZlYkMEVi1pl1JxZpM8KXDMPyy9ISBhDl55sKQH7ZrZOWG
	DMrNUFHFvcEVTyZmco7DTbQVK0Kyhn7TA8wcXGA8gQwtFK+7C+lntadl22CkFNZrXn+DSOKWB4b
	AvERjF/sW4BSOgDT/rBzRZJ6VFxM/Q55UWx8yfqV0l1TqFlmUqm8YIQQjQ9CCWGNIDfXuVUMpIT
	iPwex4+P9AWiFZu0HPvwiS3gEV4BTcN7xlPYJW4gSf6psTZHZPtmfiaNKbeUFnyQumNBRmpCFPL
	wYd7/5Qy9TRDLza+7/Cdb3Quuo1LJqtYlxXuv7Jd+0S1G7X3XMOy9791c6mPb3vUWLi1mLoJCSD
	YGbL5UDG2+XiCykkGpEcKuka9K+dUKHS1Q+UUM5gxkP90aOEjI+/PcliWrNOJjJ+S0QphJ1Tq+B
	fCWe1w4zgSWVMK99+POPUx3MIH3t7yZ9MnP3zvMvZ8=
X-Received: by 2002:a05:6a00:950b:b0:851:d12e:389b with SMTP id d2e1a72fcca58-86f854fa179mr1418104b3a.14.1789352313961;
        Sun, 13 Sep 2026 19:18:33 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b291c06e0sm3752158b3a.28.2026.09.13.19.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 19:18:33 -0700 (PDT)
Message-ID: <e55a7422-1871-4a03-80bd-09cedf9630dd@bytedance.com>
Date: Mon, 14 Sep 2026 10:18:29 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] writeback, memcg: skip foreign dirty tracking for bdev
 inodes
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk,
 tj@kernel.org
References: <20260909034343.340703-1-sunjunchao@bytedance.com>
 <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
 <CAHSKhtcvaWgGHY_NWW242vYHHiSet0v-qsj4MsXGiwZJFrdUnQ@mail.gmail.com>
 <ekylbhyzseq25nxq2yivmmdt5xl5glum5proueyd5mrqfux2y6@fpvflg4crr2i>
 <db6d62f4-34f0-4237-ab58-c21b0968bee7@bytedance.com>
 <l2awpukcp7lorvujvwdoqnlwlkkjl6e2kef6tnjvdw7qve2fni@vh4lspozoytt>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <l2awpukcp7lorvujvwdoqnlwlkkjl6e2kef6tnjvdw7qve2fni@vh4lspozoytt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/11/26 11:39 PM, Jan Kara wrote:
> On Fri 11-09-26 19:39:42, Julian Sun wrote:
>> On 9/11/26 7:20 PM, Jan Kara wrote:
>>> On Wed 09-09-26 21:18:11, Julian Sun wrote:
>>>> On Wed, Sep 9, 2026 at 7:13 PM Jan Kara <jack@suse.cz> wrote:
>>>>>
>>>>> On Wed 09-09-26 11:43:43, Julian Sun wrote:
>>>>>> The expectation in wbc_detach_inode() that "concurrent write sharing of an
>>>>>> inode is expected to be very rare" does not hold for bdev inodes. On ext4,
>>>>>> metadata from many memcgs shares the same bdev inode, so dirty throttling
>>>>>> in those memcgs can repeatedly trigger foreign flushes of the owner wb.
>>>>>> These flushes can also write ordinary file data, reducing overwrite
>>>>>> coalescing under continuous buffered overwrites. The resulting extra I/O
>>>>>> leaves less device bandwidth for other workloads.
>>>>>
>>>>> Hum. Are you aware of [1]? The guy is from the same company so I was
>>>>> assuming you two are working together on the problem :).
>>>>
>>>> Yes, Xin and I are on the same team, and we are looking at different
>>>> ways to mitigate this issue.
>>>
>>> OK :).
>>>
>>>> We will continue trying to gather more evidence from production to
>>>> better understand its actual impact. The number of calls to
>>>> `balance_dirty_pages()` and the time spent in it might be useful
>>>> metrics for this purpose.
>>>>
>>>> Jan, if we can show that this patch provides a measurable improvement
>>>> in production, would you consider accepting it? Or do you think we
>>>> should still look for a better approach? If you think there is a
>>>> better way to address this, we'd be very interested in your
>>>> suggestion.
>>>
>>> I definitely acknowledge that there's a problem with foreign flushing due
>>> to bdev inodes that needs to be fixed because as Tejun wrote, bdev inodes
>>> break the fundamental assumptions of foreign flushes. But so far I haven't
>>> seen a solution which I'd definitely support.
>>>
>>> Having data from production to understand what exactly is the practical
>>> problem will hopefully help us understand how the solution should look
>>> like. Is it just that we trigger too many flushes and that slows down
>>> things? Or is even one foreign flush of the whole wb due to bdev inode
>>> making performance bad? Is it that we have many foreign pages and foreign
>>> flushes fail to properly write them?  These are questions we need to answer
>>> to decide how the solution should look like. And the solution could be
>>> anything from just limiting number of foreign flushes for a wb to 1
>>> (because there really isn't big point in more of them being queued) to more
>>> involved foreign page tracking for bdev inodes so that flushes can be more
>>> targetted.
>>
>> Hi Jan,
>>
>> Thanks for your feedback.
>>
>> All the foreign flushes we've observed were triggered by bdev inodes.
>> What we've observed is that the bdev inode has only around 10 MB of
>> dirty pages, but it triggers writeback of around 40 GB of dirty pages
>> across the entire wb. The actual foreign pages account for less than
>> 10 MB, yet flushing them triggers writeback of the whole wb, and this
>> happens repeatedly.
>>
>> This appears to cause significant write amplification.
>>
>> Limiting foreign flushes to one may not be sufficient in this case,
>> since even a single flush can trigger a large amount of unnecessary
>> writeback. I'm currently working on tracking foreign inodes so that
>> foreign flushes can target those inodes specifically.
> 
> OK, good, these are already some tangible data to use :). So in that case
> I'd maybe just:
> 
> 1) Avoid adding 'wb' as foreign just because it owns bdev inode where we
> are dirtying a page.
> 2) Track that we have some foreign pages in this particular bdev inode.
> 3) In balance dirty pages queue flushes of bdev inodes where we have
> foreign pages (besides queueing standard foreign flushes).
> 
> I didn't put too much thought into how to integrate this in an elegant way
> with the current writeback infrastructure but something like this shouldn't
> be that hard and it should help you with the foreign flush issues you
> observe.
> 
>> The impact on production workloads is not easy to measure directly,
>> which is another challenge we're facing. We've had reports of slow
>> dirty page writeback from production workloads. Although we haven't
>> established the full causal chain yet, we suspect foreign flushes may
>> be contributing to the problem.

Jan, thanks for the suggestion. This approach makes more sense.
I'll implement it and send a patch after testing.
> 
> Just being able to measure that "with these patches we don't need to flush
> 40GB of unrelated data in foreign flushes in our production workloads" is
> enough to convince me they bring some tangible benefit for your workload
> :).
> 
> 								Honza

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
