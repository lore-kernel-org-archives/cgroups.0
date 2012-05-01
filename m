From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH RESEND] memcg: Free spare array to avoid memory leak
Date: Tue, 1 May 2012 14:03:14 -0700
Message-ID: <20120501140314.1d7312fb.akpm@linux-foundation.org>
References: <1334825690-9065-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334825690-9065-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Thu, 19 Apr 2012 16:54:50 +0800
Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> When the last event is unregistered, there is no need to keep the spare
> array anymore. So free it to avoid memory leak.

How serious is this leak?  Is there any way in which it can be used to
consume unbounded amounts of memory?

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4412,6 +4412,12 @@ static void mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
>  swap_buffers:
>  	/* Swap primary and spare array */
>  	thresholds->spare = thresholds->primary;
> +	/* If all events are unregistered, free the spare array */
> +	if (!new) {
> +		kfree(thresholds->spare);
> +		thresholds->spare = NULL;
> +	}
> +
>  	rcu_assign_pointer(thresholds->primary, new);
>  

The resulting code is really quite convoluted.  Try to read through it
and follow the handling of ->primary and ->spare.  Head spins.

What is the protocol here?  If ->primary is NULL then ->spare must also
be NULL?


I'll apply the patch, although I don't (yet) have sufficient info to
know which kernels it should be applied to.  Perhaps someone could
revisit this code and see if it can be made more straightforward.
