From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Tue, 12 Nov 2013 17:55:04 +0100
Message-ID: <20131112165504.GF6049@dhcp22.suse.cz>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com>
 <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131112155530.GA2860-/vebjAlq/uFE7V8Yqttd03bhEEblAqRIDbRjUBewulXQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

On Tue 12-11-13 09:55:30, Shawn Bohrer wrote:
> On Tue, Nov 12, 2013 at 03:31:47PM +0100, Michal Hocko wrote:
> > On Tue 12-11-13 18:17:20, Li Zefan wrote:
> > > Cc more people
> > > 
> > > On 2013/11/12 6:06, Shawn Bohrer wrote:
> > > > Hello,
> > > > 
> > > > This morning I had a machine running 3.10.16 go unresponsive but
> > > > before we killed it we were able to get the information below.  I'm
> > > > not an expert here but it looks like most of the tasks below are
> > > > blocking waiting on the cgroup_mutex.  You can see that the
> > > > resource_alloca:16502 task is holding the cgroup_mutex and that task
> > > > appears to be waiting on a lru_add_drain_all() to complete.
> > 
> > Do you have sysrq+l output as well by any chance? That would tell
> > us what the current CPUs are doing. Dumping all kworker stacks
> > might be helpful as well. We know that lru_add_drain_all waits for
> > schedule_on_each_cpu to return so it is waiting for workers to finish.
> > I would be really curious why some of lru_add_drain_cpu cannot finish
> > properly. The only reason would be that some work item(s) do not get CPU
> > or somebody is holding lru_lock.
> 
> In fact the sys-admin did manage to fire off a sysrq+l, I've put all
> of the info from the syslog below.  I've looked it over and I'm not
> sure it reveals anything.  First looking at the timestamps it appears
> we ran the sysrq+l 19.2 hours after the cgroup_mutex lockup I
> previously sent.

I would expect sysrq+w would still show those kworkers blocked on the
same cgroup mutex?

> I also have atop logs over that whole time period
> that show hundreds of zombie processes which to me indicates that over
> that 19.2 hours systemd remained wedged on the cgroup_mutex.  Looking
> at the backtraces from the sysrq+l it appears most of the CPUs were
> idle

Right so either we managed to sleep with the lru_lock held which sounds
a bit improbable - but who knows - or there is some other problem. I
would expect the later to be true.

lru_add_drain executes per-cpu and preemption disabled this means that
its work item cannot be preempted so the only logical explanation seems
to be that the work item has never got scheduled.

> except there are a few where ptpd is trying to step the clock
> with clock_settime.  The ptpd process also appears to get stuck for a
> bit but it looks like it recovers because it moves CPUs and the
> previous CPUs become idle.

It gets soft lockup because it is waiting for it's own IPIs which got
preempted by NMI trace dumper. But this is unrelated.

> The fact that ptpd is stepping the clock
> at all at this time means that timekeeping is a mess at this point and
> the system clock is way out of sync.  There are also a few of these
> NMI messages in there that I don't understand but at this point the
> machine was a sinking ship.
> 
> Nov 11 07:03:29 sydtest0 kernel: [764305.327043] Uhhuh. NMI received for unknown reason 21 on CPU 26.
> Nov 11 07:03:29 sydtest0 kernel: [764305.327043] Do you have a strange power saving mode enabled?
> Nov 11 07:03:29 sydtest0 kernel: [764305.327043] Dazed and confused, but trying to continue
> Nov 11 07:03:29 sydtest0 kernel: [764305.327143] Uhhuh. NMI received for unknown reason 31 on CPU 27.
> Nov 11 07:03:29 sydtest0 kernel: [764305.327144] Do you have a strange power saving mode enabled?
> Nov 11 07:03:29 sydtest0 kernel: [764305.327144] Dazed and confused, but trying to continue
> Nov 11 07:03:29 sydtest0 kernel: [764305.327242] Uhhuh. NMI received for unknown reason 31 on CPU 28.
> Nov 11 07:03:29 sydtest0 kernel: [764305.327242] Do you have a strange power saving mode enabled?
> Nov 11 07:03:29 sydtest0 kernel: [764305.327243] Dazed and confused, but trying to continue
> 
> Perhaps there is another task blocking somewhere holding the lru_lock, but at
> this point the machine has been rebooted so I'm not sure how we'd figure out
> what task that might be. Anyway here is the full output of sysrq+l plus
> whatever else ended up in the syslog.

OK. In case the issue happens again. It would be very helpful to get the
kworker and per-cpu stacks. Maybe Tejun can help with some waitqueue
debugging tricks.
-- 
Michal Hocko
SUSE Labs
