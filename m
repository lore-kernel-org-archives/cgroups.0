From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: Memory CG and 5.1 to 5.6 uprade slows backup
Date: Thu, 9 Apr 2020 11:50:48 +0100
Message-ID: <20200409105048.GA1040020@chrisdown.name>
References: <20200409112505.2e1fc150@hemera.lan.sysophe.eu>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=v38bfbui8k5a6UTKAOOaJuah7JdF2f/erdWIs/iN2qA=;
        b=HW+Knoxg6d/dZG9qisjLcg2gnNliKCOWd8p3/R5jwqedJAeqw6sTWQbY7DRl6EP5qj
         Z0oIN4Gj+z5uafDfWB1vhxgYIt/IayuZXkSSHsYKgPNRr7lUaBAkhFpAiYGbcjTm/08J
         ogsOuGxSUOM8UjBOW/f8+EmhnUm5ARNpntjQI=
Content-Disposition: inline
In-Reply-To: <20200409112505.2e1fc150-pDZhbqX7CfkoGc32E1+a2S4z1YicLaQ4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons-ud5FBsm0p/xEiooADzr8i9i2O/JbrIOy@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi Bruno,

Bruno Pr=E9mont writes:
>Upgrading from 5.1 kernel to 5.6 kernel on a production system using
>cgroups (v2) and having backup process in a memory.high=3D2G cgroup
>sees backup being highly throttled (there are about 1.5T to be
>backuped).

Before 5.4, memory usage with memory.high=3DN is essentially unbounded if t=
he=20
system is not able to reclaim pages for some reason. This is because all=20
memory.high throttling before that point is just based on forcing direct=20
reclaim for a cgroup, but there's no guarantee that we can actually reclaim=
=20
pages, or that it will serve as a time penalty.

In 5.4, my patch 0e4b01df8659 ("mm, memcg: throttle allocators when failing=
=20
reclaim over memory.high") changes kernel behaviour to actively penalise=20
cgroups exceeding their memory.high by a large amount. That is, if reclaim =

fails to reclaim pages and bring the cgroup below the high threshold, we=20
actively deschedule the process running for some number of jiffies that is =

exponential to the amount of overage incurred. This is so that cgroups usin=
g=20
memory.high cannot simply have runaway memory usage without any consequence=
s.

This is the patch that I'd particularly suspect is related to your problem.=
=20
However:

>Most memory usage in that cgroup is for file cache.
>
>Here are the memory details for the cgroup:
>memory.current:2147225600
>[...]
>memory.events:high 423774
>memory.events:max 31131
>memory.high:2147483648
>memory.max:2415919104

Your high limit is being exceeded heavily and you are failing to reclaim. Y=
ou=20
have `max` events here, which mean your application is at least at some poi=
nt=20
using over 268 *mega*bytes over its memory.high.

So yes, we will penalise this cgroup heavily since we cannot reclaim from i=
t.=20
The real question is why we can't reclaim from it :-)

>memory.low:33554432

You have a memory.low set, which will bias reclaim away from this cgroup ba=
sed=20
on overage. It's not very large, though, so it shouldn't change the semanti=
cs=20
here, although it's worth noting since it also changed in another one of my=
=20
patches, 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim"),=
=20
which is also in 5.4.

In 5.1, as soon as you exceed memory.low, you immediately lose all protecti=
on. =20
This is not ideal because it results in extremely binary, back-and-forth=20
behaviour for cgroups using it (see the changelog for more information). Th=
is=20
change means you will still receive some small amount of protection based o=
n=20
your overage, but it's fairly insignificant in this case (memory.current is=
=20
about 64x larger than memory.low). What did you intend to do with this in 5=
.1?=20
:-)

>memory.stat:anon 10887168
>memory.stat:file 2062102528
>memory.stat:kernel_stack 73728
>memory.stat:slab 76148736
>memory.stat:sock 360448
>memory.stat:shmem 0
>memory.stat:file_mapped 12029952
>memory.stat:file_dirty 946176
>memory.stat:file_writeback 405504
>memory.stat:anon_thp 0
>memory.stat:inactive_anon 0
>memory.stat:active_anon 10121216
>memory.stat:inactive_file 1954959360
>memory.stat:active_file 106418176
>memory.stat:unevictable 0
>memory.stat:slab_reclaimable 75247616
>memory.stat:slab_unreclaimable 901120
>memory.stat:pgfault 8651676
>memory.stat:pgmajfault 2013
>memory.stat:workingset_refault 8670651
>memory.stat:workingset_activate 409200
>memory.stat:workingset_nodereclaim 62040
>memory.stat:pgrefill 1513537
>memory.stat:pgscan 47519855
>memory.stat:pgsteal 44933838
>memory.stat:pgactivate 7986
>memory.stat:pgdeactivate 1480623
>memory.stat:pglazyfree 0
>memory.stat:pglazyfreed 0
>memory.stat:thp_fault_alloc 0
>memory.stat:thp_collapse_alloc 0

Hard to say exactly why we can't reclaim using these statistics, usually if=
=20
anything the kernel is *over* eager to drop cache pages than anything.

If the kernel thinks those file pages are too hot, though, it won't drop th=
em.=20
However, we only have 106M active file, compared to 2GB memory.current, so =
it=20
doesn't look like this is the issue.

Can you please show io.pressure, io.stat, and cpu.pressure during these per=
iods=20
compared to baseline for this cgroup and globally (from /proc/pressure)? My=
=20
suspicion is that we are not able to reclaim fast enough because memory=20
management is getting stuck behind a slow disk.

Swap availability and usage information would also be helpful.

>Regularly the backup process seems to be blocked for about 2s, but not
>within a syscall according to strace.

2 seconds is important, it's the maximum time we allow the allocator thrott=
ler=20
to throttle for one allocation :-)

If you want to verify, you can look at /proc/pid/stack during these stalls =
--=20
they should be in mem_cgroup_handle_over_high, in an address related to=20
allocator throttling.

>Is there a way to tell kernel that this cgroup should not be throttled

Huh? That's what memory.high is for, so why are you using if it you don't w=
ant=20
that?

>and its inactive file cache given up (rather quickly).

I suspect the kernel is reclaiming as far as it can, but is being stopped f=
rom=20
doing so for some reason, which is why I'd like to see io.pressure and=20
cpu.pressure.

>On a side note, I liked v1's mode of soft/hard memory limit where the
>memory amount between soft and hard could be used if system has enough
>free memory. For v2 the difference between high and max seems almost of
>no use.

For that use case, that's more or less what we've designed memory.low to do=
.=20
The difference is that v1's soft limit almost never worked: the heuristics =
are=20
extremely complicated, so complicated in fact that even we as memcg maintai=
ners=20
cannot reason about them. If we cannot reason about them, I'm quite sure it=
's=20
not really doing what you expect :-)

In this case everything looks like it's working as intended, just this is a=
ll=20
the result of memory.high becoming less broken in 5.4. From your descriptio=
n,=20
I'm not sure that memory.high is what you want, either.

>A cgroup parameter for impacting RO file cache differently than
>anonymous memory or otherwise dirty memory would be great too.

We had vm.swappiness in v1 and it manifested extremely poorly. I won't go t=
oo=20
much into the details of that here though, since we already discussed it fa=
irly=20
comprehensively here[0].

Please feel free to send over the io.pressure, io.stat, cpu.pressure, and s=
wap=20
metrics at baseline and during this when possible. Thanks!

0: https://lore.kernel.org/patchwork/patch/1172080/
