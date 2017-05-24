From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: per-cgroup memory reclaim stats
Date: Wed, 24 May 2017 11:26:27 -0400
Message-ID: <20170524152627.GA22174@cmpxchg.org>
References: <1494530183-30808-1-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KMbgoZ/GB0WQ6uNjQpcJ3ldrnE5WScTC/BzCAsoW8+A=; b=QzqQJayQgpjrsLXMPoiLhjTJMe
        Goz8H+R+VIzDR+anj95T9H2qff9EZ96dyjJWfSrLxFbUq1kXZ5+SdXqgTQeh7BWqRrc2eltrtP0mV
        5UJRQhH5GCPj/bpQmGDxCjsY4QL2hFwNu/L1fHlCi6pSc1a3IkFcfmqcxWspqYZ8sqQ4=;
Content-Disposition: inline
In-Reply-To: <1494530183-30808-1-git-send-email-guro@fb.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Thu, May 11, 2017 at 08:16:23PM +0100, Roman Gushchin wrote:
> Track the following reclaim counters for every memory cgroup:
> PGREFILL, PGSCAN, PGSTEAL, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE and
> PGLAZYFREED.
> 
> These values are exposed using the memory.stats interface of cgroup v2.
> 
> The meaning of each value is the same as for global counters,
> available using /proc/vmstat.
> 
> Also, for consistency, rename mem_cgroup_count_vm_event() to
> count_memcg_event_mm().
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: cgroups@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Andrew, if there aren't any other objections, could you pick this one
up please?
