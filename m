From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [RFC PATCH 01/23 V2] node_states: introduce N_MEMORY
Date: Sat, 4 Aug 2012 21:38:41 +0800
Message-ID: <CAJd=RBDwhrA1v_uzqnmsnuoA1R9R=PoU8VJua868nvJqf2D+Hw@mail.gmail.com>
References: <1343875991-7533-1-git-send-email-laijs@cn.fujitsu.com>
	<1343875991-7533-2-git-send-email-laijs@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=xy5nDkqeH9++55mh7kDKHoactsGRSMUE6ria6i5Jtw0=;
        b=pLdjoSTWw9MzwzwY0T8t3iq+AlHfdLwXChkrBNMGAPol2oGP0PSPQDWHLe/PBGP3Wo
         SbGrboYhpIhHqw8jC0tfHn5Pk/NCuVipeZTxcDqBCndj5/CAoShwVyMaXKO/OXxY1Dt6
         z86cFRzIm0ha1en+gYmWQ5B7dHpqyPOyYn3TV2sl2eaBNrLnYBKCyChvmNIwIHl67VLp
         5HgvBiBxkyGOAhLtMMNKDsxB71FcbEuAQ0fXJgaF4Q0fEBWucwcWeMju6HrOVMw1Hqre
         dzxmiKhn1j/yR6rvXrFLuwLuOGiV7cVTj0DKdBdnwB62pDZJ5IIeyJMl4hb2Xzc34MdE
         XVtw==
In-Reply-To: <1343875991-7533-2-git-send-email-laijs@cn.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Paul Menage <paul@paulmenage.org>, Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matt Fleming <matt.fleming@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>, Bjorn Helgaas <bhelgaas@google.com>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Petr

On Thu, Aug 2, 2012 at 10:52 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> We have N_NORMAL_MEMORY for standing for the nodes that have normal memory with
> zone_type <= ZONE_NORMAL.
>
> And we have N_HIGH_MEMORY for standing for the nodes that have normal or high
> memory.
>
> But we don't have any word to stand for the nodes that have *any* memory.
>
> And we have N_CPU but without N_MEMORY.
>
> Current code reuse the N_HIGH_MEMORY for this purpose because any node which
> has memory must have high memory or normal memory currently.
>
> A)      But this reusing is bad for *readability*. Because the name
>         N_HIGH_MEMORY just stands for high or normal:
>
> A.example 1)
>         mem_cgroup_nr_lru_pages():
>                 for_each_node_state(nid, N_HIGH_MEMORY)
>
>         The user will be confused(why this function just counts for high or
>         normal memory node? does it counts for ZONE_MOVABLE's lru pages?)
>         until someone else tell them N_HIGH_MEMORY is reused to stand for
>         nodes that have any memory.
>
> A.cont) If we introduce N_MEMORY, we can reduce this confusing
>         AND make the code more clearly:
>
> A.example 2) mm/page_cgroup.c use N_HIGH_MEMORY twice:
>
>         One is in page_cgroup_init(void):
>                 for_each_node_state(nid, N_HIGH_MEMORY) {
>
>         It means if the node have memory, we will allocate page_cgroup map for
>         the node. We should use N_MEMORY instead here to gaim more clearly.
>
>         The second using is in alloc_page_cgroup():
>                 if (node_state(nid, N_HIGH_MEMORY))
>                         addr = vzalloc_node(size, nid);
>
>         It means if the node has high or normal memory that can be allocated
>         from kernel. We should keep N_HIGH_MEMORY here, and it will be better
>         if the "any memory" semantic of N_HIGH_MEMORY is removed.
>
> B)      This reusing is out-dated if we introduce MOVABLE-dedicated node.
>         The MOVABLE-dedicated node should not appear in
>         node_stats[N_HIGH_MEMORY] nor node_stats[N_NORMAL_MEMORY],
>         because MOVABLE-dedicated node has no high or normal memory.
>
>         In x86_64, N_HIGH_MEMORY=N_NORMAL_MEMORY, if a MOVABLE-dedicated node
>         is in node_stats[N_HIGH_MEMORY], it is also means it is in
>         node_stats[N_NORMAL_MEMORY], it causes SLUB wrong.
>
>         The slub uses
>                 for_each_node_state(nid, N_NORMAL_MEMORY)
>         and creates kmem_cache_node for MOVABLE-dedicated node and cause problem.
>
> In one word, we need a N_MEMORY. We just intrude it as an alias to
> N_HIGH_MEMORY and fix all im-proper usages of N_HIGH_MEMORY in late patches.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---

Acked-by: Hillf Danton <dhillf@gmail.com>


>  include/linux/nodemask.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 7afc363..c6ebdc9 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -380,6 +380,7 @@ enum node_states {
>  #else
>         N_HIGH_MEMORY = N_NORMAL_MEMORY,
>  #endif
> +       N_MEMORY = N_HIGH_MEMORY,
>         N_CPU,          /* The node has one or more cpus */
>         NR_NODE_STATES
>  };
> --
> 1.7.1
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
