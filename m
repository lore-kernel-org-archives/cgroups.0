From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] selftests/cgroup: fix repeated words in comments
Date: Thu, 8 Sep 2022 06:52:57 -0700
Message-ID: <5fd375c6-1bad-b937-634b-7efc4391c0e3@infradead.org>
References: <20220908121107.4814-1-wangjianli@cdjrlc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=b3NFkfppRZobo8xoKriBYse3KmRxLd7jAty1YkyS81c=; b=i4IM6V+NtVfo3v3I0a4ptJkjZx
        p/hCMXcKziCml5l/XMWq9v6YoKp/oIXwIpnPcx/qa9LlgwGdqawIgNBV8mClMWgrofoZS98P7McAR
        CwiN4snfvLE2T8vmeKn8pXyuBE0AjtUbLndfpWQsuLI/gXYu2xv5W7r6Ltq/1xub1QZncbVyG8nCP
        AWvVbA5ik+jJPx4zxsdGtFoEqDYf/mw8OOD7sogTk06L+QSDltB8x4IpQj6jfnyy5ajhQOyH5QfvJ
        YqB6u/el6uWKHNwzmhtBhW2bWIXyRP+LaHJcAugfP25CylcXJV6Yv7quRa6ZI+9reX1CYUy/Z9nwQ
        S8Ki58mg==;
Content-Language: en-US
In-Reply-To: <20220908121107.4814-1-wangjianli-zcEOJCtA6GXQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: wangjianli <wangjianli-zcEOJCtA6GXQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 9/8/22 05:11, wangjianli wrote:
> Delete the redundant word 'in'.
> 
> Signed-off-by: wangjianli <wangjianli-zcEOJCtA6GXQT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/cgroup/test_freezer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
> index ff519029f6f4..b479434e87b7 100644
> --- a/tools/testing/selftests/cgroup/test_freezer.c
> +++ b/tools/testing/selftests/cgroup/test_freezer.c
> @@ -740,7 +740,7 @@ static int test_cgfreezer_ptraced(const char *root)
>  
>  	/*
>  	 * cg_check_frozen(cgroup, true) will fail here,
> -	 * because the task in in the TRACEd state.

	                    is in

> +	 * because the task in the TRACEd state.
>  	 */
>  	if (cg_freeze_wait(cgroup, false))
>  		goto cleanup;

-- 
~Randy
