From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 0/2] mm: memcontrol: cgroup2 memory statistics
Date: Fri, 15 Jan 2016 15:30:59 -0500
Message-ID: <20160115203059.GA25092@cmpxchg.org>
References: <1452722469-24704-1-git-send-email-hannes@cmpxchg.org>
 <20160113144916.03f03766e201b6b04a8a47cc@linux-foundation.org>
 <20160114202408.GA20218@cmpxchg.org>
 <20160115095834.GP30160@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160115095834.GP30160@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Jan 15, 2016 at 12:58:34PM +0300, Vladimir Davydov wrote:
> With the follow-up it looks good to me. All exported counters look
> justified enough and the format follows that of other cgroup2
> controllers (cpu, blkio). Thanks!
> 
> Acked-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Thanks Vladimir.

> One addition though. May be, we could add 'total' field which would show
> memory.current? Yeah, this would result in a little redundancy, but I
> think that from userspace pov it's much more convenient to read the
> only file and get all stat counters than having them spread throughout
> several files.

I am not fully convinced that a total value or even memory.current
will be looked at that often in practice, because in all but a few
cornercases that value will be pegged to the configured limit. In
those instances I think it should be okay to check another file.

> Come to think of it, do we really need separate memory.events file?
> Can't these counters live in memory.stat either?

I think it sits at a different level of the interface. The events file
indicates cgroup-specific dynamics between configuration and memory
footprint, and so it sits on the same level as low, high, max, and
current. These are the parts involved in the most basic control loop
between the kernel and the job scheduler--monitor and adjust or notify
the admin. It's for the entity that allocates and manages the system.

The memory.stat file on the other hand is geared toward analyzing and
understanding workload-specific performance (whether by humans or with
some automated heuristics) and if necessary correcting the config file
that describes the application's requirements to the job scheduler.

I think it makes sense to not conflate these two interfaces.

> Yeah, this file
> generates events, but IMHO it's not very useful the way it is currently
> implemented:
> 
> Suppose, a user wants to receive notifications about OOM or LOW events,
> which are rather rare normally and might require immediate action. The
> only way to do that is to listen to memory.events, but this file can
> generate tons of MAX/HIGH when the cgroup is performing normally. The
> userspace app will have to wake up every time the cgroup performs
> reclaim and check memory.events just to ensure no OOM happened and this
> all will result in wasting cpu time.

Under optimal system load there is no limit reclaim, and memory
pressure comes exclusively from a shortage of physical pages that
global reclaim balances based on memory.low. If groups run into their
own limits, it means that there are idle resources left on the table.

So events only happen when the machine is over or under utilized, and
as per above, the events file is mainly meant for something like a job
scheduler tasked with allocating the machine's resources. It's hard to
imagine a job scheduler scenario where the long-term goal is anything
other than optimal utilization.

There are reasonable cases in which memory could be temporarily left
idle, say to keep startup latency of new jobs low. In those it's true
that the max and high notifications might become annoying. But do you
really think that could become problematic in practice? In that case
it should be enough if we ratelimit the file-changed notifications.

> May be, we could generate LOW/HIGH/MAX events on memory.low/high/max?
> This would look natural IMO. Don't know where OOM events should go in
> this case though.

Without a natural place for OOM notifications, it probably makes sense
to stick with memory.events.

Thanks,
Johannes
