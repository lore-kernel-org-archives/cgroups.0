From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Mon, 13 Feb 2023 14:36:39 +0100
Message-ID: <Y+o855yLUXa2dWgC@dhcp22.suse.cz>
References: <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
 <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
 <Y9MI42NSLooyVZNu@P9FQF9L96D.corp.robot.car>
 <Y9N5CI8PpsfiaY9c@dhcp22.suse.cz>
 <Y9PYe1X7dRQOcahg@dhcp22.suse.cz>
 <Y9QVWwAreTlDVdZ0@P9FQF9L96D.corp.robot.car>
 <Y90mZQhW89HtYfT9@dhcp22.suse.cz>
 <Y91fnF5uEcSA0/99@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676295400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WBsHPFyQ/3u7/lh/7uLULXSnFfjfKpl/+ZQxS+UDoN8=;
        b=ACRFerY9QTr65z3Df8Q5sEawTKjoV04EOvZc+1ThKd2y5Gh1wCZZeMHcPkLA5kuH+0GSm4
        1bw19SNVRXLu8QM2qNVitO+V0dCusj4E6XNs9FABjLO7sJqaEDaI02e6239GbixcpWrLRY
        l3LNC5WFqGUnt+GT3sYThyEqgJn+NqA=
Content-Disposition: inline
In-Reply-To: <Y91fnF5uEcSA0/99-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbecker-l3A5Bk7waGM@public.gmane.org>

On Fri 03-02-23 11:25:16, Roman Gushchin wrote:
> On Fri, Feb 03, 2023 at 04:21:09PM +0100, Michal Hocko wrote:
> > OK, so this is a speculative patch. cpu_is_isolated doesn't exist yet. I
> > have talked to Frederic off-list and he is working on an implementation.
> > I will be offline next whole week (will be back Feb 13th) so I am
> > sending this early but this patch cannot be merged without his one of
> > course.
> > 
> > I have tried to summarize the reasoning behind both approach should we
> > ever need to revisit this approach. For now I strongly believe a simpler
> > solution should be preferred.
> > 
> > Roman, I have added your ack as you indicated but if you disagree with
> > the reasoning please let me know.
> 
> Great, thank you for preparing it up! Really nice summary.
> My ack definitely applies.
> 
> If you want, feel free to add a
> "Suggested-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>"
> tag to blame me later :)

Sure, I have updated the changelog. I will repost after the patchset by
Frederic[1] is merged.

[1] http://lkml.kernel.org/r/20230203232409.163847-1-frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
-- 
Michal Hocko
SUSE Labs
