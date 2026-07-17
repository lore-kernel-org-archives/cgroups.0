Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4359F2F8EAF
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 02:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784255304; cv=none; b=hd54p1koniRH3I0LSv0VES58vJ+5NY0PObXPQfH52FupO7jcQ5XHxAKBP7FRuolpUdhwBHf3vTTGvQe614jqvG9Mm7H9Uh68TnZa2bZeLOWKVsN/QY6hnpN42jPGk7i/yDwJWBJK4YD1BH9CCY0K8NIzX0ragbjNZbtpOekgNLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784255304; c=relaxed/simple;
	bh=Ih5SLu2X4K5Fixk67XYx7zgqlcqgvqZxwoIRIrLPaqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DvS8wF9G8N9lAOBG3PqZ1SeAf5vqi8zPpL/TgxbLrrbpnMaL1jav0qPvq73wFZRomFO03QwckFoMykp6sZGRi4zMydBktugqWzea16j64ubq2TfvIDyc23WNR316qzP9+D/2OgJ36Dj1Ya8oV1aelPIjF1s904LtVhghWffqqIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VcWEPhq4; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VcWEPhq4"
Message-ID: <bd61c847-6432-491d-9314-304070b18196@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784255289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7BquqktHv1/BZuLZY0RQng54+jc6Y0pgFNTnH/SVV0=;
	b=VcWEPhq4E+a+5McB+OTjqrvM3jg56G30RJxu5ay+P5eX+Y3Lf4/JaMWwS1D2For1jcDONU
	JqMi2TQAGD3a5C8HTdNvSIycx9sVWHReci4yRuvuItFztk+X5a2eu0QE/XVp2wApXo5L6z
	wArI5y4X5mCX4YMoBrH8kismyj4tVuY=
Date: Fri, 17 Jul 2026 10:27:45 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
To: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
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
 <a5eb5433-cf6c-40ee-b14e-128a8bcc85bf@linux.dev>
 <94a489d5-8b02-46e6-92d2-ccb85f556769@linux.dev>
 <65305712-8598-46aa-822b-914298277b64@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <65305712-8598-46aa-822b-914298277b64@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 7/16/26 7:17 PM, Ridong Chen wrote:
> 
> 
> On 7/16/2026 4:42 PM, Qi Zheng wrote:
>>
>>
>> On 7/16/26 4:21 PM, Ridong Chen wrote:
>>>
>>>
>>> On 7/16/2026 11:58 AM, Qi Zheng wrote:
>>>> Hi Ridong,
>>>>
>>>> On 7/16/26 11:17 AM, Ridong wrote:
>>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>>
>>>>> sc_swappiness() had two separate definitions depending on
>>>>> CONFIG_MEMCG. The !CONFIG_MEMCG variant simply returned
>>>>> vm_swappiness, ignoring the proactive_swappiness value passed
>>>>> through scan_control. This caused the swappiness parameter
>>>>> written to /sys/devices/system/node/nodeX/reclaim to have no
>>>>> effect when CONFIG_MEMCG is disabled.
>>>>>
>>>>> Fix this by consolidating sc_swappiness() into a single definition
>>>>> that checks sc->proactive_swappiness first, then falls back to
>>>>> mem_cgroup_swappiness() which already handles both CONFIG_MEMCG
>>>>> and !CONFIG_MEMCG.
>>>>>
>>>>> Before fix (swappiness=max ignored, mostly file pages reclaimed):
>>>>>
>>>>>      # cat /proc/sys/vm/swappiness
>>>>>      60
>>>>>      # cat /proc/vmstat | grep pgsteal
>>>>>      pgsteal_kswapd 0
>>>>>      pgsteal_direct 0
>>>>>      pgsteal_khugepaged 0
>>>>>      pgsteal_proactive 1840
>>>>>      pgsteal_anon 25
>>>>>      pgsteal_file 1815
>>>>>      # echo "64M swappiness=max" > /sys/devices/system/node/node0/ 
>>>>> reclaim
>>>>>      # cat /proc/vmstat | grep pgsteal
>>>>>      pgsteal_kswapd 0
>>>>>      pgsteal_direct 0
>>>>>      pgsteal_khugepaged 0
>>>>>      pgsteal_proactive 18013
>>>>>      pgsteal_anon 337
>>>>>      pgsteal_file 17676
>>>>>
>>>>> After fix (swappiness=max honored, anon pages reclaimed as expected):
>>>>>
>>>>
>>>> By the way, in get_scan_count(), it seems we still reclaim file pages
>>>> without swap space, even if swappiness=max (SWAPPINESS_ANON_ONLY) is
>>>> set.
>>>>
>>>> This behavior appears to contradict the semantics of
>>>> SWAPPINESS_ANON_ONLY, which probably needs a fix as well.
>>>>
>>> Thanks, Qi.
>>>
>>> You're right. Currently, when can_reclaim_anon_pages() returns false, 
>>> the reclaim logic falls back to scanning file folios even if 
>>> swappiness == SWAPPINESS_ANON_ONLY is set:
>>>
>>> ```
>>> static void get_scan_count(struct lruvec *lruvec, struct scan_control 
>>> *sc,
>>>                 unsigned long *nr)
>>> {
>>>      ....
>>>      /* If we have no swap space, do not bother scanning anon folios. */
>>>      if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat- 
>>> >node_id, sc)) {
>>>          scan_balance = SCAN_FILE;
>>>          goto out;
>>>      }
>>>
>>>      ...
>>>      /* Proactive reclaim initiated by userspace for anonymous memory 
>>> only */
>>>      if (swappiness == SWAPPINESS_ANON_ONLY) {
>>>          WARN_ON_ONCE(!sc->proactive);
>>>          scan_balance = SCAN_ANON;
>>>          goto out;
>>>      }
>>>      ...
>>> }
>>> ```
>>>
>>> The !can_reclaim_anon_pages() check above takes precedence over the 
>>> SWAPPINESS_ANON_ONLY branch, making the latter effectively 
>>> unreachable when anonymous pages are deemed non-reclaimable.
>>>
>>> To fix this, could we move the SWAPPINESS_ANON_ONLY check up before 
>>> the can_reclaim_anon_pages() check?
>>>
>>> ```
>>> static void get_scan_count(struct lruvec *lruvec, struct scan_control 
>>> *sc,
>>>                 unsigned long *nr)
>>> {
>>>      ...
>>>      /* Proactive reclaim initiated by userspace for anonymous memory 
>>> only */
>>>      if (swappiness == SWAPPINESS_ANON_ONLY) {
>>>          WARN_ON_ONCE(!sc->proactive);
>>>          scan_balance = SCAN_ANON;
>>>          goto out;
>>
>> For SWAPPINESS_ANON_ONLY + !can_reclaim_anon_pages, perhaps we should
>> just return directly instead of goto out, since no pages can be
>> reclaimed in this situation.
>>
> 
> Much better.
> Would you mind if I send a separate patch to fix this issue?
>

Sure, thanks for your time on this, and I look forward to your fix!




