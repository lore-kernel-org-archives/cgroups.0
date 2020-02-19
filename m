From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Wed, 19 Feb 2020 11:31:39 -0800
Message-ID: <20200219113139.ee60838bc7eb35747eb330fa@linux-foundation.org>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
        <20200219183731.GC11847@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582140700;
        bh=WFvZa8hDniOG8g1qTenV8AtspoE+3eAninCHZes58LU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0/Z2qwVUjvEBK9lueZh7pxv8imBgjnkMO9MVu2fV58D6nh1RWpn7VHc0zxzfzsbVd
         k3NwiEWCzkAAatIu4pcPaBY36s/oaD/qjVZML74u8CLJS+JdScIbOuCsQ9x6tv8p70
         +pBJ6402V2bEIvxO3B1PeMhVv6eRF3KfABKD6MYk=
In-Reply-To: <20200219183731.GC11847-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, 19 Feb 2020 19:37:31 +0100 Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> On Wed 19-02-20 13:12:19, Johannes Weiner wrote:
> > We have received regression reports from users whose workloads moved
> > into containers and subsequently encountered new latencies. For some
> > users these were a nuisance, but for some it meant missing their SLA
> > response times. We tracked those delays down to cgroup limits, which
> > inject direct reclaim stalls into the workload where previously all
> > reclaim was handled my kswapd.
> 
> I am curious why is this unexpected when the high limit is explicitly
> documented as a throttling mechanism.

Yes, this sounds like a feature-not-a-bug.

But what was the nature of these stalls?  If they were "stuck in D
state waiting for something" then that's throttling.  If they were
"unexpected bursts of in-kernel CPU activity" then I see a better case.

