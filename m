From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Don't increase effective low/min if no
 protection needed
Date: Tue, 11 Oct 2022 21:01:20 +0200
Message-ID: <Y0W9gHblrima2tDd@dhcp22.suse.cz>
References: <20221011143015.1152968-1-longman@redhat.com>
 <Y0WOPZxWSnUjzZ8e@dhcp22.suse.cz>
 <defdb421-342e-ebcb-d7f0-005559dd1e0d@redhat.com>
 <Y0WiIDmPPXYZuHpX@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1665514881; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w1Wip/kR/nLx7NLOcIVQ++U0LbZfFaHpu0ZiHUekL6M=;
        b=r0pi3DBSDiAet5rHRn6FCp5z5UxtoxqnvqLG4J56c9yiBSUM+770wvzqJwNB5kNiRUa1IZ
        shbQchCLgt2qSnnrrkvPeyFYQoKrHIwkovCmtVRT2LFUY6Zyvf0AC2axO2N9Sf/+3Dimv2
        LBdTVAi9D5F06aQWnvV/8tU8HTcuo6M=
Content-Disposition: inline
In-Reply-To: <Y0WiIDmPPXYZuHpX-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Tue 11-10-22 07:04:32, Tejun Heo wrote:
> On Tue, Oct 11, 2022 at 01:00:22PM -0400, Waiman Long wrote:
> > You are right about that. An alternative way to address this issue is to
> > disable memory low event when memory.low isn't set. An user who want to
> > track memory.low event has to set it to a non-zero value. Would that be
> > acceptable?
> 
> Wouldn't it make sense to fix the test? With recursive_prot on, the cgroup
> actually is under low protection and it seems like the correct behavior is
> to report the low events accordingly.

Agreed, the semantic makes sense and it seems to be just the test that
is not aware of it.
-- 
Michal Hocko
SUSE Labs
