Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B84377A8E
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 04:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788496474; cv=none; b=DqsaFl3xRs27RYIH385pl5X4NIBbejA3k1HlEQ6m+FAoRXJzNrnzf0s8iuQlgwHhWt+JiKrBtMMG1f7hZlCN0P21MllExcdCG7gOm+7AGmBtnG523h3uYSTsHphegogYqARa8DHtqagkPBAd0QhPKikPkIodG5qaPhqL4HRo1c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788496474; c=relaxed/simple;
	bh=6YY5MbHewiEFIFU66oLo9CdU637qXi7FvDB4diC+J4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VgYsOO/U2DxolX3Rj3VMxAez70JumivR1OL3Ukx84CtAFIkKghFVYgPYM08dO3rbkXG0U0i/FdiPGlnMvOTJhTApDZUBzcxygKZBEXCIkRZtjVcEOl5pXqUQ3dot24WPC5rRG44vCp+EmakK10qZCAOLYjbsxabdw/xfqMI7G38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=ByXIsAwt; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="ByXIsAwt"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ce98cb8165so6677095ad.1
        for <cgroups@vger.kernel.org>; Thu, 03 Sep 2026 21:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788496472; x=1789101272; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eSlhukOAEBzhTTxKjuHTEkWF5Nd7WBqUfZbcICKKwNo=;
        b=ByXIsAwtzNvbtAuFZRTTWa1AeJbg/f2xSSBPgixtneifiT5OvzmWfXz2XYDsPezsRr
         xAZtR4enm7EY/hcx75wnaA33voytxE5N3UHyYQV8EnJhNYTSVPyIloPruTPchs9TGe1L
         QUBcirBsCs7pdiICha1lvuV+wPpliCwRMwYhDzyjxpU7/kloy9YO3qvLVxxTEdPu1STS
         CCEMAqsdRwnaPSbyAI/hNZaYj9e/XyW26XG2/t8S8B21xqP1EDVo6dUADjRGdEi3HrDZ
         gNQx8wmb/z5mAt6prjPKA5qNYjMw181RcXLxAfozQ0Ws+NxBiv7ucYI+H+YoGnr9qIUc
         xySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788496472; x=1789101272;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eSlhukOAEBzhTTxKjuHTEkWF5Nd7WBqUfZbcICKKwNo=;
        b=Rh/5gQ2gPem+5dIx13sjHOBwqpWgWPkgnkLMaCNpxI8BnDZ3SjNZhEGZz0WH4u7SWe
         FHCFQtpEU15DmhLcRMy85FS9cQ0V/wp/X3nFydF516MJXSZWyHEoGkgXErCh0aU3Ldcd
         MAmBq8Cpje1glu2Az/zE4X1ndsxyGAkSmvsIIL6u/Tcp/mpzajz6/DmGGWKLVH8M3U0q
         3UrjCpAP7sFFT1ATXLmc32QPpdPV04ym6rtjQ8ahGUqQ57cYAdF/2vsLUL5P/h1lQakk
         JIH+YCXcgCcSZ7qXj1C3G9IQJ6RSKrdCH+O5B08rllfUNLrGejVTEVAy4IZ3/QyxwUtJ
         BxUw==
X-Forwarded-Encrypted: i=1; AKwUvBxtyDObj8PATHG/tnEo0zvnllj3mb8zp0SdfxTEehoUVqGNkpj4KKMPTdPUV2cXvilWE+sw9hrG@vger.kernel.org
X-Gm-Message-State: AFuF++m+j24X4BRorQq1XdoGgdbniMLZPPMIhPLNo4dFUS6EcQAUoRXV
	WUOF6ILu5j7yIu8edBQFmQIViIUORJzfLsAyFi5YDR4XV3WUv7zI/LluHddvDy8V5ms=
X-Gm-Gg: AYBFou11alsnC0UTx7vRVYmucXhFdc2hJJUwi/UA2eaoV70ePwT/EIULeiDQN1Uu+5A
	jXlryJjxRNBc3AqIAdVGZ2ZHKC3ecjJfFa5IdK9moM06gRoeTDeTYWSLG05UaI/4JvU7KgB1If4
	qOubSIVghBQjTpMK5tkQezF6UmalKKAH36Ep/34KB3P84HPNqTvNPp7C0SX8Db7i6fu2lPFMAzZ
	6E2EI7ad6/K4Lb2VBGCyOgvR/sQ0L9rW00CmWnXumr8nZSmopL6LytzCe7WOZ8Z5ISPqhoXUsOU
	0OGrJ1BHALHZH/WB2Yz/HqU2jnqhipqD+eyibtUV86mSp7YEAdvBfPaiQvv4sArz8sKfLEUykTZ
	vFnSSDHy02DfioRLS/nNbAj2Fm+TGO8yFe1faTGxef1WTHZDVLBw8UBpwmcrv7hJ04CRwshIcDh
	rLQSchmSbkWQImL5/NZWbMU4J5F4YeFsl5gn0TTLIzOIpEQ0CVf8xVFjTuab5tCY2plBwUdSQxh
	VwiHjavuepTplFgsFFYT9pR4Kk5vzoU
X-Received: by 2002:a17:903:32d1:b0:2db:18e7:e5db with SMTP id d9443c01a7336-2db18e7fa12mr13335245ad.12.1788496472116;
        Thu, 03 Sep 2026 21:34:32 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1497d455sm4363415ad.30.2026.09.03.21.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 21:34:31 -0700 (PDT)
Message-ID: <3a7ca3ba-d2e6-40a1-95b2-4d0ee93d4242@bytedance.com>
Date: Fri, 4 Sep 2026 12:34:27 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH v2] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
To: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk,
 jack@suse.cz
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
 <apnYouiUINQR-98e@slm.duckdns.org>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <apnYouiUINQR-98e@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/26 4:29 AM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Sep 03, 2026 at 04:33:03PM +0800, Julian Sun wrote:
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
> 
> Was this reproduced from an actual workload with adverse effects? If so, can
> you please explain the workload and effects with concrete details?

Yes, this can be reproduced on many production machines. On one 
production machine, we observed 102 wb works with 
WB_REASON_FOREIGN_FLUSH as their reason, 101 of which belonged to the 
same wb. This wb was the owner of the bdev inode, and dirty pages were 
continuously being generated for it.

The logic here is that, Once a memcg has recorded the owner wb of a bdev 
inode as foreign, any task in that memcg that reaches the throttling 
path in balance_dirty_pages() may queue one WB_REASON_FOREIGN_FLUSH work 
item for each recently recorded foreign wb, up to four in total, without 
checking whether those target wbs caused the current dirty throttling.

On this machine, the total nr_pages of the foreign-flush works was 
630,681,285, or about 2.4 TiB, while the machine had only 400 GiB of 
memory. Although nr_pages does not represent the number of dirty pages 
that will ultimately be written back, the actual number of pages written 
back may still be very large because the corresponding wb was 
continuously accumulating dirty pages.

> 
>> Skip foreign dirty tracking when the folio mapping's host inode is on the
>> blockdev pseudo superblock. This prevents bdev-originated records from
>> triggering later foreign flushes.
> 
> If you do this, tho, that means now cgroups that accumulated a lot of
> metadata writes on ext4 and crunched for memory don't have a way to relieve
> the pressure outside of periodic or other lucky flushes. ie. I have a hard
> time judging whether this is net plus or not without learning more about how
> this patch came to be.

How about this approach? Before queuing a WB_REASON_FOREIGN_FLUSH work 
item, check the target wb and avoid queuing another one if it already 
has an unfinished WB_REASON_FOREIGN_FLUSH work item.

This approach can eliminate a large number of duplicate foreign flushes, 
but one issue remains: a memcg may dirty only a small number of pages in 
a bdev inode, and when that memcg enters dirty throttling, the 
throttling may be completely unrelated to the wb that owns the bdev 
inode, yet a foreign flush is still queued to that wb. This problem 
becomes more pronounced when the wb has a large number of dirty pages. 
Perhaps we should track the number of foreign pages in the memcg and 
avoid issuing a foreign flush when the number is below a certain 
percentage?

> 
> Thanks.
> 

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
