From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 2/2] memcg: dump memory.stat during cgroup OOM for v1
Date: Thu, 27 Apr 2023 02:21:30 -0700
Message-ID: <CAJD7tkZ1cODXRuVQ3fWL0s=VsyKZqDPPNqFZec_COAXm0XfXWA@mail.gmail.com>
References: <20230426133919.1342942-1-yosryahmed@google.com>
 <20230426133919.1342942-3-yosryahmed@google.com> <ZElC127xlU2NtlqF@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682587327; x=1685179327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iEYtiCxAFTT9nXuyjd6W9FGtnnEdizlurXntdkjLbWw=;
        b=DjlOfwcGalpmFwZRlwKkvYAn8STIQN+MKG4F65GC4r7jVv1sLRLlBH3Wcxen9DqUeN
         0bm6Gj7fDcuXsqj4nk5i662ifcqhyZEZYZH21y+uUc9rNB3V5EQEPJ0Ac8Sxt22MJstO
         7nwaf8iTBOVAnavohH1/kWyE76bbKgVXU2yrnc4OQGBmJw42GNzTot1mAiGOqFKbrfDJ
         Nf2GhDxWo836YKH6ifbrTfRhoscfANxgxxCyiOL6eAdqfFrf8OVPxld7nXem9N82ZJNO
         VGbizhpTMriKxG5mAYlx5TjLuE8/TjK6tn0hx3iC0JAnKmwgG7BFg734fn5nuVsAqFJE
         Ygew==
In-Reply-To: <ZElC127xlU2NtlqF@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, Sergey Senozhatsky <senozhatsky@chromium.org>, Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.com>, Chris Li <chrisl@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed, Apr 26, 2023 at 8:27=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Wed 26-04-23 13:39:19, Yosry Ahmed wrote:
> > Commit c8713d0b2312 ("mm: memcontrol: dump memory.stat during cgroup
> > OOM") made sure we dump all the stats in memory.stat during a cgroup
> > OOM, but it also introduced a slight behavioral change. The code used t=
o
> > print the non-hierarchical v1 cgroup stats for the entire cgroup
> > subtree, not it only prints the v2 cgroup stats for the cgroup under
> > OOM.
> >
> > Although v2 stats are a superset of v1 stats, some of them have
> > different naming. We also lost the non-hierarchical stats for the cgrou=
p
> > under OOM in v1.
>
> Why is that a problem worth solving? It would be also nice to add an
> example of the oom report before and after the patch.
> --
> Michal Hocko
> SUSE Labs

Thanks for taking a look!

The problem is that when upgrading to a kernel that contains
c8713d0b2312 on cgroup v1, the OOM logs suddenly change. The stats
names become different, a couple of stats are gone, and the
non-hierarchical stats disappear.

The non-hierarchical stats are important to identify if a memcg OOM'd
because of the memory consumption of its own processes or its
descendants. In the example below, I created a parent memcg "a", and a
child memcg "b". A process in "a" itself ("tail" in this case) is
hogging memory and causing an OOM, not the processes in the child "b"
(the "sleep" processes). With non-hierarchical stats, it's clear that
this is the case.

Also, it is generally nice to keep things consistent as much as
possible. The sudden change of the OOM log with the kernel upgrade is
confusing, especially that the memcg stats in the OOM logs in cgroup
v1 now look different from the stats in memory.stat. This patch
restores the consistency for cgroup v1, without affecting cgroup v2.
IMO, it's also a nice cleanup to have the stats formatting code be
consistent across cgroup v1 and v2. I personally didn't like the
memory_stat_format() vs. memcg_stat_show() distinction.

Here is a sample of the OOM logs from the scenario described above:

Before:
[   88.339330] memory: usage 10240kB, limit 10240kB, failcnt 54
[   88.339340] memory+swap: usage 10240kB, limit 9007199254740988kB, failcn=
t 0
[   88.339347] kmem: usage 552kB, limit 9007199254740988kB, failcnt 0
[   88.339348] Memory cgroup stats for /a:
[   88.339458] anon 9900032
[   88.339483] file 0
[   88.339483] kernel 565248
[   88.339484] kernel_stack 0
[   88.339485] pagetables 294912
[   88.339486] sec_pagetables 0
[   88.339486] percpu 15584
[   88.339487] sock 0
[   88.339487] vmalloc 0
[   88.339488] shmem 0
[   88.339488] zswap 0
[   88.339489] zswapped 0
[   88.339489] file_mapped 0
[   88.339490] file_dirty 0
[   88.339490] file_writeback 0
[   88.339491] swapcached 0
[   88.339491] anon_thp 2097152
[   88.339492] file_thp 0
[   88.339492] shmem_thp 0
[   88.339497] inactive_anon 9797632
[   88.339498] active_anon 45056
[   88.339498] inactive_file 0
[   88.339499] active_file 0
[   88.339499] unevictable 0
[   88.339500] slab_reclaimable 19888
[   88.339500] slab_unreclaimable 42752
[   88.339501] slab 62640
[   88.339501] workingset_refault_anon 0
[   88.339502] workingset_refault_file 0
[   88.339502] workingset_activate_anon 0
[   88.339503] workingset_activate_file 0
[   88.339503] workingset_restore_anon 0
[   88.339504] workingset_restore_file 0
[   88.339504] workingset_nodereclaim 0
[   88.339505] pgscan 0
[   88.339505] pgsteal 0
[   88.339506] pgscan_kswapd 0
[   88.339506] pgscan_direct 0
[   88.339507] pgscan_khugepaged 0
[   88.339507] pgsteal_kswapd 0
[   88.339508] pgsteal_direct 0
[   88.339508] pgsteal_khugepaged 0
[   88.339509] pgfault 2750
[   88.339509] pgmajfault 0
[   88.339510] pgrefill 0
[   88.339510] pgactivate 1
[   88.339511] pgdeactivate 0
[   88.339511] pglazyfree 0
[   88.339512] pglazyfreed 0
[   88.339512] zswpin 0
[   88.339513] zswpout 0
[   88.339513] thp_fault_alloc 0
[   88.339514] thp_collapse_alloc 1
[   88.339514] Tasks state (memory values in pages):
[   88.339515] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes
swapents oom_score_adj name
[   88.339516] [    108]     0   108     2986     2624    61440
0             0 tail
[   88.339525] [     97]     0    97      724      352    32768
0             0 sleep
[   88.339538] [     99]     0    99      724      352    32768
0             0 sleep
[   88.339541] [     98]     0    98      724      320    32768
0             0 sleep
[   88.339542] [    101]     0   101      724      320    32768
0             0 sleep
[   88.339544] [    102]     0   102      724      352    32768
0             0 sleep
[   88.339546] [    103]     0   103      724      352    32768
0             0 sleep
[   88.339548] [    104]     0   104      724      352    32768
0             0 sleep
[   88.339549] [    105]     0   105      724      352    32768
0             0 sleep
[   88.339551] [    100]     0   100      724      352    32768
0             0 sleep
[   88.339558] [    106]     0   106      724      352    32768
0             0 sleep
[   88.339563] oom-kill:constraint=3DCONSTRAINT_MEMCG,nodemask=3D(null),cpu=
set=3D/,mems_allowed=3D0-2,oom_memcg=3D/a,task_memcg=3D/a,task=3Dtail,pid=
=3D108,uid0
[   88.339588] Memory cgroup out of memory: Killed process 108 (tail)
total-vm:11944kB, anon-rss:9216kB, file-rss:0kB, shmem-rss:1280kB,
UID:00


After:
[   74.447997] memory: usage 10240kB, limit 10240kB, failcnt 116
[   74.447998] memory+swap: usage 10240kB, limit 9007199254740988kB, failcn=
t 0
[   74.448000] kmem: usage 548kB, limit 9007199254740988kB, failcnt 0
[   74.448001] Memory cgroup stats for /a:
[   74.448103] cache 0
[   74.448104] rss 9433088
[   74.448105] rss_huge 2097152
[   74.448105] shmem 0
[   74.448106] mapped_file 0
[   74.448106] dirty 0
[   74.448107] writeback 0
[   74.448107] workingset_refault_anon 0
[   74.448108] workingset_refault_file 0
[   74.448109] swap 0
[   74.448109] pgpgin 2304
[   74.448110] pgpgout 512
[   74.448111] pgfault 2332
[   74.448111] pgmajfault 0
[   74.448112] inactive_anon 9388032
[   74.448112] active_anon 4096
[   74.448113] inactive_file 0
[   74.448113] active_file 0
[   74.448114] unevictable 0
[   74.448114] hierarchical_memory_limit 10485760
[   74.448115] hierarchical_memsw_limit 9223372036854771712
[   74.448116] total_cache 0
[   74.448116] total_rss 9818112
[   74.448117] total_rss_huge 2097152
[   74.448118] total_shmem 0
[   74.448118] total_mapped_file 0
[   74.448119] total_dirty 0
[   74.448119] total_writeback 0
[   74.448120] total_workingset_refault_anon 0
[   74.448120] total_workingset_refault_file 0
[   74.448121] total_swap 0
[   74.448121] total_pgpgin 2407
[   74.448121] total_pgpgout 521
[   74.448122] total_pgfault 2734
[   74.448122] total_pgmajfault 0
[   74.448123] total_inactive_anon 9715712
[   74.448123] total_active_anon 45056
[   74.448124] total_inactive_file 0
[   74.448124] total_active_file 0
[   74.448125] total_unevictable 0
[   74.448125] Tasks state (memory values in pages):
[   74.448126] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes
swapents oom_score_adj name
[   74.448127] [    107]     0   107     2982     2592    61440
0             0 tail
[   74.448131] [     97]     0    97      724      352    32768
0             0 sleep
[   74.448134] [     98]     0    98      724      352    32768
0             0 sleep
[   74.448136] [     99]     0    99      724      352    32768
0             0 sleep
[   74.448137] [    101]     0   101      724      352    32768
0             0 sleep
[   74.448139] [    102]     0   102      724      352    32768
0             0 sleep
[   74.448141] [    103]     0   103      724      352    28672
0             0 sleep
[   74.448143] [    104]     0   104      724      352    32768
0             0 sleep
[   74.448144] [    105]     0   105      724      352    32768
0             0 sleep
[   74.448146] [    106]     0   106      724      352    32768
0             0 sleep
[   74.448148] [    100]     0   100      724      352    32768
0             0 sleep
[   74.448155] oom-kill:constraint=3DCONSTRAINT_MEMCG,nodemask=3D(null),cpu=
set=3D/,mems_allowed=3D0-2,oom_memcg=3D/a,task_memcg=3D/a,task=3Dtail,pid=
=3D107,uid0
[   74.448178] Memory cgroup out of memory: Killed process 107 (tail)
total-vm:11928kB, anon-rss:9088kB, file-rss:0kB, shmem-rss:1280kB,
UID:00
