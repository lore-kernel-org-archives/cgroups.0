From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] memcg: hugetlbfs basic usage accounting
Date: Tue, 14 Nov 2017 13:06:07 -0800
Message-ID: <20171114210607.GT983427@devbig577.frc2.facebook.com>
References: <20171114172429.8916-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jxSasMaNqq/n7hprzjeCHQIkMj+pAjvtTPLDgeKyPPs=;
        b=AAzmoYh31u9MupOw6WNQtzBUDHA7bwCvYY9EBjTk30Ey3IauArmGN6weUXyyC7CIT6
         bZaA5EMqay8eIfi8nEk0oJkv+2tOQ5NkxYnMJD4V3INYzBxlM4bJNO+SzITnbFzgufn3
         9VlYtYDi7wSb53er2e/YAcGGDCV+KV1NPZFHhStb5JLvKG9IHC6qKZ4qFfIpt2JjPXM0
         yRJjgW9vdDrTInRsDvWYmTL0qW/EsseDtcUk3bONwk1rb2lX72r89sgI67LeP/vSwxkt
         zRc8433yauFYWxfeFvVvQOiZva+h7dhb0evmmOYad5wKk6V5LioOs3hUzsxvOV6ok9cC
         rqvw==
Content-Disposition: inline
In-Reply-To: <20171114172429.8916-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Kravetz <mike.kravetz@oracle.com>, Dave Hansen <dave.hansen@intel.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 14, 2017 at 05:24:29PM +0000, Roman Gushchin wrote:
> This patch implements basic accounting of memory consumption
> by hugetlbfs pages for cgroup v2 memory controller.
> 
> Cgroup v2 memory controller lacks any visibility into the
> hugetlbfs memory consumption. Cgroup v1 implemented a separate
> hugetlbfs controller, which provided such stats, and also
> provided some control abilities. Although porting of the
> hugetlbfs controller to cgroup v2 is arguable a good idea and
> is outside of scope of this patch, it's very useful to have
> basic stats provided by memory.stat.
> 
> As hugetlbfs memory can easily represent a big portion of total
> memory, it's important to understand who (which memcg/container)
> is using it.
> 
> The number is represented in memory.stat as "hugetlb" in bytes and
> is printed unconditionally. Accounting code doesn't depend on
> cgroup v1 hugetlb controller.
> 
> Example:
>   $ cat /sys/fs/cgroup/user.slice/user-0.slice/session-1.scope/memory.stat
>   anon 1634304
>   file 1163264
>   kernel_stack 16384
>   slab 737280
>   sock 0
>   shmem 0
>   file_mapped 32768
>   file_dirty 4096
>   file_writeback 0
>   inactive_anon 0
>   active_anon 1634304
>   inactive_file 65536
>   active_file 1097728
>   unevictable 0
>   slab_reclaimable 282624
>   slab_unreclaimable 454656
>   hugetlb 1073741824
>   pgfault 4580
>   pgmajfault 13
>   ...
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: kernel-team@fb.com
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
