From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 7/8] cgroup: add a tset_get_css macro
Date: Mon, 18 May 2015 17:34:23 -0400
Message-ID: <20150518213423.GI24861@htj.duckdns.org>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
 <1431960667-26593-8-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QzAKHcX7urRP9gGObkCfA/3JXgYiwiC/YQpotxsg4JA=;
        b=LcRSAYcMzFlSNZwUNFYiiJ3ecrvgLkDwbyp4bT1P6DXuxs+/mjtG1tVV2aeBXCHY9+
         sa35yuYNg0Irq0OI1vWA4NvIvlNE4MdQfrl4ia6zbVAd+wHSWCqsSo8+W4gY1Y9KkTot
         Njj43AXDygPdm9+tgdKxaFmD9Wkhgl8AFfs11KILiLGhrzOhcghJPEcghulbjjT5RhNP
         V/boinNnuisnVy6a6YOXgX4EKl8OgkcytiwPFGUGEHgHhSg+4Y7yffV4owJdENZQNsDx
         ORmEsrdxSjCdLrbHI8hJrKuiVkAvWFEcHShLoQnjwqNzUQTK/+3SpOQyRl4HZVlgVF+U
         eaKQ==
Content-Disposition: inline
In-Reply-To: <1431960667-26593-8-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 19, 2015 at 12:51:06AM +1000, Aleksa Sarai wrote:
> This adds a macro to get the css of a tset (using task_get_css()) by
> just grabbing a ref to the first item in the tset (since there is a
> guarantee that all tasks in a tset share a css).
> 
> This is in preparation for implementing the pids cgroup subsystem.
> 
> Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/cgroup.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 886a883..773846d 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -639,6 +639,18 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset);
>  	for ((task) = cgroup_taskset_first((tset)); (task);		\
>  	     (task) = cgroup_taskset_next((tset)))
>  
> +/**
> + * tset_get_css - obtain and get css for (tset, subsys_id)
> + * @tset: target taskset
> + * @subsys_id: target subsystem id
> + *
> + * Since all of the tasks in a taskset are guaranteed to have the same css, it's
> + * safe to grab the ref of just the first task's css and treat it as though you
> + * have a ref on the taskset's "collective" css.
> + */
> +#define tset_get_css(tset, subsys_id)					\
> +	task_get_css(cgroup_taskset_first(tset), subsys_id)

They aren't tho.  It depends on the hierarchy configuration.  csses
belonging to hierarchies which aren't the current migration target may
differ.

Thanks.

-- 
tejun
