From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
Date: Tue, 16 Oct 2012 11:44:24 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1210161142390.2910@chino.kir.corp.google.com>
References: <1350382328-28977-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=J98pmGPNEyHmNLNRpdvTvWrg4wEjK7nhqAAsLT3Skrw=;
        b=LgW0P64awiX2VGpLE/wxfl/Lc8WrpR7A75SxGvgAbZIjNukfZbfGoyG83YwwjIViq0
         K+kvdBSNkiXF9nz0oY2tzCMtwfY9oYJDRviQkr3kshCy656fFXih18dYmDG/FZOoEEGu
         VZ42znqRXIKVQ+PaDw9b+oPMhQ+FEazbE2zTLRr8SQ31uzWlzkYOCstvszfxIbou0LQm
         HaN3gDJ3iR4zksSD+WjBni9LIQBoOOHFxSQ7H3iu6EnIdz/NDU5GO11fVb4z9lzI55FF
         5d38NDhaS1tJMdrY2bm+13zdO4vK7J2aEe9BsB6RC+X8j2D4GSydKBJOhPhQWDN2/jv1
         Glyw==
In-Reply-To: <1350382328-28977-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Tue, 16 Oct 2012, Sha Zhengju wrote:

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e4e9b18..c329940 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1486,6 +1486,15 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  
>  	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
>  	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
> +	if (sysctl_oom_kill_allocating_task && current->mm &&
> +	    !oom_unkillable_task(current, memcg, NULL) &&
> +	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
> +		get_task_struct(current);
> +		oom_kill_process(current, gfp_mask, order, 0, totalpages, memcg, NULL,
> +				 "Memory cgroup out of memory (oom_kill_allocating_task)");
> +		return;
> +	}
> +
>  	for_each_mem_cgroup_tree(iter, memcg) {
>  		struct cgroup *cgroup = iter->css.cgroup;
>  		struct cgroup_iter it;

Please try to compile your patches and run scripts/checkpatch.pl on them 
before proposing them.

You'll also need to update Documentation/sysctl/vm.txt.
