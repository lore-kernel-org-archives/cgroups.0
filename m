From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Thu, 31 Mar 2022 15:25:11 -0400
Message-ID: <YkYAFxTgo4OsL4q4@cmpxchg.org>
References: <20220331084151.2600229-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vyEyFUKqryt9zBzJe2Z7xpXuyc7SpWk9id19kGwXgKM=;
        b=mEMZuaiSHC0FBEUUP25G6KwZkLY4fMTbC8nkggOHXCQ/rM2A8QlY/nhB4znsxN8X9w
         0jeQiv+bQGLWX0qeKRehzPVnXaW+Q8ZCCepBvbNi3xIV8pEDnpbycgEhOGONjdxalGsx
         9pYzWnpcjILDPK/VxTHTnMbiOIl/m/ZDNCyBhP+rCo6pD7FSWUgRr9B1F2mzbadBoEOq
         MENdNcglup1LzOJdJaWye2ZZlN3INJM9XB+m7+M5ya+XfHYGoDkDEbbJ6rdk+qi8Z+lS
         yUX/W/uL/945ytaEli3+xdaOUNHQdReLI2rZXgPFC7SQ7uLSX4in12E1YEzscjaqpQdU
         ZyDQ==
Content-Disposition: inline
In-Reply-To: <20220331084151.2600229-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>

On Thu, Mar 31, 2022 at 08:41:51AM +0000, Yosry Ahmed wrote:
> From: Shakeel Butt <shakeelb@google.com>
> 
> Introduce an memcg interface to trigger memory reclaim on a memory cgroup.
> 
> Use case: Proactive Reclaim
> ---------------------------
> 
> A userspace proactive reclaimer can continuously probe the memcg to
> reclaim a small amount of memory. This gives more accurate and
> up-to-date workingset estimation as the LRUs are continuously
> sorted and can potentially provide more deterministic memory
> overcommit behavior. The memory overcommit controller can provide
> more proactive response to the changing behavior of the running
> applications instead of being reactive.
> 
> A userspace reclaimer's purpose in this case is not a complete replacement
> for kswapd or direct reclaim, it is to proactively identify memory savings
> opportunities and reclaim some amount of cold pages set by the policy
> to free up the memory for more demanding jobs or scheduling new jobs.
> 
> A user space proactive reclaimer is used in Google data centers.
> Additionally, Meta's TMO paper recently referenced a very similar
> interface used for user space proactive reclaim:
> https://dl.acm.org/doi/pdf/10.1145/3503222.3507731
> 
> Benefits of a user space reclaimer:
> -----------------------------------
> 
> 1) More flexible on who should be charged for the cpu of the memory
> reclaim. For proactive reclaim, it makes more sense to be centralized.
> 
> 2) More flexible on dedicating the resources (like cpu). The memory
> overcommit controller can balance the cost between the cpu usage and
> the memory reclaimed.
> 
> 3) Provides a way to the applications to keep their LRUs sorted, so,
> under memory pressure better reclaim candidates are selected. This also
> gives more accurate and uptodate notion of working set for an
> application.
> 
> Why memory.high is not enough?
> ------------------------------
> 
> - memory.high can be used to trigger reclaim in a memcg and can
>   potentially be used for proactive reclaim.
>   However there is a big downside in using memory.high. It can potentially
>   introduce high reclaim stalls in the target application as the
>   allocations from the processes or the threads of the application can hit
>   the temporary memory.high limit.
> 
> - Userspace proactive reclaimers usually use feedback loops to decide
>   how much memory to proactively reclaim from a workload. The metrics
>   used for this are usually either refaults or PSI, and these metrics
>   will become messy if the application gets throttled by hitting the
>   high limit.
> 
> - memory.high is a stateful interface, if the userspace proactive
>   reclaimer crashes for any reason while triggering reclaim it can leave
>   the application in a bad state.
> 
> - If a workload is rapidly expanding, setting memory.high to proactively
>   reclaim memory can result in actually reclaiming more memory than
>   intended.
> 
> The benefits of such interface and shortcomings of existing interface
> were further discussed in this RFC thread:
> https://lore.kernel.org/linux-mm/5df21376-7dd1-bf81-8414-32a73cea45dd@google.com/
> 
> Interface:
> ----------
> 
> Introducing a very simple memcg interface 'echo 10M > memory.reclaim' to
> trigger reclaim in the target memory cgroup.
> 
> 
> Possible Extensions:
> --------------------
> 
> - This interface can be extended with an additional parameter or flags
>   to allow specifying one or more types of memory to reclaim from (e.g.
>   file, anon, ..).
> 
> - The interface can also be extended with a node mask to reclaim from
>   specific nodes. This has use cases for reclaim-based demotion in memory
>   tiering systens.
> 
> - A similar per-node interface can also be added to support proactive
>   reclaim and reclaim-based demotion in systems without memcg.
> 
> For now, let's keep things simple by adding the basic functionality.
> 
> [yosryahmed@google.com: refreshed to current master, updated commit
> message based on recent discussions and use cases]
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks for compiling all the history and arguments around this change!
