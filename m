From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Subject: Memory CG and 5.1 to 5.6 uprade slows backup
Date: Thu, 9 Apr 2020 11:25:05 +0200
Message-ID: <20200409112505.2e1fc150@hemera.lan.sysophe.eu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi,

Upgrading from 5.1 kernel to 5.6 kernel on a production system using
cgroups (v2) and having backup process in a memory.high=2G cgroup
sees backup being highly throttled (there are about 1.5T to be
backuped).

Most memory usage in that cgroup is for file cache.

Here are the memory details for the cgroup:
memory.current:2147225600
memory.events:low 0
memory.events:high 423774
memory.events:max 31131
memory.events:oom 0
memory.events:oom_kill 0
memory.events.local:low 0
memory.events.local:high 423774
memory.events.local:max 31131
memory.events.local:oom 0
memory.events.local:oom_kill 0
memory.high:2147483648
memory.low:33554432
memory.max:2415919104
memory.min:0
memory.oom.group:0
memory.pressure:some avg10=90.42 avg60=72.59 avg300=78.30 total=298252577711
memory.pressure:full avg10=90.32 avg60=72.53 avg300=78.24 total=295658626500
memory.stat:anon 10887168
memory.stat:file 2062102528
memory.stat:kernel_stack 73728
memory.stat:slab 76148736
memory.stat:sock 360448
memory.stat:shmem 0
memory.stat:file_mapped 12029952
memory.stat:file_dirty 946176
memory.stat:file_writeback 405504
memory.stat:anon_thp 0
memory.stat:inactive_anon 0
memory.stat:active_anon 10121216
memory.stat:inactive_file 1954959360
memory.stat:active_file 106418176
memory.stat:unevictable 0
memory.stat:slab_reclaimable 75247616
memory.stat:slab_unreclaimable 901120
memory.stat:pgfault 8651676
memory.stat:pgmajfault 2013
memory.stat:workingset_refault 8670651
memory.stat:workingset_activate 409200
memory.stat:workingset_nodereclaim 62040
memory.stat:pgrefill 1513537
memory.stat:pgscan 47519855
memory.stat:pgsteal 44933838
memory.stat:pgactivate 7986
memory.stat:pgdeactivate 1480623
memory.stat:pglazyfree 0
memory.stat:pglazyfreed 0
memory.stat:thp_fault_alloc 0
memory.stat:thp_collapse_alloc 0

Numbers that change most are pgscan/pgsteal
Regularly the backup process seems to be blocked for about 2s, but not
within a syscall according to strace.

Is there a way to tell kernel that this cgroup should not be throttled
and its inactive file cache given up (rather quickly).

The aim here is to avoid backup from killing production task file cache
but not starving it.


If there is some useful info missing, please tell (eventually adding how
I can obtain it).


On a side note, I liked v1's mode of soft/hard memory limit where the
memory amount between soft and hard could be used if system has enough
free memory. For v2 the difference between high and max seems almost of
no use.

A cgroup parameter for impacting RO file cache differently than
anonymous memory or otherwise dirty memory would be great too.


Thanks,
Bruno
