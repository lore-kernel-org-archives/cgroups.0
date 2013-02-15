From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 3/7] lru: add an element to a memcg list
Date: Thu, 14 Feb 2013 17:32:31 -0800
Message-ID: <xr93txpemkeo.fsf@gthelen.mtv.corp.google.com>
References: <1360328857-28070-1-git-send-email-glommer@parallels.com>
	<1360328857-28070-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=x-received:from:to:cc:subject:references:date:message-id:user-agent
         :mime-version:content-type;
        bh=yLklFB49Wput6X2fB3uKXyqSbTFgGCJqW7Dq65xcuws=;
        b=pcOR6CwzMvjf8m0nWQ8aCB1asCNGoEHKPiI4mW4q9ADAOV6iYUG65R52vBdIBhhOMe
         FHhKKkQ3NixvMJp8SLFM9HhjjXH1CNmylkqQZjrmSpTO48HTovVWI3435dj4p1Ah1OGN
         dmwGSYnYml0M+QvBKTzN+/64Uii28cb7EqkPQNF6Nz2NrRsY1h7zVpbjRj2DvIsKxAr+
         ZBqf0sPqWh4rMRVpX2no9VCFn6EhzZWgwdJfl+MWCamfz4u3Jzx1VYXFs7dpRi7CsNRX
         sVRmGFlXovGmFSmuYtwGBgD2Hbda29hyejJkNndBGKcEoF3UgdtF/oNYH+Fgzvmlyk9G
         BRwg==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, Dave Shrinnker <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>

On Fri, Feb 08 2013, Glauber Costa wrote:

> With the infrastructure we now have, we can add an element to a memcg
> LRU list instead of the global list. The memcg lists are still
> per-node.

[...]

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b9e1941..bfb4b5b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3319,6 +3319,36 @@ static inline void memcg_resume_kmem_account(void)
>  	current->memcg_kmem_skip_account--;
>  }
>  
> +static struct mem_cgroup *mem_cgroup_from_kmem_page(struct page *page)
> +{
> +	struct page_cgroup *pc;
> +	struct mem_cgroup *memcg = NULL;
> +
> +	pc = lookup_page_cgroup(page);
> +	if (!PageCgroupUsed(pc))
> +		return NULL;
> +
> +	lock_page_cgroup(pc);
> +	if (PageCgroupUsed(pc))
> +		memcg = pc->mem_cgroup;
> +	unlock_page_cgroup(pc);

Once we drop the lock, is there anything that needs protection
(e.g. PageCgroupUsed)?  If there's no problem, then what's the point of
taking the lock?

> +	return memcg;
> +}
> +

[...]

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
