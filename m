From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: Remove unused cpuset_node_allowed
Date: Mon, 27 Feb 2023 09:56:59 -0500
Message-ID: <9953284e-05da-56b0-047d-ecf18aa53892@redhat.com>
References: <20230227080719.20280-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677509824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ss2xMFtfBNj0edm2OxxXiynydqERuSjVgjdxnPnjzQc=;
        b=KE1749iYuF7wwoAMXLnyxesjAKaYaYcK8QYIK7lVER3tb4mfRdZtv3QrBVLDDnI/wx+r1R
        bIqJGq+Ftaic81cnEIiNfnEC+Hx8aaM6rBfpCHQhXd/Y6jDbn5xD5W7IMcP9D2Y//XO1RD
        QV5Y6vw1thads9hAtntLgOTE1uAVVLs=
Content-Language: en-US
In-Reply-To: <20230227080719.20280-1-haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/27/23 03:07, Haifeng Xu wrote:
> Commit 002f290627c2 ("cpuset: use static key better and convert to new API")
> has used __cpuset_node_allowed instead of cpuset_node_allowed to check
> whether we can allocate on a memory node. Now this function isn't used by
> anyone, so we can remove it safely.
>
> Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> ---
>   include/linux/cpuset.h | 12 ------------
>   1 file changed, 12 deletions(-)
>
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index d58e0476ee8e..7fad5afe3bba 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -82,13 +82,6 @@ int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
>   
>   extern bool __cpuset_node_allowed(int node, gfp_t gfp_mask);
>   
> -static inline bool cpuset_node_allowed(int node, gfp_t gfp_mask)
> -{
> -	if (cpusets_enabled())
> -		return __cpuset_node_allowed(node, gfp_mask);
> -	return true;
> -}
> -
>   static inline bool __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
>   {
>   	return __cpuset_node_allowed(zone_to_nid(z), gfp_mask);
> @@ -223,11 +216,6 @@ static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
>   	return 1;
>   }
>   
> -static inline bool cpuset_node_allowed(int node, gfp_t gfp_mask)
> -{
> -	return true;
> -}
> -
>   static inline bool __cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
>   {
>   	return true;

The kernel convention is to add a "__" prefix to a function name if 
there is higher level helper without the "__" prefix that uses it. Since 
cpuset_node_allowed() is no longer used. We should just rename 
__cpuset_node_allowed() to cpuset_node_allowed() and get rid of the 
unused helper. A bit more code changes are needed for this, though.

Cheers,
Longman

