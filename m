Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A0F3ACEE3
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 08:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787215419; cv=none; b=CV+VnYhfGwNvz8n7aBqKXxaxVKxfJIuUTp5TyrVKjP/43WLhiRmjqYrWK9su1r+l9dhW592PXB0yK9AEw3+Z13L9yzhxd45VM7pUmnDIQHFB34RhS9mjTPkPHEkQgzVjx1RWoXyWcI4ebk4ieoszYdkYD3b+yY3oSGld8PkLQwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787215419; c=relaxed/simple;
	bh=yTjYhvKkMHDo9qLLabTyUV3J3cL/wvyOOWOBN5nhYWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZL28JJSBXFYDTCjtc3AnJ71W6SkeVGo3Pkn0z/1aTytzq76Vdad+bmmvJd4wfiFHQXvjxOdfWp7FQKJtLSO304hJv2Y8Fa9UWDyzJjThknL6icIPfjghdLVBvzNMqx6sqBHqyxI3Qse1uNsP4Ml44Urn+alNAWhglz2CQwwef10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XStD9AlN; arc=none smtp.client-ip=91.218.175.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XStD9AlN"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yTjYhvKkMHDo9qLLabTyUV3J3cL/wvyOOWOBN5nhYWo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787215415; v=1; x=1787820215;
 b=XStD9AlN2vwxKH/blq7pNCqOEL8amlojWvPjAb3wCg/FZCrQhmsbmF9XlBqxSgj3hMe4pvOV
 PV3CVYNKEHMWJ8TsH4YheOf+VYIy8LtftbzPMevvEFDnE3/8E8g8omazPcXCdJwNacF/hGE5hn6
 S9hgxjwprJI0uMlEmYsjy6uQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 50b587144d94fa93;
	Thu, 20 Aug 2026 08:43:35 +0000
X-Mizu-Trace-ID: 50b587144d94fa93
X-Migadu-Flow: FLOW_OUT
Message-ID: <ee4cd3ab-0708-4c37-b597-703a7d7547e2@linux.dev>
Date: Thu, 20 Aug 2026 16:43:23 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] mm, memcg: fix memory.peak reset clobbering other
 fds' watermark
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, David Finkel <davidf@vimeo.com>,
 Tejun Heo <tj@kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
References: <20260814033005.2481920-1-ridong.chen@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260814033005.2481920-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/14/2026 11:30 AM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The memory.peak / memory.swap.peak per-fd watermark tracking has two
> issues. Each open fd is a watcher and reads back max(its own value, the
> shared local_watermark); both bugs live in that scheme.
> 
> Worst case for both is the same and is userspace-visible: a reader of
> memory.peak (or memory.swap.peak) gets a value lower than the true peak,
> so a tool that sizes or bills a cgroup by its peak usage under-reports it.
> 
> Patch 1 (read side) fixes the race Sashiko pointed out in the v1 review
> [1]: peak_show() inspects local_watermark and the per-fd values without
> holding peaks_lock, so a reader that races an unrelated peak_write()
> reset briefly observes the lowered value. Transient. It takes peaks_lock
> in the show path.
> 
> Patch 2 (write side) fixes peak_write(): on a reset it stores the
> current usage into the other watchers instead of the old watermark, so
> once usage has dropped from a peak a reset on one fd drags every other
> fd's peak down too, even fds that never reset.
> 
> ---
> Changes since v3:
> - Switch to guard(spinlock) in the peak readers, suggested by Muchun.
> 
> Changes since v2:
> - Spell out the worst-case userspace-visible effect, per Andrew's
>    Go back to v1 [2].
> 
> Changes since v1:
>   - New patch 1: hold peaks_lock in the peak readers (Sashiko).
>   - Patch 2: floor the peers with max(usage, local_watermark), mirroring
>     peak_show(), and skip the writing fd (Johannes Weiner).
> 
> [1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
> [2] https://lore.kernel.org/all/20260730115314.1069089-1-ridong.chen@linux.dev/
> 
> Ridong Chen (2):
>    memcg: acquire peaks_lock when reading memory.peak
>    mm, memcg: fix memory.peak reset clobbering other fds' watermark
> 
>   mm/memcontrol.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 

Hi all,

Just a quick reminder on this series, could it be applied?
Sending this note in case it got buried.

-- 
Best regards
Ridong

