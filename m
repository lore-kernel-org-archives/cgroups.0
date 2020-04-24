From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: optimize memory.numa_stat like memory.stat
Date: Thu, 23 Apr 2020 22:38:52 -0400
Message-ID: <20200424023852.GA464082@cmpxchg.org>
References: <20200304022058.248270-1-shakeelb@google.com>
 <20200305204109.be23f5053e2368d3b8ccaa06@linux-foundation.org>
 <CALvZod7W-Qwa4BRKW0_Ts5f68fwkcqD72SF_4NqZRgEMgA_1-g@mail.gmail.com>
 <CALvZod4R68wNgzOF9dN=i6LwyUYMBhvM7SXaRJGW9Wn_SmeGGA@mail.gmail.com>
 <20200423161009.973c645420a4d17ded2a67ee@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ldECbwkx2KzC+gjraTT+5K+gEB5icL0nRQIC9XPuGkU=;
        b=Ddtvcj1n3A2iRjbjaGXKb42PeJjcfV41WkfP5jznQsOoAXtq4Aq0YAI+jC0sCsKnvx
         3ZUlrZSEr3HUWZp9NZZUR0WJE+gtm9Uewof/FeE8jRb+3r2wee/XOWlmOAmQMF85e2cW
         QBsM3r65qePLq09dyRU//VQ1HxsdWxOOkQ5hV/kB6m09C/86n/XsphQWiUecxZrtcy5j
         EFolcHbY7QejWuMaqC22oW+PcDruwHWEGwRIKo9ovvU5K4MZuxo++hLjAlegnyZ2T3hU
         mBUEvRefs3krgdLJT5E4/GkLAylz+osjnZ55rZwa2wXOUEN0L6QFj3VRgJErkjjZe4Gy
         UfrA==
Content-Disposition: inline
In-Reply-To: <20200423161009.973c645420a4d17ded2a67ee@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Thu, Apr 23, 2020 at 04:10:09PM -0700, Andrew Morton wrote:
> From: Shakeel Butt <shakeelb@google.com>
> Subject: mm/memcg: optimize memory.numa_stat like memory.stat
> 
> Currently reading memory.numa_stat traverses the underlying memcg tree
> multiple times to accumulate the stats to present the hierarchical view of
> the memcg tree.  However the kernel already maintains the hierarchical
> view of the stats and use it in memory.stat.  Just use the same mechanism
> in memory.numa_stat as well.
> 
> I ran a simple benchmark which reads root_mem_cgroup's memory.numa_stat
> file in the presense of 10000 memcgs.  The results are:
> 
> Without the patch:
> $ time cat /dev/cgroup/memory/memory.numa_stat > /dev/null
> 
> real    0m0.700s
> user    0m0.001s
> sys     0m0.697s
> 
> With the patch:
> $ time cat /dev/cgroup/memory/memory.numa_stat > /dev/null
> 
> real    0m0.001s
> user    0m0.001s
> sys     0m0.000s
> 
> [akpm@linux-foundation.org: avoid forcing out-of-line code generation]
> Link: http://lkml.kernel.org/r/20200304022058.248270-1-shakeelb@google.com
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Ouch, yes. That makes sense.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
