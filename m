Received: from mail-dy2-f12.google.com (mail-dy2-f12.google.com [74.125.229.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A613486E7D
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 09:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790589088; cv=none; b=gqO4H3GbcI738FvGbJEPzNm1+7VPwJ1eZKMU+nhKpfa8nGT8jehunIAEMDNGv4IFF1kupF9ggmNZQIMfLrV8kcUi4c9rA/AbfC45AhsunouHv1Wcf2diNmDxVRGu2DQ9DVMMKk8ftkNYviUP31KGee57bS+qaXh8A6g/ClQLA+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790589088; c=relaxed/simple;
	bh=E2s8ZRF2N2knlArU5QNYleJvF1AGn/GBRND9jJ+/r3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RD8Ka2jRnhVTgV8vY1YitRMl9LbiSRCK87hnwIgef5amNU+3VlBj3O74DDeHAP5eV2v2EVSiPZvi5Mq5OKgmvdlyKFRY+UYz1iZF3uDbXxQi9WI6VGGAOPV/uLowF+9ND2OqjqVAwsb3OdAQSMqN2ioJlzzVoEINcXpLFzi5Kgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=SL9Q6y6r; arc=none smtp.client-ip=74.125.229.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="SL9Q6y6r"
Received: by mail-dy2-f12.google.com with SMTP id 5a478bee46e88-328664b7528so2688693eec.2
        for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 02:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790589085; x=1791193885; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=u1HXVH+r86enel9+rQTBOES9ysvhe0ZUHDob7OwbV1g=;
        b=SL9Q6y6r1IRGJA6IKsml37/T81TpVgG3173W9MG788C5CO582zt/wuIj8C5X6PFGYZ
         ciYPHBUDcGKtkaUt0mf6bjBO3ectA1iRXQ6muBn0gZ4wvPMjwIEoDDK0qzCOBowro5jR
         6gl4qycYsKve47k0qOThCXRfUOaWP1MiI0fvsgHDsdcd5cm+Gce6O3Mv6HegtXqr+XWm
         oV5bc7iM/YZhcP0hjKURad6GM0bTMfhczOfh98i7aUBrPMmCT7/ilae96XlYwcXDp6dv
         tTwELQ/0nUY59T2OIdrqF6JExaTxB+Ky5y3cWTNLF7q+YAAnPlQGVVl9/V980i042m+d
         mLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790589085; x=1791193885;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u1HXVH+r86enel9+rQTBOES9ysvhe0ZUHDob7OwbV1g=;
        b=dCTUitlNP7VSmIAa+ix0jSH7P1kdEo5c1zXDjSZlxTWEJDjbCm0w43UHb69yucYc9y
         eu5Mhk3iGCNTd58RXymYrTfWgqwU+z30WLNXGJOhZydZSdMp8YFNHC+FYM+cDMUg8MBd
         e4bmdIwHdY/Zi+9E73Q4snn2fhCVqGl79TICrGrQi0//2oREA7VyrQvVRGl/hpWqXZXU
         zGfb48jZBOAkTGMNx3chw9qD0LBp8jLueQZmNsmu1wC4L9aHRose2EPkwFDKGOeOAO34
         +dPwdF4qgTxTjU1m/n+cVEeRJo+K1bKd8N5FdouDN1gDy401/NOjrcvdTMOeOCVm2wvu
         JoVw==
X-Forwarded-Encrypted: i=1; AKwUvBxIn+ioAV7r/uNIQeB4xKpKtPADGC7kEMFXcKHgDEZQ9XWjY07c+0z5T7Nw7LBi0CmwrFmLOjBV@vger.kernel.org
X-Gm-Message-State: AFq9FYKUohxHaN1PK/gNWul4544ZhWC50RIUjCLPubHDCrE4PwfXnxHx
	YznzVZ5PE3CyzikedOGh+zEi4Yzo73BFwgrbL9BJmz1e63UAAm4Q5VoFOjm1P/4QXqk=
X-Gm-Gg: AYBFou0uf5F1YrWIzdRZDKcsvDMWizfw5eywQdNxo6W2kG/vsKT8Cm11q2Ebk8MKs6R
	C96hVR6zi2juBtxCRTAevKTEaH+078lCbDMFyd4XrgrIpZFEH5PCP1mKnvEeK6Ohbjnejn8q9Lx
	hMTO5+kxuGyQ0IwFkLootHFf8GfsyOxKRugX5THleBkExCV7YoNL8oT4jAj5WiCwj9LIP+l8k/N
	jpNLVRazUdBIjNoQEbWqQweQ97ODqH62wM0gL8twgHv2wgi1ugyQLihKlki93crtc8musTJbZ8d
	jh+MDUqRhM5Vgou31TM6pu4xnBuM0U5g+6gYuQn7QMqM+Mv9AhZFeuGoqYAZao1DO6xsFgUhPD5
	dhrLo0pfT8BpJfr0jfdhl3wx1iKLhl3SJo9br4pjLB35N84GrKZKhcEMRGH4O8dmjEYg4pZap+c
	hZSpQtqFSKQoO/fBVwVMzRk++PZj9a9X6rDtNlLOiANi811+G5MpMBMIkPTnPJvMeBvtMP+5JoJ
	+Z7TrWGGAWI5Eg5K6at
X-Received: by 2002:a05:7300:8189:b0:342:e7a0:2829 with SMTP id 5a478bee46e88-342e7a0534dmr11613300eec.26.1790589085183;
        Mon, 28 Sep 2026 02:51:25 -0700 (PDT)
Received: from [10.255.210.72] ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-341f2b18cbfsm25480102eec.30.2026.09.28.02.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 02:51:24 -0700 (PDT)
Message-ID: <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
Date: Mon, 28 Sep 2026 17:51:09 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
To: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, willy@infradead.org, tj@kernel.org,
 akpm@linux-foundation.org, Boris Burkov <boris@bur.io>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <aroIAqoCNDBPlB2A@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/28/26 2:24 PM, Christoph Hellwig wrote:

Hi, Christoph.

Thanks for your review and suggestions.

> On Fri, Sep 25, 2026 at 12:34:52PM +0200, Jan Kara wrote:
>> On Thu 24-09-26 23:52:33, Christoph Hellwig wrote:
>>> On Fri, Sep 25, 2026 at 02:44:42PM +0800, Julian Sun wrote:
>>>> Add bdev_flush_by_dev() to submit page-cache writeback for a device
>>>> identified by dev_t without requiring callers to hold a persistent
>>>> device reference.
>>>
>>> This isn't really a flush is it?  This is writeback.
>>
>> So bdev_writeback_by_dev()? Fine by me.
> 
> Yes.
> 
>> Well, Julian is explaining that in the cover letter. We don't want memcgs
>> to hold bdev references just for foreign flush tracking. There's no easy
>> way to get rid of them so they could pin bdevs for a long time leading to
>> strange artifacts.
> 
> I have to admit I didn't get it when flying over the cover letter.
> But this also really belongs into the patch where it is more obvious,
> or even better into code comments.
> 
>>
>> As you write, we could just hold a reference to the bdev inode. Those get
>> unhashed when the device dies (__del_gendisk()) so memcgs would be just
>> wasting some memory by holding these inodes alive. But still, transitioning
>> from inode to proper bdev reference verifying bdev is still alive will add
>> a bit of hairy code (essentially what blkdev_get_no_open() does plus
>> verification inode is still hashed). Plus when replacing foreign flush
>> entries you're under irqsafe xa_lock so doing iput() from there is kind of
>> a nogo.
>>
>> So I think tracking devices by dev_t is a good way of dealing with these
>> problems. But then when flushing you have to transition from dev_t to
>> struct block_device and blkdev_get_no_open() is the canonical way of doing
>> that (and note this use is just internal to block/bdev.c).
> 
> I'd really prefer not to grow more blkdev_get_no_open users.
> 
> But the more I look at this I wonder why we even bother.  Trying to
> attribute individual bits of dirty metadata to cgroups is pretty much
> insane.  Why don't we bypass memcg accounting for buffer_heads like we
> always did for the XFS buffer cache, and what btrfs switched to last
> year? See commit b55102826d7d ("btrfs: set AS_KERNEL_FILE on the
> btree_inode") for the btrfs side.

That sounds reasonable. However, IMHO, the main difference is that ext4
stores this metadata in the bdev page cache rather than a separate metadata
cache as btrfs and XFS do. The same bdev->bd_mapping is also used for buffered
reads of the raw block device from userspace. Setting AS_KERNEL_FILE on that
mapping would therefore also charge newly allocated page-cache folios from
those reads to the root memcg rather than the reader's memcg, bypassing its
memory limits.

If we pass a flag from ext4's metadata buffer-cache allocation sites and
check it in grow_buffers() to charge new folios to the root memcg, accounting
them as kernel-file pages would still require persistent per-folio state.
When a folio is removed from the page cache, the allocation context is gone,
so we cannot tell whether it was counted as a kernel-file folio.

Separating ext4's metadata cache from the bdev page cache would address this,
but that seems like a much larger, longer-term change.


Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
