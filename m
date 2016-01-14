From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: Only free spare array when readers are done
Date: Thu, 14 Jan 2016 15:38:47 +0100
Message-ID: <20160114143847.GD5046@dhcp22.suse.cz>
References: <001a113abaa499606605294b5b17@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <001a113abaa499606605294b5b17-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Martijn Coenen <maco-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 14-01-16 14:33:52, Martijn Coenen wrote:
> A spare array holding mem cgroup threshold events is kept around
> to make sure we can always safely deregister an event and have an
> array to store the new set of events in.
> 
> In the scenario where we're going from 1 to 0 registered events, the
> pointer to the primary array containing 1 event is copied to the spare
> slot, and then the spare slot is freed because no events are left.
> However, it is freed before calling synchronize_rcu(), which means
> readers may still be accessing threshold->primary after it is freed.

Have you seen this triggering in the real life?

> 
> Fixed by only freeing after synchronize_rcu().
> 

Fixes: 8c7577637ca3 ("memcg: free spare array to avoid memory leak")
> Signed-off-by: Martijn Coenen <maco-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: stable

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 14cb1db..73228b6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3522,16 +3522,17 @@ static void
> __mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
>  swap_buffers:
>  	/* Swap primary and spare array */
>  	thresholds->spare = thresholds->primary;
> -	/* If all events are unregistered, free the spare array */
> -	if (!new) {
> -		kfree(thresholds->spare);
> -		thresholds->spare = NULL;
> -	}
> 
>  	rcu_assign_pointer(thresholds->primary, new);
> 
>  	/* To be sure that nobody uses thresholds */
>  	synchronize_rcu();
> +
> +	/* If all events are unregistered, free the spare array */
> +	if (!new) {
> +		kfree(thresholds->spare);
> +		thresholds->spare = NULL;
> +	}
>  unlock:
>  	mutex_unlock(&memcg->thresholds_lock);
>  }
> -- 
> 2.6.0.rc2.230.g3dd15c0

-- 
Michal Hocko
SUSE Labs
