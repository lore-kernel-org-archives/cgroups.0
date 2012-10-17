From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v5 09/14] memcg: kmem accounting lifecycle management
Date: Wed, 17 Oct 2012 16:28:38 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1210171624540.20813@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-10-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=3/7w/g/Ez/mtDNpVkWeK1nKKXMaFbFYD1UWYVoi+Xds=;
        b=PS32P2DXZqcC3QXPT+auLO3ZSHlpT9C6+ntfoMNz7k15tgKH/9yOTXtf/MGWU/i6z4
         46OuPimxE3tWACA4qJbwCCsNYqnoTl+c5V/Bp9Kj3hHqzk/GoJB/CUP+bC3uOPPpTB0h
         wY2rLEeJmIH43LU/EREdp5TCklRoZ5muNNC45PRoAX83qCAaF8HtpV2MCFnJWZSqxncW
         zPBY0RDIqM/92mwHi8KTdJUi/oAOe0es5GONm7It/p8FH5sir27x7N2D1WT+wC+zKItC
         KrT1ZpQuEN27yqYJCUJnzi22QT6v2ZjFD3qQ2DE3WeohioA0YCrYc5umDmk6yzUaY6hb
         HfGQ==
In-Reply-To: <1350382611-20579-10-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, devel@openvz.org, linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On Tue, 16 Oct 2012, Glauber Costa wrote:

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1182188..e24b388 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -344,6 +344,7 @@ struct mem_cgroup {
>  /* internal only representation about the status of kmem accounting. */
>  enum {
>  	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
> +	KMEM_ACCOUNTED_DEAD, /* dead memcg, pending kmem charges */

"dead memcg with pending kmem charges" seems better.

>  };
>  
>  #define KMEM_ACCOUNTED_MASK (1 << KMEM_ACCOUNTED_ACTIVE)
> @@ -353,6 +354,22 @@ static void memcg_kmem_set_active(struct mem_cgroup *memcg)
>  {
>  	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted);
>  }
> +
> +static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
> +{
> +	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted);
> +}

I think all of these should be inline.

> +
> +static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
> +{
> +	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted))
> +		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_accounted);
> +}

The set_bit() doesn't happen atomically with the test_bit(), what 
synchronization is required for this?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
