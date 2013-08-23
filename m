From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/12] memcg: rename cgroup_event to mem_cgroup_event
Date: Fri, 23 Aug 2013 11:42:00 +0800
Message-ID: <5216DA08.8040406@huawei.com>
References: <1376582550-12548-1-git-send-email-tj@kernel.org> <1376582550-12548-12-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376582550-12548-12-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>  /*
> + * DO NOT USE IN NEW FILES.
> + *
> + * "cgroup.event_control" implementation.
> + *
> + * This is way over-engineered.  It tries to support fully configureable

s/configureable/configurable

> + * events for each user.  Such level of flexibility is completely
> + * unnecessary especially in the light of the planned unified hierarchy.
> + *
> + * Please deprecate this and replace with something simpler if at all
> + * possible.
> + */
> +
> +/*
