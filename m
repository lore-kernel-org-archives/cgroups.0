From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Date: Tue, 12 Nov 2013 15:31:47 +0100
Message-ID: <20131112143147.GB6049@dhcp22.suse.cz>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52820030.6000806-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>

On Tue 12-11-13 18:17:20, Li Zefan wrote:
> Cc more people
> 
> On 2013/11/12 6:06, Shawn Bohrer wrote:
> > Hello,
> > 
> > This morning I had a machine running 3.10.16 go unresponsive but
> > before we killed it we were able to get the information below.  I'm
> > not an expert here but it looks like most of the tasks below are
> > blocking waiting on the cgroup_mutex.  You can see that the
> > resource_alloca:16502 task is holding the cgroup_mutex and that task
> > appears to be waiting on a lru_add_drain_all() to complete.

Do you have sysrq+l output as well by any chance? That would tell
us what the current CPUs are doing. Dumping all kworker stacks
might be helpful as well. We know that lru_add_drain_all waits for
schedule_on_each_cpu to return so it is waiting for workers to finish.
I would be really curious why some of lru_add_drain_cpu cannot finish
properly. The only reason would be that some work item(s) do not get CPU
or somebody is holding lru_lock.

-- 
Michal Hocko
SUSE Labs
