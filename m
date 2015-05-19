From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/7] memcg: immigrate charges only when a threadgroup
 leader is moved
Date: Tue, 19 May 2015 14:13:21 +0200
Message-ID: <20150519121321.GB6203@dhcp22.suse.cz>
References: <1431978595-12176-1-git-send-email-tj@kernel.org>
 <1431978595-12176-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=M8ZrlW2p5O5Joymd0gN9ZJjwYehnTVutvpDuvKRRXMk=;
        b=Ke7sTqxP60D2Oezo1EwTCTmhzGsQh+KuAnm/aQuBtoBduPRhQ7W9N4btpWgbKykgrP
         9HNGVEWzF603mmjj99frOxYrsHJhybhbWWyX3zgWjNW6H1KXmLacuJ15vABOleF2mtnw
         sR2CRcuDXM6EiJVd8S0nYDChpoqClNmz+/cEbfJ4y+h/D/ar/s169b76Pnc6U8MK9ud+
         uiRq1FZ8nwCznUyal6feaNGqwEmh2LMvklrAGYPndGdbFAqCCdLAGQey0zNICaCqeI/T
         Uta/OsocIF17flFhHZ5fG1T2G9I8MbQLLY7CfKP9k5Q1Jrc/LthHs0QE8HQt3k4xSDIR
         fmAw==
Content-Disposition: inline
In-Reply-To: <1431978595-12176-4-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 18-05-15 15:49:51, Tejun Heo wrote:
> If move_charge flag is set, memcg tries to move memory charges to the
> destnation css.  The current implementation migrates memory whenever
> any thread of a process is migrated making the behavior somewhat
> arbitrary. 

This is not true. We have:
                mm = get_task_mm(p);
                if (!mm)
                        return 0;
                /* We move charges only when we move a owner of the mm */
                if (mm->owner == p) {

So we are ignoring threads which are not owner of the mm struct and that
should be the thread group leader AFAICS.

mm_update_next_owner is rather complex (maybe too much and it would
deserve some attention) so there might really be some corner cases but
the whole memcg code relies on mm->owner rather than thread group leader
so I would keep the same logic here.

> Let's tie memory operations to the threadgroup leader so
> that memory is migrated only when the leader is migrated.

This would lead to another strange behavior when the group leader is not
owner (if that is possible at all) and the memory wouldn't get migrated
at all.

I am trying to wrap my head around mm_update_next_owner and maybe we can
change it to use the thread group leader but this needs more thinking...

> While this is a behavior change, given the inherent fuziness, this
> change is not too likely to be noticed and allows us to clearly define
> who owns the memory (always the leader) and helps the planned atomic
> multi-process migration.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> ---
>  mm/memcontrol.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b1b834d..74fcea3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5014,6 +5014,9 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
>  		return 0;
>  
>  	p = cgroup_taskset_first(tset);
> +	if (!thread_group_leader(p))
> +		return 0;
> +
>  	from = mem_cgroup_from_task(p);
>  
>  	VM_BUG_ON(from == memcg);
> -- 
> 2.4.0
> 

-- 
Michal Hocko
SUSE Labs
