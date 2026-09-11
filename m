Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617D73B8D5C
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 11:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789126789; cv=none; b=A2qmlRv9i6QknTVTm9CG5emTZ8g6wFUG2KKN10Zs8ianpejW4QDmN/UHPE6SgRNIUHLksT4eftK6hFZpR6VoUDRyBu9IBbVV3G8MWjf2Han9Oa5Aurd0oOEXmS1OCN3KqvMO+5UNcfqSb22orKFAVbrXa21I/+E7XQZf3SCfbbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789126789; c=relaxed/simple;
	bh=Ok4+hD9azR+g5ojmlRz1kk1LD9HCDxdTr7YJJElV97I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rh4fsNZuH8f21+A3jUKTFEHHYazz/7IwMtKViKa1PNXtpmhzSJgdfK8uKQ7PhwqWHiVLQgaiqTd+jRXbrzGz6ju0VD/MQtk4a3IIRJRDjSklJYpVVWx6tv+YLU4/hPvpkBNWLF3RyN8rhfdS1y9qVvF7IRu7oCcZNfiAPPlQs1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NuoDIdSd; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NuoDIdSd"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-86265451beeso507755b3a.0
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 04:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789126786; x=1789731586; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oS5pCTFp0KI+iC50w7FkRnX3WOjbdZEE16QE70yFVGs=;
        b=NuoDIdSd41PIH4pKRL1Wfv3nssSMBFbWqkw9l/yIc7hfUlDZm1w5SehzQZLbUjyBji
         T/qFOgAIiBP9qr0aY52WKmamH/xXhhkH3CTfHkHQvVPXBN1irAnuCdWXVWL6c3EdF+/9
         RWM0sEicq6d2sk8q6JW+UuMSgxCp4uZtJMU+tx+aAwFwOxkaWQ3QKvi5H9MvgdPWb1A4
         cjGwZ9mZi/67PLcxoEdDhFn0hbt7/ba6NwkhNU2G1XWweCQHBjvFhbOl198SjOhuW6IZ
         VDOGrhE4Dm/oObRybLL1cJWHa7ukBmj3cFEHygMdSeRLLkhGnWFjSxOc9TROKIrUn1gH
         keDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789126786; x=1789731586;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oS5pCTFp0KI+iC50w7FkRnX3WOjbdZEE16QE70yFVGs=;
        b=TmBOC/f8Cj/yzbtsL+XlDoT3nf7seecAToPO71zBiVWiqryfSYcO2I0e1svBtbIBu5
         9KQ7OBUANi5rMYpitlzG/YqYUe5ueTymcrwuhx/+ZpDYz/OXqQH8SPRKnsN6GogZl65Q
         Jhf7cwX0O68PFe7PkuSQnnMcwEh/jqvDSHJni7Wdq32JAeCb/oshkJLP5PJye0+Tqg6d
         wvEFLizP65KT1LFvIqY3XNn9jZvsYOPLByWPnJ46ox7aVisca0lZ0FGXKN5KQ5tqLHLO
         uCwYRq18Bz033pdyN0/TYARQwQKU2roJQUaWZ4CKwHS0bFoi3r//I1SlBbCsXhJ5H2W9
         rkUw==
X-Forwarded-Encrypted: i=1; AKwUvBwbwEMhlx58BkRoIoAW8c/Cgr8CtTyX7ytw29BKgs4doiYpWzhkjynDDZzHUJu+anq2WPfQZAYu@vger.kernel.org
X-Gm-Message-State: AFuF++mYyGWzjAYNYSK6BWwwgoe+d7mHv9beF6m7yruhG/5rV+noPU3m
	SS1U80/ovDrZMhBQF9nKSMrXFi2q6NQWQp0npBrdVVF5Z9DZLBCo21acrg32jsB6y67W5b8FSdG
	zeLAfO3U=
X-Gm-Gg: AYBFou3UlDjG8s1ucWGnwQoPy5xO/N0P3M6auIt/wAlcHcZoXM03PuuZiczs41F2ydE
	Nr1uN40dy6Af1ko0aD+WQdEL3YwLXOB9k7oUCbFgKw0d7MgApJqXJ3qe24xfJsfWxgxCJpEVKKY
	tK8tZ6W4q9eJneyqGRPkxkMA4vULNXd6Z7J3eU5mdkfZPFvgOMYkVf8gi+TewoDoBGLwRMDcYa4
	CMC+hwYB9+JGCPdeW00aaFQEjH72wyWBWDGA1MVFUPcffjqdMP9Pl+aWC5LTp9etR33606zILjq
	iF03U+m30YQnFX2wNxo7jNgXjoZv0/bxuKSjZ++ZD/fy9diOIymUYi3OXAkAKG9G1DngpPieYOz
	FDxbvH7mfDrSExW/qaMEd9HZ1z3FGo90QYH+F4i8pZndhrNwIac1EBh74eNRhBTKETIXzyJJTR0
	WuyTgjL4CGBoRfin+hz1frbNWPyYiLhNVc8ARieMIKrBBwKZA9Ms2hQ+2v6URGBCA7ZIBmlH4A3
	96cnzkXYSL2Y3eeQqFMz57AyLol+34x7k9lu0tYLzQn
X-Received: by 2002:a05:6a00:4fcd:b0:864:cbc5:b8dc with SMTP id d2e1a72fcca58-86b2ecef9e2mr5888381b3a.10.1789126786110;
        Fri, 11 Sep 2026 04:39:46 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b286c4e5esm1038881b3a.19.2026.09.11.04.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 04:39:45 -0700 (PDT)
Message-ID: <db6d62f4-34f0-4237-ab58-c21b0968bee7@bytedance.com>
Date: Fri, 11 Sep 2026 19:39:42 +0800
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
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <ekylbhyzseq25nxq2yivmmdt5xl5glum5proueyd5mrqfux2y6@fpvflg4crr2i>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/11/26 7:20 PM, Jan Kara wrote:
> On Wed 09-09-26 21:18:11, Julian Sun wrote:
>> On Wed, Sep 9, 2026 at 7:13 PM Jan Kara <jack@suse.cz> wrote:
>>>
>>> On Wed 09-09-26 11:43:43, Julian Sun wrote:
>>>> The expectation in wbc_detach_inode() that "concurrent write sharing of an
>>>> inode is expected to be very rare" does not hold for bdev inodes. On ext4,
>>>> metadata from many memcgs shares the same bdev inode, so dirty throttling
>>>> in those memcgs can repeatedly trigger foreign flushes of the owner wb.
>>>> These flushes can also write ordinary file data, reducing overwrite
>>>> coalescing under continuous buffered overwrites. The resulting extra I/O
>>>> leaves less device bandwidth for other workloads.
>>>
>>> Hum. Are you aware of [1]? The guy is from the same company so I was
>>> assuming you two are working together on the problem :).
>>
>> Yes, Xin and I are on the same team, and we are looking at different
>> ways to mitigate this issue.
> 
> OK :).
> 
>> We will continue trying to gather more evidence from production to
>> better understand its actual impact. The number of calls to
>> `balance_dirty_pages()` and the time spent in it might be useful
>> metrics for this purpose.
>>
>> Jan, if we can show that this patch provides a measurable improvement
>> in production, would you consider accepting it? Or do you think we
>> should still look for a better approach? If you think there is a
>> better way to address this, we'd be very interested in your
>> suggestion.
> 
> I definitely acknowledge that there's a problem with foreign flushing due
> to bdev inodes that needs to be fixed because as Tejun wrote, bdev inodes
> break the fundamental assumptions of foreign flushes. But so far I haven't
> seen a solution which I'd definitely support.
> 
> Having data from production to understand what exactly is the practical
> problem will hopefully help us understand how the solution should look
> like. Is it just that we trigger too many flushes and that slows down
> things? Or is even one foreign flush of the whole wb due to bdev inode
> making performance bad? Is it that we have many foreign pages and foreign
> flushes fail to properly write them?  These are questions we need to answer
> to decide how the solution should look like. And the solution could be
> anything from just limiting number of foreign flushes for a wb to 1
> (because there really isn't big point in more of them being queued) to more
> involved foreign page tracking for bdev inodes so that flushes can be more
> targetted.

Hi Jan,

Thanks for your feedback.

All the foreign flushes we've observed were triggered by bdev inodes.
What we've observed is that the bdev inode has only around 10 MB of
dirty pages, but it triggers writeback of around 40 GB of dirty pages
across the entire wb. The actual foreign pages account for less than
10 MB, yet flushing them triggers writeback of the whole wb, and this
happens repeatedly.

This appears to cause significant write amplification.

Limiting foreign flushes to one may not be sufficient in this case,
since even a single flush can trigger a large amount of unnecessary
writeback. I'm currently working on tracking foreign inodes so that
foreign flushes can target those inodes specifically.

The impact on production workloads is not easy to measure directly,
which is another challenge we're facing. We've had reports of slow
dirty page writeback from production workloads. Although we haven't
established the full causal chain yet, we suspect foreign flushes may
be contributing to the problem.
> 
> 								Honza

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
