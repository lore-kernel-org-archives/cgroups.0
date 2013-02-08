From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM if PF_NO_MEMCG_OOM
 is set
Date: Fri, 8 Feb 2013 18:10:12 +0100
Message-ID: <20130208171012.GH7557@dhcp22.suse.cz>
References: <20130206140119.GD10254@dhcp22.suse.cz>
 <20130206142219.GF10254@dhcp22.suse.cz>
 <20130206160051.GG10254@dhcp22.suse.cz>
 <20130208060304.799F362F@pobox.sk>
 <20130208094420.GA7557@dhcp22.suse.cz>
 <20130208120249.FD733220@pobox.sk>
 <20130208123854.GB7557@dhcp22.suse.cz>
 <20130208145616.FB78CE24@pobox.sk>
 <20130208152402.GD7557@dhcp22.suse.cz>
 <20130208165805.8908B143@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130208165805.8908B143-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Fri 08-02-13 16:58:05, azurIt wrote:
[...]
> I took the kernel log from yesterday from the same time frame:
> 
> $ grep "killed as a result of limit" kern2.log | sed 's@.*\] @@' | sort | uniq -c | sort -k1 -n
>       1 Task in /1252/uid killed as a result of limit of /1252
>       1 Task in /1709/uid killed as a result of limit of /1709
>       2 Task in /1185/uid killed as a result of limit of /1185
>       2 Task in /1388/uid killed as a result of limit of /1388
>       2 Task in /1567/uid killed as a result of limit of /1567
>       2 Task in /1650/uid killed as a result of limit of /1650
>       3 Task in /1527/uid killed as a result of limit of /1527
>       5 Task in /1552/uid killed as a result of limit of /1552
>    1634 Task in /1258/uid killed as a result of limit of /1258
> 
> As you can see, there were much more OOM in '1258' and no such
> problems like this night (well, there were never such problems before
> :) ).

Well, all the patch does is that it prevents from the deadlock we have
seen earlier. Previously the writer would block on the oom wait queue
while it fails with ENOMEM now. Caller sees this as a short write which
can be retried (it is a question whether userspace can cope with that
properly). All other OOMs are preserved.

I suspect that all the problems you are seeing now are just side effects
of the OOM conditions.

> As i said, cgroup 1258 were freezing every few minutes with your
> latest patch so there must be something wrong (it usually freezes
> about once per day). And it was really freezed (i checked that), the
> sypthoms were:

I assume you have checked that the killed processes eventually die,
right?

>  - cannot strace any of cgroup processes
>  - no new processes were started, still the same processes were 'running'
>  - kernel was unable to resolve this by it's own
>  - all processes togather were taking 100% CPU
>  - the whole memory limit was used
> (see memcg-bug-4.tar.gz for more info)

Well, I do not see anything supsicious during that time period
(timestamps translate between Fri Feb  8 02:34:05 and Fri Feb  8
02:36:48). The kernel log shows a lot of oom during that time. All
killed processes die eventually.

> Unfortunately i forget to check if killing only few of the processes
> will resolve it (i always killed them all yesterday night). Don't
> know if is was in deadlock or not but kernel was definitely unable
> to resolve the problem.

Nothing shows it would be a deadlock so far. It is well possible that
the userspace went mad when seeing a lot of processes dying because it
doesn't expect it.

> And there is still a mystery of two freezed processes which cannot be
> killed.
> 
> By the way, i KNOW that so much OOM is not healthy but the client
> simply don't want to buy more memory. He knows about the problem of
> unsufficient memory limit.

Well, then you would see a permanent flood of OOM killing, I am afraid.
-- 
Michal Hocko
SUSE Labs
