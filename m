From: "azurIt" <azurit-Rm0zKEqwvD4@public.gmane.org>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_if_PF=5FNO=5FMEMCG=5FOOM_is_set?=
Date: Fri, 22 Feb 2013 09:23:32 +0100
Message-ID: <20130222092332.4001E4B6@pobox.sk>
References: <20130208094420.GA7557@dhcp22.suse.cz>, <20130208120249.FD733220@pobox.sk>, <20130208123854.GB7557@dhcp22.suse.cz>, <20130208145616.FB78CE24@pobox.sk>, <20130208152402.GD7557@dhcp22.suse.cz>, <20130208165805.8908B143@pobox.sk>, <20130208171012.GH7557@dhcp22.suse.cz>, <20130208220243.EDEE0825@pobox.sk>, <20130210150310.GA9504@dhcp22.suse.cz>, <20130210174619.24F20488@pobox.sk> <20130211112240.GC19922@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130211112240.GC19922-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?utf-8?q?cgroups_mailinglist?= <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, =?utf-8?q?Johannes_Weiner?= <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

>Unfortunately I am not able to reproduce this behavior even if I try
>to hammer OOM like mad so I am afraid I cannot help you much without
>further debugging patches.
>I do realize that experimenting in your environment is a problem but I
>do not many options left. Please do not use strace and rather collect
>/proc/pid/stack instead. It would be also helpful to get group/tasks
>file to have a full list of tasks in the group



Hi Michal,


sorry that i didn't response for a while. Today i installed kernel with your two patches and i'm running it now. I'm still having problems with OOM which is not able to handle low memory and is not killing processes. Here is some info:

- data from cgroup 1258 while it was under OOM and no processes were killed (so OOM don't stop and cgroup was freezed)
http://watchdog.sk/lkml/memcg-bug-6.tar.gz

I noticed problem about on 8:39 and waited until 8:57 (nothing happend). Then i killed process 19864 which seems to help and other processes probably ends and cgroup started to work. But problem accoured again about 20 seconds later, so i killed all processes at 8:58. The problem is occuring all the time since then. All processes (in that cgroup) are always in state 'D' when it occurs.


- kernel log from boot until now
http://watchdog.sk/lkml/kern3.gz


Btw, something probably happened also at about 3:09 but i wasn't able to gather any data because my 'load check script' killed all apache processes (load was more than 100).



azur
