Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920243D331D
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 08:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190111; cv=none; b=tD/ft2TB2zkEEi0iPwWKB1vG84frkBxkZi6L7y0pJOgv35tPg79rUvL2XH7p7g3NiL0BFxkQIHeb63gr53CE8lEJ1yv8z2oa+bp3H8qW3y4Z9ZcOWiG/e3i9fZ5kiaEEEckKLjTt+CxAqwlrFZKUQOLuVouOeB4glK1Hu49GD0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190111; c=relaxed/simple;
	bh=ACmNFVxu/mQCmwVMD/wrzRZFQD+UnJuccJs3iI++g3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NiBHyYPXbYKeJCgLr2lQrP0rTm3+SuCXEn+tE8qivW1jM+pFM5O1Fr1mtkjnsvXEkMykIWgkTAvOY+aCglXAQVGnJ146e0MmiWqILNMLAeJ8OIEinYF42goBfKMP09xypVqeMOhAhsHY/uFqs18QIbG5JqL5aVxrzLl4P4qJWl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wer/jBSi; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wer/jBSi"
Message-ID: <a5eb5433-cf6c-40ee-b14e-128a8bcc85bf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784190092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IrTNLkTEiNUGL9LPA1/vuzxmxpcOM8zbqcaxs0NN2Ys=;
	b=wer/jBSiyvVJstwo92kI7gXiYgohgQ7aV/U7hIX2D/8mfPO7iSMpWXL8Bt5BgmMK1ULwqW
	nKiYSlD88WmbS6ZY0jq0M10linb+m+2TIs9ybRTnsC6HE7Ip60ThGAEakxbyA0Tq10Y0Ho
	QuQj2Wzo0VpUextlFl7DjBjXEfOaMG4=
Date: Thu, 16 Jul 2026 16:21:14 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
To: Qi Zheng <qi.zheng@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Davidlohr Bueso <dave@stgolabs.net>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
 <20260716031729.1064007-3-ridong.chen@linux.dev>
 <7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 7/16/2026 11:58 AM, Qi Zheng wrote:
> Hi Ridong,
> 
> On 7/16/26 11:17 AM, Ridong wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> sc_swappiness() had two separate definitions depending on
>> CONFIG_MEMCG. The !CONFIG_MEMCG variant simply returned
>> vm_swappiness, ignoring the proactive_swappiness value passed
>> through scan_control. This caused the swappiness parameter
>> written to /sys/devices/system/node/nodeX/reclaim to have no
>> effect when CONFIG_MEMCG is disabled.
>>
>> Fix this by consolidating sc_swappiness() into a single definition
>> that checks sc->proactive_swappiness first, then falls back to
>> mem_cgroup_swappiness() which already handles both CONFIG_MEMCG
>> and !CONFIG_MEMCG.
>>
>> Before fix (swappiness=max ignored, mostly file pages reclaimed):
>>
>>      # cat /proc/sys/vm/swappiness
>>      60
>>      # cat /proc/vmstat | grep pgsteal
>>      pgsteal_kswapd 0
>>      pgsteal_direct 0
>>      pgsteal_khugepaged 0
>>      pgsteal_proactive 1840
>>      pgsteal_anon 25
>>      pgsteal_file 1815
>>      # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
>>      # cat /proc/vmstat | grep pgsteal
>>      pgsteal_kswapd 0
>>      pgsteal_direct 0
>>      pgsteal_khugepaged 0
>>      pgsteal_proactive 18013
>>      pgsteal_anon 337
>>      pgsteal_file 17676
>>
>> After fix (swappiness=max honored, anon pages reclaimed as expected):
>>
> 
> By the way, in get_scan_count(), it seems we still reclaim file pages
> without swap space, even if swappiness=max (SWAPPINESS_ANON_ONLY) is
> set.
> 
> This behavior appears to contradict the semantics of
> SWAPPINESS_ANON_ONLY, which probably needs a fix as well.
> 
Thanks, Qi.

You're right. Currently, when can_reclaim_anon_pages() returns false, 
the reclaim logic falls back to scanning file folios even if swappiness 
== SWAPPINESS_ANON_ONLY is set:

```
static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
			   unsigned long *nr)
{
	....
	/* If we have no swap space, do not bother scanning anon folios. */
	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
		scan_balance = SCAN_FILE;
		goto out;
	}

	...
	/* Proactive reclaim initiated by userspace for anonymous memory only */
	if (swappiness == SWAPPINESS_ANON_ONLY) {
		WARN_ON_ONCE(!sc->proactive);
		scan_balance = SCAN_ANON;
		goto out;
	}
	...
}
```

The !can_reclaim_anon_pages() check above takes precedence over the 
SWAPPINESS_ANON_ONLY branch, making the latter effectively unreachable 
when anonymous pages are deemed non-reclaimable.

To fix this, could we move the SWAPPINESS_ANON_ONLY check up before the 
can_reclaim_anon_pages() check?

```
static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
			   unsigned long *nr)
{
	...
	/* Proactive reclaim initiated by userspace for anonymous memory only */
	if (swappiness == SWAPPINESS_ANON_ONLY) {
		WARN_ON_ONCE(!sc->proactive);
		scan_balance = SCAN_ANON;
		goto out;
	}
	....
	/* If we have no swap space, do not bother scanning anon folios. */
	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
		scan_balance = SCAN_FILE;
		goto out;
	}

	...
}
```

-- 
Best regards
Ridong

