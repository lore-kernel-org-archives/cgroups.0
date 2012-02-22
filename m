From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/7] memcg kernel memory tracking
Date: Wed, 22 Feb 2012 12:32:03 -0800
Message-ID: <CABCjUKBf1T=ccwz9xNY84y5Kizyx0sD+8Vh0ro-jtrdMgD-SNw@mail.gmail.com>
References: <1329824079-14449-1-git-send-email-glommer@parallels.com>
	<CABCjUKCwLTOFOYR7E6v_z5=tUCUKch7TTMpAOrhQ_JKT1sqTqA@mail.gmail.com>
	<4F44F4A2.7010902@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=8Gk80OypiBiIeUbRQra9iT5Cr+qspCW5MqQ1kRjm668=;
        b=iLWpBDCU5/I/KpZBU0Va5R2U1kUOa052/xthv33dJDzQEM3MY0Ozf18okQuYAbCY9B
         1vEpcQ6K6BEjGDM9uYASHASy+DxNRAmZtTjZKTeZBm7i7/t/taUX9cVohGe+SbmdJzj5
         F1anoLps7ftKE9x7TOlmrjUheFyxYq3HO43BY=
In-Reply-To: <4F44F4A2.7010902-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Feb 22, 2012 at 5:58 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> =
wrote:
>>> As previously proposed, one has the option of keeping kernel memory
>>> accounted separatedly, or together with the normal userspace memory=
=2E
>>> However, this time I made the option to, in this later case, bill
>>> the memory directly to memcg->res. It has the disadvantage that it
>>> becomes
>>> complicated to know which memory came from user or kernel, but OTOH=
,
>>> it does not create any overhead of drawing from multiple res_counte=
rs
>>> at read time. (and if you want them to be joined, you probably don'=
t
>>> care)
>>
>>
>> It would be nice to still keep a kernel memory counter (that gets
>> updated at the same time as memcg->res) even when the limits are not
>> independent, because sometimes it's important to know how much kerne=
l
>> memory is being used by a cgroup.
>
>
> Can you clarify in this "sometimes" ? The way I see it, we either alw=
ays use
> two counters - as did in my original proposal - or use a single count=
er for
> this case. Keeping a separated counter and still billing to the user =
memory
> is the worst of both worlds to me, since you get the performance hit =
of
> updating two resource counters.

By "sometimes", I mean pretty much any time we have to debug why a
cgroup is out of memory.
If there is no counter for how much kernel memory is used, it's pretty
much impossible to determine why the cgroup is full.

As for the performance, I do not think it is bad, as the accounting is
done in the slow path of slab allocation, when we allocate/free pages.

>
>
>>> Kernel memory is never tracked for the root memory cgroup. This mea=
ns
>>> that a system where no memory cgroups exists other than the root, t=
he
>>> time cost of this implementation is a couple of branches in the slu=
b
>>> code - none of them in fast paths. At the moment, this works only
>>> with the slub.
>>>
>>> At cgroup destruction, memory is billed to the parent. With no hier=
archy,
>>> this would mean the root memcg. But since we are not billing to tha=
t,
>>> it simply ceases to be tracked.
>>>
>>> The caches that we want to be tracked need to explicit register int=
o
>>> the infrastructure.
>>
>>
>> Why not track every cache unless otherwise specified? If you don't,
>> you might end up polluting code all around the kernel to create
>> per-cgroup caches.
>> =A0From what I've seen, there are a fair amount of different caches =
that
>> can end up using a significant amount of memory, and having to go
>> around and explicitly mark each one doesn't seem like the right thin=
g
>> to do.
>>
> The registration code is quite simple, so I don't agree this is pollu=
ting
> code all around the kernel. It is just a couple of lines.
>
> Of course, in an opt-out system, this count would be zero. So is it b=
etter?
>
> Let's divide the caches in two groups: Ones that use shrinkers, and s=
imple
> ones that won't do. I am assuming most of the ones we need to track u=
se
> shrinkers somehow.
>
> So if they do use a shrinker, it is very unlikely that the normal shr=
inkers
> will work without being memcg-aware. We then end up in a scenario in =
which
> we track memory, we create a bunch of new caches, but we can't really=
 force
> reclaim on that cache. We then depend on luck to have the objects rec=
laimed
> from the root shrinker. Note that this is a problem that did not exis=
t
> before: a dcache shrinker would shrink dcache objects and that's it, =
but we
> didn't have more than one cache with those objects.
>
> So in this context, registering a cache explicitly is better IMHO, be=
cause
> what you are doing is telling: "I examined this cache, and I believe =
it will
> work okay with the memcg. It either does not need changes to the shri=
nker,
> or I made them already"
>
> Also, everytime we create a new cache, we're wasting some memory, as =
we
> duplicate state. That is fine, since we're doing this to prevent the =
usage
> to explode.
>
> But I am not sure it pays of in a lot of caches, even if they use a l=
ot of
> pages: Like, quickly scanning slabinfo:
>
> task_struct =A0 =A0 =A0 =A0 =A0512 =A0 =A0570 =A0 5920 =A0 =A05 =A0 =A0=
8 : tunables =A0 =A00 =A0 =A00 =A00 :
> slabdata =A0 =A0114 =A0 =A0114 =A0 =A0 =A00
>
> Can only grow if # of processes grow. Likely to hit a limit on that f=
irst.
>
> Acpi-Namespace =A0 =A0 =A04348 =A0 5304 =A0 =A0 40 =A0102 =A0 =A01 : =
tunables =A0 =A00 =A0 =A00 =A00 :
> slabdata =A0 =A0 52 =A0 =A0 52 =A0 =A0 =A00
>
> I doubt we can take down a sane system by using this cache...
>
> and so on and so forth.
>
> What do you think?

Well, we've seen several slabs that don't have shrinkers use
significant amounts of memory. For example, size-64, size-32,
vm_area_struct, buffer_head, radix_tree_node, TCP, filp..

=46or example, consider this perl program (with high enough file
descriptor limits):
use POSIX; use Socket; my $i; for ($i =3D 0; $i < 100000; $i++) {
socket($i, PF_INET, SOCK_STREAM, 0) || die "socket: $!"; }

One can make other simple programs like this that use significant
amounts of slab memory.

Having to look at a running kernel, having to find out which caches
are significant, and then going back and marking them for accounting,
really doesn't seem the right approach to me.

-- Suleiman
