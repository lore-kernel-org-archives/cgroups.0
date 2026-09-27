Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2924E3D331E
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 11:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790509722; cv=none; b=DQh9ORdTiE96lU91SpHnZcjqZL+aywekjcENmXPdNGSkN0ULTvuCG5N33VckRQSRYXQhqo+81X4PCDOJpX4xz6aS2LQ9WcJQm29Z/UeWYrXgIpLHd3alC6Zs8uYjExBWam/XFptn3f7vN+wcMr5RLSVt0u4ejlqFq1IJ595utUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790509722; c=relaxed/simple;
	bh=L6smztHc7Zu7OvGd8/tyj4fHgTUBsP8/eRiT/kR8iU0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=OEh0f1xPXafXyfalFwIczl7p6B6kVDeY/suARmuSOtdAL6hgzSaaz5phCKyCsuJBi5Q+rxdoJ+hU/Yr8Z+jhzFHwGX7SuVoPFBW/sddMhj3o94LG8q+m71BTmA3fx1AWQ9a1ME7Y65P6Ar4sa82xQaT+01QcemGJJr+T4/odpL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=emtXiVyz; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="emtXiVyz"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2caced6038eso13136765ad.0
        for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 04:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790509718; x=1791114518; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6UgoZARQeqwbtbTZxY5jfWds9R7jptg+w98Z3sju2mM=;
        b=emtXiVyzWe0iGdGJIPu6n8xh/tyFrCYzT3KO6q94Mw470wu+mJ3slsqfKQFSDWZGO4
         Pt/2uFbO6UtfI/tQnLGX7PHQEqN4UD5LSPvrYgPsMuWvjEGA9vkyX42jzFHABANzZdRm
         jDzNv1kFnpxNXpaQGAfqkfPUuc33ih8sraYjWx5L/Zn9Ut/KmtL+kxTfXGEbuoVz/p8e
         urLfwh/7hIDerrMfkMpCh5Yv/Pk1K4JT5Zu6jMLHOmaOtPRTPul4gP84XOrlUs0nPETr
         O3fK/b3iOLMkdp3QVlFFAhXm2yQiCu1fjZQwrnA66J8hdGtyYseZ1Hw+tqJXbln8WzME
         4HPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790509718; x=1791114518;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6UgoZARQeqwbtbTZxY5jfWds9R7jptg+w98Z3sju2mM=;
        b=CT2FNj5WqnM+K8KcL9os/zvzH8u/JFnpFsMzxXBmfbwHVoK7EVP7ygML20Q/5CTvfC
         gYH5XmAw6YCfrXQElHfnt1cnq2H8s1MrJynu04mZD9apEGrT0jPk5Y3TEkY5+g7xvvGk
         sYQZz3H0bHvccVYWwuCmd35Unp+SIlXkNlfzfZoqjx7W96Y3ruZ/t4maEs/+aLUCZsZo
         ORsVZhqCnL0fgurJhGRCeOtgnR494TKfVADWMQ5PrRYpKEZXWA6PGYBA/F15UmAe9uiC
         uvkGdzY/xBJkbjMB94Qo1NRgWNqIhofNBXvZksxhwmR9XQg4u0bKMJIru/yaYydZu9Yd
         myRA==
X-Forwarded-Encrypted: i=1; AKwUvByRc8EfsqbqT+bofsGTBeJXBVyGW1BC4wG+tTeGqeE4+bqAQmznFBk+GpssFVLVK4OLWS32cGUQ@vger.kernel.org
X-Gm-Message-State: AFq9FYKvORq3PYfi0UDIe/xKQ51V4nMOKL432Yo5ffx8kkOAXg05C6JK
	la5gnU1uOUqYXmSrmeGXsQvTJtAH+0VoovkNFv0YBHx3EPW/L1fT0wFRUJPQttHKFWs=
X-Gm-Gg: AYBFou2OzeQA4mHBjMj7/dWvPJu7CvsMEVgy6etdlU9Q/8lyh1jjp/GHBZ16pJ4wvYt
	ussnHWs1vYgvdboRLCn8TM073CZasxjI9gWLXkb4B6mGS9KWNT+WcOrmBzj+0sByd4fwmQbS4ea
	41l3ziAhjIEK5tBGhvvck4d6iR6pDOlIfZ9+WzkDEyb8UhCtjLf9XQKZhUd5m3HlIkG+sczATqq
	bSkRZOIQ3ANgy7G51kGzAq+p0v75HkOBznAtFH4yVEG6OKINvIAuakP3DwRJj6TxQL2KXSV+S63
	zzyHxoKMkNkbiT9QmMNJ6wWa3D1LrHxMhRxOaJ8nbWEGm+f8Zbx4H4nepRjKcTj9cjmgCS3Q9MU
	F+3elLSDHLvaUxymQJwZImZ2HZnzltJaGT1kZbzZUlCWHtBE6j037QFNe+/HnEiutlO4IUew5Lr
	VfKVRi+DvxSmmn4R+WPEy6YNzluQBDD2aCUh4yHNhfIee9t9CCnpB2F1ceffJ8aNY4xgqCje6rP
	bZfQeepswYcczkrAFyasOryJfMe5zzXSBv3Z1sRJ+Zvm1O3FA9P4iBf9g4776nGR/09IBM4FVDs
	XI4THQ==
X-Received: by 2002:a17:903:144e:b0:2d7:1cbd:9ceb with SMTP id d9443c01a7336-2df7dfc2e54mr63334925ad.12.1790509718121;
        Sun, 27 Sep 2026 04:48:38 -0700 (PDT)
Received: from ?IPV6:2409:8a04:3024:f231:884:d8f1:aab5:6785? ([2409:8a04:3024:f231:884:d8f1:aab5:6785])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9146ed7csm28018285ad.80.2026.09.27.04.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 04:48:37 -0700 (PDT)
Message-ID: <b5da5c30-7c8b-4c60-aa3b-d2e3603e82c1@bytedance.com>
Date: Sun, 27 Sep 2026 19:48:26 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/3] memcg,writeback: flush foreign bdev mappings
 separately
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 willy@infradead.org, jack@suse.cz, tj@kernel.org, akpm@linux-foundation.org
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
In-Reply-To: <20260922125015.3435215-1-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/22/26 8:50 PM, Julian Sun wrote:

Hi,

Do you have any further thoughts on this series?
Should I rename bdev_flush_by_dev() to bdev_writeback_by_dev()
and send the next revision?

> Hi,
> 
> This series avoids owner-wide foreign writeback triggered by dirtying
> shared bdev inodes. Instead, it tracks bdev targets separately and
> schedules writeback of their mappings.
> 
> Problem
> =======
> 
> Bdev inodes are commonly shared by many memcgs. Dirtying their pages
> can cause the owner wb to be tracked as foreign, triggering writeback
> of the entire wb rather than just the bdev mapping.
> 
> In production, almost all the foreign dirtying we traced came from bdev
> inodes. Across our observations, a bdev mapping had as little as about
> 10 MiB of dirty pages, yet foreign flushes targeted the entire owner
> wb. On one machine, we observed 599 such works queued on one wb, with
> an average request budget of about 43 GiB per work.
> 
> Measured impact
> ===============
> 
> The synthetic test used a VM with 4 vCPUs, 8 GiB RAM, ext4 and cgroup
> v2, with device write bandwidth capped at 200 MiB/s. Background fio
> repeatedly overwrote a 256 MiB file using buffered I/O, while
> foreground fio performed sequential direct writes. Four memcgs
> generated metadata and buffered writes to trigger foreign flushes.
> 
> We measured completed block writes to the background fio file,
> including final sync, and foreground fio bandwidth, latency and
> completion time.
> 
> Across three runs per kernel, mean background file write I/O decreased
> by 72.7%, foreground bandwidth increased by 23.0%, and completion time
> decreased by 18.8%.
> 
> Metric                         Baseline    Patched     Change
> Background file write I/O (GiB)    6.154      1.680     -72.7%
> Foreground bandwidth (MiB/s)      150.29     184.81     +23.0%
> Foreground completion time (s)   109.203     88.652     -18.8%
> Foreground mean latency (ms)      212.84     172.74     -18.8%
> 
> How it helps
> ============
> 
> Frequent writeback of the file overwritten by background fio reduces
> the opportunity to coalesce buffered writes in the page cache.
> Several overwrites of the same page can otherwise result in a single
> write of its latest contents. Flushing between updates instead writes
> the same page repeatedly, generating more device I/O for the same
> application writes.
> 
> This additional I/O makes the device reach its performance limit
> more easily and competes with foreground I/O for device bandwidth.
> 
> The benefit is expected to be most pronounced when these conditions
> occur together on the same device:
> 
> 1. Limited device bandwidth, as with an HDD, makes the additional
>    writeback I/O more likely to saturate the device.
> 2. Multiple cgroups perform buffered overwrites. Frequent foreign
>    writeback reduces write coalescing and increases device I/O.
> 3. Concurrent direct I/O bypasses the page cache and competes directly
>    with writeback I/O for device bandwidth.
> 
> Approach
> ========
> 
> Following Jan's suggestion, this series records foreign bdev targets
> separately and flushes their mappings instead of their owner wbs. This
> preserves a way for dirty throttling to initiate bdev writeback while
> avoiding owner-wide writeback triggered by these records. The existing
> foreign-wb mechanism remains unchanged for other inodes.
> 
> Tracking uses oldest-first replacement and expiry after
> dirty_expire_interval. Further dirtying during an ongoing flush can
> trigger another flush after it finishes.
> 
> Tracking is best effort: each memcg keeps a bounded set of device
> numbers without persistent device or inode references. Recording runs
> under mapping->i_pages with IRQs disabled, while dropping a device
> reference can sleep. A memcg that never enters dirty throttling could
> also retain an unused record and pin the device object indefinitely.
> Recording only dev_t avoids these lifetime constraints. Device removal
> and device-number reuse may cause an unintended best-effort flush,
> which is an accepted trade-off.
> 
> Writeback submission may block for a long time, with up to four work
> items outstanding per memcg. A dedicated unbound workqueue provides
> a separate max_active budget so these flushes do not exhaust active
> slots on a shared workqueue and delay unrelated work. If the workqueue
> cannot be allocated at boot, bdev inodes continue to use the existing
> foreign-wb path.
> 
> This primarily affects filesystems that keep metadata in the bdev page
> cache, such as ext4 and other buffer_head users, rather than the usual
> metadata writeback paths of XFS and Btrfs. This also covers buffered
> writes to raw block devices. The decision still does not account for
> how much of the memcg's dirty memory belongs to the bdev: even a single
> dirty bitmap block can trigger writeback of the entire bdev mapping
> when the memcg enters dirty throttling.
> 
> Changes since v7:
> - Update comments and commit messages as suggested by Tejun Heo.
> 
> Changes since v6:
> - Drop open_mutex and the openers check from bdev_flush_by_dev(), and
>   add a !CONFIG_BLOCK stub.
> - Follow the existing foreign-wb tracking policy: use timestamps for
>   oldest-first replacement and expiry, and allow dirtying during an
>   in-flight flush to re-arm the record.
> - Replace frn_lock with an atomic in-flight flag.
> - Drop WQ_MEM_RECLAIM and explain the separate max_active budget.
> - Expand the dev_t lifetime rationale and filesystem scope, update
>   the foreign-dirty overview, and drop the Fixes tag.
> 
> Changes since v5:
> - Fix repeated overwriting of slot 0 in patch 2 and add comments.
> 
> Changes since v4:
> - Add before-and-after performance comparisons to the cover letter.
> 
> Changes since v3:
> - Flush foreign-dirtied bdev inode mappings separately, as suggested
>   by Jan.
> 
> Thanks.
> 
> Julian Sun (3):
>   block: introduce bdev_flush_by_dev()
>   memcg,writeback: flush foreign bdev mappings separately from owner wbs
>   writeback: record bdev targets in foreign writeback tracepoints
> 
>  block/bdev.c                     |  18 ++++++
>  include/linux/blkdev.h           |   4 ++
>  include/linux/memcontrol.h       |  12 ++++
>  include/trace/events/writeback.h |  22 ++++---
>  mm/memcontrol.c                  | 123 +++++++++++++++++++++++++++++++++++----
>  5 files changed, 160 insertions(+), 19 deletions(-)
> 

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
