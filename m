Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF131DE4EF
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 04:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788322815; cv=none; b=dC87UB62wKxINz2G50tC2Kk242BBBHHB02OFPnQYSZGlKQG8qX+7u5nhUa081Yw2RgYiaXSY7RMN0Ajq/W6RZv1wzoHyh0zv+Pq5sJ7xFPGl4RKpGv/wu3xiEfTweLZreLxgOW8CAmrassu0FH3uSdDtGyD2D6TMv/dcEarNmMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788322815; c=relaxed/simple;
	bh=LsM/FoFkeFW5bWe+QSSiSF/yjfJXYslfexptiA0OssE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QzVrrAgpLDjror0cbugW+8OgJsOuJXrRdtkhOqz2gKxbTi8Y45gJW/80c/Q3JJ2mA2v0+/4GdCOLzeNsR4Tl5lSEGQUThs+tecZzVuXTnfnYdO9S03NZAwuGO4e4BurY7pwrZP+9x+IUW5lzfB7yZxgg7TXYT5cuKiK19I54qfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=hRH9ZLAS; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="hRH9ZLAS"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso900386a91.2
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 21:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788322812; x=1788927612; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7Vt2Ic8657HcteJslXznvT5iwAK2HkL400J7GxOIdrs=;
        b=hRH9ZLASFVT7SzSawIa22/wKtkJVK3e8xfX/GVnXsxjNmUth/VeId8eUaM6MfLDrIw
         BzbMYVw/qk2o2w5nAKnBS57cSmSLGoE8cMjxcb1BP71Ne6J6Cw+rYrOXOo/g50nVD0MJ
         YtWDB1ZUJEMOVIWlvdA7OBMx9qK3t/IzSICF6j75j+dLNpnn+dowPNZqS7/D+OeOTQsx
         +Y/rpriDCsareZk5F9Rxgcp9UKV7fdSKm+4x2BAN4rf+MMi8TO+3CU9eG9/E7oBqL4f0
         V04FMyuikWM3U5yaxD9Kdd0lwsJ4L1SZwlYjHfTkAPaocABDE/JHGtSRK1tFxYQ1m3Ce
         +tBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788322812; x=1788927612;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Vt2Ic8657HcteJslXznvT5iwAK2HkL400J7GxOIdrs=;
        b=UXeBPLKYptfjjlpAL/e+g/vBChVd83f/xF3u+ZBOm3ddki6Hfg1Uq68Vx1Sc0o/BkJ
         9MyQpskMIdA4dIKtuCVQxB6doMUPT+fRXySoaMnoUQ1S5eSK4mRrBAwjSaoR+vmkl4Up
         RDrV8PenOimdYTHw2k8gxuI10JvgQmUoDkfFY0IXaemXLFthJIPvoSn+eTKP+ZPl5xNX
         AAy/DCthd+07HOvemwPQO9fppemt0aiBibh+gYChD4Y+qRvJkd/2TXunEFqUya5VcY8J
         1xeqmOm8V5ue6JvIZJwkYu2DqDzxTAZhASyI+pqvh3DW5xz8RAlrDXwIqL30FfWVDKwa
         77LQ==
X-Forwarded-Encrypted: i=1; AKwUvBxxrQTRuS3yJdaowUdgkbkQ0KyY0HGMBQz5Z7gHdFG42G/oqtFSaD3aVlWMjQz1eQlRtImf2Fq7@vger.kernel.org
X-Gm-Message-State: AFuF++mh1xtCP3DbnzgiY4EFK829XtKSR3fyt81F6Ej3D3L41uIPnKpp
	RmSM6ZRbiT5r4yK+2DfNjy234cFk7Y3v0WL++a/B/24vjDMCW3JoMsEV5FwFt+dAC9Q=
X-Gm-Gg: AYBFou3ysrbOuufPC1iWFXIR/zJ1sdUFTsHRE0M8a45vnxEaXwG4gI/LAqQNwbhwx9F
	d2lZ+sL24V42BEKdyVkn1veYqiRYXiPiQ66kj3/CRHnK21nCQG3unYYYHtIbZc6hL3jan95tR8W
	78U/J9x1KAw3FxVFSNYDLtrF+iH/ozDB+SAV/5GYVHaWGXY50vH8etVHhjjWzwJgd2R4T/onsf/
	hwEKlSArGdwGWky/4irgwx1zDhLDPW82HImCOGRaAdhZw0xUWdOevUt2Pgxol15ezLHiA+aHTKp
	bOpxvGVXdZigwNGkwwOpG3dmIRW3XPfLu0yJNAQa0ROfXRBKhkN7N9RbBKaN4iXDr4f4OtCaNuz
	Pd/gbALhK8vMBnh2ZXTQipQpvNLG3FwbfA5sV4Ho3VdmlITf4fhOiE9ho0VHcm0ufmHABgiA/Lc
	sDYR6VIAFyO9jMy6UFpqjd+kyo3x68sXwutoSoIbLq9Pwdf8+3T46pHJtpTEJde5WrN4Sh4Ms2u
	FH63R6n0SqNwZEwbspDkpkZnAMBYo6xPg==
X-Received: by 2002:a17:90b:4fc5:b0:38e:49c0:75a7 with SMTP id 98e67ed59e1d1-39aedfe18c0mr3175817a91.8.1788322812091;
        Tue, 01 Sep 2026 21:20:12 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.56])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d76463csm9067914a91.9.2026.09.01.21.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 21:20:11 -0700 (PDT)
Message-ID: <0103ea4f-914c-476b-82e8-c670701a5578@bytedance.com>
Date: Wed, 2 Sep 2026 12:20:07 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] writeback, memcg: skip foreign dirty tracking for bdev
 inodes
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk,
 tj@kernel.org
References: <20260901131028.1120284-1-sunjunchao@bytedance.com>
 <b4yiuuthnjfgoc2djz5cju3jahstzwizqyaqxo5dd3qijmsww7@66sink2shhwu>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <b4yiuuthnjfgoc2djz5cju3jahstzwizqyaqxo5dd3qijmsww7@66sink2shhwu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 10:44 PM, Jan Kara wrote:

Hi Jan,

Thanks for the review.
> On Tue 01-09-26 21:10:28, Julian Sun wrote:
>> Foreign dirty flushing handles cases where a dirtied folio's memcg and
>> the memcg owning its inode wb differ.
>>
>> wbc_detach_inode() notes that "concurrent write sharing of an inode is
>> expected to be very rare". This expectation does not hold for bdev inodes.
>> A bdev inode and mapping are shared by buffered users of the block device,
>> while the inode has a single wb owner. On ext4, buffer-cache folios used
>> by metadata and journal I/O can therefore be charged to different memcgs
>> while sharing the same mapping. Normal bdev activity can thus produce
>> frequent folio/wb ownership mismatches.
>>
>> This was reproduced on cgroup v2 with the memory and I/O controllers
>> enabled, using ext4 on a loop device. jbd2 repeatedly generated
>> track_foreign_dirty events for bdev folios charged to unrelated memcgs.
>> When one of those memcgs entered dirty throttling, the resulting record led
>> to a flush_foreign event and queued writeback with reason=foreign_flush for
>> the bdev inode's root wb.
>>
>> Skip foreign dirty tracking when the folio mapping's host inode is on the
>> blockdev pseudo superblock. This prevents bdev-originated records from
>> triggering later foreign flushes.
> 
> I suppose the real downside of foreign flushes is ultimately reduced
> performance?

Yes, reduced writeback performance is the downside we are concerned 
about. We suspect that foreign flushes contribute to the writeback 
hungtasks observed in production, but cannot establish causality yet.

We have two production cohorts using cgroup v2, based on 5.4 and 5.15. 
Foreign-flush and writeback stalls occur much more frequently with 5.15, 
even though the core foreign-flush mechanism appears unchanged.

Our production observations show 102 queued foreign-flush works, 101 
targeting the same wb, while the owner wb has a continuously replenished 
dirty backlog. These flushes can therefore consume writeback bandwidth 
and delay other writeback work. Regardless of whether they are a cause 
or a consequence of the stalls, a bdev inode generating this many 
foreign flushes is unexpected.

> 
>> The tradeoff is that dirty throttling in the folio's memcg no longer uses
>> bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
>> folios remain subject to normal writeback. This is preferable because a
>> single bdev wb owner does not identify which cgroup is responsible for a
>> mapping shared by buffered bdev users. Flushing it can write back data
>> unrelated to the throttled memcg. Dirty accounting, normal writeback, and
>> foreign dirty tracking for non-bdev inodes remain unchanged.
>>
>> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
>> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> 
> To me this looks as a sensible workaround but I'd be a bit worried whether
> a memcg that dirties a significant amount of bdev folios (compared to its
> dirty limit) cannot be blocked in dirty throttling due to this - as the
> comment above mem_cgroup_track_foreign_dirty_slowpath() describes. I'd
> defer to Tejun to judge if can be severe enough. But I think if we go this
> path, the added condition should have at least a short comment like:
> 
> 	/*
> 	 * Bdev inodes are usually shared by many memcgs so foreign
> 	 * tracking leads to frequent flushes which is counterproductive.
> 	 */
> 
> because otherwise this condition really makes you wonder what is going on.
>

I will add the suggested comment and send patch v2.

> 								Honza
>> ---
>>   mm/memcontrol.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1271d390b617..5d7320f76c06 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3898,6 +3898,11 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>>   	u64 oldest_at = now;
>>   	int oldest = -1;
>>   	int i;
>> +	struct address_space *mapping = folio_mapping(folio);
>> +	struct inode *bdev_inode = mapping ? mapping->host : NULL;
>> +
>> +	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
>> +		return;
>>   
>>   	trace_track_foreign_dirty(folio, wb);
>>   
>> -- 
>> 2.39.5
>>

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
