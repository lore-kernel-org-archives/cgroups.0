From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_if_PF=5FNO=5FMEMCG=5FOOM_is_set?=
Date: Fri, 08 Feb 2013 12:02:49 +0100
Message-ID: <20130208120249.FD733220@pobox.sk>
References: <20130125160723.FAE73567@pobox.sk>, <20130125163130.GF4721@dhcp22.suse.cz>, <20130205134937.GA22804@dhcp22.suse.cz>, <20130205154947.CD6411E2@pobox.sk>, <20130205160934.GB22804@dhcp22.suse.cz>, <20130206021721.1AE9E3C7@pobox.sk>, <20130206140119.GD10254@dhcp22.suse.cz>, <20130206142219.GF10254@dhcp22.suse.cz>, <20130206160051.GG10254@dhcp22.suse.cz>, <20130208060304.799F362F@pobox.sk> <20130208094420.GA7557@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130208094420.GA7557@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>, =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>

>
>Do you have logs from that time period?
>
>I have only glanced through the stacks and most of the threads are
>waiting in the mem_cgroup_handle_oom (mostly from the page fault path
>where we do not have other options than waiting) which suggests that
>your memory limit is seriously underestimated. If you look at the number
>of charging failures (memory.failcnt per-group file) then you will get
>9332083 failures in _average_ per group. This is a lot!
>Not all those failures end with OOM, of course. But it clearly signals
>that the workload need much more memory than the limit allows.


What type of logs? I have all.

Memory usage graph:
http://www.watchdog.sk/lkml/memory2.png

New kernel was booted about 1:15. Data in memcg-bug-4.tar.gz were taken a=
bout 2:35 and data in memcg-bug-5.tar.gz about 5:25. There was always lot=
s of free memory. Higher memory consumption between 3:39 and 5:33 was cau=
sed by data backup and was completed few minutes before i restarted the s=
erver (this was just a coincidence).



>There are only 5 groups in this one and all of them have no memory
>charged (so no OOM going on). All tasks are somewhere in the ptrace
>code.


It's all from the same cgroup but from different time.



>grep cache -r .
>./1360297489/memory.stat:cache 0
>./1360297489/memory.stat:total_cache 65642496
>./1360297491/memory.stat:cache 0
>./1360297491/memory.stat:total_cache 65642496
>./1360297492/memory.stat:cache 0
>./1360297492/memory.stat:total_cache 65642496
>./1360297490/memory.stat:cache 0
>./1360297490/memory.stat:total_cache 65642496
>./1360297488/memory.stat:cache 0
>./1360297488/memory.stat:total_cache 65642496
>
>which suggests that this is a parent group and the memory is charged in
>a child group. I guess that all those are under OOM as the number seems
>like they have limit at 62M.


The cgroup has limit 330M (346030080 bytes). As i said, these two process=
es were stucked and was impossible to kill them. They were, maybe, the pr=
ocesses which i was trying to 'strace' before - 'strace' was freezed as a=
lways when the cgroup has this problem and i killed it (i was just trying=
 if it is the original cgroup problem).

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
