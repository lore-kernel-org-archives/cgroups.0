From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge
 infrastructure
Date: Wed, 30 May 2012 14:34:08 +0200
Message-ID: <20120530123406.GC25094@somewhere.redhat.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
 <1337951028-3427-17-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dKMQ3feVs2b7/5rShB7sHUpZxPt/qSZFwqSiV2QlmlA=;
        b=JFl/VzgX24xrfr2gGoYTlBcjolqR8bCDK5z9E0DOsi0St5X/rEIIptop8z9rpOY8zb
         adHNi+f2UWJ6HMnA8nzNl6wuM3RP2VdImk69uMb1e+y/n9L6XRWhOjuXGb4dnCG32HCR
         yBrzI3B44N0TLXYogiC+NcZk+HKNObWkJYf+O3QBZ0bwf5nJfI8XiuqEkkxm41dTLY7W
         YPQjpuZogwOEfP7ClmIg5VbNEJQNXvOMNRf/Xo7Va044/aYRM24supWbKSK5/sd0yJy0
         NJzidNsAeZGGim64eQhi4sV8vYumwOg49oClZytj9w9bRrnezKqpsG6fCwGrIxkOGsEE
         D3Sw==
Content-Disposition: inline
In-Reply-To: <1337951028-3427-17-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Fri, May 25, 2012 at 05:03:36PM +0400, Glauber Costa wrote:
> +bool __mem_cgroup_new_kmem_page(struct page *page, gfp_t gfp)
> +{
> +	struct mem_cgroup *memcg;
> +	struct page_cgroup *pc;
> +	bool ret = true;
> +	size_t size;
> +	struct task_struct *p;
> +
> +	if (!current->mm || in_interrupt())
> +		return true;
> +
> +	rcu_read_lock();
> +	p = rcu_dereference(current->mm->owner);
> +	memcg = mem_cgroup_from_task(p);

So this takes the memcg of the group owner rather than the
task? I understand why we want this for user memory, but for
kernel?
