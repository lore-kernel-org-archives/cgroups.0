From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 0/2] mm: memcontrol: cgroup2 memory statistics
Date: Fri, 15 Jan 2016 12:58:34 +0300
Message-ID: <20160115095834.GP30160@esperanza>
References: <1452722469-24704-1-git-send-email-hannes@cmpxchg.org>
 <20160113144916.03f03766e201b6b04a8a47cc@linux-foundation.org>
 <20160114202408.GA20218@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160114202408.GA20218-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hi Johannes,

On Thu, Jan 14, 2016 at 03:24:08PM -0500, Johannes Weiner wrote:
...
> The output of this file looks as follows:
> 
> $ cat memory.stat
> anon 167936
> file 87302144
> file_mapped 0
> file_dirty 0
> file_writeback 0
> inactive_anon 0
> active_anon 155648
> inactive_file 87298048
> active_file 4096
> unevictable 0
> pgfault 636
> pgmajfault 0
> 
> The list consists of two sections: statistics reflecting the current
> state of the memory management subsystem, and statistics reflecting
> past events. The items themselves are sorted such that generic big
> picture items come before specific details, and items related to
> userspace activity come before items related to kernel heuristics.
> 
> All memory counters are in bytes to eliminate all ambiguity with
> variable page sizes.
> 
> There will be more items and statistics added in the future, but this
> is a good initial set to get a minimum of insight into how a cgroup is
> using memory, and the items chosen for now are likely to remain valid
> even with significant changes to the memory management implementation.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

With the follow-up it looks good to me. All exported counters look
justified enough and the format follows that of other cgroup2
controllers (cpu, blkio). Thanks!

Acked-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

One addition though. May be, we could add 'total' field which would show
memory.current? Yeah, this would result in a little redundancy, but I
think that from userspace pov it's much more convenient to read the
only file and get all stat counters than having them spread throughout
several files.

Come to think of it, do we really need separate memory.events file?
Can't these counters live in memory.stat either? Yeah, this file
generates events, but IMHO it's not very useful the way it is currently
implemented:

Suppose, a user wants to receive notifications about OOM or LOW events,
which are rather rare normally and might require immediate action. The
only way to do that is to listen to memory.events, but this file can
generate tons of MAX/HIGH when the cgroup is performing normally. The
userspace app will have to wake up every time the cgroup performs
reclaim and check memory.events just to ensure no OOM happened and this
all will result in wasting cpu time.

May be, we could generate LOW/HIGH/MAX events on memory.low/high/max?
This would look natural IMO. Don't know where OOM events should go in
this case though.

Thanks,
Vladimir
