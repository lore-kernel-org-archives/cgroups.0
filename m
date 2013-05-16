From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch v3 -mm 3/3] vmscan, memcg: Do softlimit reclaim also for
 targeted reclaim
Date: Thu, 16 May 2013 16:12:38 -0700
Message-ID: <20130516231238.GA15025@mtj.dyndns.org>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz>
 <1368431172-6844-4-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=heUSpuIzV9QcCPJz3sVs5HmLCktAwaPsPcOYbbKSDg0=;
        b=Pydya1jCReZRZfrCefPK2MROIWQrOSrCgf9WpjsxgUiznHFZYZ8olGNzcKmeWdjGGR
         mbPGzK/acCynuf4iMBhYwhe98V6Qh7Ts5s7zxNd/Ns+DLDFlCVasWgKkVl7ib/Ucrffd
         NxQviKs8nxp5xJMV0CRtaIC+IRrJ5K/mJGXe7gmNEraOpB5MyiZ0RgL2wDrXrmMPDjtP
         Wpd2OOyl8/v8N9aVQ7n1LPg7hA1nSNlZgim0j/UvcbbVwtX2JdVaY1rIJ0aN4gR64GCe
         /hdfVg2uf18bIBERMffDrkXIe9vj+ePlb0LJxSEIcbrewsIwqD0ZuJQgqdS/L3Klfggg
         2W6w==
Content-Disposition: inline
In-Reply-To: <1368431172-6844-4-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>, Glauber Costa <glommer@parallels.com>, Michel Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>

On Mon, May 13, 2013 at 09:46:12AM +0200, Michal Hocko wrote:
> Soft reclaim has been done only for the global reclaim (both background
> and direct). Since "memcg: integrate soft reclaim tighter with zone
> shrinking code" there is no reason for this limitation anymore as the
> soft limit reclaim doesn't use any special code paths and it is a
> part of the zone shrinking code which is used by both global and
> targeted reclaims.
...
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

 Reviewed-by: Tejun Heo <tj@kernel.org>

Some nitpicks follow.

>  /*
> - * A group is eligible for the soft limit reclaim if it is
> - * 	a) is over its soft limit
> + * A group is eligible for the soft limit reclaim under the given root
> + * hierarchy if
> + * 	a) it is over its soft limit
>   * 	b) any parent up the hierarchy is over its soft limit

This was added before but in general I think the use of parent for
ancestor is a bit confusing.  Not a big deal but no reason to continue
it.

>  	/*
> -	 * If any parent up the hierarchy is over its soft limit then we
> -	 * have to obey and reclaim from this group as well.
> +	 * If any parent up to the root in the hierarchy is over its soft limit
> +	 * then we have to obey and reclaim from this group as well.

Prolly using terms ancestors and subtree would make the explanation
clearer?

>  static bool mem_cgroup_should_soft_reclaim(struct scan_control *sc)
>  {
> -	return global_reclaim(sc);
> +	return true;

Kinda silly after this change, maybe just modify shrink_zone() like
the following?

        if (IS_ENABLED(CONFIG_MEMCG)) {
		__shrink_zone(zone, sc, true);
		if (sc->nr_scanned == nr_scanned)
			__shrink_zone(zone, sc, false);
	} else {
		__shrink_zone(zone, sc, false);
        }

> @@ -1974,7 +1974,7 @@ __shrink_zone(struct zone *zone, struct scan_control *sc, bool soft_reclaim)
>  			struct lruvec *lruvec;
>  
>  			if (soft_reclaim &&
> -					!mem_cgroup_soft_reclaim_eligible(memcg)) {
> +					!mem_cgroup_soft_reclaim_eligible(memcg, root)) {

Weird indentation which breaks line and goes over 80 col, why not do
the following?

		if (soft_reclaim &&
		    !mem_cgroup_soft_reclaim_eligible(memcg, root)) {
			memcg = mem_cgroup_iter(root, memcg, &reclaim);
			continue;
		}

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
