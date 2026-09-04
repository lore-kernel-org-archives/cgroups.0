Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E300D3C8C52
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 03:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788493170; cv=none; b=RFFxvj0RZeStdBXUFjAFAGNttZqBf2efEg+0qP3YLmrlRy2X1ncl24oIAWYdpsHHVInFmm9PD59xCMygyROs9zPOrtSeRLzU+QuCzsVB0NYW4IEK78VoVoVZFLIaXZs35+QIYPX6XX93wRWYVQgauGrMPBtSN4XlUh4fMZuU5RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788493170; c=relaxed/simple;
	bh=kbovyl4Vfr8x0hrjmJfY6gc8DerMZtsDrvaE9mw6ogo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OHLGaNmLigLO/oX28EyhbMKPqOsM6ZVR+3/8jPyabiBK5aObbyjwEsNmn0bdJ9htuzdR9MgQJCobDFg1dYIyUWBSOwN6iXwTIWd83XE5XzuPd2FoIK2Prb9ZmYahScZgRx/X9gMaiE0wNeHLBUnM5VK0umJ/ru8OjdjlC5sF4Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NdnGlUzx; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NdnGlUzx"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8568e3ed034so411823b3a.0
        for <cgroups@vger.kernel.org>; Thu, 03 Sep 2026 20:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788493168; x=1789097968; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MNwQxIddTEnFNFTYEgM9wD4+3ebO+BflR2FwcYl3w2A=;
        b=NdnGlUzx1tTXMGFXWIVewd7m+BuWgASw6QRxbiA6AF8ItUcqN8EtLHlzwCkN7d0weR
         ehYhGJ7O+53Qc80q3ZYnbGV1M3nMhvmGELQPlFYIgTP5RYnY6c7QzobpySuIxOlWJQZb
         1qauGIVBvslLuABwAWYa5Ok4areyBKXNq2i3PBQJWUjHsecIfEinxCTGjUTqAqSjbJH+
         bMEyooxrTOIW8QpbSebevWIyqQvk6MO4h1UtPmmqJDj3fF5PBP2RyqEaGUWmqQ9OEj5Z
         ZZLkVdkL8bMyT2S1ctfHTanhy/TuZECvsSgfUfdoT4Vbzi1apoCJ4FRSkd4eGP0B1Wlx
         56AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788493168; x=1789097968;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MNwQxIddTEnFNFTYEgM9wD4+3ebO+BflR2FwcYl3w2A=;
        b=k+lvahaAIbRukcX/x5tS9h9cFPOi6P2IuHcVLRL39YBjYcO0QPCouqaIPJXh0M5rDP
         fgH4vw472XxAnHK31Ni2rk90HTkS64ozALcEX1tovDhpy+sNita/U1+wlnP3pJ+zlhN+
         3SqlitO1Kkt+MHVlnleewp/TlbUDmSosJ2wbFmRX09q49wzdflMEo3003foSlb96f6dM
         4ZddQGDyLisW+5ic47p66sSbFe68QIR0rJp9/mSPNCxdj4/dzul8Ki2cWtQTw9kz54FO
         R6i5foREYEokNXipm3m0G8LOelMgHfyKrCaAzk1xvFfRFLW3O8pzD7SeQNJxydGawGFK
         34rA==
X-Forwarded-Encrypted: i=1; AKwUvBy5Ff+dAr5EsxrEQn8Yy6qo7firKmSn7nLGCVtTjaoSoOSKaerwHuEc6F7eaw0CY8BaYng7ycGH@vger.kernel.org
X-Gm-Message-State: AFuF++mWdq3OMLGzgF7ItYdQhq7yWTsyWjjFeNIby8yuiEJBMmZ/ygGP
	fuvZaLdfHYUgNQ+okOk4vqCyMNgvdxxPsfjWSYT9sCPe2qdo9OQkExXgXPX3JvR152SHPjTmLDk
	xk6L01G4=
X-Gm-Gg: AYBFou2CHIS2+Cj+rp/2Fzo8RlzEd7lLePJO/5jLHM7joolPIgs3B3Cu8wZK4Vd6pUD
	AMY4I4Nka1VWJArku2w6+Y8q7UtqyV84KQ3xpbXD6FWef8OLOtfeGLvJODzQrf34Q6EZIR8yIqB
	Wp6OzSCup2Bq6xhvjmFmcQV86bv/lrVCiSgFl5vfOXZk6BZiptIBSejhZx5yTXg9nrD8stb5DWL
	HlUiREf0J7LcEePNpb91vXtoEDhWfVRGeoUrnwVzievM4FtMQGLlUorLcTM7a5f4nF/eJlUnwJh
	4H5+kNBaGl03BdYE34l6nqZ4RRhavDnpjHOSyiCh1YH2507UmM4H/PXgGhWiG9T3bl+xD6ceZWS
	/tr/KuTBA5bwyOSfjC+4Cn1OVft7w8MRXvhQ3k6PZT7fpNfTUJBAl/vxbK2v47THbhEELDCRyk5
	ozlpnwFm0WYN3+8m2PG3Tp+XxbEDsuzb5JnHpRd+iW6YOLP/PPtozoGCfKIkJIj27SkCMAfCePN
	MiUtYhl80sm4MPe2B1WMe5d6ea5O5qy
X-Received: by 2002:a05:6a00:8016:b0:857:74ae:ad76 with SMTP id d2e1a72fcca58-8616b46b125mr5070023b3a.26.1788493167991;
        Thu, 03 Sep 2026 20:39:27 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152e39a38sm603701b3a.39.2026.09.03.20.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 20:39:27 -0700 (PDT)
Message-ID: <5f34e3e1-749e-44d1-b3e7-50e11f7240e3@bytedance.com>
Date: Fri, 4 Sep 2026 11:39:23 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH v2] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, axboe@kernel.dk, tj@kernel.org, jack@suse.cz
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
 <20260903123427.eb0beab18ff68d4632aece6c@linux-foundation.org>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <20260903123427.eb0beab18ff68d4632aece6c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/26 3:34 AM, Andrew Morton wrote:
> On Thu,  3 Sep 2026 16:33:03 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:
> 
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
>>
>> The tradeoff is that dirty throttling in the folio's memcg no longer uses
>> bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
>> folios remain subject to normal writeback. This is preferable because a
>> single bdev wb owner does not identify which cgroup is responsible for a
>> mapping shared by buffered bdev users. Flushing it can write back data
>> unrelated to the throttled memcg. Dirty accounting, normal writeback, and
>> foreign dirty tracking for non-bdev inodes remain unchanged.
> 
> When fixing something, please always describe the userspace-visible
> runtime effects.

Sorry, I overlooked this aspect.
> 
> I'm thinking probably "unnecessary I/O"?  If so, has this been
> quantified/measured?  If not, can the effects be guessed about?

We suspect that a large amount of prematurely triggered foreign 
writeback consumes device writeback bandwidth, thereby degrading the 
performance of the entire writeback path.

On one production machine, the total nr_pages of the foreign-flush works 
was 630,681,285, or about 2.4 TiB, while the machine had only 400 GiB of 
memory. Although nr_pages does not represent the number of dirty pages 
that will ultimately be written back, the actual number of pages written 
back may still be very large because the corresponding wb was 
continuously accumulating dirty pages.>
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3898,6 +3898,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>>   	u64 oldest_at = now;
>>   	int oldest = -1;
>>   	int i;
>> +	struct address_space *mapping = folio_mapping(folio);
>> +	struct inode *bdev_inode = mapping ? mapping->host : NULL;
>> +
>> +	/*
>> +	 * Bdev inodes are usually shared by many memcgs so foreign
>> +	 * tracking leads to frequent flushes which is counterproductive.
>> +	 */
>> +	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
>> +		return;
>>   
>>   	trace_track_foreign_dirty(folio, wb);
>>   
>> -- 
>> 2.39.5

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
