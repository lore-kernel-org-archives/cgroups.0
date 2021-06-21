From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: [PATCH v1] proc: Implement /proc/self/meminfo
Date: Mon, 21 Jun 2021 20:20:28 +0200
Message-ID: <d1eb12ec-8e6a-11c1-ea0a-b36dcf354d16@metux.net>
References: <ac070cd90c0d45b7a554366f235262fa5c566435.1622716926.git.legion@kernel.org>
 <20210615113222.edzkaqfvrris4nth@wittgenstein>
 <20210615124715.nzd5we5tl7xc2n2p@example.org>
 <CALvZod7po_fK9JpcUNVrN6PyyP9k=hdcyRfZmHjSVE5r_8Laqw@mail.gmail.com>
 <87zgvpg4wt.fsf@disp2133>
 <CALvZod70DNiWF-jTUHp6pOVtVX9pzdvYXaQ1At3GHtdKD=iTwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CALvZod70DNiWF-jTUHp6pOVtVX9pzdvYXaQ1At3GHtdKD=iTwQ@mail.gmail.com>
Content-Language: tl
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Gladkov <legion@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux.dev>, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Chris Down <chris@chrisdown.name>, Cgroups <cgroups@vger.kernel.org>

On 19.06.21 01:38, Shakeel Butt wrote:

> Nowadays, I don't think MemAvailable giving "amount of memory that can
> be allocated without triggering swapping" is even roughly accurate.
> Actually IMO "without triggering swap" is not something an application
> should concern itself with where refaults from some swap types
> (zswap/swap-on-zram) are much faster than refaults from disk.

If we're talking about things like database workloads, there IMHO isn't
anything really better than doing measurements with the actual loads
and tuning incrementally.

But: what is the actual optimization goal, why an application might
want to know where swapping begins ? Computing performance ? Caching +
IO Latency or throughput ? Network traffic (e.g. w/ iscsi) ? Power
consumption ?

>> I do know that hiding the implementation details and providing userspace
>> with information it can directly use seems like the programming model
>> that needs to be explored.  Most programs should not care if they are in
>> a memory cgroup, etc.  Programs, load management systems, and even
>> balloon drivers have a legitimately interest in how much additional load
>> can be placed on a systems memory.

What kind of load exactly ? CPU ? disk IO ? network ?

> How much additional load can be placed on a system *until what*. I
> think we should focus more on the "until" part to make the problem
> more tractable.

ACK. The interesting question is what to do in that case.

An obvious move by an database system could be eg. filling only so much
caches as there's spare physical RAM, in order to avoid useless swapping
(since we'd potentiall produce more IO load when a cache is written
out to swap, instead of just discarding it)

But, this also depends ...

#1: the application doesn't know the actual performance of the swap
device, eg. the already mentioned zswap+friends, or some fast nvmem
for swap vs disk for storage.

#2: caches might also be implemented indirectly by mmap()ing the storage
file/device and so using the kernel's cache here. in that case, the
kernel would automatically discard the pages w/o going to swap. of
course that only works if the cache is nothing but copying pages from
storage into ram.

A completely different scenario would be load management on a cluster
like k8s. Here we usually care of cluster performance (dont care about
individual nodes so muck), but wanna prevent individual nodes from being
overloaded. Since we usually don't know much about the indivdual
workload, we probably don't have much other chance than contigous
monitoring and acting when a node is getting too busy - or trying to
balance when new workloads are started, on current system load (and
other metrics). In that case, I don't see where this new proc file
should be of much help.

> Second, is the reactive approach acceptable? Instead of an upfront
> number representing the room for growth, how about just grow and
> backoff when some event (oom or stall) which we want to avoid is about
> to happen? This is achievable today for oom and stall with PSI and
> memory.high and it avoids the hard problem of reliably estimating the
> reclaimable memory.

I tend to believe that for certain use cases it would be helpful if an
application gets notified if some of its pages are soon getting swapped
out due memory pressure. Then it could decide on its own which whether
it should drop certain caches in order to prevent swapping.


--mtx

-- 
---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
