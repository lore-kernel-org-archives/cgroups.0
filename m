From: Mukesh Ojha <quic_mojha@quicinc.com>
Subject: Re: [PATCH -next] cgroup: simplify code in cgroup_apply_control
Date: Mon, 19 Sep 2022 16:19:10 +0530
Message-ID: <22ef7722-2f60-688d-4cf0-f59f0272a293@quicinc.com>
References: <20220917084039.3177-1-williamsukatube@163.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=RcMmOlpnS4AWnqNiIpy8ZOmV53hTUnYc4Fvlx4MH3BU=;
 b=IgzlouolRenhn2zc65LTb3I0tABPSChqtEq8wvqMI9rFrUBfr3U9GFbloG0eA42KcVdq
 DSW+XCM6mWWwgSpj/leIu/+aPmr4Kgvp4sRr0GpmWY4XB9PRM/JZwlk9aywJXzWrzybK
 kBC73hVz3YQ4S+uS67290jgtf11T8aRbjAdGzMK8nMYlgj1gMXnIF+QBeV5VYDOLpeeO
 Z6A90mR8+xvhAtxQ21rF9oW3TKGTOKYOn8dxnEENAobJECx3Z/iBce3e/lFCRb67/hwp
 01WCuEWBGYvcu+Kn/CPw+xJZYsQvFWpim0Yxb98uoQZqdIktMH6eTlJ1sQ/CIwR9NRBN 0g== 
Content-Language: en-US
In-Reply-To: <20220917084039.3177-1-williamsukatube@163.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: williamsukatube@163.com, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

On 9/17/2022 2:10 PM, williamsukatube@163.com wrote:
> From: William Dean <williamsukatube@163.com>
> 
> It could directly return 'cgroup_update_dfl_csses' to simplify code.
> 
> Signed-off-by: William Dean <williamsukatube@163.com>
> ---
>   kernel/cgroup/cgroup.c | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index e4bb5d57f4d1..1958f8bd93d6 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3292,11 +3292,7 @@ static int cgroup_apply_control(struct cgroup *cgrp)
>   	 * making the following cgroup_update_dfl_csses() properly update
>   	 * css associations of all tasks in the subtree.
>   	 */
> -	ret = cgroup_update_dfl_csses(cgrp);
> -	if (ret)
> -		return ret;
> -
> -	return 0;
> +	return cgroup_update_dfl_csses(cgrp);
>   }
> 
>   /**
> --
> 2.25.1
> 

LGTM.

Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>

-Mukesh
