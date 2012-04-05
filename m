From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memcg: revise the position of threshold index while
 unregistering event
Date: Thu, 5 Apr 2012 16:35:30 -0700
Message-ID: <20120405163530.a1a9c9f9.akpm@linux-foundation.org>
References: <1331035943-7456-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331035943-7456-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Tue,  6 Mar 2012 20:12:23 +0800
Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> Index current_threshold should point to threshold just below or equal to usage.
> See below:
> http://www.spinics.net/lists/cgroups/msg00844.html

I have a bad feeling that I looked at a version of this patch
yesterday, but I can't find it.

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4398,7 +4398,7 @@ static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
>  			continue;
>  
>  		new->entries[j] = thresholds->primary->entries[i];
> -		if (new->entries[j].threshold < usage) {
> +		if (new->entries[j].threshold <= usage) {
>  			/*
>  			 * new->current_threshold will not be used
>  			 * until rcu_assign_pointer(), so it's safe to increment

What were the runtime effects of this bug?
