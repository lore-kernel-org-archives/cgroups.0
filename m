From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Re: Memory CG and 5.1 to 5.6 uprade slows backup
Date: Thu, 9 Apr 2020 17:09:26 +0200
Message-ID: <20200409170926.182354c3@hemera.lan.sysophe.eu>
References: <20200409112505.2e1fc150@hemera.lan.sysophe.eu>
        <20200409094615.GE18386@dhcp22.suse.cz>
        <20200409121733.1a5ba17c@hemera.lan.sysophe.eu>
        <20200409103400.GF18386@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200409103400.GF18386-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Thu, 9 Apr 2020 12:34:00 +0200Michal Hocko wrote:

> On Thu 09-04-20 12:17:33, Bruno Prémont wrote:
> > On Thu, 9 Apr 2020 11:46:15 Michal Hocko wrote:  
> > > [Cc Chris]
> > > 
> > > On Thu 09-04-20 11:25:05, Bruno Prémont wrote:  
> > > > Hi,
> > > > 
> > > > Upgrading from 5.1 kernel to 5.6 kernel on a production system using
> > > > cgroups (v2) and having backup process in a memory.high=2G cgroup
> > > > sees backup being highly throttled (there are about 1.5T to be
> > > > backuped).    
> > > 
> > > What does /proc/sys/vm/dirty_* say?  
> > 
> > /proc/sys/vm/dirty_background_bytes:0
> > /proc/sys/vm/dirty_background_ratio:10
> > /proc/sys/vm/dirty_bytes:0
> > /proc/sys/vm/dirty_expire_centisecs:3000
> > /proc/sys/vm/dirty_ratio:20
> > /proc/sys/vm/dirty_writeback_centisecs:500  
> 
> Sorry, but I forgot ask for the total amount of memory. But it seems
> this is 64GB and 10% dirty ration might mean a lot of dirty memory.
> Does the same happen if you reduce those knobs to something smaller than
> 2G? _bytes alternatives should be useful for that purpose.

Well, tuning it to /proc/sys/vm/dirty_background_bytes:268435456
/proc/sys/vm/dirty_background_ratio:0
/proc/sys/vm/dirty_bytes:536870912
/proc/sys/vm/dirty_expire_centisecs:3000
/proc/sys/vm/dirty_ratio:0
/proc/sys/vm/dirty_writeback_centisecs:500
does not make any difference.


From /proc/meminfo there is no indication on high amounts of dirty
memory either:
MemTotal:       65930032 kB
MemFree:        21237240 kB
MemAvailable:   51646528 kB
Buffers:          202692 kB
Cached:         21493120 kB
SwapCached:            0 kB
Active:         12875888 kB
Inactive:       11361852 kB
Active(anon):    2879072 kB
Inactive(anon):    20600 kB
Active(file):    9996816 kB
Inactive(file): 11341252 kB
Unevictable:        9396 kB
Mlocked:            9396 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:              3880 kB
Writeback:             0 kB
AnonPages:       2551776 kB
Mapped:           461816 kB
Shmem:            351144 kB
KReclaimable:   10012140 kB
Slab:           15673816 kB
SReclaimable:   10012140 kB
SUnreclaim:      5661676 kB
KernelStack:        7888 kB
PageTables:        24192 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    32965016 kB
Committed_AS:    4792440 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      126408 kB
VmallocChunk:          0 kB
Percpu:           136448 kB
HardwareCorrupted:     0 kB
AnonHugePages:    825344 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
FileHugePages:         0 kB
FilePmdMapped:         0 kB
CmaTotal:              0 kB
CmaFree:               0 kB
DirectMap4k:       27240 kB
DirectMap2M:     4132864 kB
DirectMap1G:    65011712 kB


> [...]
> 
> > > Is it possible that the reclaim is not making progress on too many
> > > dirty pages and that triggers the back off mechanism that has been
> > > implemented recently in  5.4 (have a look at 0e4b01df8659 ("mm,
> > > memcg: throttle allocators when failing reclaim over memory.high")
> > > and e26733e0d0ec ("mm, memcg: throttle allocators based on
> > > ancestral memory.high").  
> > 
> > Could be though in that case it's throttling the wrong task/cgroup
> > as far as I can see (at least from cgroup's memory stats) or being
> > blocked by state external to the cgroup.
> > Will have a look at those patches so get a better idea at what they
> > change.  
> 
> Could you check where is the task of your interest throttled?
> /proc/<pid>/stack should give you a clue.

As guessed by Chris, it's
[<0>] mem_cgroup_handle_over_high+0x121/0x170
[<0>] exit_to_usermode_loop+0x67/0xa0
[<0>] do_syscall_64+0x149/0x170
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9


And I know no way to tell kernel "drop all caches" for a specific cgroup
nor how to list the inactive files assigned to a given cgroup (knowing
which ones they are and their idle state could help understanding why
they aren't being reclaimed).



Could it be that cache is being prevented from being reclaimed by a task
in another cgroup?

e.g.
  cgroup/system/backup
    first reads $files (reads each once)
  cgroup/workload/bla
    second&more reads $files

Would $files remain associated to cgroup/system/backup and not
reclaimed there instead of being reassigned to cgroup/workload/bla?



Bruno
