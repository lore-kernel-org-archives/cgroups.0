From: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] selftests/cgroup: fix repeated words in comments
Date: Thu, 8 Sep 2022 19:22:07 +0530
Message-ID: <36d3af06-4534-000f-525d-d1fa82467aaa@quicinc.com>
References: <20220908121107.4814-1-wangjianli@cdjrlc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=GJh0mrNCEHXtxxdUH+g6jKIM0jaKF/Dn8W1pmU6Rpqc=;
 b=oStrnru62YWYjVxhyRyTbNsnG/bSLDErTQXiVZ/eTY8WKkzWslc7kvBJL0GtHNsuqXah
 fl8WStiqCAjp3ChZUwJaAajVQka3GKy6yQvRf1zpR/UrT11EmUMOlbvTTTiq/0f5x64q
 D/krKWiIjsD4aqtJhi0kIK8UbQmoJ7YaeigFWifftggYYA9UMIu2sZqzxVFls6y4th9B
 YrGl5qrAMY94DNIM4hczzpP94J/ZDjqsqLtMM3T3+n9Gv6/G854pOPK/EANeX2lRPWQk
 yB/NcpNV2QIabcnjuYbKT/gwbqmH9GqbDxQOQwna786O07mALU5lxVCkxaB92CmcWaER Fg== 
Content-Language: en-US
In-Reply-To: <20220908121107.4814-1-wangjianli-zcEOJCtA6GXQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: wangjianli <wangjianli-zcEOJCtA6GXQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 9/8/2022 5:41 PM, wangjianli wrote:
> Delete the redundant word 'in'.
> 
> Signed-off-by: wangjianli <wangjianli-zcEOJCtA6GXQT0dZR+AlfA@public.gmane.org>
> ---
>   tools/testing/selftests/cgroup/test_freezer.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
> index ff519029f6f4..b479434e87b7 100644
> --- a/tools/testing/selftests/cgroup/test_freezer.c
> +++ b/tools/testing/selftests/cgroup/test_freezer.c
> @@ -740,7 +740,7 @@ static int test_cgfreezer_ptraced(const char *root)
>   
>   	/*
>   	 * cg_check_frozen(cgroup, true) will fail here,
> -	 * because the task in in the TRACEd state.
> +	 * because the task in the TRACEd state.

Should it be s/in in/is in/ ?

-Mukesh
>   	 */
>   	if (cg_freeze_wait(cgroup, false))
>   		goto cleanup;
