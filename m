From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=5D_memcg=3A_do_not_trap_chargers_with_full_callstack_on_OOM?=
Date: Sun, 14 Jul 2013 01:51:12 +0200
Message-ID: <20130714015112.FFCB7AF7@pobox.sk>
References: <20130624201345.GA21822@cmpxchg.org>, <20130628120613.6D6CAD21@pobox.sk>, <20130705181728.GQ17812@cmpxchg.org>, <20130705210246.11D2135A@pobox.sk>, <20130705191854.GR17812@cmpxchg.org>, <20130708014224.50F06960@pobox.sk>, <20130709131029.GH20281@dhcp22.suse.cz>, <20130709151921.5160C199@pobox.sk>, <20130709135450.GI20281@dhcp22.suse.cz>, <20130710182506.F25DF461@pobox.sk>, <20130711072507.GA21667@dhcp22.suse.cz> <20130714012641.C2DA4E05@pobox.sk>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130714012641.C2DA4E05@pobox.sk>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Cc: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>, righi.andrea@gmail.com

> CC: "Johannes Weiner" <hannes@cmpxchg.org>, linux-kernel@vger.kernel.or=
g, linux-mm@kvack.org, "cgroups mailinglist" <cgroups@vger.kernel.org>, "=
KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, righi.andrea@gmail.c=
om
>> CC: "Johannes Weiner" <hannes@cmpxchg.org>, linux-kernel@vger.kernel.o=
rg, linux-mm@kvack.org, "cgroups mailinglist" <cgroups@vger.kernel.org>, =
"KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>, righi.andrea@gmail.=
com
>>On Wed 10-07-13 18:25:06, azurIt wrote:
>>> >> Now i realized that i forgot to remove UID from that cgroup before
>>> >> trying to remove it, so cgroup cannot be removed anyway (we are us=
ing
>>> >> third party cgroup called cgroup-uid from Andrea Righi, which is a=
ble
>>> >> to associate all user's processes with target cgroup). Look here f=
or
>>> >> cgroup-uid patch:
>>> >> https://www.develer.com/~arighi/linux/patches/cgroup-uid/cgroup-ui=
d-v8.patch
>>> >>=20
>>> >> ANYWAY, i'm 101% sure that 'tasks' file was empty and 'under_oom' =
was
>>> >> permanently '1'.
>>> >
>>> >This is really strange. Could you post the whole diff against stable
>>> >tree you are using (except for grsecurity stuff and the above cgroup=
-uid
>>> >patch)?
>>>=20
>>>=20
>>> Here are all patches which i applied to kernel 3.2.48 in my last test=
:
>>> http://watchdog.sk/lkml/patches3/
>>
>>The two patches from Johannes seem correct.
>>
>>From a quick look even grsecurity patchset shouldn't interfere as it
>>doesn't seem to put any code between handle_mm_fault and mm_fault_error
>>and there also doesn't seem to be any new handle_mm_fault call sites.
>>
>>But I cannot tell there aren't other code paths which would lead to a
>>memcg charge, thus oom, without proper FAULT_FLAG_KERNEL handling.
>
>
>Michal,
>
>now i can definitely confirm that problem with unremovable cgroups persi=
sts. What info do you need from me? I applied also your little 'WARN_ON' =
patch.
>
>azur



Ok, i think you want this:
http://watchdog.sk/lkml/kern4.log

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
