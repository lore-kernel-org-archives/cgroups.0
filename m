From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=5D_memcg=3A_do_not_trap_chargers_with_full_callstack_on_OOM?=
Date: Mon, 24 Jun 2013 18:48:40 +0200
Message-ID: <20130624184840.781777E6@pobox.sk>
References: <20130208171012.GH7557@dhcp22.suse.cz>, <20130208220243.EDEE0825@pobox.sk>, <20130210150310.GA9504@dhcp22.suse.cz>, <20130210174619.24F20488@pobox.sk>, <20130211112240.GC19922@dhcp22.suse.cz>, <20130222092332.4001E4B6@pobox.sk>, <20130606160446.GE24115@dhcp22.suse.cz>, <20130606181633.BCC3E02E@pobox.sk>, <20130607131157.GF8117@dhcp22.suse.cz>, <20130617122134.2E072BA8@pobox.sk> <20130619132614.GC16457@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130619132614.GC16457@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>, =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>

>I would be really interesting to see what those tasks are blocked on.


Ok, i got it! Problem occurs two times and it behaves differently each ti=
me, I was running kernel with that latest patch.

1.) It doesn't have impact on the whole server, only on one cgroup. Here =
are stacks:
http://watchdog.sk/lkml/memcg-bug-7.tar.gz


2.) It almost takes down the server because of huge I/O on HDDs. Unfortun=
ately, i had a bug in my script which was suppose to gather stacks (i was=
n't able to do it by hand like in (1), server was almost unoperable). But=
 I was lucky and somehow killed processes from problematic cgroup (via ht=
op) and server was ok again EXCEPT one important thing - processes from t=
hat cgroup were still running in D state and i wasn't able to kill them f=
or good. They were taking web server network ports so i had to reboot the=
 server :( BUT, before that, i gathered stacks:
http://watchdog.sk/lkml/memcg-bug-8.tar.gz

What do you think?

azur

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
