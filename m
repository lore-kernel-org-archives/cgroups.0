From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: execute partial memcg freeing in mem_cgroup_destroy
Date: Fri, 17 Aug 2012 10:36:05 +0400
Message-ID: <502DE655.3010305@parallels.com>
References: <1345114903-20627-1-git-send-email-glommer@parallels.com> <xr93vcgiazok.fsf@gthelen.mtv.corp.google.com> <502DCDD0.3060502@parallels.com> <xr93a9xu9g7z.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <xr93a9xu9g7z.fsf-aSPv4SP+Du0KgorLzL7FmE7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

On 08/17/2012 10:37 AM, Greg Thelen wrote:
> I am by no means a swap expert, so I may be heading in the weeds.  But I
> think that a swapped out page is not necessarily in any memcg lru.  So
> the mem_cgroup_pre_destroy() call to mem_cgroup_force_empty() will not
> necessarily see swapped out pages.
> 
> I think this demonstrates the problem.
hummm, hummm... all right.

I'll take a look at that today

Thanks Greg
