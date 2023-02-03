From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Fri, 3 Feb 2023 11:25:16 -0800
Message-ID: <Y91fnF5uEcSA0/99@P9FQF9L96D.corp.robot.car>
References: <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
 <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
 <Y9MI42NSLooyVZNu@P9FQF9L96D.corp.robot.car>
 <Y9N5CI8PpsfiaY9c@dhcp22.suse.cz>
 <Y9PYe1X7dRQOcahg@dhcp22.suse.cz>
 <Y9QVWwAreTlDVdZ0@P9FQF9L96D.corp.robot.car>
 <Y90mZQhW89HtYfT9@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675452324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xemEPS75g6CyaGYVTuNx4T5APXnPBUE9kBl1lVKlrTM=;
        b=ah/EreyLTKURus8ZQYbvdkwIeyZn+6VcKKQqlNdRE+EKzIxTpJdYzfdCWnCx8dIjocnERr
        FabQHAoVFjL7/nCF4j6JwNDZ3IxOsSqSwgKBVNOg8H1r2A4U/yDR8aWkgHFDw5EsvHH5ad
        z01tV+bx4YqgPBnEsnYYSL0KSmKrlEo=
Content-Disposition: inline
In-Reply-To: <Y90mZQhW89HtYfT9-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbecker-l3A5Bk7waGM@public.gmane.org>

On Fri, Feb 03, 2023 at 04:21:09PM +0100, Michal Hocko wrote:
> OK, so this is a speculative patch. cpu_is_isolated doesn't exist yet. I
> have talked to Frederic off-list and he is working on an implementation.
> I will be offline next whole week (will be back Feb 13th) so I am
> sending this early but this patch cannot be merged without his one of
> course.
> 
> I have tried to summarize the reasoning behind both approach should we
> ever need to revisit this approach. For now I strongly believe a simpler
> solution should be preferred.
> 
> Roman, I have added your ack as you indicated but if you disagree with
> the reasoning please let me know.

Great, thank you for preparing it up! Really nice summary.
My ack definitely applies.

If you want, feel free to add a
"Suggested-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>"
tag to blame me later :)

Thank you!
