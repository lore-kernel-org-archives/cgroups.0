From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup/cpuset: fix a memory binding failure for
 cgroup v2
Date: Thu, 21 Apr 2022 12:22:35 -1000
Message-ID: <YmHZK+M470GjeJCV@slm.duckdns.org>
References: <20220419020958.40419-1-feng.tang@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y6WfdHbJCYQzab5SHoARzKzrfz2r1T0YKiP1hNGHigk=;
        b=ZO4eaJJc1D/7LWDis399vvRSyw5MBy95K81Welr1tTB6Wq6BW/lnNe2/GwfAzvcz6I
         U8IY9rPktTgn8KKX28BEbFqA2GiE6eHzQ9XWVWv7mNUeVqphiyNt+GJUxnsztz8BpCPV
         pzc//pxX7LAS0hEczz1kc/IY7mbLuU43a71tTY8CiViZu7u09/nrRr3pBLVXcrulUICa
         cIwUXxKbhjYv/yFzkWpLASqQfnmniPnwYmJUAhxZLyJJzhA6nFTI0HbFrYdvYl8E/Nh6
         JEmekiIqu9b3PmiaUaSqwKeUHq7TokiOmj5/CZqHGBre+241ESZz3lxcjwDeUbJwsIJn
         WIuA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220419020958.40419-1-feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

cc'ing Waiman and copying the whole body.

Waiman, can you please take a look?

Thanks.

On Tue, Apr 19, 2022 at 10:09:58AM +0800, Feng Tang wrote:
> We got report that setting cpuset.mems failed when the nodemask
> contains a newly onlined memory node (not enumerated during boot)
> for cgroup v2, while the binding succeeded for cgroup v1.
> 
> The root cause is, for cgroup v2, when a new memory node is onlined,
> top_cpuset's 'mem_allowed' is not updated with the new nodemask of
> memory nodes, and the following setting memory nodemask will fail,
> if the nodemask contains a new node.
> 
> Fix it by updating top_cpuset.mems_allowed right after the
> new memory node is onlined, just like v1.
> 
> Signed-off-by: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> Very likely I missed some details here, but it looks strange that
> the top_cpuset.mem_allowed is not updatd even after we onlined
> several memory nodes after boot.
> 
>  kernel/cgroup/cpuset.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 9390bfd9f1cd..b97caaf16374 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3314,8 +3314,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>  	/* synchronize mems_allowed to N_MEMORY */
>  	if (mems_updated) {
>  		spin_lock_irq(&callback_lock);
> -		if (!on_dfl)
> -			top_cpuset.mems_allowed = new_mems;
> +		top_cpuset.mems_allowed = new_mems;
>  		top_cpuset.effective_mems = new_mems;
>  		spin_unlock_irq(&callback_lock);
>  		update_tasks_nodemask(&top_cpuset);
> -- 
> 2.27.0
> 

-- 
tejun
