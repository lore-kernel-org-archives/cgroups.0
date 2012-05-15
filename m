From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: About cgroup memory limits
Date: Tue, 15 May 2012 11:20:40 +0200
Message-ID: <20120515092040.GF1406@cmpxchg.org>
References: <1336685923.15687.1.camel@andre>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1336685923.15687.1.camel@andre>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andre Nathan <andre-K36Kqf6HJK439yzSjRtAkw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, michel-K36Kqf6HJK439yzSjRtAkw@public.gmane.org

On Thu, May 10, 2012 at 06:38:43PM -0300, Andre Nathan wrote:
> Hello
> 
> I'm doing some tests with LXC and how it interacts with the memory
> cgroup limits, more specifically the memory.limit_in_bytes control file.
> 
> Am I correct in my understanding of the memory cgroup documentation[1]
> that the limit set in memory.limit_in_bytes is applied to the sum of the
> fields 'cache', 'rss' and 'mapped_file' in the memory.stat file?

mapped_file is the subset of cache that is mapped into virtual memory.

cache (= inactive_file + active_file) + rss (= inactive_anon +
active_anon) is what the limit applies to.

> I am also trying to understand the values reported in memory.stat when
> compared to the statistics in /proc/$PID/statm.
> 
> Below is the sum of each field in /proc/$PID/statm for every process
> running inside a test container, converted to bytes:
> 
>        size  resident     share     text  lib       data  dt
>   897208320  28741632  20500480  1171456    0  170676224   0

statms accounts based on virtual memory, not physical memory like
memcg does.  If you have the same page mapped into two tasks, both
their "share" counters will show a page, while the memcg will only
account the single physical page in mapped_file.

> Compare this with the usage reports from memory.stat (fields total_*,
> hierarchical_* and pg* omitted):
> 
> cache                     16834560
> rss                       8192000
> mapped_file               3743744
> swap                      0
> inactive_anon             0
> active_anon               8192000
> inactive_file             13996032
> active_file               2838528
> unevictable               0
> 
> Is there a way to reconcile these numbers somehow? I understand that the
> fields from the two files represent different things. What I'm trying to
> do is to combine, for example, the fields from memory.stat to
> approximately reach what is displayed by statm.

Excluding the memory shared between tasks in the same group from the
"shared" counter gets you to "mapped_file" etc.
