From: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Thu, 14 Nov 2013 16:56:49 -0600
Message-ID: <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com>
 <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=imvyMi+ytPokgphWaNIwp2mfEnjDC8QaH/w2Kffsl+w=;
        b=SgEf/1ppsSqhslSqtZPfcMG3BJoXL9HF0GKqvwcxg/nsDQTcnX37K56vSoX900wNLU
         /1LS06qHL8Uy+QP3GPhTQIXbbwJcxliQ0TDAWkssHxmjtN1W+H3ZJOQUO8L1lTaCaTQN
         MT1i7Mzp6QP8Jf/z0Nd43o8+jwya7i/Mz/KngVNqmqDFDSP4ay5S/eDxvchhHKhlvyr1
         kuCSPNH3xyAWxIgQdrB0zXsOvUsIVYygJ2ofJb81AwzSZ2ss53cDyPtDigEzfJDRwclM
         ctLmolvEWPqTSgeouqgmM9+ApCUKIqhbGOaBnV5kBb4yQxtcYMuAUoho4KpVyAbsAr0P
         zXFg==
Content-Disposition: inline
In-Reply-To: <20131112165504.GF6049-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

On Tue, Nov 12, 2013 at 05:55:04PM +0100, Michal Hocko wrote:
> On Tue 12-11-13 09:55:30, Shawn Bohrer wrote:
> > On Tue, Nov 12, 2013 at 03:31:47PM +0100, Michal Hocko wrote:
> > > On Tue 12-11-13 18:17:20, Li Zefan wrote:
> > > > Cc more people
> > > > 
> > > > On 2013/11/12 6:06, Shawn Bohrer wrote:
> > > > > Hello,
> > > > > 
> > > > > This morning I had a machine running 3.10.16 go unresponsive but
> > > > > before we killed it we were able to get the information below.  I'm
> > > > > not an expert here but it looks like most of the tasks below are
> > > > > blocking waiting on the cgroup_mutex.  You can see that the
> > > > > resource_alloca:16502 task is holding the cgroup_mutex and that task
> > > > > appears to be waiting on a lru_add_drain_all() to complete.
> > > 
> > > Do you have sysrq+l output as well by any chance? That would tell
> > > us what the current CPUs are doing. Dumping all kworker stacks
> > > might be helpful as well. We know that lru_add_drain_all waits for
> > > schedule_on_each_cpu to return so it is waiting for workers to finish.
> > > I would be really curious why some of lru_add_drain_cpu cannot finish
> > > properly. The only reason would be that some work item(s) do not get CPU
> > > or somebody is holding lru_lock.
> > 
> > In fact the sys-admin did manage to fire off a sysrq+l, I've put all
> > of the info from the syslog below.  I've looked it over and I'm not
> > sure it reveals anything.  First looking at the timestamps it appears
> > we ran the sysrq+l 19.2 hours after the cgroup_mutex lockup I
> > previously sent.
> 
> I would expect sysrq+w would still show those kworkers blocked on the
> same cgroup mutex?

Yes, I believe so.

> > I also have atop logs over that whole time period
> > that show hundreds of zombie processes which to me indicates that over
> > that 19.2 hours systemd remained wedged on the cgroup_mutex.  Looking
> > at the backtraces from the sysrq+l it appears most of the CPUs were
> > idle
> 
> Right so either we managed to sleep with the lru_lock held which sounds
> a bit improbable - but who knows - or there is some other problem. I
> would expect the later to be true.
> 
> lru_add_drain executes per-cpu and preemption disabled this means that
> its work item cannot be preempted so the only logical explanation seems
> to be that the work item has never got scheduled.

Meaning you think there would be no kworker thread for the
lru_add_drain at this point?  If so you might be correct.

> OK. In case the issue happens again. It would be very helpful to get the
> kworker and per-cpu stacks. Maybe Tejun can help with some waitqueue
> debugging tricks.

I set up one of my test pools with two scripts trying to reproduce the
problem.  One essentially puts tasks into several cpuset groups that
have cpuset.memory_migrate set, then takes them back out.  It also
occasionally switches cpuset.mems in those groups to try to keep the
memory of those tasks migrating between nodes.  The second script is:

$ cat /home/hbi/cgroup_mutex_cgroup_maker.sh 
#!/bin/bash

session_group=$(ps -o pid,cmd,cgroup -p $$ | grep -E 'c[0-9]+' -o)
cd /sys/fs/cgroup/systemd/user/hbi/${session_group}
pwd

while true; do
    for x in $(seq 1 1000); do
        mkdir $x
        echo $$ > ${x}/tasks
        echo $$ > tasks
        rmdir $x
    done
    sleep .1
    date
done

After running both concurrently on 40 machines for about 12 hours I've
managed to reproduce the issue at least once, possibly more.  One
machine looked identical to this reported issue.  It has a bunch of
stuck cgroup_free_fn() kworker threads and one thread in cpuset_attach
waiting on lru_add_drain_all().  A sysrq+l shows all CPUs are idle
except for the one triggering the sysrq+l.  The sysrq+w unfortunately
wrapped dmesg so we didn't get the stacks of all blocked tasks.  We
did however also cat /proc/<pid>/stack of all kworker threads on the
system.  There were 265 kworker threads that all have the following
stack:

[kworker/2:1]
[<ffffffff810930ec>] cgroup_free_fn+0x2c/0x120
[<ffffffff81057c54>] process_one_work+0x174/0x490
[<ffffffff81058d0c>] worker_thread+0x11c/0x370
[<ffffffff8105f0b0>] kthread+0xc0/0xd0
[<ffffffff814c20dc>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

And there were another 101 that had stacks like the following:

[kworker/0:0]
[<ffffffff81058daf>] worker_thread+0x1bf/0x370
[<ffffffff8105f0b0>] kthread+0xc0/0xd0
[<ffffffff814c20dc>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

That's it.  Again I'm not sure if that is helpful at all but it seems
to imply that the lru_add_drain_work was not scheduled.

I also managed to kill another two machines running my test.  One of
them we didn't get anything out of, and the other looks like I
deadlocked on the css_set_lock lock.  I'll follow up with the
css_set_lock deadlock in another email since it doesn't look related
to this one.  But it does seem that I can probably reproduce this if
anyone has some debugging ideas.

--
Shawn
