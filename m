From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Thu, 30 Apr 2020 12:06:10 -0700
Message-ID: <20200430190610.GD339283@carbon.dhcp.thefacebook.com>
References: <20200430182712.237526-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=izMAJz8DJVs85exNsDSF0g00gieebqbhFq/VLhscdPk=;
 b=LmahK+czBUQ9NHDakW0O/IPvAmo9wvBjbXymAtqv1ePSD7ttgke32LAMZKguOm1Drfdg
 7RxheLnQUY/HGP3YJJEO3rqZ0fp7rfmiwmuakTrfXbuf8Qwm1W2XHVng+nmRBQiwXcEz
 WRp6u6m/8SzZ8I1lnemZ1pMtPr7SNjFWZRA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izMAJz8DJVs85exNsDSF0g00gieebqbhFq/VLhscdPk=;
 b=IJemA5xFGWGxib2c3wopxExH+ydDTC6i+wn8i0iQ01Yi4FE6pzgczw93J6Fm8a6yPo51Fqn4R1scfX8/uSzZHxlcGpyiS90qau1/HEAMd8tG972J42kHw9eK9n27gYD3W9IqCQYgot5T2cRrn2mixR4l+rFjonQ/EVXyp5dK51U=
Content-Disposition: inline
In-Reply-To: <20200430182712.237526-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Shakeel!

On Thu, Apr 30, 2020 at 11:27:12AM -0700, Shakeel Butt wrote:
> Lowering memory.max can trigger an oom-kill if the reclaim does not
> succeed. However if oom-killer does not find a process for killing, it
> dumps a lot of warnings.

Makes total sense to me.

> 
> Deleting a memcg does not reclaim memory from it and the memory can
> linger till there is a memory pressure. One normal way to proactively
> reclaim such memory is to set memory.max to 0 just before deleting the
> memcg. However if some of the memcg's memory is pinned by others, this
> operation can trigger an oom-kill without any process and thus can log a
> lot un-needed warnings. So, ignore all such warnings from memory.max.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
>  include/linux/oom.h | 3 +++
>  mm/memcontrol.c     | 9 +++++----
>  mm/oom_kill.c       | 2 +-
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index c696c265f019..6345dc55df64 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -52,6 +52,9 @@ struct oom_control {
>  
>  	/* Used to print the constraint info. */
>  	enum oom_constraint constraint;
> +
> +	/* Do not warn even if there is no process to be killed. */
> +	bool no_warn;

I'd invert it to warn. Or maybe even warn_on_no_proc?

>  };
>  
>  extern struct mutex oom_lock;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 317dbbaac603..a1f00d9b9bb0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1571,7 +1571,7 @@ unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
>  }
>  
>  static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
> -				     int order)
> +				     int order, bool no_warn)
>  {
>  	struct oom_control oc = {
>  		.zonelist = NULL,
> @@ -1579,6 +1579,7 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		.memcg = memcg,
>  		.gfp_mask = gfp_mask,
>  		.order = order,
> +		.no_warn = no_warn,
>  	};
>  	bool ret;
>  
> @@ -1821,7 +1822,7 @@ static enum oom_status mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int
>  		mem_cgroup_oom_notify(memcg);
>  
>  	mem_cgroup_unmark_under_oom(memcg);
> -	if (mem_cgroup_out_of_memory(memcg, mask, order))
> +	if (mem_cgroup_out_of_memory(memcg, mask, order, false))
>  		ret = OOM_SUCCESS;
>  	else
>  		ret = OOM_FAILED;
> @@ -1880,7 +1881,7 @@ bool mem_cgroup_oom_synchronize(bool handle)
>  		mem_cgroup_unmark_under_oom(memcg);
>  		finish_wait(&memcg_oom_waitq, &owait.wait);
>  		mem_cgroup_out_of_memory(memcg, current->memcg_oom_gfp_mask,
> -					 current->memcg_oom_order);
> +					 current->memcg_oom_order, false);
>  	} else {
>  		schedule();
>  		mem_cgroup_unmark_under_oom(memcg);
> @@ -6106,7 +6107,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
>  		}
>  
>  		memcg_memory_event(memcg, MEMCG_OOM);
> -		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
> +		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0, true))

I wonder if we can handle it automatically from the oom_killer side?
We can suppress warnings if oc->memcg is set and the cgroup scanning
showed that there are no belonging processes?

Thanks!
