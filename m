From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: add myself as a memcg co-maintainer as well
Date: Thu, 24 Feb 2022 08:39:34 +0100
Message-ID: <Yhc2NryrtsqPN4Jr@dhcp22.suse.cz>
References: <20220224060148.4092228-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645688375; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qEgq5b010Dc6+wc2/YsOMt1qe+8jokFJKfqLno0+jwE=;
        b=QjzSY5riKfB7KYO1FLjOw7ijkE4br3EC2PSfKMS59pnnJ6juy//nXJPCTK+XueysGy/69D
        TPToJ1yuwUnYW41+f3ezzYFH+KnA7QHSHKbuBu0wLyzvHrS65PRLQD0FolGrxjuiccO7oG
        T0+KYA2MHXIM5exHnXEPmb81gVQqOf0=
Content-Disposition: inline
In-Reply-To: <20220224060148.4092228-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 23-02-22 22:01:48, Shakeel Butt wrote:
> I have been contributing and reviewing to the memcg codebase for last
> couple of years. So, making it official.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks for stepping up, Shakeel!

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> 
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ab8f1621d027..cb97140e7dda 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5014,6 +5014,7 @@ CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
>  M:	Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>  M:	Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>  M:	Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> +M:	Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>  L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  L:	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
>  S:	Maintained
> -- 
> 2.35.1.574.g5d30c73bfb-goog

-- 
Michal Hocko
SUSE Labs
