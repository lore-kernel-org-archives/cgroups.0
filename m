From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_=5Bpatch_0=2F7=5D_improve_memcg_oom_killer_robustness_v2?=
Date: Wed, 11 Sep 2013 20:54:48 +0200
Message-ID: <20130911205448.656D9D7C@pobox.sk>
References: <20130909201238.GH856@cmpxchg.org>, <20130910201359.D0984EFF@pobox.sk>, <20130910183740.GI856@cmpxchg.org>, <20130910213253.A1E666C5@pobox.sk>, <20130910201222.GA25972@cmpxchg.org>, <20130910230853.FEEC19B5@pobox.sk>, <20130910211823.GJ856@cmpxchg.org>, <20130910233247.9EDF4DBA@pobox.sk>, <20130910220329.GK856@cmpxchg.org>, <20130911143305.FFEAD399@pobox.sk> <20130911180327.GL856@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130911180327.GL856@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
Cc: =?utf-8?q?Andrew_Morton?= <akpm@linux-foundation.org>, =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>, =?utf-8?q?David_Rientjes?= <rientjes@google.com>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>, =?utf-8?q?KOSAKI_Motohiro?= <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org

>On Wed, Sep 11, 2013 at 02:33:05PM +0200, azurIt wrote:
>> >On Tue, Sep 10, 2013 at 11:32:47PM +0200, azurIt wrote:
>> >> >On Tue, Sep 10, 2013 at 11:08:53PM +0200, azurIt wrote:
>> >> >> >On Tue, Sep 10, 2013 at 09:32:53PM +0200, azurIt wrote:
>> >> >> >> Here is full kernel log between 6:00 and 7:59:
>> >> >> >> http://watchdog.sk/lkml/kern6.log
>> >> >> >
>> >> >> >Wow, your apaches are like the hydra.  Whenever one is OOM kill=
ed,
>> >> >> >more show up!
>> >> >>=20
>> >> >>=20
>> >> >>=20
>> >> >> Yeah, it's supposed to do this ;)
>> >
>> >How are you expecting the machine to recover from an OOM situation,
>> >though?  I guess I don't really understand what these machines are
>> >doing.  But if you are overloading them like crazy, isn't that the
>> >expected outcome?
>>=20
>>=20
>>=20
>>=20
>>=20
>> There's no global OOM, server has enough of memory. OOM is occuring on=
ly in cgroups (customers who simply don't want to pay for more memory).
>
>Yes, sure, but when the cgroups are thrashing, they use the disk and
>CPU to the point where the overall system is affected.




Didn't know that there is a disk usage because of this, i never noticed a=
nything yet.




>> >> >> >> >> What do you think? I'm now running kernel with your previo=
us patch, not with the newest one.
>> >> >> >> >
>> >> >> >> >Which one exactly?  Can you attach the diff?
>> >> >> >>=20
>> >> >> >>=20
>> >> >> >>=20
>> >> >> >> I meant, the problem above occured on kernel with your latest=
 patch:
>> >> >> >> http://watchdog.sk/lkml/7-2-memcg-fix.patch
>> >> >> >
>> >> >> >The above log has the following callstack:
>> >> >> >
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.337628]  [<ffffffff810d=
19fe>] dump_header+0x7e/0x1e0
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.337707]  [<ffffffff810d=
18ff>] ? find_lock_task_mm+0x2f/0x70
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.337790]  [<ffffffff810d=
18ff>] ? find_lock_task_mm+0x2f/0x70
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.337874]  [<ffffffff8109=
4bb0>] ? __css_put+0x50/0x90
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.337952]  [<ffffffff810d=
1ec5>] oom_kill_process+0x85/0x2a0
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.338037]  [<ffffffff810d=
2448>] mem_cgroup_out_of_memory+0xa8/0xf0
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.338120]  [<ffffffff8111=
0858>] T.1154+0x8b8/0x8f0
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.338201]  [<ffffffff8111=
0fa6>] mem_cgroup_charge_common+0x56/0xa0
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.338283]  [<ffffffff8111=
1035>] mem_cgroup_newpage_charge+0x45/0x50
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.338364]  [<ffffffff810f=
3039>] handle_pte_fault+0x609/0x940
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.338451]  [<ffffffff8102=
ab1f>] ? pte_alloc_one+0x3f/0x50
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.338532]  [<ffffffff8107=
e455>] ? sched_clock_local+0x25/0x90
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.338617]  [<ffffffff810f=
34d7>] handle_mm_fault+0x167/0x340
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.338699]  [<ffffffff8102=
714b>] do_page_fault+0x13b/0x490
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.338781]  [<ffffffff810f=
8848>] ? do_brk+0x208/0x3a0
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.338865]  [<ffffffff812d=
ba22>] ? gr_learn_resource+0x42/0x1e0
>> >> >> >Sep 10 07:59:43 server01 kernel: [ 3846.338951]  [<ffffffff815c=
b7bf>] page_fault+0x1f/0x30
>> >> >> >
>> >> >> >The charge code seems to be directly invoking the OOM killer, w=
hich is
>> >> >> >not possible with 7-2-memcg-fix.  Are you sure this is the righ=
t patch
>> >> >> >for this log?  This _looks_ more like what 7-1-memcg-fix was do=
ing,
>> >> >> >with a direct kill in the charge context and a fixup later on.
>> >> >>=20
>> >> >> I, luckyly, still have the kernel source from which that kernel =
was build. I tried to re-apply the 7-2-memcg-fix.patch:
>> >> >>=20
>> >> >> # patch -p1 --dry-run < 7-2-memcg-fix.patch=20
>> >> >> patching file arch/x86/mm/fault.c
>> >> >> Reversed (or previously applied) patch detected!  Assume -R? [n]=
=20
>> >> >> Apply anyway? [n]=20
>> >> >> Skipping patch.
>> >> >> 4 out of 4 hunks ignored -- saving rejects to file arch/x86/mm/f=
ault.c.rej
>> >> >> patching file include/linux/memcontrol.h
>> >> >> Hunk #1 succeeded at 141 with fuzz 2 (offset 21 lines).
>> >> >> Hunk #2 succeeded at 391 with fuzz 1 (offset 39 lines).
>> >> >
>> >> >Uhm, some of it applied...  I have absolutely no idea what state t=
hat
>> >> >tree is in now...
>> >>=20
>> >> I used '--dry-run' so it should be ok :)
>> >
>> >Ah, right.
>> >
>> >> >> patching file include/linux/mm.h
>> >> >> Reversed (or previously applied) patch detected!  Assume -R? [n]=
=20
>> >> >> Apply anyway? [n]=20
>> >> >> Skipping patch.
>> >> >> 1 out of 1 hunk ignored -- saving rejects to file include/linux/=
mm.h.rej
>> >> >> patching file include/linux/sched.h
>> >> >> Reversed (or previously applied) patch detected!  Assume -R? [n]=
=20
>> >> >> Apply anyway? [n]=20
>> >> >> Skipping patch.
>> >> >> 1 out of 1 hunk ignored -- saving rejects to file include/linux/=
sched.h.rej
>> >> >> patching file mm/memcontrol.c
>> >> >> Reversed (or previously applied) patch detected!  Assume -R? [n]=
=20
>> >> >> Apply anyway? [n]=20
>> >> >> Skipping patch.
>> >> >> 10 out of 10 hunks ignored -- saving rejects to file mm/memcontr=
ol.c.rej
>> >> >> patching file mm/memory.c
>> >> >> Reversed (or previously applied) patch detected!  Assume -R? [n]=
=20
>> >> >> Apply anyway? [n]=20
>> >> >> Skipping patch.
>> >> >> 2 out of 2 hunks ignored -- saving rejects to file mm/memory.c.r=
ej
>> >> >> patching file mm/oom_kill.c
>> >> >> Reversed (or previously applied) patch detected!  Assume -R? [n]=
=20
>> >> >> Apply anyway? [n]=20
>> >> >> Skipping patch.
>> >> >> 1 out of 1 hunk ignored -- saving rejects to file mm/oom_kill.c.=
rej
>> >> >>=20
>> >> >>=20
>> >> >> Can you tell from this if the source has the right patch?
>> >> >
>> >> >Not reliably, I don't think.  Can you send me
>> >> >
>> >> >  include/linux/memcontrol.h
>> >> >  mm/memcontrol.c
>> >> >  mm/memory.c
>> >> >  mm/oom_kill.c
>> >> >
>> >> >from those sources?
>> >> >
>> >> >It might be easier to start the application from scratch...  Keep =
in
>> >> >mind that 7-2 was not an incremental fix, you need to remove the
>> >> >previous memcg patches (as opposed to 7-1).
>> >>=20
>> >>=20
>> >>=20
>> >> Yes, i used only 7-2 from your patches. Here are the files:
>> >> http://watchdog.sk/lkml/kernel
>> >>=20
>> >> orig - kernel source which was used to build the kernel i was talki=
ng about earlier
>> >> new - newly unpacked and patched 3.2.50 with all of 'my' patches
>> >
>> >Ok, thanks!
>> >
>> >> Here is how your patch was applied:
>> >>=20
>> >> # patch -p1 < 7-2-memcg-fix.patch=20
>> >> patching file arch/x86/mm/fault.c
>> >> Hunk #1 succeeded at 944 (offset 102 lines).
>> >> Hunk #2 succeeded at 970 (offset 102 lines).
>> >> Hunk #3 succeeded at 1273 with fuzz 1 (offset 212 lines).
>> >> Hunk #4 succeeded at 1382 (offset 223 lines).
>> >
>> >Ah, I forgot about this one.  Could you provide that file (fault.c) a=
s
>> >well please?
>>=20
>>=20
>>=20
>>=20
>> I added it.
>
>Thanks.  This one looks good, too.
>
>> >> patching file include/linux/memcontrol.h
>> >> Hunk #1 succeeded at 122 with fuzz 2 (offset 2 lines).
>> >> Hunk #2 succeeded at 354 (offset 2 lines).
>> >
>> >Looks good, still.
>> >
>> >> patching file include/linux/mm.h
>> >> Hunk #1 succeeded at 163 (offset 7 lines).
>> >> patching file include/linux/sched.h
>> >> Hunk #1 succeeded at 1644 (offset 76 lines).
>> >> patching file mm/memcontrol.c
>> >> Hunk #1 succeeded at 1752 (offset 9 lines).
>> >> Hunk #2 succeeded at 1777 (offset 9 lines).
>> >> Hunk #3 succeeded at 1828 (offset 9 lines).
>> >> Hunk #4 succeeded at 1867 (offset 9 lines).
>> >> Hunk #5 succeeded at 2256 (offset 9 lines).
>> >> Hunk #6 succeeded at 2317 (offset 9 lines).
>> >> Hunk #7 succeeded at 2348 (offset 9 lines).
>> >> Hunk #8 succeeded at 2411 (offset 9 lines).
>> >> Hunk #9 succeeded at 2419 (offset 9 lines).
>> >> Hunk #10 succeeded at 2432 (offset 9 lines).
>> >> patching file mm/memory.c
>> >> Hunk #1 succeeded at 3712 (offset 273 lines).
>> >> Hunk #2 succeeded at 3812 (offset 317 lines).
>> >> patching file mm/oom_kill.c
>> >
>> >These look good as well.
>> >
>> >That leaves the weird impossible stack trace.  Did you double check
>> >that this crash came from a kernel with those exact files?
>>=20
>>=20
>>=20
>> Yes i'm sure.
>
>Okay, my suspicion is that the previous patches invoked the OOM killer
>right away, whereas in this latest version it's invoked only when the
>fault is finished.  Maybe the task that locked the group gets held up
>somewhere else and then it takes too long until something is actually
>killed.  Meanwhile, every other allocator drops into 5 reclaim cycles
>before giving up, which could explain the thrashing.  And on the memcg
>level we don't have BDI congestion sleeps like on the global level, so
>everybody is backing off from the disk.
>
>Here is an incremental fix to the latest version, i.e. the one that
>livelocked under heavy IO, not the one you are using right now.
>
>First, it reduces the reclaim retries from 5 to 2, which resembles the
>global kswapd + ttfp somewhat.  Next, NOFS/NORETRY allocators are not
>allowed to kick off the OOM killer, like in the global case, so that
>we don't kill things and give up just because light reclaim can't free
>anything.  Last, the memcg is marked under OOM when one task enters
>OOM so that not everybody is livelocking in reclaim in a hopeless
>situation.



Thank you i will boot it this night. I also created a new server load che=
cking and recuing script so i hope i won't be forced to hard reboot the s=
erver in case something similar as before happens. Btw, patch didn't appl=
y to 3.2.51, there were probably big changes in memory system (almost all=
 hunks failed). I used 3.2.50 as before.

azur

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
