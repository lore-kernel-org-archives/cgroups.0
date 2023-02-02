From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: introduce entrance for root_mem_cgroup's current
Date: Thu, 2 Feb 2023 09:27:39 +0100
Message-ID: <Y9tz+0J9fw+Z+O+O@dhcp22.suse.cz>
References: <1675312377-4782-1-git-send-email-zhaoyang.huang@unisoc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675326460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=exe0DtfeQcAlhuYAQJBwVd6y+SRpyDu0VP1XU1cSGK0=;
        b=DGcyKCskLROJaYfTPTapPmF5EHxGu6uUXfqgXYFhdqrgb/9iD14ccSbNigzTJnMCOTleaR
        6hBq//gwdIwePPtKTgeVwYAOQzqGE4LbpKPAX+qDcIKzRFsYZhuWiy2i3bRip5V6H0/4L3
        8d6HZNPrIguXQnVO5tvB5bm8XVjtpFc=
Content-Disposition: inline
In-Reply-To: <1675312377-4782-1-git-send-email-zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org

On Thu 02-02-23 12:32:57, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> 
> Introducing memory.root_current for the memory charges on root_mem_cgroup.

Charges are not currently accounted for the root memcg universally. See
try_charge which is used for all user space and skmem charges. I am not
100% sure about objcg based accounting because there is no explicit
check for the root memcg but this might be hidden somewhere as well.

That means that the patch as is doesn't really provide and usable value.
The root exemption has been removed in the past but that has been
reverted due to a regression. See ce00a967377b ("mm: memcontrol: revert
use of root_mem_cgroup res_counter") for more.

> Signed-off-by: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ab457f0..158d4232 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6681,6 +6681,11 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
>  
>  static struct cftype memory_files[] = {
>  	{
> +		.name = "root_current",
> +		.flags = CFTYPE_ONLY_ON_ROOT,
> +		.read_u64 = memory_current_read,
> +	},
> +	{
>  		.name = "current",
>  		.flags = CFTYPE_NOT_ON_ROOT,
>  		.read_u64 = memory_current_read,
> -- 
> 1.9.1

-- 
Michal Hocko
SUSE Labs
