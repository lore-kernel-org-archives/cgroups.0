From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Thu, 26 Jan 2023 08:45:36 +0100
Message-ID: <Y9IvoDJbLbFcitTc@dhcp22.suse.cz>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674719137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nyfyICH/nuaTPIMu2gFSl4YjBW5PkhozqayimXZNZ+M=;
        b=nOpFGD4S/OURsfQXM1js173kpvKGKBzy0EeLOpXOxAzYIbZjud1LGPWcyGCuzPRfv/15rr
        gFZGxHj5K5Asa+oAsIcqDRgvHdi1gPKbeE5F1s5wcpevANvW4xN9xRwUSA7xKzxLfAmSkK
        Va8Nmt8liDThwSi9/UjWWiRx6zUox0A=
Content-Disposition: inline
In-Reply-To: <Y9FzSBw10MGXm2TK@tpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 25-01-23 15:22:00, Marcelo Tosatti wrote:
[...]
> Remote draining reduces interruptions whether CPU 
> is marked as isolated or not:
> 
> - Allows isolated CPUs from benefiting of pcp caching.
> - Removes the interruption to non isolated CPUs. See for example 
> 
> https://lkml.org/lkml/2022/6/13/2769

This is talking about page allocato per cpu caches, right? In this patch
we are talking about memcg pcp caches. Are you sure the same applies
here?
-- 
Michal Hocko
SUSE Labs
