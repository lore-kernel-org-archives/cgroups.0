From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4] mm: oom: introduce cpuset oom
Date: Tue, 11 Apr 2023 16:36:26 +0200
Message-ID: <ZDVwaqzOBNTpuR1w@dhcp22.suse.cz>
References: <20230411065816.9798-1-ligang.bdlg@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1681223787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U29cCnOHbPWuYYBzDboY6Km3Yy5eqaduHl0Wu231j74=;
        b=edjpGMrZ7N5YaS+Bhq84eaTAsFUJQfQ5qUZDGHxznT+HT1UWjhwdo+L4abwkywXdptySD5
        5qp7+MeH72opCbELqEE75FiRgE2ZoDDMZrxDENYrm6SyMRarDUSbtF48i7Jo82DPD+J4MW
        CncLnF+JzdMoTJt+laveADpsUJQZfok=
Content-Disposition: inline
In-Reply-To: <20230411065816.9798-1-ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 11-04-23 14:58:15, Gang Li wrote:
> Cpusets constrain the CPU and Memory placement of tasks.
> `CONSTRAINT_CPUSET` type in oom  has existed for a long time, but
> has never been utilized.
> 
> When a process in cpuset which constrain memory placement triggers
> oom, it may kill a completely irrelevant process on other numa nodes,
> which will not release any memory for this cpuset.
> 
> We can easily achieve node aware oom by using `CONSTRAINT_CPUSET` and
> selecting victim from cpusets with the same mems_allowed as the
> current one.

I believe it still wouldn't hurt to be more specific here.
CONSTRAINT_CPUSET is rather obscure. Looking at this just makes my head
spin.
        /* Check this allocation failure is caused by cpuset's wall function */
        for_each_zone_zonelist_nodemask(zone, z, oc->zonelist, 
                        highest_zoneidx, oc->nodemask)
                if (!cpuset_zone_allowed(zone, oc->gfp_mask))
                        cpuset_limited = true;

Does this even work properly and why? prepare_alloc_pages sets
oc->nodemask to current->mems_allowed but the above gives us
cpuset_limited only if there is at least one zone/node that is not
oc->nodemask compatible. So it seems like this wouldn't ever get set
unless oc->nodemask got reset somewhere. This is a maze indeed. Is there
any reason why we cannot rely on __GFP_HARWALL here? Or should we
instead rely on the fact the nodemask should be same as
current->mems_allowed?

I do realize that this is not directly related to your patch but
considering this has been mostly doing nothing maybe we want to document
it better or even rework it at this occasion.

> Example:
> 
> Create two processes named mem_on_node0 and mem_on_node1 constrained
> by cpusets respectively. These two processes alloc memory on their
> own node. Now node0 has run out of memory, OOM will be invokled by
> mem_on_node0.

Don't you have an actual real life example with a properly partitioned
system which clearly misbehaves and this patch addresses that?
-- 
Michal Hocko
SUSE Labs
