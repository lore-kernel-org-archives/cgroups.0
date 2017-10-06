From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v11 4/6] mm, oom: introduce memory.oom_group
Date: Fri, 6 Oct 2017 13:04:35 +0100
Message-ID: <20171006120435.GA22702@castle.dhcp.TheFacebook.com>
References: <20171005130454.5590-1-guro@fb.com>
 <20171005130454.5590-5-guro@fb.com>
 <20171005143104.wo5xstpe7mhkdlbr@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=tXwtSOcfYLwvh3iZmMOjapkkENGMReU7Md40od88YU4=;
 b=mUQzSe4fO8wcR2PAnJn8y2rEpYtgFHkZ9Ohhv9yePLiBpaP203K5MHB1CvHa9OXzwsNq
 0mWGiYm/kzAEfSqkFWJXAIt4CDYlPQNsBmTb2Wq8trrsJ1SFpVx9SdLprmUvepXyQ7mi
 vZrwQ4PxuusIL/Qr+l2kv/fNrNwEiE1PToo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=tXwtSOcfYLwvh3iZmMOjapkkENGMReU7Md40od88YU4=;
 b=R3/c97s5pu/hNhbFe88HdjxFkAw5sR7yoLQXD64Zb6CzV06ePwUdwv8fHXLvQVqIII5v7ehoMkTgJZP+3AJtd4+SYkVCZLBku1iNB+EXyd7XIXZrc0VNmKI1ndnkX7YQCiAyQKow328svxBqniovbXjYNuXHwM3mn8GIG9jJTp4=
Content-Disposition: inline
In-Reply-To: <20171005143104.wo5xstpe7mhkdlbr-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 05, 2017 at 04:31:04PM +0200, Michal Hocko wrote:
> Btw. here is how I would do the recursive oom badness. The diff is not
> the nicest one because there is some code moving but the resulting code
> is smaller and imho easier to grasp. Only compile tested though

Thanks!

I'm not against this approach, and maybe it can lead to a better code,
but the version you sent is just not there yet.

There are some problems with it:

1) If there are nested cgroups with oom_group set, you will calculate
a badness multiple times, and rely on the fact, that top memcg will
become the largest score. It can be optimized, of course, but it's
additional code.

2) cgroup_has_tasks() probably requires additional locking.
Maybe it's ok to read nr_populated_csets without explicit locking,
but it's not obvious for me.

3) Returning -1 from memcg_oom_badness() if eligible is equal to 0
is suspicious.

Right now your version has exactly the same amount of code
(skipping comments). I assume, this approach just requires some additional
thinking/rework.

Anyway, thank you for sharing this!

> ---
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 085056e562b1..9cdba4682198 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -122,6 +122,11 @@ void cgroup_free(struct task_struct *p);
>  int cgroup_init_early(void);
>  int cgroup_init(void);
>  
> +static bool cgroup_has_tasks(struct cgroup *cgrp)
> +{
> +	return cgrp->nr_populated_csets;
> +}
> +
>  /*
>   * Iteration helpers and macros.
>   */
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 8dacf73ad57e..a2dd7e3ffe23 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -319,11 +319,6 @@ static void cgroup_idr_remove(struct idr *idr, int id)
>  	spin_unlock_bh(&cgroup_idr_lock);
>  }
>  
> -static bool cgroup_has_tasks(struct cgroup *cgrp)
> -{
> -	return cgrp->nr_populated_csets;
> -}
> -
>  bool cgroup_is_threaded(struct cgroup *cgrp)
>  {
>  	return cgrp->dom_cgrp != cgrp;
