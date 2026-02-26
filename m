Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086F5387590
	for <cgroups@vger.kernel.org>; Thu, 26 Feb 2026 06:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772088200; cv=none; b=WDKg8yTgb78RDQTGSzeAjhEUnc/c3XZPuBlGkVHvnUiFqA5ANy0ApoX75PPevjxCvsnEZjTIJ0cAsctaAZ4n0la4C+TrOSTH2jLxdS6F17LfmaZ3V4j8Dr0uVxJTBNWNKXHdnJlfw1w+fpwOsW8DeUF/gW0nW1aWrHV0pO9JKiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772088200; c=relaxed/simple;
	bh=p8R4zmAB9V4nCQaJusrhg0BJhZnx2oFpUwWtRscukWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MA+tYX0oErRqWWPFl6xfy6WTIn9fqkBtHZf60Dlxmgx2hKt+zLKSPMm+P1lvQBCNqzeNXUGRpa1cDlUwZvCB7xGGRFIVIfxhYXkj353NNObgYOM8OB3s2pDZrrkW4gz78NnK5g3BDluk7/pj+F7Cus32v9E5ll1IINkBLeIiaI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HP5Ga7xy; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HP5Ga7xy"
Message-ID: <d7bc163c-7dca-4cb5-b522-a6f98ba4b16f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772088196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/gFMs3BNYCLYbp907qyYSrv7ESdIsN4oDF7h/Fu2FJY=;
	b=HP5Ga7xyX4/Ux+VNCIMWTaLmiC52BjFNZ8ZGo2ljwIaNuUW1j9m0tascLyfYdtnFd+8HtH
	Z55p50bo9TBs9IZhmfCIXUiw7Tjqv9UwPTuyH3MtGTAf/qgvQ0w8lku/YcCSGDx40MMllu
	Ogim/cLOLqJMhJFU7U1l3hlNee2bCCo=
Date: Thu, 26 Feb 2026 14:42:51 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
 <aZ-R87JfacQ2gGq1@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aZ-R87JfacQ2gGq1@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 2/26/26 8:25 AM, Shakeel Butt wrote:
> On Wed, Feb 25, 2026 at 06:58:59AM -0800, Yosry Ahmed wrote:
>>> @@ -473,6 +493,29 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>>          return x;
>>>   }
>>>
>>> +#ifdef CONFIG_MEMCG_V1
>>> +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>>> +                                      struct mem_cgroup *parent, int idx)
>>> +{
>>> +       int i = memcg_stats_index(idx);
>>> +       int nid;
>>> +
>>> +       if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
>>> +               return;
>>> +
>>> +       for_each_node(nid) {
>>> +               struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
>>> +               struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
>>> +               struct mem_cgroup_per_node *parent_pn;
>>> +               unsigned long value = lruvec_page_state_local(child_lruvec, idx);
>>> +
>>> +               parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
>>> +
>>> +               atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
>>> +       }
>>> +}
>>
>> Did you measure the impact of making state_local atomic on the flush
>> path? It's a slow path but we've seen pain from it being too slow
>> before, because it extends the critical section of the rstat flush
>> lock.
> 
> Qi, please measure the impact on flushing and if no impact then no need to do

OK, will try to do it.

> anything as I don't want anymore churn in this series.

Agree.

> 


