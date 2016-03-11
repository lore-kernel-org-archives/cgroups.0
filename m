From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: reclaim when shrinking memory.high below
 usage
Date: Fri, 11 Mar 2016 11:34:40 +0300
Message-ID: <20160311083440.GI1946@esperanza>
References: <1457643015-8828-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457643015-8828-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Mar 10, 2016 at 03:50:13PM -0500, Johannes Weiner wrote:
> When setting memory.high below usage, nothing happens until the next
> charge comes along, and then it will only reclaim its own charge and
> not the now potentially huge excess of the new memory.high. This can
> cause groups to stay in excess of their memory.high indefinitely.
> 
> To fix that, when shrinking memory.high, kick off a reclaim cycle that
> goes after the delta.

I agree that we should reclaim the high excess, but I don't think it's a
good idea to do it synchronously. Currently, memory.low and memory.high
knobs can be easily used by a single-threaded load manager implemented
in userspace, because it doesn't need to care about potential stalls
caused by writes to these files. After this change it might happen that
a write to memory.high would take long, seconds perhaps, so in order to
react quickly to changes in other cgroups, a load manager would have to
spawn a thread per each write to memory.high, which would complicate its
implementation significantly.

Since, in contrast to memory.max, memory.high definition allows cgroup
to breach it, I believe it would be better if we spawned an asynchronous
reclaim work from the kernel on write to memory.high instead of doing
this synchronously. I guess we could reuse mem_cgroup->high_work for
that.

Thanks,
Vladimir
