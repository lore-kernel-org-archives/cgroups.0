From: Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH v2] cpuset: use static key better and convert to new API
Date: Thu, 14 Apr 2016 16:28:50 +0800
Message-ID: <570F54C2.2000300@huawei.com>
References: <1459931973-29247-1-git-send-email-vbabka@suse.cz>
 <1459934392-12756-1-git-send-email-vbabka@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1459934392-12756-1-git-send-email-vbabka@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On 2016/4/6 17:19, Vlastimil Babka wrote:
> An important function for cpusets is cpuset_node_allowed(), which optimizes on
> the fact if there's a single root CPU set, it must be trivially allowed. But
> the check "nr_cpusets() <= 1" doesn't use the cpusets_enabled_key static key
> the right way where static keys eliminate branching overhead with jump labels.
> 
> This patch converts it so that static key is used properly. It's also switched
> to the new static key API and the checking functions are converted to return
> bool instead of int. We also provide a new variant __cpuset_zone_allowed()
> which expects that the static key check was already done and they key was
> enabled. This is needed for get_page_from_freelist() where we want to also
> avoid the relatively slower check when ALLOC_CPUSET is not set in alloc_flags.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Looks good to me.

Acked-by: Zefan Li <lizefan@huawei.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
