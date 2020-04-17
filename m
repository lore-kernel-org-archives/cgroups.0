From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: automatically penalize tasks with high swap use
Date: Fri, 17 Apr 2020 16:22:48 -0700
Message-ID: <20200417162248.415ff51e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200417010617.927266-1-kuba@kernel.org>
        <20200417010617.927266-4-kuba@kernel.org>
        <20200417073716.GG26707@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587165771;
        bh=ftdKWGgpIDLZDqr/mtlNo4/49vEIAWuOveNytV1igpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cZ0BvbedqipSYOEP06wf+4Wk0rHhX3n7O/h+J7aROxs03yXlcfHFdrb7woubqPx6g
         0trl37tPnerWYr7m3ao1JycRQI7QFYAeRQFOFlawPRqSRobYUm8wbD/0A44lY3u+s9
         c69OVXWHRvSQhao25faEPxiEbtuZJ/hNKYij0L3M=
In-Reply-To: <20200417073716.GG26707-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 17 Apr 2020 09:37:16 +0200 Michal Hocko wrote:
> On Thu 16-04-20 18:06:17, Jakub Kicinski wrote:
> > Add a memory.swap.high knob, which functions in a similar way
> > to memory.high, but with a less steep slope.  
> 
> This really begs for more details. What does "similar way to
> memory.high" mean? Because my first thought would be that the swap usage
> will be throttled and kept at the swap.high level. From a quick look at
> the patch you only do throttling. There is no swap space reclaim to keep
> the usage at the level. So unless I am missing something this is very
> confusing and it doesn't really fit into high limit semantic.

The new knob does influence mem_cgroup_swap_full(), but you're right,
the analogy is not strong enough, I'll rephrase.

> This changelog also doesn't describe any usecase.

Will do.
