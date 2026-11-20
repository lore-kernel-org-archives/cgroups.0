Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795158287;
	b=kGyQg0TQXJeY6uE58YX2MN8nO93J8Mf7vNRQdcDsWHvFi6z6kTOxv94ioL22YF+33xIP
	 m7y3mPhDsolViJU3NHkqIsUXMf01NbxxlLgkHI+DJpwbBG708b/WoQxG3SFamfxGjX7tQ
	 wwV7sEeSZdJyNEcbrCevgP92sS3mz+Wlm+TP2D/DU8HLVnHxydh68syqBER1asRXUoqe5
	 kO7g0Ewdhmqegu4nIByzj9VFiW14LocbAASjyNfmo1YxoQrCtQ1WUuRJLst4UsEpg+g2h
	 VqaszAZxA5TZ2N1hdaIQrMR7nyQ57eb/rls7bqXtHYzbQpZUch7E+sUnKXBW8UNvpqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795158287;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=3OAgcRg9EnbY/PPSzXn+hugpxwFSYehyNculrW0hUPM=;
	b=hPjYIiscKuvphN75jp+MmRNvUd6Hpql2ubvFj0zBc5eSYjHQE2MUisFR4ktjJs2FBm54
	 9pjU3wgQg//woG8tH37Ya7i90AYU4FyqhsUy9nR5EtM0ZS9bNUZITANSBDwrTOrL5PHIE
	 lHtdyYfZSaxPDTcwNBFi2HNqBcKc5AePSC8GnBBnAfKVBC63016B0uVSZB5nhebcoGxED
	 siWX3utTDPoux1+TQmjXeJDvu/3YWRPQYRbza03nkc43bt+0VVb8Hj4fk1/TWysJFcY7z
	 Ir2JZMyh/U2G6pcwca815X2rdX+cOGp+EoACCRBwDEiOML9/nXlYZXhyNN4/GjHks3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=d4aFD2UJ;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E0D606A334;
	Fri, 20 Nov 2026 07:04:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61E0D606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=d4aFD2UJ
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795158282; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3OAgcRg9EnbY/PPSzXn+hugpxwFSYehyNculrW0hUPM=;
	b=d4aFD2UJIIb4eH1FRHl/28m2Ij9G+lXS//SYj4IpcacVMUunlALlrcH8OOh4RDlrJ41p0LIw+q3Pow3sRpOd9LxavhWLzBGqsd00DqjcUGzIyaQcZugmP6cUmqtP1H3igi1L29bBaaFnm2wVRJ5sKbERfZZvp5ZoKurmiKHYxY4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XF5YGBo_1795158278;
Received: from 30.178.66.186(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XF5YGBo_1795158278 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Nov 2026 15:04:40 +0800
Message-ID: <565e4075-2788-4310-8309-7739b9ee94ed@linux.alibaba.com>
Date: Fri, 20 Nov 2026 15:04:37 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 RESEND 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
 david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
 <20261109215053.85df5685da951ab47ef858f1@linux-foundation.org>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <20261109215053.85df5685da951ab47ef858f1@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/10/26 1:50 PM, Andrew Morton wrote:
> On Thu,  5 Nov 2026 17:22:28 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
> 
>> With cgroup.memory=nokmem, the THP deferred split shrinker and the
>> zswap shrinker are degraded in two ways.
>>
>> First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
>> shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
>> limit-induced reclaim of a cgroup neither splits its partially
>> unmapped THPs nor writes back its zswapped pages.  v1 of this series
>> [1] restored the flag to fix that.
>>
>> However, as Sashiko's review of v1 pointed out [2], the flag alone
>> is not enough.  __list_lru_init() also collapses every list_lru into
>> per-node lists under nokmem, so even with the flag restored, the
>> objects of all cgroups share one list per node: the per-memcg
>> shrinker bit is only set for whichever memcg happens to repopulate
>> the empty list, so pressure in other cgroups may not even trigger
>> the scan, and when it does, the scan walks everyone's objects.
> 
> Thanks.  Sashiko still has significant-sounding things to say:
> 
> 	https://sashiko.dev/#/patchset/20261105092233.3558950-1-qinyuntan@linux.alibaba.com
> 
> It also says "failed" for reasons I don't understand and it doesn't
> seem to have emailed anyone.  Please check it out?


Hi Andrew,

Sorry it's taken me this long to get back to you. I've had a very busy
couple of weeks.

Thanks for pointing me to the report. I looked into the two issues
Sashiko flagged in patch 2/5.

Sashiko pointed out that mem_cgroup_id() identifies the cgroup
directory. We reproduced the ID collision on v4: after disabling and
re-enabling the memory controller on the same cgroup, the old and new
memcgs had the same mem_cgroup_id(). Once the new memcg has its own
LRU list, a lookup for the old memcg can therefore find the new list.

I think memcg->css.id would be a better fit for the list_lru index.
Each per-memcg list belongs to a particular memory CSS, and its ID can
only be reused after the last reference to that CSS is dropped and an
RCU grace period has elapsed. That keeps the indices distinct for as
long as the old CSS can still be accessed.

The second finding is the same race that Shakeel's patch [1] addresses.
It predates this series: a folio can move to the root memcg between
the two lookups in folio_memcg_list_lru_alloc(). Shakeel's patch
rechecks whether allocation is needed after taking the memcg reference.
That also prevents the unnecessary allocation at index 0 that Sashiko
flagged in v4.

Does using the CSS ID for the list_lru index sound reasonable? I'd be
happy to incorporate any suggestions and send a v5.

Best regards,
Qinyun Tan

[1] https://lore.kernel.org/linux-mm/20261112061231.2469026-1-shakeel.butt@linux.dev/
