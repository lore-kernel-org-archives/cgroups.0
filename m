From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 11:04:51 -0700
Message-ID: <20120626180451.GP3869@google.com>
References: <1340725634-9017-1-git-send-email-glommer@parallels.com>
 <1340725634-9017-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=E1CbvPXDKkOCcmRu4KVXcAOsrnh8qZysYbA5QnD7P+c=;
        b=zkNGGrIw2ncq1i/dkKt0mvtNTkxWKIPcGbnhgmVFxca2M/0zCHe0Hdw2hB3ViXiqDI
         eWl3fOndVTfMGXjl+b+HskTTdC2m/z6+3zwG9R65prEwdcoqi0FTcS4QTTTr1iVFEtjF
         jPzXHi1TqgnBDnrpsfjek1mi1kA1biFj34pdNAEOyWuHPM7rJ9eH45ofSi7KmcqRODJ7
         i45u/Y4MMBKphkj0PgLcy8ss6tcQxbbSUbMYjkZLgHnjs2KnlARIiCQcRALH8RUjR/vk
         de5+KUVo/HNNGMuPWdFs/0aUxGUW7mvU6+cy++28wdDzNd8M9w5QzuLuUHeH+NulJEym
         iRXQ==
Content-Disposition: inline
In-Reply-To: <1340725634-9017-3-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Jun 26, 2012 at 07:47:14PM +0400, Glauber Costa wrote:
> Okay, so after recent discussions, I am proposing the following
> patch. It won't remove hierarchy, or anything like that. Just default
> to true in the root cgroup, and print a warning once if you try
> to set it back to 0.
> 
> I am not adding it to feature-removal-schedule.txt because I don't
> view it as a consensus. Rather, changing the default would allow us
> to give it a time around in the open, and see if people complain
> and what we can learn about that.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  mm/memcontrol.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 85f7790..c37e4c1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3993,6 +3993,10 @@ static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
>  	if (memcg->use_hierarchy == val)
>  		goto out;
>  
> +	WARN_ONCE(!parent_memcg && memcg->use_hierarchy,
> +	"Non-hierarchical memcg is considered for deprecation\n"
> +	"Please consider reorganizing your tree to work with hierarchical accounting\n"
> +	"If you have any reason not to, let us know at cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org\n");
>  	/*
>  	 * If parent's use_hierarchy is set, we can't make any modifications
>  	 * in the child subtrees. If it is unset, then the change can
> @@ -5221,6 +5225,7 @@ mem_cgroup_create(struct cgroup *cont)
>  			INIT_WORK(&stock->work, drain_local_stock);
>  		}
>  		hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
> +		memcg->use_hierarchy = true;
>  	} else {
>  		parent = mem_cgroup_from_cont(cont->parent);
>  		memcg->use_hierarchy = parent->use_hierarchy;

So, ummm, I don't think we can do this.  We CAN NOT silently flip the
default behavior like this.  Hell, no.  What we can do is something
like the following.

1. Make .use_hierarchy a global property and convert .use_hierarchy
   file to reject writes to the setting which is different from the
   global one.  Rip out partial hierarchy related code (how little
   they may be).  Note that the default should still be flat
   hierarchy.

2. Mark flat hierarchy deprecated and produce a warning message if
   memcg is mounted w/o hierarchy option for a year or two.

3. After the existing users had enough chance to move away from flat
   hierarchy, rip out flat hierarchy code and error if hierarchy
   option is not specified.

Later on, we may decide to get rid of the hierarchy mount option but I
don't think that matters all that much.

Thanks.

-- 
tejun
