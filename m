From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v3 8/8] kselftests: cgroup: update kmem test for new
 vmstat implementation
Date: Tue, 9 Feb 2021 12:17:47 -0800
Message-ID: <20210209201747.GC524633@carbon.DHCP.thefacebook.com>
References: <20210209163304.77088-1-hannes@cmpxchg.org>
 <20210209163304.77088-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=DJERSTkw4isNjvcqx1tdH0RoH9cRE1Lx9NOu9ApbbQ4=;
 b=pNpn78ociYajKDdHPi0uWHCWr5V0//nNPr1dUC6my7RExsJ9aB8SJwnKxPFPjPxojo8f
 kC22GjxJNo1xdsDpTilCF6idorJdLIi8eCfCxEUFic3QqkEbfyCipeR6uuPe3qrKhtTw
 XW7BNLGnq1ylWD3JJ3JV1Od6qjWWr/E5/lY= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJERSTkw4isNjvcqx1tdH0RoH9cRE1Lx9NOu9ApbbQ4=;
 b=Cs/84A5K0xG6I5ijeYXodS0Pl+eBOjQ+F3k+t4n+mdeajqr+iMjWFKqdwYfF77MVTVU8qjNl7EdlH/PWzoigSVtkojf/3uCWJASIDMQ8J0HqSc9SX+BqT7fA9hs4+CK0gV4upqW5wZJ4S5DJ2Yl+V+j1XOVc/TJslCpHXp36H3A=
Content-Disposition: inline
In-Reply-To: <20210209163304.77088-9-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Feb 09, 2021 at 11:33:04AM -0500, Johannes Weiner wrote:
> With memcg having switched to rstat, memory.stat output is precise.
> Update the cgroup selftest to reflect the expectations and error
> tolerances of the new implementation.
> 
> Also add newly tracked types of memory to the memory.stat side of the
> equation, since they're included in memory.current and could throw
> false positives.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
