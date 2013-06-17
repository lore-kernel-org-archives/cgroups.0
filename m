From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=5D_memcg=3A_do_not_trap_chargers_with_full_callstack_on_OOM?=
Date: Mon, 17 Jun 2013 12:21:34 +0200
Message-ID: <20130617122134.2E072BA8@pobox.sk>
References: <20130208152402.GD7557@dhcp22.suse.cz>, <20130208165805.8908B143@pobox.sk>, <20130208171012.GH7557@dhcp22.suse.cz>, <20130208220243.EDEE0825@pobox.sk>, <20130210150310.GA9504@dhcp22.suse.cz>, <20130210174619.24F20488@pobox.sk>, <20130211112240.GC19922@dhcp22.suse.cz>, <20130222092332.4001E4B6@pobox.sk>, <20130606160446.GE24115@dhcp22.suse.cz>, <20130606181633.BCC3E02E@pobox.sk> <20130607131157.GF8117@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130607131157.GF8117@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>, =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>

>Here we go. I hope I didn't screw anything (Johannes might double check)
>because there were quite some changes in the area since 3.2. Nothing
>earth shattering though. Please note that I have only compile tested
>this. Also make sure you remove the previous patches you have from me.


Hi Michal,

it, unfortunately, didn't work. Everything was working fine but original =
problem is still occuring. I'm unable to send you stacks or more info bec=
ause problem is taking down the whole server for some time now (don't kno=
w what exactly caused it to start happening, maybe newer versions of 3.2.=
x). But i'm sure of one thing - when problem occurs, nothing is able to a=
ccess hard drives (every process which tries it is freezed until problem =
is resolved or server is rebooted). Problem is fixed after killing proces=
ses from cgroup which caused it and everything immediatelly starts to wor=
k normally. I find this out by keeping terminal opened from another serve=
r to one where my problem is occuring quite often and running several app=
s there (htop, iotop, etc.). When problem occurs, all apps which wasn't w=
orking with HDD was ok. The htop proved to be very usefull here because i=
t's only reading proc filesystem and is also able to send KILL signals - =
i was able to resolve the problem with it
  without rebooting the server.

I created a special daemon (about month ago) which is able to detect and =
fix the problem so i'm not having server outages now. The point was to NO=
T access anything which is stored on HDDs, the daemon is only reading inf=
o from cgroup filesystem and sending KILL signals to processes. Maybe i s=
hould be able to also read stack files before killing, i will try it.

Btw, which vanilla kernel includes this patch?

Thank you and everyone involved very much for time and help.

azur

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
