From: "azurIt" <azurit-Rm0zKEqwvD4@public.gmane.org>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_if_PF=5FNO=5FMEMCG=5FOOM_is_set?=
Date: Fri, 08 Feb 2013 16:58:05 +0100
Message-ID: <20130208165805.8908B143@pobox.sk>
References: <20130205160934.GB22804@dhcp22.suse.cz>, <20130206021721.1AE9E3C7@pobox.sk>, <20130206140119.GD10254@dhcp22.suse.cz>, <20130206142219.GF10254@dhcp22.suse.cz>, <20130206160051.GG10254@dhcp22.suse.cz>, <20130208060304.799F362F@pobox.sk>, <20130208094420.GA7557@dhcp22.suse.cz>, <20130208120249.FD733220@pobox.sk>, <20130208123854.GB7557@dhcp22.suse.cz>, <20130208145616.FB78CE24@pobox.sk> <20130208152402.GD7557@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130208152402.GD7557-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?utf-8?q?cgroups_mailinglist?= <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, =?utf-8?q?Johannes_Weiner?= <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

>Which means that the oom killer didn't try to kill any task more than
>once which is good because it tells us that the killed task manages to
>die before we trigger oom again. So this is definitely not a deadlock.
>You are just hitting OOM very often.
>$ grep "killed as a result of limit" kern2.log | sed 's@.*\] @@' | sort | uniq -c | sort -k1 -n
>      1 Task in /1091/uid killed as a result of limit of /1091
>      1 Task in /1223/uid killed as a result of limit of /1223
>      1 Task in /1229/uid killed as a result of limit of /1229
>      1 Task in /1255/uid killed as a result of limit of /1255
>      1 Task in /1424/uid killed as a result of limit of /1424
>      1 Task in /1470/uid killed as a result of limit of /1470
>      1 Task in /1567/uid killed as a result of limit of /1567
>      2 Task in /1080/uid killed as a result of limit of /1080
>      3 Task in /1381/uid killed as a result of limit of /1381
>      4 Task in /1185/uid killed as a result of limit of /1185
>      4 Task in /1289/uid killed as a result of limit of /1289
>      4 Task in /1709/uid killed as a result of limit of /1709
>      5 Task in /1279/uid killed as a result of limit of /1279
>      6 Task in /1020/uid killed as a result of limit of /1020
>      6 Task in /1527/uid killed as a result of limit of /1527
>      9 Task in /1388/uid killed as a result of limit of /1388
>     17 Task in /1281/uid killed as a result of limit of /1281
>     22 Task in /1599/uid killed as a result of limit of /1599
>     30 Task in /1155/uid killed as a result of limit of /1155
>     31 Task in /1258/uid killed as a result of limit of /1258
>     71 Task in /1293/uid killed as a result of limit of /1293
>
>So the group 1293 suffers the most. I would check how much memory the
>worklod in the group really needs because this level of OOM cannot
>possible be healthy.



I took the kernel log from yesterday from the same time frame:

$ grep "killed as a result of limit" kern2.log | sed 's@.*\] @@' | sort | uniq -c | sort -k1 -n
      1 Task in /1252/uid killed as a result of limit of /1252
      1 Task in /1709/uid killed as a result of limit of /1709
      2 Task in /1185/uid killed as a result of limit of /1185
      2 Task in /1388/uid killed as a result of limit of /1388
      2 Task in /1567/uid killed as a result of limit of /1567
      2 Task in /1650/uid killed as a result of limit of /1650
      3 Task in /1527/uid killed as a result of limit of /1527
      5 Task in /1552/uid killed as a result of limit of /1552
   1634 Task in /1258/uid killed as a result of limit of /1258

As you can see, there were much more OOM in '1258' and no such problems like this night (well, there were never such problems before :) ). As i said, cgroup 1258 were freezing every few minutes with your latest patch so there must be something wrong (it usually freezes about once per day). And it was really freezed (i checked that), the sypthoms were:
 - cannot strace any of cgroup processes
 - no new processes were started, still the same processes were 'running'
 - kernel was unable to resolve this by it's own
 - all processes togather were taking 100% CPU
 - the whole memory limit was used
(see memcg-bug-4.tar.gz for more info)
Unfortunately i forget to check if killing only few of the processes will resolve it (i always killed them all yesterday night). Don't know if is was in deadlock or not but kernel was definitely unable to resolve the problem. And there is still a mystery of two freezed processes which cannot be killed.

By the way, i KNOW that so much OOM is not healthy but the client simply don't want to buy more memory. He knows about the problem of unsufficient memory limit.

Thank you.


azur
