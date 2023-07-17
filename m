From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/misc: Fix an overflow
Date: Mon, 17 Jul 2023 08:51:39 -1000
Message-ID: <ZLWNu4IeehNVO1nh@slm.duckdns.org>
References: <20230717184719.85523-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689619902; x=1692211902;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jAlFdhdYimT7TnDfeJ0lD67idJ1017L3UN8Mf00CzHI=;
        b=ED+Djowc/2dcO/tE9axqFc9b4Hjf+ViIX4s7d5D7pjvK1iWZfrjCWS6eMWepFGnc2A
         OiqqVO9dlfjFQXKsVX9cG7py+y6+JafDVDhRNiKNAin1agC3Bt3jvN1MGjLFOcCCok97
         qo3IZkDLh7at2TsXebl4uUAwQlbV3eZDF1JIohTInR63rLLc8I6LhdR2Vzczjj5Yv1Pt
         TpIrmmUwNXD+PmlOmV6GRX+BxxVLNBSTV/dtkIyOEDxSVdFoeJpbwF7/EH7gfTmF9STn
         6SCpIRFjuxYHYV1GUWBsTQIkn9/X05A74eDB8drJInQsPX4VrLNPPXSV9bhatuePiG5O
         7DzQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230717184719.85523-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

On Mon, Jul 17, 2023 at 11:47:19AM -0700, Haitao Huang wrote:
> The variable 'new_usage' in misc_cg_try_charge() may overflow if it
> becomes above INT_MAX. This was observed when I implement the new SGX
> EPC cgroup[1] as a misc cgroup and test on a platform with large SGX EPC
> sizes.
> 
> Change type of new_usage to long from int and check overflow.
> -	int new_usage;
> +	long new_usage;
>  
>  	if (!(valid_type(type) && cg && READ_ONCE(misc_res_capacity[type])))
>  		return -EINVAL;
> @@ -153,10 +153,10 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
>  
>  	for (i = cg; i; i = parent_misc(i)) {
>  		res = &i->res[type];
> -
>  		new_usage = atomic_long_add_return(amount, &res->usage);
>  		if (new_usage > READ_ONCE(res->max) ||
> -		    new_usage > READ_ONCE(misc_res_capacity[type])) {
> +		    new_usage > READ_ONCE(misc_res_capacity[type]) ||
> +		    new_usage < 0) {

Applying to cgroup/for-6.6 (as none of the current users are affected by
this) but I think the right thing to do here is using explicit 64bit types
(s64 or u64) for the resource counters rather than depending on the long
width.

Thanks.

-- 
tejun
