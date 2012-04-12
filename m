From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v1 0/7] memcg remove pre_destroy
Date: Thu, 12 Apr 2012 10:20:50 -0300
Message-ID: <4F86D6B2.2020401@parallels.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F86B9BE.8000105-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 04/12/2012 08:17 AM, KAMEZAWA Hiroyuki wrote:
> One of problem in current implementation is that memcg moves all charges to
> parent in pre_destroy(). At doing so, if use_hierarchy=0, pre_destroy() may
> hit parent's limit and may return -EBUSY. To fix this problem, this patch
> changes behavior of rmdir() as
> 
>   - if use_hierarchy=0, all remaining charges will go to root cgroup.
>   - if use_hierarchy=1, all remaining charges will go to the parent.
To be quite honest, this is one of those things that we end up
overlooking, and just don't think about it in the middle of the complexity.

Now that you mention it... When use_hierarchy=0,  there is no parent!
(At least from where memcg is concerned). So it doesn't make any sense
to have it ever have moved it to the "parent" (from the core cgroup
perspective).

I agree with this new behavior 100 %.

Just a nitpick: When use_hierarchy=1, remaining charges need not to "go
to the parent". They are already there.

I will review your series for the specifics.
