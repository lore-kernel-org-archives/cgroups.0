From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_if_PF=5FNO=5FMEMCG=5FOOM_is_set?=
Date: Fri, 08 Feb 2013 22:02:43 +0100
Message-ID: <20130208220243.EDEE0825@pobox.sk>
References: <20130206140119.GD10254@dhcp22.suse.cz>, <20130206142219.GF10254@dhcp22.suse.cz>, <20130206160051.GG10254@dhcp22.suse.cz>, <20130208060304.799F362F@pobox.sk>, <20130208094420.GA7557@dhcp22.suse.cz>, <20130208120249.FD733220@pobox.sk>, <20130208123854.GB7557@dhcp22.suse.cz>, <20130208145616.FB78CE24@pobox.sk>, <20130208152402.GD7557@dhcp22.suse.cz>, <20130208165805.8908B143@pobox.sk> <20130208171012.GH7557@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130208171012.GH7557@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>, =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>

>
>I assume you have checked that the killed processes eventually die,
>right?
>


When i killed them by hand, yes, they dissappeard from process list (i sa=
w it). I don't know if they really died when OOM killed them.


>Well, I do not see anything supsicious during that time period
>(timestamps translate between Fri Feb  8 02:34:05 and Fri Feb  8
>02:36:48). The kernel log shows a lot of oom during that time. All
>killed processes die eventually.


No, they didn't died by OOM when cgroup was freezed. Just check PIDs from=
 memcg-bug-4.tar.gz and try to find them in kernel log. Why are all PIDs =
waiting on 'mem_cgroup_handle_oom' and there is no OOM message in the log=
? Data in memcg-bug-4.tar.gz are only for 2 minutes but i let it run for =
about 15-20 minutes, no single process killed by OOM. I'm 100% sure that =
OOM was not killing them (maybe it was trying to but it didn't happen).


>
>Nothing shows it would be a deadlock so far. It is well possible that
>the userspace went mad when seeing a lot of processes dying because it
>doesn't expect it.
>


Lots of processes are dying also now, without your latest patch, and no s=
uch things are happening. I'm sure there is something more it this, maybe=
 it revealed another bug?


azur

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
