From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH-cgroup 5/6] cgroup: Skip dying css in
 cgroup_apply_control_{enable,disable}
Date: Wed, 21 Jun 2017 17:42:16 -0400
Message-ID: <20170621214216.GE14720@htj.duckdns.org>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
 <1497452737-11125-6-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HG9ZbJj3r34QjAO/Wm+kY0HZTweM3cyaq3dgEB6GnOs=;
        b=BsGnDuoTsfl+gc6l5d0lYgMRCCfHzdnvM+7KudB5oUWDtDnV/yhZdOmcZw3fNFVdTf
         0xIDXjkpF9z6ZS8jKkYSXrpqSJ1Vm2xnljHApxXq7T17bmbjI0m4bML/ULaxDel/4yXQ
         2e+E4kCDFEXIQ2wt2rNubVnOjoxWzqrTlaxopmVm7jihdGnj3kxpuRg4eNKQy0Ow7C2C
         1AkWEoIiLnjLA11uVJ07jQxhNBT0kUxd0ePjfj5GrjPhFBYjlgvCPyQY1+TJATHiJW7k
         iLzlrHSt5jTSot8F7nVesFWxE65Onu7W0V1KyTr4npuxG9FCzS8oKWu2dQC7PdpjgfTp
         yM+Q==
Content-Disposition: inline
In-Reply-To: <1497452737-11125-6-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org

Hello,

On Wed, Jun 14, 2017 at 11:05:36AM -0400, Waiman Long wrote:
> While constantly turning on and off controllers, it is possible to
> trigger the dying CSS warnings in cgroup_apply_control_enable() and
> cgroup_apply_control_disable(). The current code, however, proceeds
> after the warning leading to other secondary warnings and maybe even
> data corruption, like
> 
>   cgroup: cgroup_addrm_files: failed to add current, err=-17
> 
> To avoid the secondary errors, the dying CSS is now ignored or skipped
> so as not to cause other problem.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  kernel/cgroup/cgroup.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index f0bea32..2a5bd49 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -2846,12 +2846,24 @@ static int cgroup_apply_control_enable(struct cgroup *cgrp)
>  		for_each_subsys(ss, ssid) {
>  			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
>  
> -			WARN_ON_ONCE(css && percpu_ref_is_dying(&css->refcnt));
> -
>  			if (!(cgroup_ss_mask(dsct, false) & (1 << ss->id)) ||
>  			    (dsct->bypass_ss_mask & (1 << ss->id)))
>  				continue;
>  
> +			/*
> +			 * If the css is dying, we will just skip it after
> +			 * warning.
> +			 */
> +			if (css && (css->flags & CSS_DYING)) {
> +				char name[NAME_MAX+1];
> +
> +				cgroup_name(cgrp, name, NAME_MAX);
> +				pr_warn("%s: %s css of cgroup %s is dying!\n",
> +					__func__, ss->name, name);
> +				WARN_ON_ONCE(1);
> +				continue;
> +			}

Can you trigger this without your patches because this triggering
means that the code screwed up before it reached this point.  We
should be fixing that bug rather than masking it up here.

Thanks.

-- 
tejun
