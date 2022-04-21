From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH -next] mm/memcontrol.c: remove unused private flag of
 memory.oom_control
Date: Thu, 21 Apr 2022 11:27:49 -0700
Message-ID: <YmGiJYFUWjYQkovG@carbon>
References: <20220421122755.40899-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1650565674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NLNyYOb3KLGGVorwsN8XSXsL2aBq/Eak31L0IM28kbY=;
        b=WXc9PPWlfnoWGuoV9R1mzgCuJPRJaSm/d6dMbgm9Is9eDUq9uvc5xXqmz+VUIl33nQ8Llr
        rjwy+CbrlzOjMBE9ycR3KCbpL/NpjwWOpIFMhBycu/uXDRMrrraouu3GI0bPwD2eu2kWHj
        G88okiSLmUCFFaNdFPxdTEPnOncZpZo=
Content-Disposition: inline
In-Reply-To: <20220421122755.40899-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Apr 21, 2022 at 08:27:55PM +0800, Lu Jialin wrote:
> There is no use for the private value, __OOM_TYPE and OOM notifier
> OOM_CONTROL. Therefore remove them to make the code clean.
> 
> Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
