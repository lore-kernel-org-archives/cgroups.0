From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] sched: RT bandwidth interface for cgroup unified
 hierarchy
Date: Tue, 21 Jun 2022 08:59:42 -0700
Message-ID: <7933e208-cd4f-2234-58cb-2e5b40e795d8@infradead.org>
References: <20220621123542.1444-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=E2A5u8QnSoMuLSc5EffUox9oGwY+67AbE7UeaWIqBa0=; b=jVTclS4fLpxKLJMGDBlW0xO1Vd
        lawqGsyENs/93M71b4W1moKdogZEArIvMitxBhpmz+0XLVPhoGV+VmTnLXTSnMMp8AYgDKOCn1tGa
        cwrsCFEvN03D4f7XuVHFomvs8wpU34WjbmnTQjYf+T3lDlOUip7av9mQjc5G7Vw1hN5EgKLXqIHn9
        nUsVQRxKkFBQlznowevdLf5OpyZeLf3tgV5pW5i0M0pdIbUYa4UWRq5LO+cUxE67bxQL8udNqVomQ
        QlVa6wR2XwpN739g9Cmfqz5C9w8JAx/WGiI4yNiu3PvGF51j95mqG2d4B0znzhtd8IUfUZwqa7fEX
        xN0Y11Bg==;
Content-Language: en-US
In-Reply-To: <20220621123542.1444-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi--

On 6/21/22 05:35, Chengming Zhou wrote:
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 176298f2f4de..3d2949e16e04 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1055,6 +1055,19 @@ All time durations are in microseconds.
>  
>  	The burst in the range [0, $MAX].
>  
> +  cpu.max.rt
> +	A read-write two value file which exists on all cgroups when

	             two-value

> +	CONFIG_RT_GROUP_SCHED enabled, to control CPU bandwidth for

	                      is enabled,

> +	RT threads in the task group.
> +
> +	The maximum bandwidth limit.  It's in the following format::
> +
> +	  $MAX $PERIOD
> +
> +	which indicates that RT threads in the group may consume upto

	                                                         up to

> +	$MAX in each $PERIOD duration.  "max" for $MAX indicates no
> +	limit.  If only one number is written, $MAX is updated.

-- 
~Randy
