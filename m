From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 1/2] fix bad behavior in use_hierarchy file
Date: Tue, 26 Jun 2012 15:25:22 -0700
Message-ID: <20120626152522.c7161b5a.akpm@linux-foundation.org>
References: <1340725634-9017-1-git-send-email-glommer@parallels.com>
	<1340725634-9017-2-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340725634-9017-2-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, 26 Jun 2012 19:47:13 +0400
Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3989,6 +3989,10 @@ static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
>  		parent_memcg = mem_cgroup_from_cont(parent);
>  
>  	cgroup_lock();
> +
> +	if (memcg->use_hierarchy == val)
> +		goto out;
> +
>  	/*
>  	 * If parent's use_hierarchy is set, we can't make any modifications
>  	 * in the child subtrees. If it is unset, then the change can
> @@ -4005,6 +4009,8 @@ static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
>  			retval = -EBUSY;
>  	} else
>  		retval = -EINVAL;
> +
> +out:
>  	cgroup_unlock();
>  
>  	return retval;

hm.  The various .write_u64() implementations go and return zero on
success and cgroup_write_X64() sees this and rewrites the return value
to `nbytes'.

That was a bit naughty of us - it prevents a .write_u64() instance from
being able to fully implement a partial write.  We can *partially*
implement a partial write, by returning a value between 1 and nbytes-1,
but we can't return zero.  It's a weird interface, it's a surprising
interface and it was quite unnecessary to do it this way.  Someone
please slap Paul.

It's hardly a big problem I, but that's why the unix write() interface
was designed the way it is.
