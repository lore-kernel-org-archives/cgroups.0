From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Bug report - OOM killer kills task outside of cgroup
Date: Fri, 12 Sep 2014 10:58:33 +0900
Message-ID: <20140912015833.GA7415@mtj.dyndns.org>
References: <CALehsD6wjTSn2P6vaurL65XLGCymgbMEiddw5=PGBE5+YQq-Gg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pqTyUK2KPqONOeDO1VKEJzoOPdadJ2TTchFcKl6KBkw=;
        b=cb/1Mr4/ZiXJFl0FS5Xw6Ww90azBleS2Xhr+/VgSkgmIwifnDSrzea0/tmWpxTFPrc
         uvGmIArMA6GwILSB5MhHbR5Snn3Ng25QaFwUCBwQ5ol90EjYHy3NBS+JDknjD3YNC3AF
         yYdosWlfX/AyPl2Er9kBWMZy+jSscyQc7ThSsY5kJNbb3BAQdVO1j1/NWIXTPtRL6RKm
         DtY3IvQJT0MtikDeuAL9ioLpkopli0npuiFn8K0ZtuIRVoxj2ClLgxCbo8XKKDf/qtlD
         CXnyLvAi8XkALIB1YPgG/IZlLrIiw2zu1KuYeMwT27ot+RXgXrTchabs8AB/BwttJIB9
         yFvw==
Content-Disposition: inline
In-Reply-To: <CALehsD6wjTSn2P6vaurL65XLGCymgbMEiddw5=PGBE5+YQq-Gg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tyler Power <tylerp-0OmgUqZ5G+O9C01uVemLPA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

(cc'ing memcg maintainers and quoting whole body)

On Thu, Sep 11, 2014 at 02:05:19PM +1200, Tyler Power wrote:
> Hi there,
> 
> Hopefully I'm sending this to the right place, this is the first time
> I've reported a kernel bug. I'm roughly following this format here
> https://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html.
> 
> 1. The OOM killer kicks in to kill processes inside a cgroup that has
> hit its memory limit but sometimes kills a process outside of the
> cgroup
> 
> 2. We've encountered an error on Ubuntu 12.04 running on vsphere with
> kernel linux-image-3.13.0-32-generic as well as
> linux-image-3.13.0-35-generic which causes the machine to hard lock
> up. It is completely unresponsive until hard reset.
> 
> The issue appears to be that the OOM killer kicks in and kills a
> process outside of the cgroup that has hit its memory limit. Once this
> has happened the kernel log shows soft lock ups and eventually
> completely hangs.
> 
> We can fairly consistently reproduce this by starting some processes
> inside an LXC container (via docker) that push the container very
> close to its memory limit. We then have a cron task that starts up
> inside the container and causes it to OOM. The OOM killer then kicks
> in and sometimes will trigger this hang.
> 
> Every time it happens we see this message:
> 
> [ 2635.212105] Task in / killed as a result of limit of
> /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
> 
> Notice how it kills a task in "/"? Immediately following that we start
> seeing this repeated:
> 
> [ 3164.153296] BUG: soft lockup - CPU#0 stuck for 22s! [php5:15940]
> 
> And then the machine hangs.
> 
> It looks very similar to
> http://permalink.gmane.org/gmane.linux.kernel.mm/108113 and
> http://irc.13thfloor.at/LOG/2014-02/LOG_2014-02-28.txt +
> http://217.196.41.9/~ard/bertl-is-the-nicest-guy-in-the-world/jimmy.txt
> (search for "in / killed").
> 
> Kernel log excerpt (fetched via serial using
> GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8 debug
> ignore_loglevel nomodeset pciehp_force=1 pciehp_poll_mode=1")
> 
> [ 2395.454778] docker0: port 2(vethdRqyGV) entered forwarding state
> [ 2410.500706] docker0: port 2(vethdRqyGV) entered forwarding state
> [ 2634.814382] java invoked oom-killer: gfp_mask=0xd0, order=0, oom_score_adj=0
> [ 2634.818286] java
> cpuset=e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
> mems_allowed=0
> [ 2634.822596] CPU: 1 PID: 15775 Comm: java Not tainted
> 3.13.0-32-generic #57~precise1-Ubuntu
> [ 2634.824960] Hardware name: VMware, Inc. VMware Virtual
> Platform/440BX Desktop Reference Platform, BIOS 6.00 06/22/2012
> [ 2634.828336]  ffff8801375a2000 ffff880137f0bbe8 ffffffff81752c9e
> ffff88013fd0fff0
> [ 2634.830662]  ffff8800ab6ddfc0 ffff880137f0bc38 ffffffff81748aba
> ffff880100000000
> [ 2634.832972]  000000d08137cd48 ffff880137f0bc38 ffff8800ae5ec7d0
> 0000000000000000
> [ 2634.835253] Call Trace:
> [ 2634.836418]  [<ffffffff81752c9e>] dump_stack+0x46/0x58
> [ 2634.838078]  [<ffffffff81748aba>] dump_header+0x7e/0xbd
> [ 2634.839825]  [<ffffffff81748b50>] oom_kill_process.part.5+0x57/0x2d4
> [ 2634.841768]  [<ffffffff810751b5>] ? has_ns_capability_noaudit+0x15/0x20
> [ 2634.843776]  [<ffffffff8115b499>] ? oom_badness.part.4+0xa9/0x140
> [ 2634.845637]  [<ffffffff8115b7b7>] oom_kill_process+0x47/0x50
> [ 2634.847424]  [<ffffffff811be85c>] mem_cgroup_out_of_memory+0x28c/0x2b0
> [ 2634.849413]  [<ffffffff811c0c0b>] mem_cgroup_oom_synchronize+0x21b/0x250
> [ 2634.851413]  [<ffffffff811c04c0>] ? memcg_charge_kmem+0xf0/0xf0
> [ 2634.853296]  [<ffffffff8115bb98>] pagefault_out_of_memory+0x18/0x90
> [ 2634.855197]  [<ffffffff817453c4>] mm_fault_error+0xb9/0xd3
> [ 2634.857020]  [<ffffffff817638d5>] __do_page_fault+0x545/0x570
> [ 2634.858815]  [<ffffffff811182cc>] ? acct_account_cputime+0x1c/0x20
> [ 2634.860733]  [<ffffffff810a25e9>] ? account_user_time+0x99/0xb0
> [ 2634.862595]  [<ffffffff810a2c6d>] ? vtime_account_user+0x5d/0x70
> [ 2634.864476]  [<ffffffff8176391a>] do_page_fault+0x1a/0x70
> [ 2634.866197]  [<ffffffff8175fa88>] page_fault+0x28/0x30
> [ 2634.867954] Task in
> /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
> killed as a result of limit of
> /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
> [ 2634.872851] memory: usage 65536kB, limit 65536kB, failcnt 34251
> [ 2634.874714] memory+swap: usage 65536kB, limit 65536kB, failcnt 1
> [ 2634.876622] kmem: usage 0kB, limit 18014398509481983kB, failcnt 0
> [ 2634.878527] Memory cgroup stats for
> /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4:
> cache:412KB rss:65124KB rss_huge:0KB mapped_file:4KB writeback:0KB
> swap:0KB inactive_anon:33392KB active_anon:32052KB inactive_file:88KB
> active_file:0KB unevictable:0KB
> [ 2634.888650] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents
> oom_score_adj name
> [ 2634.891018] [15552]     0 15552    12511      732      29        0
>            0 sshd
> [ 2634.893373] [15596]     0 15596     5180      276      15        0
>            0 cron
> [ 2634.895686] [15731]     0 15731    19971      926      43        0
>            0 sshd
> [ 2634.898004] [15735]  1014 15735    19971      395      40        0
>            0 sshd
> [ 2634.900305] [15736]  1014 15736     2760      376      10        0
>            0 bash
> [ 2634.902588] [15756]  1014 15756   551397    14730      92        0
>            0 java
> [ 2634.904853] [15757]  1014 15757     2760      152      10        0
>            0 bash
> [ 2634.907080] [15758]  1014 15758     2760      158      10        0
>            0 bash
> [ 2634.909316] [15759]  1014 15759     1472      171       7        0
>            0 tee
> [ 2634.911495] [15760]  1014 15760     1472      172       8        0
>            0 tee
> [ 2634.913689] [15936]     0 15936    11535      338      28        0
>            0 cron
> [ 2634.915905] [15937]     0 15937     1102      153       8        0
>            0 sh
> [ 2634.918055] [15938]     0 15938     1102      153       8        0
>            0 maxlifetime
> [ 2634.920385] [15940]     0 15940    53661     2029     105        0
>            0 php5
> [ 2634.922570] Memory cgroup out of memory: Kill process 15919 (java)
> score 904 or sacrifice child
> [ 2634.924952] Killed process 15758 (bash) total-vm:11040kB,
> anon-rss:216kB, file-rss:416kB
> [ 2634.937740] php5 invoked oom-killer: gfp_mask=0xd0, order=0, oom_score_adj=0
> [ 2634.939903] php5
> cpuset=e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
> mems_allowed=0
> [ 2634.943244] CPU: 0 PID: 15940 Comm: php5 Not tainted
> 3.13.0-32-generic #57~precise1-Ubuntu
> [ 2634.945628] Hardware name: VMware, Inc. VMware Virtual
> Platform/440BX Desktop Reference Platform, BIOS 6.00 06/22/2012
> [ 2634.949166]  ffff8801375a2000 ffff8800920c5be8 ffffffff81752c9e
> ffff88013fc0fff0
> [ 2634.951526]  ffff8800ab1a47d0 ffff8800920c5c38 ffffffff81748aba
> ffff880000000000
> [ 2634.953906]  000000d08137cd48 ffff8800920c5c38 ffff8800ae5ec7d0
> 0000000000000000
> [ 2634.956274] Call Trace:
> [ 2634.957475]  [<ffffffff81752c9e>] dump_stack+0x46/0x58
> [ 2634.959212]  [<ffffffff81748aba>] dump_header+0x7e/0xbd
> [ 2634.960979]  [<ffffffff81748b50>] oom_kill_process.part.5+0x57/0x2d4
> [ 2634.962970]  [<ffffffff810751b5>] ? has_ns_capability_noaudit+0x15/0x20
> [ 2634.965016]  [<ffffffff8115b499>] ? oom_badness.part.4+0xa9/0x140
> [ 2634.966913]  [<ffffffff8115b7b7>] oom_kill_process+0x47/0x50
> [ 2634.968739]  [<ffffffff811be85c>] mem_cgroup_out_of_memory+0x28c/0x2b0
> [ 2634.970768]  [<ffffffff811c0c0b>] mem_cgroup_oom_synchronize+0x21b/0x250
> [ 2634.972788]  [<ffffffff811c04c0>] ? memcg_charge_kmem+0xf0/0xf0
> [ 2634.974613]  [<ffffffff8115bb98>] pagefault_out_of_memory+0x18/0x90
> [ 2634.976509]  [<ffffffff817453c4>] mm_fault_error+0xb9/0xd3
> [ 2634.978233]  [<ffffffff817638d5>] __do_page_fault+0x545/0x570
> [ 2634.980032]  [<ffffffff811182cc>] ? acct_account_cputime+0x1c/0x20
> [ 2634.981886]  [<ffffffff810a25e9>] ? account_user_time+0x99/0xb0
> [ 2634.983713]  [<ffffffff810a2c6d>] ? vtime_account_user+0x5d/0x70
> [ 2634.985577]  [<ffffffff8176391a>] do_page_fault+0x1a/0x70
> [ 2634.987283]  [<ffffffff8175fa88>] page_fault+0x28/0x30
> [ 2634.988982] Task in
> /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
> killed as a result of limit of
> /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
> [ 2634.993837] memory: usage 65536kB, limit 65536kB, failcnt 34462
> [ 2634.995715] memory+swap: usage 65536kB, limit 65536kB, failcnt 1
> [ 2634.997667] kmem: usage 0kB, limit 18014398509481983kB, failcnt 0
> [ 2634.999596] Memory cgroup stats for
> /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4:
> cache:464KB rss:65032KB rss_huge:0KB mapped_file:16KB writeback:0KB
> swap:0KB inactive_anon:33288KB active_anon:32068KB inactive_file:92KB
> active_file:12KB unevictable:0KB
> [ 2635.008960] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents
> oom_score_adj name
> [ 2635.011353] [15552]     0 15552    12511      732      29        0
>            0 sshd
> [ 2635.013738] [15596]     0 15596     5180      276      15        0
>            0 cron
> [ 2635.016195] [15731]     0 15731    19971      926      43        0
>            0 sshd
> [ 2635.018559] [15735]  1014 15735    19971      395      40        0
>            0 sshd
> [ 2635.020947] [15736]  1014 15736     2760      376      10        0
>            0 bash
> [ 2635.023288] [15756]  1014 15756   551397    14759      92        0
>            0 java
> [ 2635.025590] [15757]  1014 15757     2760      152      10        0
>            0 bash
> [ 2635.027821] [15759]  1014 15759     1472      171       7        0
>            0 tee
> [ 2635.030055] [15760]  1014 15760     1472      172       8        0
>            0 tee
> [ 2635.032287] [15936]     0 15936    11535      338      28        0
>            0 cron
> [ 2635.034570] [15937]     0 15937     1102      153       8        0
>            0 sh
> [ 2635.036809] [15938]     0 15938     1102      153       8        0
>            0 maxlifetime
> [ 2635.039211] [15940]     0 15940    53661     2029     105        0
>            0 php5
> [ 2635.041469] Memory cgroup out of memory: Kill process 15919 (java)
> score 904 or sacrifice child
> [ 2635.043872] Killed process 15757 (bash) total-vm:11040kB,
> anon-rss:216kB, file-rss:392kB
> [ 2635.050025] java invoked oom-killer: gfp_mask=0xd0, order=0, oom_score_adj=0
> [ 2635.052155] java
> cpuset=e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
> mems_allowed=0
> [ 2635.055293] CPU: 0 PID: 15768 Comm: java Not tainted
> 3.13.0-32-generic #57~precise1-Ubuntu
> [ 2635.057673] Hardware name: VMware, Inc. VMware Virtual
> Platform/440BX Desktop Reference Platform, BIOS 6.00 06/22/2012
> [ 2635.061178]  ffff8801375a2000 ffff88009212fbe8 ffffffff81752c9e
> 000000000000b9e4
> [ 2635.063548]  ffff8800b858dfc0 ffff88009212fc38 ffffffff81748aba
> ffff880000000000
> [ 2635.066421]  000000d08137cd48 ffff88009212fc38 ffff8800ae5ec7d0
> 0000000000000000
> [ 2635.069043] Call Trace:
> [ 2635.070234]  [<ffffffff81752c9e>] dump_stack+0x46/0x58
> [ 2635.072018]  [<ffffffff81748aba>] dump_header+0x7e/0xbd
> [ 2635.073804]  [<ffffffff81748b50>] oom_kill_process.part.5+0x57/0x2d4
> [ 2635.075796]  [<ffffffff810751b5>] ? has_ns_capability_noaudit+0x15/0x20
> [ 2635.077847]  [<ffffffff8115b499>] ? oom_badness.part.4+0xa9/0x140
> [ 2635.079754]  [<ffffffff8115b7b7>] oom_kill_process+0x47/0x50
> [ 2635.081600]  [<ffffffff811be85c>] mem_cgroup_out_of_memory+0x28c/0x2b0
> [ 2635.083604]  [<ffffffff811c0c0b>] mem_cgroup_oom_synchronize+0x21b/0x250
> [ 2635.085649]  [<ffffffff811c04c0>] ? memcg_charge_kmem+0xf0/0xf0
> [ 2635.087488]  [<ffffffff8115bb98>] pagefault_out_of_memory+0x18/0x90
> [ 2635.089409]  [<ffffffff817453c4>] mm_fault_error+0xb9/0xd3
> [ 2635.091155]  [<ffffffff817638d5>] __do_page_fault+0x545/0x570
> [ 2635.092958]  [<ffffffff811182cc>] ? acct_account_cputime+0x1c/0x20
> [ 2635.094819]  [<ffffffff810a25e9>] ? account_user_time+0x99/0xb0
> [ 2635.096657]  [<ffffffff810a2c6d>] ? vtime_account_user+0x5d/0x70
> [ 2635.098493]  [<ffffffff8176391a>] do_page_fault+0x1a/0x70
> [ 2635.100257]  [<ffffffff8175fa88>] page_fault+0x28/0x30
> [ 2635.101917] Task in
> /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
> killed as a result of limit of
> /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
> [ 2635.106727] memory: usage 65536kB, limit 65536kB, failcnt 34826
> [ 2635.108694] memory+swap: usage 65416kB, limit 65536kB, failcnt 1
> [ 2635.110609] kmem: usage 0kB, limit 18014398509481983kB, failcnt 0
> [ 2635.112573] Memory cgroup stats for
> /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4:
> cache:452KB rss:65084KB rss_huge:0KB mapped_file:4KB writeback:0KB
> swap:0KB inactive_anon:33304KB active_anon:32104KB inactive_file:128KB
> active_file:0KB unevictable:0KB
> [ 2635.120953] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents
> oom_score_adj name
> [ 2635.123326] [15552]     0 15552    12511      732      29        0
>            0 sshd
> [ 2635.125696] [15596]     0 15596     5180      276      15        0
>            0 cron
> [ 2635.128042] [15731]     0 15731    19971      926      43        0
>            0 sshd
> [ 2635.130337] [15735]  1014 15735    19971      395      40        0
>            0 sshd
> [ 2635.132641] [15736]  1014 15736     2760      376      10        0
>            0 bash
> [ 2635.134904] [15756]  1014 15756   551397    14752      92        0
>            0 java
> [ 2635.137170] [15759]  1014 15759     1472      171       7        0
>            0 tee
> [ 2635.139389] [15760]  1014 15760     1472      172       8        0
>            0 tee
> [ 2635.141612] [15936]     0 15936    11535      338      28        0
>            0 cron
> [ 2635.143833] [15937]     0 15937     1102      153       8        0
>            0 sh
> [ 2635.146024] [15938]     0 15938     1102      153       8        0
>            0 maxlifetime
> [ 2635.148378] [15940]     0 15940    55252     2162     108        0
>            0 php5
> [ 2635.150580] Memory cgroup out of memory: Kill process 15919 (java)
> score 906 or sacrifice child
> [ 2635.153010] Killed process 15919 (java) total-vm:2205588kB,
> anon-rss:58444kB, file-rss:564kB
> [ 2635.160153] php5 invoked oom-killer: gfp_mask=0xd0, order=0, oom_score_adj=0
> [ 2635.162238] php5
> cpuset=e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
> mems_allowed=0
> [ 2635.165420] CPU: 0 PID: 15940 Comm: php5 Not tainted
> 3.13.0-32-generic #57~precise1-Ubuntu
> [ 2635.167811] Hardware name: VMware, Inc. VMware Virtual
> Platform/440BX Desktop Reference Platform, BIOS 6.00 06/22/2012
> [ 2635.171392]  ffff8801375a2000 ffff8800920c5be8 ffffffff81752c9e
> 0000000000000007
> [ 2635.173904]  ffff8800ab1a47d0 ffff8800920c5c38 ffffffff81748aba
> ffff880000000000
> [ 2635.176363]  000000d08137cd48 ffff8800920c5c38 ffff880137f2c7d0
> 0000000000000000
> [ 2635.178731] Call Trace:
> [ 2635.179924]  [<ffffffff81752c9e>] dump_stack+0x46/0x58
> [ 2635.181732]  [<ffffffff81748aba>] dump_header+0x7e/0xbd
> [ 2635.183532]  [<ffffffff81748b50>] oom_kill_process.part.5+0x57/0x2d4
> [ 2635.185606]  [<ffffffff810751b5>] ? has_ns_capability_noaudit+0x15/0x20
> [ 2635.187661]  [<ffffffff8115b499>] ? oom_badness.part.4+0xa9/0x140
> [ 2635.189642]  [<ffffffff8115b7b7>] oom_kill_process+0x47/0x50
> [ 2635.191472]  [<ffffffff811be85c>] mem_cgroup_out_of_memory+0x28c/0x2b0
> [ 2635.193567]  [<ffffffff811c0c0b>] mem_cgroup_oom_synchronize+0x21b/0x250
> [ 2635.195601]  [<ffffffff811c04c0>] ? memcg_charge_kmem+0xf0/0xf0
> [ 2635.197548]  [<ffffffff8115bb98>] pagefault_out_of_memory+0x18/0x90
> [ 2635.199548]  [<ffffffff817453c4>] mm_fault_error+0xb9/0xd3
> [ 2635.201309]  [<ffffffff817638d5>] __do_page_fault+0x545/0x570
> [ 2635.203099]  [<ffffffff811182cc>] ? acct_account_cputime+0x1c/0x20
> [ 2635.205016]  [<ffffffff810a25e9>] ? account_user_time+0x99/0xb0
> [ 2635.206847]  [<ffffffff810a2c6d>] ? vtime_account_user+0x5d/0x70
> [ 2635.208699]  [<ffffffff8176391a>] do_page_fault+0x1a/0x70
> [ 2635.210413]  [<ffffffff8175fa88>] page_fault+0x28/0x30
> **-> [ 2635.212105] Task in / killed as a result of limit of
> /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4
> [ 2635.215651] memory: usage 5400kB, limit 65536kB, failcnt 34938
> [ 2635.217580] memory+swap: usage 5400kB, limit 65536kB, failcnt 1
> [ 2635.219498] kmem: usage 0kB, limit 18014398509481983kB, failcnt 0
> [ 2635.221488] Memory cgroup stats for
> /lxc/e177098cd5f95ff8dbfa1ea14667b0bdc525dfa2e1c1b3bf763acd0a7ef217a4:
> cache:452KB rss:4088KB rss_huge:0KB mapped_file:0KB writeback:0KB
> swap:0KB inactive_anon:1080KB active_anon:3328KB inactive_file:132KB
> active_file:0KB unevictable:0KB
> [ 2635.233441] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents
> oom_score_adj name
> [ 2635.235809] [15552]     0 15552    12511      732      29        0
>            0 sshd
> [ 2635.238209] [15596]     0 15596     5180      276      15        0
>            0 cron
> [ 2635.240604] [15936]     0 15936    11535      338      28        0
>            0 cron
> [ 2635.242918] [15937]     0 15937     1102      153       8        0
>            0 sh
> [ 2635.245179] [15938]     0 15938     1102      153       8        0
>            0 maxlifetime
> [ 2635.247564] [15940]     0 15940    55252     2162     108        0
>            0 php5
> [ 2635.249819] Memory cgroup out of memory: Kill process 15861 (java)
> score 918 or sacrifice child
> [ 2659.884484] BUG: soft lockup - CPU#0 stuck for 23s! [php5:15940]
> [ 2659.888830] Modules linked in: xt_nat veth ipt_REJECT xt_tcpudp
> xt_state xt_addrtype iptable_filter xt_conntrack ipt_MASQUERADE
> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
> nf_conntrack ip_tables x_tables bridge stp llc aufs psmouse vmwgfx
> serio_raw ttm drm ppdev vmw_vmci vmw_balloon parport_pc shpchp
> i2c_piix4 mac_hid lp parport e1000 floppy mptspi mptscsih mptbase
> vmw_pvscsi vmxnet3
> [ 2659.908560] CPU: 0 PID: 15940 Comm: php5 Not tainted
> 3.13.0-32-generic #57~precise1-Ubuntu
> [ 2659.912330] Hardware name: VMware, Inc. VMware Virtual
> Platform/440BX Desktop Reference Platform, BIOS 6.00 06/22/2012
> [ 2659.917958] task: ffff8800ab1a47d0 ti: ffff8800920c4000 task.ti:
> ffff8800920c4000
> [ 2659.921601] RIP: 0010:[<ffffffff81748c29>]  [<ffffffff81748c29>]
> oom_kill_process.part.5+0x130/0x2d4
> [ 2659.927119] RSP: 0000:ffff8800920c5c48  EFLAGS: 00000246
> [ 2659.930090] RAX: ffff8800a0ffe358 RBX: 0000000000000396 RCX: 0000000000000000
> [ 2659.932371] RDX: ffff88013fc0fff0 RSI: ffff88013fc0e3d8 RDI: ffffffff81c06040
> [ 2659.934649] RBP: ffff8800920c5ca8 R08: 0000000000000000 R09: ffff8800ba7b1410
> [ 2660.093701] R10: 0000000000000773 R11: ffffffff8185b248 R12: ffff880137f2c7d0
> [ 2660.097119] R13: 0000000000000005 R14: 0000000000000246 R15: 00000000375a2000
> [ 2660.100528] FS:  00007ff405dc2700(0000) GS:ffff88013fc00000(0000)
> knlGS:0000000000000000
> [ 2660.103897] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 2660.105903] CR2: 000000000105c188 CR3: 00000000b86e1000 CR4: 00000000000007f0
> [ 2660.108262] Stack:
> [ 2660.109477]  ffff8800920c5c58 ffff880137f2c7d0 0000000000004000
> ffff8801375a2000
> [ 2660.111952]  ffff8800920c5ca8 ffff8800a0ffe358 ffff8800ba578000
> ffff880137f2c7d0
> [ 2660.114437]  0000000000004000 0000000000000000 ffff8801375a2000
> 0000000000000000
> [ 2660.116912] Call Trace:
> [ 2660.118209]  [<ffffffff8115b7b7>] oom_kill_process+0x47/0x50
> [ 2660.120166]  [<ffffffff811be85c>] mem_cgroup_out_of_memory+0x28c/0x2b0
> [ 2660.122291]  [<ffffffff811c0c0b>] mem_cgroup_oom_synchronize+0x21b/0x250
> [ 2660.124439]  [<ffffffff811c04c0>] ? memcg_charge_kmem+0xf0/0xf0
> [ 2660.126415]  [<ffffffff8115bb98>] pagefault_out_of_memory+0x18/0x90
> [ 2660.128503]  [<ffffffff817453c4>] mm_fault_error+0xb9/0xd3
> [ 2660.130405]  [<ffffffff817638d5>] __do_page_fault+0x545/0x570
> [ 2660.132395]  [<ffffffff811182cc>] ? acct_account_cputime+0x1c/0x20
> [ 2660.134474]  [<ffffffff810a25e9>] ? account_user_time+0x99/0xb0
> [ 2660.136605]  [<ffffffff810a2c6d>] ? vtime_account_user+0x5d/0x70
> [ 2660.138612]  [<ffffffff8176391a>] do_page_fault+0x1a/0x70
> [ 2660.140483]  [<ffffffff8175fa88>] page_fault+0x28/0x30
> [ 2660.364234] Code: 4d 8b a4 24 18 03 00 00 49 81 ec 18 03 00 00 49
> 8d 84 24 18 03 00 00 4c 39 e8 75 9c 49 8b 87 98 03 00 00 48 89 45 c8
> 4c 8b 7d c8 <49> 81 ef 98 03 00 00 4c 39 fb 0f 85 66 ff ff ff f0 ff 05
> 00 d4
> [ 2687.763079] BUG: soft lockup - CPU#0 stuck for 23s! [php5:15940]
> [ 2687.765130] Modules linked in: xt_nat veth ipt_REJECT xt_tcpudp
> xt_state xt_addrtype iptable_filter xt_conntrack ipt_MASQUERADE
> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
> nf_conntrack ip_tables x_tables bridge stp llc aufs psmouse vmwgfx
> serio_raw ttm drm ppdev vmw_vmci vmw_balloon parport_pc shpchp
> i2c_piix4 mac_hid lp parport e1000 floppy mptspi mptscsih mptbase
> vmw_pvscsi vmxnet3
> [ 2687.778062] CPU: 0 PID: 15940 Comm: php5 Not tainted
> 3.13.0-32-generic #57~precise1-Ubuntu
> [ 2687.781178] Hardware name: VMware, Inc. VMware Virtual
> Platform/440BX Desktop Reference Platform, BIOS 6.00 06/22/2012
> [ 2687.784908] task: ffff8800ab1a47d0 ti: ffff8800920c4000 task.ti:
> ffff8800920c4000
> [ 2687.787208] RIP: 0010:[<ffffffff81748b9f>]  [<ffffffff81748b9f>]
> oom_kill_process.part.5+0xa6/0x2d4
> [ 2687.790638] RSP: 0000:ffff8800920c5c48  EFLAGS: 00000202
> [ 2687.792506] RAX: ffff8800a0ffe358 RBX: 0000000000000396 RCX: 0000000000000000
> [ 2687.794825] RDX: ffff88013fc0fff0 RSI: ffff88013fc0e3d8 RDI: ffffffff81c06040
> [ 2687.797074] RBP: ffff8800920c5ca8 R08: 0000000000000000 R09: ffff8800ba7b1410
> [ 2687.799314] R10: 0000000000000773 R11: ffffffff8185b248 R12: ffff880137f2c7d0
> [ 2687.801565] R13: 0000000000000005 R14: 0000000000000246 R15: 00000000375a2000
> [ 2688.028141] FS:  00007ff405dc2700(0000) GS:ffff88013fc00000(0000)
> knlGS:0000000000000000
> [ 2688.031808] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 2688.034737] CR2: 000000000105c188 CR3: 00000000b86e1000 CR4: 00000000000007f0
> [ 2688.037416] Stack:
> [ 2688.038594]  ffff8800920c5c58 ffff880137f2c7d0 0000000000004000
> ffff8801375a2000
> [ 2688.041050]  ffff8800920c5ca8 ffff8800a0ffe358 ffff8800ba578000
> ffff880137f2c7d0
> [ 2688.043501]  0000000000004000 0000000000000000 ffff8801375a2000
> 0000000000000000
> [ 2688.045972] Call Trace:
> [ 2688.047262]  [<ffffffff8115b7b7>] oom_kill_process+0x47/0x50
> [ 2688.049245]  [<ffffffff811be85c>] mem_cgroup_out_of_memory+0x28c/0x2b0
> [ 2688.051383]  [<ffffffff811c0c0b>] mem_cgroup_oom_synchronize+0x21b/0x250
> [ 2688.053562]  [<ffffffff811c04c0>] ? memcg_charge_kmem+0xf0/0xf0
> [ 2688.055578]  [<ffffffff8115bb98>] pagefault_out_of_memory+0x18/0x90
> [ 2688.057675]  [<ffffffff817453c4>] mm_fault_error+0xb9/0xd3
> [ 2688.059606]  [<ffffffff817638d5>] __do_page_fault+0x545/0x570
> [ 2688.061588]  [<ffffffff811182cc>] ? acct_account_cputime+0x1c/0x20
> [ 2688.063655]  [<ffffffff810a25e9>] ? account_user_time+0x99/0xb0
> [ 2688.065647]  [<ffffffff810a2c6d>] ? vtime_account_user+0x5d/0x70
> [ 2688.067645]  [<ffffffff8176391a>] do_page_fault+0x1a/0x70
> [ 2688.069508]  [<ffffffff8175fa88>] page_fault+0x28/0x30
> [ 2688.071297] Code: 00 00 45 89 e8 48 c7 c7 08 50 a7 81 31 c0 e8 1c
> e1 ff ff 4c 89 e7 e8 b1 66 01 00 48 c7 c7 40 60 c0 81 e8 05 63 01 00
> 48 89 5d a8 <4d> 8b a7 08 03 00 00 4d 8d af 08 03 00 00 49 81 ec 18 03
> 00 00
> [ 2715.786036] BUG: soft lockup - CPU#0 stuck for 22s! [php5:15940]
> [ 2715.788772] Modules linked in: xt_nat veth ipt_REJECT xt_tcpudp
> xt_state xt_addrtype iptable_filter xt_conntrack ipt_MASQUERADE
> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
> nf_conntrack ip_tables x_tables bridge stp llc aufs psmouse vmwgfx
> serio_raw ttm drm ppdev vmw_vmci vmw_balloon parport_pc shpchp
> i2c_piix4 mac_hid lp parport e1000 floppy mptspi mptscsih mptbase
> vmw_pvscsi vmxnet3
> [ 2715.801184] CPU: 0 PID: 15940 Comm: php5 Not tainted
> 3.13.0-32-generic #57~precise1-Ubuntu
> [ 2715.803616] Hardware name: VMware, Inc. VMware Virtual
> Platform/440BX Desktop Reference Platform, BIOS 6.00 06/22/2012
> [ 2715.807270] task: ffff8800ab1a47d0 ti: ffff8800920c4000 task.ti:
> ffff8800920c4000
> [ 2715.809571] RIP: 0010:[<ffffffff81748c30>]  [<ffffffff81748c30>]
> oom_kill_process.part.5+0x137/0x2d4
> [ 2715.812972] RSP: 0000:ffff8800920c5c48  EFLAGS: 00000286
> [ 2715.814858] RAX: ffff8800a0ffe358 RBX: 0000000000000396 RCX: 0000000000000000
> [ 2715.817102] RDX: ffff88013fc0fff0 RSI: ffff88013fc0e3d8 RDI: ffffffff81c06040
> [ 2715.819350] RBP: ffff8800920c5ca8 R08: 0000000000000000 R09: ffff8800ba7b1410
> [ 2715.821619] R10: 0000000000000773 R11: ffffffff8185b248 R12: ffff880137f2c7d0
> [ 2715.823852] R13: 0000000000000005 R14: 0000000000000246 R15: 00000000375a2000
> [ 2715.826095] FS:  00007ff405dc2700(0000) GS:ffff88013fc00000(0000)
> knlGS:0000000000000000
> [ 2716.058770] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 2716.060776] CR2: 000000000105c188 CR3: 00000000b86e1000 CR4: 00000000000007f0
> [ 2716.063102] Stack:
> [ 2716.064279]  ffff8800920c5c58 ffff880137f2c7d0 0000000000004000
> ffff8801375a2000
> [ 2716.066731]  ffff8800920c5ca8 ffff8800a0ffe358 ffff8800ba578000
> ffff880137f2c7d0
> [ 2716.069221]  0000000000004000 0000000000000000 ffff8801375a2000
> 0000000000000000
> [ 2716.071694] Call Trace:
> [ 2716.072983]  [<ffffffff8115b7b7>] oom_kill_process+0x47/0x50
> [ 2716.074951]  [<ffffffff811be85c>] mem_cgroup_out_of_memory+0x28c/0x2b0
> [ 2716.077116]  [<ffffffff811c0c0b>] mem_cgroup_oom_synchronize+0x21b/0x250
> [ 2716.079305]  [<ffffffff811c04c0>] ? memcg_charge_kmem+0xf0/0xf0
> [ 2716.081322]  [<ffffffff8115bb98>] pagefault_out_of_memory+0x18/0x90
> [ 2716.083443]  [<ffffffff817453c4>] mm_fault_error+0xb9/0xd3
> [ 2716.085375]  [<ffffffff817638d5>] __do_page_fault+0x545/0x570
> [ 2716.087364]  [<ffffffff811182cc>] ? acct_account_cputime+0x1c/0x20
> [ 2716.089458]  [<ffffffff810a25e9>] ? account_user_time+0x99/0xb0
> [ 2716.091451]  [<ffffffff810a2c6d>] ? vtime_account_user+0x5d/0x70
> [ 2716.093447]  [<ffffffff8176391a>] do_page_fault+0x1a/0x70
> [ 2716.095312]  [<ffffffff8175fa88>] page_fault+0x28/0x30
> [ 2716.097125] Code: 00 49 81 ec 18 03 00 00 49 8d 84 24 18 03 00 00
> 4c 39 e8 75 9c 49 8b 87 98 03 00 00 48 89 45 c8 4c 8b 7d c8 49 81 ef
> 98 03 00 00 <4c> 39 fb 0f 85 66 ff ff ff f0 ff 05 00 d4 4b 00 48 8b 7d
> a8 e8
> [ 2743.821209] BUG: soft lockup - CPU#0 stuck for 22s! [php5:15940]
> [ 2743.823189] Modules linked in: xt_nat veth ipt_REJECT xt_tcpudp
> xt_state xt_addrtype iptable_filter xt_conntrack ipt_MASQUERADE
> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
> nf_conntrack ip_tables x_tables bridge stp llc aufs psmouse vmwgfx
> serio_raw ttm drm ppdev vmw_vmci vmw_balloon parport_pc shpchp
> i2c_piix4 mac_hid lp parport e1000 floppy mptspi mptscsih mptbase
> vmw_pvscsi vmxnet3
> [ 2743.835431] CPU: 0 PID: 15940 Comm: php5 Not tainted
> 3.13.0-32-generic #57~precise1-Ubuntu
> [ 2743.837879] Hardware name: VMware, Inc. VMware Virtual
> Platform/440BX Desktop Reference Platform, BIOS 6.00 06/22/2012
> [ 2743.841550] task: ffff8800ab1a47d0 ti: ffff8800920c4000 task.ti:
> ffff8800920c4000
> [ 2743.843848] RIP: 0010:[<ffffffff81748ba6>]  [<ffffffff81748ba6>]
> oom_kill_process.part.5+0xad/0x2d4
> [ 2743.847267] RSP: 0000:ffff8800920c5c48  EFLAGS: 00000202
> [ 2743.849129] RAX: ffff8800a0ffe358 RBX: 0000000000000396 RCX: 0000000000000000
> [ 2743.851396] RDX: ffff88013fc0fff0 RSI: ffff88013fc0e3d8 RDI: ffffffff81c06040
> [ 2743.974848] RBP: ffff8800920c5ca8 R08: 0000000000000000 R09: ffff8800ba7b1410
> [ 2743.978217] R10: 0000000000000773 R11: ffffffff8185b248 R12: ffff880137f2c7d0
> [ 2743.981510] R13: 0000000000000005 R14: 0000000000000246 R15: 00000000375a2000
> [ 2743.983737] FS:  00007ff405dc2700(0000) GS:ffff88013fc00000(0000)
> knlGS:0000000000000000
> [ 2743.986172] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 2743.988121] CR2: 000000000105c188 CR3: 00000000b86e1000 CR4: 00000000000007f0
> [ 2743.990371] Stack:
> [ 2743.991555]  ffff8800920c5c58 ffff880137f2c7d0 0000000000004000
> ffff8801375a2000
> [ 2743.994003]  ffff8800920c5ca8 ffff8800a0ffe358 ffff8800ba578000
> ffff880137f2c7d0
> [ 2743.996448]  0000000000004000 0000000000000000 ffff8801375a2000
> 0000000000000000
> [ 2743.998918] Call Trace:
> [ 2744.000205]  [<ffffffff8115b7b7>] oom_kill_process+0x47/0x50
> [ 2744.002173]  [<ffffffff811be85c>] mem_cgroup_out_of_memory+0x28c/0x2b0
> [ 2744.004317]  [<ffffffff811c0c0b>] mem_cgroup_oom_synchronize+0x21b/0x250
> [ 2744.006492]  [<ffffffff811c04c0>] ? memcg_charge_kmem+0xf0/0xf0
> [ 2744.008507]  [<ffffffff8115bb98>] pagefault_out_of_memory+0x18/0x90
> [ 2744.010597]  [<ffffffff817453c4>] mm_fault_error+0xb9/0xd3
> [ 2744.012529]  [<ffffffff817638d5>] __do_page_fault+0x545/0x570
> [ 2744.014536]  [<ffffffff811182cc>] ? acct_account_cputime+0x1c/0x20
> [ 2744.016601]  [<ffffffff810a25e9>] ? account_user_time+0x99/0xb0
> [ 2744.018597]  [<ffffffff810a2c6d>] ? vtime_account_user+0x5d/0x70
> [ 2744.020595]  [<ffffffff8176391a>] do_page_fault+0x1a/0x70
> [ 2744.193452]  [<ffffffff8175fa88>] page_fault+0x28/0x30
> [ 2744.196140] Code: c7 08 50 a7 81 31 c0 e8 1c e1 ff ff 4c 89 e7 e8
> b1 66 01 00 48 c7 c7 40 60 c0 81 e8 05 63 01 00 48 89 5d a8 4d 8b a7
> 08 03 00 00 <4d> 8d af 08 03 00 00 49 81 ec 18 03 00 00 eb 57 48 8b 83
> a8 02
> [ 2771.854441] BUG: soft lockup - CPU#0 stuck for 22s! [php5:15940]
> 
> 
> 3. lxc, cgroup, OOM, linux-image-3.13.0-32-generic,
> linux-image-3.13.0-35-generic, vsphere
> 
> 
> 4. Linux version 3.13.0-35-generic (buildd@akateko) (gcc version 4.6.3
> (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #62~precise1-Ubuntu SMP Mon Aug 18
> 14:52:04 UTC 2014
> 
> 
> 7.1
> 
> stackato@stackato-h5jt:~$ ./ver_linux.sh
> ./ver_linux.sh: line 1: ng: command not found
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
> 
> DISTRIB_ID=Ubuntu
> DISTRIB_RELEASE=12.04
> DISTRIB_CODENAME=precise
> DISTRIB_DESCRIPTION="Ubuntu 12.04.4 LTS"
> NAME="Ubuntu"
> VERSION="12.04.4 LTS, Precise Pangolin"
> ID=ubuntu
> ID_LIKE=debian
> PRETTY_NAME="Ubuntu precise (12.04.4 LTS)"
> VERSION_ID="12.04"
> Linux stackato-h5jt 3.13.0-35-generic #62~precise1-Ubuntu SMP Mon Aug
> 18 14:52:04 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> 
> Gnu C                  gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3
> Gnu make               3.81
> util-linux             linux 2.20.1
> mount                  linux 2.20.1 (with libblkid and selinux support)
> modutils               3.16
> e2fsprogs              1.42
> PPP                    2.4.5
> Linux C Library        > libc.2.15
> Dynamic linker (ldd)   2.15
> Procps                 3.2.8
> Net-tools              1.60
> iproute2              iproute2-ss111117
> Kbd                    1.15.2
> Sh-utils               8.13
> Modules Loaded         xt_nat veth ipt_REJECT xt_tcpudp xt_state
> xt_addrtype xt_conntrack iptable_filter aufs ipt_MASQUERADE
> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
> nf_conntrack ip_tables x_tables bridge stp llc vmwgfx ttm psmouse
> vmw_vmci drm vmw_balloon shpchp mac_hid i2c_piix4 serio_raw ppdev
> parport_pc lp parport floppy mptspi mptscsih e1000 mptbase vmw_pvscsi
> vmxnet3
> 
> free reports:
>              total       used       free     shared    buffers     cached
> Mem:       1918540     786944    1131596          0      82684     278140
> -/+ buffers/cache:     426120    1492420
> Swap:      1951740          0    1951740
> 
> 
> 7.2
> 
> /proc/cpuinfo
> processor : 0
> vendor_id : GenuineIntel
> cpu family : 6
> model : 44
> model name : Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
> stepping : 2
> microcode : 0x13
> cpu MHz : 2400.085
> cache size : 12288 KB
> physical id : 0
> siblings : 1
> core id : 0
> cpu cores : 1
> apicid : 0
> initial apicid : 0
> fpu : yes
> fpu_exception : yes
> cpuid level : 11
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts mmx fxsr sse sse2 ss syscall nx rdtscp lm
> constant_tsc arch_perfmon pebs bts nopl xtopology tsc_reliable
> nonstop_tsc aperfmperf pni ssse3 cx16 sse4_1 sse4_2 popcnt hypervisor
> lahf_lm ida arat epb dtherm
> bogomips : 4800.17
> clflush size : 64
> cache_alignment : 64
> address sizes : 40 bits physical, 48 bits virtual
> power management:
> 
> processor : 1
> vendor_id : GenuineIntel
> cpu family : 6
> model : 44
> model name : Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
> stepping : 2
> microcode : 0x13
> cpu MHz : 2400.085
> cache size : 12288 KB
> physical id : 2
> siblings : 1
> core id : 0
> cpu cores : 1
> apicid : 2
> initial apicid : 2
> fpu : yes
> fpu_exception : yes
> cpuid level : 11
> wp : yes
> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat pse36 clflush dts mmx fxsr sse sse2 ss syscall nx rdtscp lm
> constant_tsc arch_perfmon pebs bts nopl xtopology tsc_reliable
> nonstop_tsc aperfmperf pni ssse3 cx16 sse4_1 sse4_2 popcnt hypervisor
> lahf_lm ida arat epb dtherm
> bogomips : 4800.17
> clflush size : 64
> cache_alignment : 64
> address sizes : 40 bits physical, 48 bits virtual
> power management:
> 
> 7.3
> 
> cat /proc/modules
> xt_nat 12726 26 - Live 0x0000000000000000
> veth 13331 0 - Live 0x0000000000000000
> ipt_REJECT 12576 0 - Live 0x0000000000000000
> xt_tcpudp 12924 39 - Live 0x0000000000000000
> xt_state 12578 13 - Live 0x0000000000000000
> xt_addrtype 12713 2 - Live 0x0000000000000000
> xt_conntrack 12760 1 - Live 0x0000000000000000
> iptable_filter 12810 1 - Live 0x0000000000000000
> aufs 210175 999 - Live 0x0000000000000000
> ipt_MASQUERADE 12880 2 - Live 0x0000000000000000
> iptable_nat 13151 1 - Live 0x0000000000000000
> nf_conntrack_ipv4 15063 15 - Live 0x0000000000000000
> nf_defrag_ipv4 12758 1 nf_conntrack_ipv4, Live 0x0000000000000000
> nf_nat_ipv4 13316 1 iptable_nat, Live 0x0000000000000000
> nf_nat 26091 4 xt_nat,ipt_MASQUERADE,iptable_nat,nf_nat_ipv4, Live
> 0x0000000000000000
> nf_conntrack 97581 7
> xt_state,xt_conntrack,ipt_MASQUERADE,iptable_nat,nf_conntrack_ipv4,nf_nat_ipv4,nf_nat,
> Live 0x0000000000000000
> ip_tables 27716 2 iptable_filter,iptable_nat, Live 0x0000000000000000
> x_tables 34194 9
> xt_nat,ipt_REJECT,xt_tcpudp,xt_state,xt_addrtype,xt_conntrack,iptable_filter,ipt_MASQUERADE,ip_tables,
> Live 0x0000000000000000
> bridge 116291 0 - Live 0x0000000000000000
> stp 12976 1 bridge, Live 0x0000000000000000
> llc 14597 2 bridge,stp, Live 0x0000000000000000
> vmwgfx 185498 1 - Live 0x0000000000000000
> ttm 90134 1 vmwgfx, Live 0x0000000000000000
> psmouse 113295 0 - Live 0x0000000000000000
> vmw_vmci 68525 0 - Live 0x0000000000000000
> drm 308868 2 vmwgfx,ttm, Live 0x0000000000000000
> vmw_balloon 13593 0 - Live 0x0000000000000000
> shpchp 37201 0 - Live 0x0000000000000000
> mac_hid 13253 0 - Live 0x0000000000000000
> i2c_piix4 22299 0 - Live 0x0000000000000000
> serio_raw 13462 0 - Live 0x0000000000000000
> ppdev 17711 0 - Live 0x0000000000000000
> parport_pc 32866 1 - Live 0x0000000000000000
> lp 17799 0 - Live 0x0000000000000000
> parport 42481 3 ppdev,parport_pc,lp, Live 0x0000000000000000
> floppy 70207 0 - Live 0x0000000000000000
> mptspi 22921 3 - Live 0x0000000000000000
> mptscsih 44751 1 mptspi, Live 0x0000000000000000
> e1000 152011 0 - Live 0x0000000000000000
> mptbase 103162 2 mptspi,mptscsih, Live 0x0000000000000000
> vmw_pvscsi 23372 0 - Live 0x0000000000000000
> vmxnet3 50657 0 - Live 0x0000000000000000
> 
> Thanks,
> Tyler

-- 
tejun
