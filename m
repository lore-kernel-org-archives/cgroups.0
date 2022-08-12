From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: use root_mem_cgroup as css when current is
 not enabled
Date: Fri, 12 Aug 2022 09:06:14 -1000
Message-ID: <YvakpukeF9d35Bc8@slm.duckdns.org>
References: <1660298966-11493-1-git-send-email-zhaoyang.huang@unisoc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=K5kHnejuEt7Pt9e4fwYPne3BNnxtsVlr6ROsJLvAIa0=;
        b=Qar1VMGJIJ0ygpP/aVRz6hN912vPbq1cxrcogPE79/v7qrHH5Fpt6e7GL1LNHUsgLf
         Ym3uNok4Eaib+wurgKcpDQ8KTxPK3A34Q+SsBzqhBL0rRqNzX5O+7snQNLrMDnCvof23
         Oq4jREnkRCQ67jemY3M/fdd8l7mh4iRBb1njKQBNzdg3Vf1xEm1Lr3HWX0Wkw7Zr2lcu
         yCFl2/gf5DdFkdIUuRsgBe/EY3u/1ca77S5GxMST03y2J8TXCXJAEnNsQ3aT8C7PJd7k
         NKWMKAf6i1iem+kaaWl5e8m7DJkzjoNYDpc6YMRSRgWTSgg3AUf3XoT+/RhCH4B7D42x
         RwPQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1660298966-11493-1-git-send-email-zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Fri, Aug 12, 2022 at 06:09:26PM +0800, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> 
> Memory charged on group B abserved on belowing v2 hierarchy where we just would
> like to only have group E's memory be controlled and B's descendants compete freely
> for memory. This should be the consequences of unified hierarchy. Solve this by
> have the cgroup without valid memory css alloced use root_mem_cgroup instead of
> its ancestor's.
> 
>  A(subtree_control = memory) - B(subtree_control = NULL) - C()
>                                                          \ D()
> 			     - E(subtree_control = memory) - F()
> 							   \ G()
> 
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cgroup.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 1779ccd..b29b3f6 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -533,6 +533,14 @@ static struct cgroup_subsys_state *cgroup_e_css_by_mask(struct cgroup *cgrp,
>  	 * can't test the csses directly.  Test ss_mask.
>  	 */
>  	while (!(cgroup_ss_mask(cgrp) & (1 << ss->id))) {
> +		/*
> +		 * charging to the parent cgroup which hasn't distribute
> +		 * memory control to its descendants doesn't make sense
> +		 * especially on cgroup v2, where the parent could be configured
> +		 * to use memory controller as its sibling want to use it
> +		 */
> +		if (memory_cgrp_id == ss->id)
> +			return &root_mem_cgroup->css;

This is gonna be a hard nack. A given cgroup always encompasses all the
resources consumed in its self-including subtree.

Thanks.

-- 
tejun
