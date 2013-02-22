From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_if_PF=5FNO=5FMEMCG=5FOOM_is_set?=
Date: Fri, 22 Feb 2013 13:00:55 +0100
Message-ID: <20130222130055.29151595@pobox.sk>
References: <20130208094420.GA7557@dhcp22.suse.cz>, <20130208120249.FD733220@pobox.sk>, <20130208123854.GB7557@dhcp22.suse.cz>, <20130208145616.FB78CE24@pobox.sk>, <20130208152402.GD7557@dhcp22.suse.cz>, <20130208165805.8908B143@pobox.sk>, <20130208171012.GH7557@dhcp22.suse.cz>, <20130208220243.EDEE0825@pobox.sk>, <20130210150310.GA9504@dhcp22.suse.cz>, <20130210174619.24F20488@pobox.sk> <20130211112240.GC19922@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130211112240.GC19922@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>, =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>

>Unfortunately I am not able to reproduce this behavior even if I try
>to hammer OOM like mad so I am afraid I cannot help you much without
>further debugging patches.
>I do realize that experimenting in your environment is a problem but I
>do not many options left. Please do not use strace and rather collect
>/proc/pid/stack instead. It would be also helpful to get group/tasks
>file to have a full list of tasks in the group



Sending new info!

I found out one interesting thing. When problem occurs (it probably happe=
n when OOM is started in target cgroup but i'm not sure), the target cgro=
up, somehow, becames broken. In other words, after the problem occurs onc=
e in target cgroup, it is happening always in this cgroup. I made this te=
st:

1.) I create cgroup A with limits (also with memory limit).
2.) Waited when OOM is started (can takes hours). Processes in target cgr=
oup becames freezed so they must be killed.
3.) After this, processes are always freezing in cgroup A, it usually tak=
es 20-30 seconds after killing previously freezed processes.
4.) I created cgroup B with the *same* limits as cgroup A and moved user =
from A to B. Problem disappears.
5.) Go to (2)

And second thing, i got've kernel oops, look at the end of:
http://watchdog.sk/lkml/oops

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
