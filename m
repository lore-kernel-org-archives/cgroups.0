Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B703DD86B
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 11:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788608142; cv=none; b=fnLznqWPZIvxIFRJD5DWCOc2d8uO1iaG9WHu+a60kLzVPqeiTaSE60RGR8eR1aLiZWKNvqfeDU7fLkIBfvLZCc+yKtW9J9hb0H6VoZlu5VI/Zw+gN48Gdxd13uyuVYQMVfkhPH9THppolYsKgpsrojCFcZOLEaXxUl5JCmR7tuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788608142; c=relaxed/simple;
	bh=1VZksYrA4idbRG/4eAB7m579b8vwjKyWH+DRnw4O240=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m2eq0t62fB3+lbK/vFwxfdmjt6IJffWAOyWp/h3wt127gGXtA8i1IpX0jwTgjHQvZejoEiuCi4/T5GmBSeGhIWUHTFJtFiFvN2riUJDUxDNjXX2k/sYxujgDz55Rx9N2ezgUlwd0m4DOEJqksYwAj8AalvXwCuuWSvz+0TSvb+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=dfCiXNYX; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="dfCiXNYX"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8485b358552so1707040b3a.2
        for <cgroups@vger.kernel.org>; Sat, 05 Sep 2026 04:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788608139; x=1789212939; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yu5YnN/1z/UayGFg88QtZGHAA8PYRJ3IGuj66BKuw00=;
        b=dfCiXNYXzyST9mz8U/xnhKCD10oRn4FfY7PDgnpfZ5rssCRxHD1qRdse3KOMWm278F
         sMP46aoaOBahbbrbGjgBA0ip/mBmW2dYI/T2em8xV9u6ULg0g1J49oHQpoK2PyXtFxUE
         RcSxSmUCtTfP7yG5OkBRKVkr8DvHmMPH+zXSHX0SpmSfNai0SsChh3ixR9dMIh6JqjVh
         2Vfwl1d1Pze8HP+QUcfvtqZQtc4ziexuKjXgOXTuaeT4/FIgzuW/y53M97dqDmDB01QN
         J7ovWYmsuzb6vtIq47zlzMXglDtJv56Q3lfcdcx1KdeC4HX5Y7/MZGDlxz3c0UQbNosu
         G8Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788608139; x=1789212939;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yu5YnN/1z/UayGFg88QtZGHAA8PYRJ3IGuj66BKuw00=;
        b=UBIeRitDnsm1Y3fbd2exJZkxitShkNzeydpxE0+nlBLMFdkMM4/U/e34xsbgqBmwyY
         ISfYHX2IhQ7UeDkcTKXHtujfvLA4orToe59dOj8ZicOJQgWoF8aPFtA06CK1+n84lOIu
         JI3aP9m05bcmcyjgmmdpjcA4Oc+a6KBggth2PE7i6J/5AHrhwFvksXVrOmt1kbzTS3vh
         hmIsbvV9zztKE9VIfv1G5Y9tpEsZEQeBRM2jWE0hYPnbYwUwoDK/ojwfHxUOaNRefuBw
         c4eWcTFIFzqyTOIM+o9QQ5c/bXT2qzkFs+HLna+8TMPZHDBLW7/kRfUULDvAYMElFoPG
         4p6Q==
X-Forwarded-Encrypted: i=1; AKwUvBxZ1lovrSd1BChYd/ZjxVsCKqaxOZ+yE4lwsyLRX5je6a48fS99NTx/AYjMjynxdAOBbRFCafD0@vger.kernel.org
X-Gm-Message-State: AFuF++mEA10wsUWuRIvdnlScBZs+a58oyAkvzGnBkECTAepq7h+FcBa7
	c2L14QiPX08STiaWv836i2aedQt9nidN66ZE4peouSz0mLIaUl2hwIDNUpkTdheND9pL7wzUTO7
	lcNpA
X-Gm-Gg: AYBFou1cXXzOswL47LV3Q4iajWFH7F95r+REGBhcffrJg6JTUoYhNPpu4N5idFX/6zv
	KobpxDzvbBAEHzCoedQPR5O/1eg2ZhDfy4dRgFcoSHdelIXvVf6FRP1xVD20fn6Ch4RlMyPFN3s
	7Iml/HqsCpP4pWcmCET12WgFq09hy66i5IpZ7gquZIR4tdTYVZbo+WrPQ911D+Q0sE7EUdIN9cc
	AwYyBe+cSOPqPacfA6egoDoUq28PJECYO1p4t/46+a+MtDyUCJbM+B39YsNVn95Z7WpIKMxilzR
	FeI9qMFNIl+OJhn/ocUcholhsoi3QSRydnjJJlK0v+Ieb9ga7Rmgo1vlJo0UzTGCcJ34IoWBg8r
	BaQ8lXrP0EmSAJtjbyTtIQFHZKR10B78sZxdbRb4tXrbDl/IoDfZtiYhE2fk9bynmxSwBd+kdlS
	4841dNeAsIvh0A0YhBPxUI9lc4V0vzy37Nbq46QBsKwFynQVvthqsXIbgJiPOs6JaF2O6xz/TpM
	gp/6xDupBhhF2uDAx+V3MK8KcfOF310
X-Received: by 2002:a05:6a00:94fb:b0:852:38ff:b4b6 with SMTP id d2e1a72fcca58-8616a76a6c4mr15990237b3a.17.1788608139353;
        Sat, 05 Sep 2026 04:35:39 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8614f873c9csm2228069b3a.5.2026.09.05.04.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 04:35:38 -0700 (PDT)
Message-ID: <00340bf1-a46a-4404-9d38-a5433ca78fbc@bytedance.com>
Date: Sat, 5 Sep 2026 19:35:35 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] writeback, memcg: skip foreign dirty tracking for bdev
 inodes
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 axboe@kernel.dk, tj@kernel.org
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
 <20260903123427.eb0beab18ff68d4632aece6c@linux-foundation.org>
 <5f34e3e1-749e-44d1-b3e7-50e11f7240e3@bytedance.com>
 <j644hkswljrskiivxcimh2ms2zoilfptfhl7bdy6uu3tvqv6yd@m46nuyunp5ni>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <j644hkswljrskiivxcimh2ms2zoilfptfhl7bdy6uu3tvqv6yd@m46nuyunp5ni>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/26 5:00 PM, Jan Kara wrote:
> On Fri 04-09-26 11:39:23, Julian Sun wrote:
>> On 9/4/26 3:34 AM, Andrew Morton wrote:
>>> On Thu,  3 Sep 2026 16:33:03 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:
>>>
>>>> Foreign dirty flushing handles cases where a dirtied folio's memcg and
>>>> the memcg owning its inode wb differ.
>>>>
>>>> wbc_detach_inode() notes that "concurrent write sharing of an inode is
>>>> expected to be very rare". This expectation does not hold for bdev inodes.
>>>> A bdev inode and mapping are shared by buffered users of the block device,
>>>> while the inode has a single wb owner. On ext4, buffer-cache folios used
>>>> by metadata and journal I/O can therefore be charged to different memcgs
>>>> while sharing the same mapping. Normal bdev activity can thus produce
>>>> frequent folio/wb ownership mismatches.
>>>>
>>>> This was reproduced on cgroup v2 with the memory and I/O controllers
>>>> enabled, using ext4 on a loop device. jbd2 repeatedly generated
>>>> track_foreign_dirty events for bdev folios charged to unrelated memcgs.
>>>> When one of those memcgs entered dirty throttling, the resulting record led
>>>> to a flush_foreign event and queued writeback with reason=foreign_flush for
>>>> the bdev inode's root wb.
>>>>
>>>> Skip foreign dirty tracking when the folio mapping's host inode is on the
>>>> blockdev pseudo superblock. This prevents bdev-originated records from
>>>> triggering later foreign flushes.
>>>>
>>>> The tradeoff is that dirty throttling in the folio's memcg no longer uses
>>>> bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
>>>> folios remain subject to normal writeback. This is preferable because a
>>>> single bdev wb owner does not identify which cgroup is responsible for a
>>>> mapping shared by buffered bdev users. Flushing it can write back data
>>>> unrelated to the throttled memcg. Dirty accounting, normal writeback, and
>>>> foreign dirty tracking for non-bdev inodes remain unchanged.
>>>
>>> When fixing something, please always describe the userspace-visible
>>> runtime effects.
>>
>> Sorry, I overlooked this aspect.
>>>
>>> I'm thinking probably "unnecessary I/O"?  If so, has this been
>>> quantified/measured?  If not, can the effects be guessed about?
>>
>> We suspect that a large amount of prematurely triggered foreign writeback
>> consumes device writeback bandwidth, thereby degrading the performance of
>> the entire writeback path.
>>
>> On one production machine, the total nr_pages of the foreign-flush works was
>> 630,681,285, or about 2.4 TiB, while the machine had only 400 GiB of memory.
>> Although nr_pages does not represent the number of dirty pages that will
>> ultimately be written back, the actual number of pages written back may
>> still be very large because the corresponding wb was continuously
>> accumulating dirty pages.
> 
> As Tejun also wrote, it would be good to really quantify these effects -
> best by demonstrating how this change improved writeback behavior (and we
> are not so much interested in the number of submitted writeback works but
> more in the observed load on the storage or completion of some workload).
> The problem with your solution is that it has its downsided as well
> (possible stalls in dirty throttling) so it should be very clear what are
> we gaining to outweight this risk.
> 
> In principle I agree that a lot of submitted writeback works can degrade
> writeback behavior - a lot of workloads has some set of folios that is
> practically permanently dirty and if you are pushing writeback too much, we
> will be just writing these folios over and over again without useful work
> really done. Also if there's comparably small amount of folios dirty, the
> IO resulting from writeback is generally less efficient. But how severe
> these effects can get in case you describe is not clear...

Thanks for the suggestion. Following your point about repeatedly writing hot
pages, I tested buffered overwrites alongside a concurrent direct-I/O workload.
Skipping bdev tracking reduced actual writes to the overwritten file by 69.6%
and the concurrent workload's completion time by 14.4%.

I also reproduced the downside you described: a metadata-heavy workload
completed 31-33% more slowly with the patch, including final sync. So these
results do not establish that blanket skipping is a net improvement.

I've sent the detailed test setup and results in a separate reply.

https://lore.kernel.org/cgroups/apnYouiUINQR-98e@slm.duckdns.org/T/#mdc87094720abce0162c14cdf8f3d0ab218eea686
> 
> 								Honza

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
