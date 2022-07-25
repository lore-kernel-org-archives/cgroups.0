From: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] selftests/cgroup: fix repeated words in comments
Date: Mon, 25 Jul 2022 11:17:59 +0530
Message-ID: <8791eec2-4714-f287-6fe7-a8b724e4176a@quicinc.com>
References: <20220724070435.7999-1-wangjianli@cdjrlc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=soXVwM9nzuX+Q1bj83PaYPMf44fabPxDdP0zIZMD9Is=;
 b=L78DZe8i2gZLMak99ZCeXQEte1gbYAifjxIMAJPPwJAXilI6S/+IzkthSiCXnshvbulr
 LC4O/fFQzbQ9Y6l9EKc7cbwgP1vU3X8Z0GCpqazAf1Jx74N6YBxif5egmoTBgB0N+UFL
 vYcgXTkRM8AR9p3c57H5jWwY2G3jl8zVsRIW2SWLRBMx6uK0bje+u7Isi0IbYeDEY7Xy
 BEJ9oxAs2nLTAWW/MAcca8uE+dxw9jwtT8GcPIj8GAcQtCD5WP3V0rNxLlvsTo6CbPxC
 YlpN2YuAqa6EdY8Az+7cdmZP+s1aX659GS/2SUptcW1aEsEv14VgZbX7RhAhsui8UxWz lQ== 
Content-Language: en-US
In-Reply-To: <20220724070435.7999-1-wangjianli-zcEOJCtA6GXQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: wangjianli <wangjianli-zcEOJCtA6GXQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 7/24/2022 12:34 PM, wangjianli wrote:
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

s/in in/is in     ?

> +	 * because the task in the TRACEd state.
>   	 */
>   	if (cg_freeze_wait(cgroup, false))
>   		goto cleanup;


-Mukesh
