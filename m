From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 1/4] memcg: Track exported dma-buffers
Date: Tue, 10 Jan 2023 09:58:19 +0100
Message-ID: <Y70oqxejnUqkJVPx@dhcp22.suse.cz>
References: <20230109213809.418135-1-tjmercier@google.com>
 <20230109213809.418135-2-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673341100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MQLMOsWeyfQ9OMwOEPpBfSY/zX1K5gLRGoJXs0PRFhQ=;
        b=d0/gJhZr3338arujv292RDCpaFVCNpNRhfmbIWIBvXye7cZy8BnXDKXCy9uBlP+DXmqzhv
        vH5AzxAF9dGjzxCxyUj1ty+EwLrjZ3mqqo1g8JsfnV+KA79R00NSzTgm9DNtTFXOX4Gf8S
        h+jlN7NEV2XA5L/y7LnIoWd7unR8GQs=
Content-Disposition: inline
In-Reply-To: <20230109213809.418135-2-tjmercier@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, daniel.vetter@ffwll.ch, android-mm@google.com, jstultz@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org

On Mon 09-01-23 21:38:04, T.J. Mercier wrote:
> When a buffer is exported to userspace, use memcg to attribute the
> buffer to the allocating cgroup until all buffer references are
> released.
> 
> Unlike the dmabuf sysfs stats implementation, this memcg accounting
> avoids contention over the kernfs_rwsem incurred when creating or
> removing nodes.

I am not familiar with dmabuf infrastructure so please bear with me.
AFAIU this patch adds a dmabuf specific counter to find out the amount
of dmabuf memory used. But I do not see any actual charging implemented
for that memory.

I have looked at two random users of dma_buf_export cma_heap_allocate
and it allocates pages to back the dmabuf (AFAIU) by cma_alloc
which doesn't account to memcg, system_heap_allocate uses
alloc_largest_available which relies on order_flags which doesn't seem
to ever use __GFP_ACCOUNT.

This would mean that the counter doesn't represent any actual memory
reflected in the overall memory consumption of a memcg. I believe this
is rather unexpected and confusing behavior. While some counters
overlap and their sum would exceed the charged memory we do not have any
that doesn't correspond to any memory (at least not for non-root memcgs).

-- 
Michal Hocko
SUSE Labs
