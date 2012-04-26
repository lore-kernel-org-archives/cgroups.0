From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/2] decrement static keys on real destroy time
Date: Thu, 26 Apr 2012 14:39:16 -0700
Message-ID: <20120426213916.GD27486@google.com>
References: <1335475463-25167-1-git-send-email-glommer@parallels.com>
 <1335475463-25167-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7WCiP+Y1ikK5VsHJvFn0dCmcun7iS+ygkz55be11s+g=;
        b=dztgceky7fYWRBXimom/rx73nL4T4e4++4Y8O28/kUnGEYWBn0mwLEuaJ+HxiSNHv+
         +N201w2XQjni1vL17g+b253q7WffSI+2gEMBlW3tr9XigmbCrXF4p4mrrPPdsxYjBwvj
         IyRWozndGRddJGfv1ilETddrouoivgZ1nXVHulxHf9zxvIUxD472p1hsDsGYGaDyIAr4
         GJ+wqKF5XvpzNZPAV/H1OCfQcEFSmUa+3lg+xkSbXP0fhJsDjI42k5fm6t34mH6+gQ2X
         nqkxaULF/BebEK+zs97QnYjCsD1472x4pEC1n/3sf67AeZ0eVDVNymL3swbh7HpllKp+
         BaKQ==
Content-Disposition: inline
In-Reply-To: <1335475463-25167-3-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Hello, Glauber.

Overall, I like this approach much better.  Just some nits below.

On Thu, Apr 26, 2012 at 06:24:23PM -0300, Glauber Costa wrote:
> @@ -4836,6 +4851,18 @@ static void free_work(struct work_struct *work)
>  	int size = sizeof(struct mem_cgroup);
>  
>  	memcg = container_of(work, struct mem_cgroup, work_freeing);
> +	/*
> +	 * We need to make sure that (at least for now), the jump label
> +	 * destruction code runs outside of the cgroup lock. It is in theory
> +	 * possible to call the cgroup destruction function outside of that
> +	 * lock, but it is not yet done. rate limiting plus the deferred
> +	 * interface for static_branch destruction guarantees that it will
> +	 * run through schedule_work(), therefore, not holding any cgroup
> +	 * related lock (this is, of course, until someone decides to write
> +	 * a schedule_work cgroup :p )
> +	 */

Isn't the above a bit too verbose?  Wouldn't just stating the locking
dependency be enough?

> +	disarm_static_keys(memcg);
>  	if (size < PAGE_SIZE)
>  		kfree(memcg);
>  	else
> diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
> index 1517037..7790008 100644
> --- a/net/ipv4/tcp_memcontrol.c
> +++ b/net/ipv4/tcp_memcontrol.c
> @@ -54,6 +54,8 @@ int tcp_init_cgroup(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
>  	cg_proto->sysctl_mem = tcp->tcp_prot_mem;
>  	cg_proto->memory_allocated = &tcp->tcp_memory_allocated;
>  	cg_proto->sockets_allocated = &tcp->tcp_sockets_allocated;
> +	cg_proto->active = false;
> +	cg_proto->activated = false;

Isn't the memory zallocd?  I find 0 / NULL / false inits unnecessary
and even misleading (can the memory be non-zero here?).  Another side
effect is that it tends to get out of sync as more fields are added.

> +/*
> + * This is to prevent two writes arriving at the same time
> + * at kmem.tcp.limit_in_bytes.
> + *
> + * There is a race at the first time we write to this file:
> + *
> + * - cg_proto->activated == false for all writers.
> + * - They all do a static_key_slow_inc().
> + * - When we are finally read to decrement the static_keys,
                            ^
                            ready

> + *   we'll do it only once per activated cgroup. So we won't
> + *   be able to disable it.
> + *
> + *   Also, after the first caller increments the static_branch
> + *   counter, all others will return right away. That does not mean,
> + *   however, that the update is finished.
> + *
> + *   Without this mutex, it would then be possible for a second writer
> + *   to get to the update site, return 

I kinda don't follow the above sentence.

> + *   When a user updates limit of 2 cgroups at once, following happens.
> + *
> + *   	CPU A				CPU B
> + *
> + *	if (cg_proto->activated)	if (cg->proto_activated)
> + *		static_key_inc()		static_key_inc()
> + * 		=> set counter 0->1		=> set counter 1->2,
> + * 						return immediately.
> + * 		=> hold mutex			=> cg_proto->activated = true. 
> + * 		=> overwrite jmps.

Isn't this something which should be solved from static_keys API?  Why
is this being worked around from memcg?  Also, I again hope that the
explanation is slightly more concise.

Thanks.

-- 
tejun
