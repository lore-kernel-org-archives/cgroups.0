From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?Re=3A_=5Bpatch_0=2F7=5D_improve_memcg_oom_killer_robustness_v2?=
Date: Wed, 11 Sep 2013 21:41:18 +0200
Message-ID: <20130911214118.7CDF2E71@pobox.sk>
References: <20130910183740.GI856@cmpxchg.org>, <20130910213253.A1E666C5@pobox.sk>, <20130910201222.GA25972@cmpxchg.org>, <20130910230853.FEEC19B5@pobox.sk>, <20130910211823.GJ856@cmpxchg.org>, <20130910233247.9EDF4DBA@pobox.sk>, <20130910220329.GK856@cmpxchg.org>, <20130911143305.FFEAD399@pobox.sk>, <20130911180327.GL856@cmpxchg.org>, <20130911205448.656D9D7C@pobox.sk> <20130911191150.GN856@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130911191150.GN856@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
Cc: =?utf-8?q?Andrew_Morton?= <akpm@linux-foundation.org>, =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>, =?utf-8?q?David_Rientjes?= <rientjes@google.com>, =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>, =?utf-8?q?KOSAKI_Motohiro?= <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org

>On Wed, Sep 11, 2013 at 08:54:48PM +0200, azurIt wrote:
>> >On Wed, Sep 11, 2013 at 02:33:05PM +0200, azurIt wrote:
>> >> >On Tue, Sep 10, 2013 at 11:32:47PM +0200, azurIt wrote:
>> >> >> >On Tue, Sep 10, 2013 at 11:08:53PM +0200, azurIt wrote:
>> >> >> >> >On Tue, Sep 10, 2013 at 09:32:53PM +0200, azurIt wrote:
>> >> >> >> >> Here is full kernel log between 6:00 and 7:59:
>> >> >> >> >> http://watchdog.sk/lkml/kern6.log
>> >> >> >> >
>> >> >> >> >Wow, your apaches are like the hydra.  Whenever one is OOM k=
illed,
>> >> >> >> >more show up!
>> >> >> >>=20
>> >> >> >>=20
>> >> >> >>=20
>> >> >> >> Yeah, it's supposed to do this ;)
>> >> >
>> >> >How are you expecting the machine to recover from an OOM situation=
,
>> >> >though?  I guess I don't really understand what these machines are
>> >> >doing.  But if you are overloading them like crazy, isn't that the
>> >> >expected outcome?
>> >>=20
>> >>=20
>> >>=20
>> >>=20
>> >>=20
>> >> There's no global OOM, server has enough of memory. OOM is occuring=
 only in cgroups (customers who simply don't want to pay for more memory)=
.
>> >
>> >Yes, sure, but when the cgroups are thrashing, they use the disk and
>> >CPU to the point where the overall system is affected.
>>=20
>>=20
>>=20
>>=20
>> Didn't know that there is a disk usage because of this, i never notice=
d anything yet.
>
>You said there was heavy IO going on...?



Yes, there usually was a big IO but it was related to that deadlocking bu=
g in kernel (or i assume it was). I never saw a big IO in normal conditio=
ns even when there were lots of OOM in cgroups. I'm even not using swap b=
ecause of this so i was assuming that lacks of memory is not doing any ad=
ditional IO (or am i wrong?). And if you mean that last problem with IO f=
rom Monday, i don't exactly know what happens but it's really long time w=
hen we had so big problem with IO that it disables also root login on con=
sole.




>> >Okay, my suspicion is that the previous patches invoked the OOM kille=
r
>> >right away, whereas in this latest version it's invoked only when the
>> >fault is finished.  Maybe the task that locked the group gets held up
>> >somewhere else and then it takes too long until something is actually
>> >killed.  Meanwhile, every other allocator drops into 5 reclaim cycles
>> >before giving up, which could explain the thrashing.  And on the memc=
g
>> >level we don't have BDI congestion sleeps like on the global level, s=
o
>> >everybody is backing off from the disk.
>> >
>> >Here is an incremental fix to the latest version, i.e. the one that
>> >livelocked under heavy IO, not the one you are using right now.
>> >
>> >First, it reduces the reclaim retries from 5 to 2, which resembles th=
e
>> >global kswapd + ttfp somewhat.  Next, NOFS/NORETRY allocators are not
>> >allowed to kick off the OOM killer, like in the global case, so that
>> >we don't kill things and give up just because light reclaim can't fre=
e
>> >anything.  Last, the memcg is marked under OOM when one task enters
>> >OOM so that not everybody is livelocking in reclaim in a hopeless
>> >situation.
>>=20
>>=20
>>=20
>> Thank you i will boot it this night. I also created a new server load =
checking and recuing script so i hope i won't be forced to hard reboot th=
e server in case something similar as before happens. Btw, patch didn't a=
pply to 3.2.51, there were probably big changes in memory system (almost =
all hunks failed). I used 3.2.50 as before.
>
>Yes, please don't change the test base in the middle of this!
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
