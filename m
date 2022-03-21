From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v2 0/4] Introduce group balancer
Date: Mon, 21 Mar 2022 08:16:26 -1000
Message-ID: <YjjA+vyQuh5fNeLG@slm.duckdns.org>
References: <20220308092629.40431-1-dtcccc@linux.alibaba.com>
 <YieOvaqJeEW2lta/@slm.duckdns.org>
 <defa02c1-9660-f335-a764-d89dbe2f502e@linux.alibaba.com>
 <YijrVmzG8/yT9a0f@slm.duckdns.org>
 <014c8afe-e57f-0f31-32bb-cf4ff3d3cb95@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ls4ppSzcwTphO5fl7/cnR5YWXHZaUFCeJodB7pVCrnU=;
        b=bayZTwU/9OUWkVg+QqtcVV1j1Ad8zFbewV2DckvEs4eUP0KmVFLQPCXlYku22qs0q4
         zM49m1PcjGur8W0lk9CJ7B9Bs5b044DrxlaNWyaY9TSZTF9rRyVrsO1mJQg2S3WDeXgm
         HtWjErAnUi6OMAcvPs/Qv1dm+IkGmF8WjQVeWA0yHP7b0TKjcU+NUwSGG+v1kdmRGdWN
         rgAKCyMEkYbcHbEQ8pGZvCV54/VfaUQOEz7jXvNyT0aycIrBNasLt1KDTvpdXD8Paq9l
         6Z+oGHIkWCgFaXp4xbcSZmEjKuNoo6Vk5fHwoVuj6J4+oAsyR7HqN8d5M5+hu5YgFdrD
         PIAg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <014c8afe-e57f-0f31-32bb-cf4ff3d3cb95-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michael Wang <yun.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Cruz Zhao <cruzzhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Masahiro Yamada <masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nathan Chancellor <nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <ar>

Hello,

On Thu, Mar 10, 2022 at 01:47:34PM +0800, Tianchen Ding wrote:
> If we want to build group balancer in userspace, we need:
>   1) gather load info from each rq periodically
>   2) make decision to set cpuset.cpus of each cgroup
>=20
> However, there're some problems about this way.
>=20
> For 1), we need to consider how frequently collecting these info, which m=
ay
> impact performance and accuracy. If the load changes hugely right after we
> get it once, our data are expired and then the decision may be wrong. (If=
 we
> are in kernel, faster action can be taken.)

We now have a pretty well established way to transport data to userspace at
really low overhead. If you piggy back on bpf interfaces, they can usually
be pretty unintrusive and low effort as long as you have the right kind of
data aggregated already, which shouldn't be that difficult here.

> We believe 2) is harder. The specific policy may be complex and alter
> according to different scenes. There's not a general method.
> e.g., with 16cpus and 4 cgroups, how to decide when we set one of them
> 0-3(when busy)or 0-7(when some of other cgroups are idle)? If there are m=
uch
> more threads in cgroupA than cgroupB/C/D , and we want to satisfy cgroupA=
 as
> far as possible(on the premise of fairness of B/C/D)=EF=BC=8C dynamically
> enlarging(when B/C/D partly idle) and shrinking(when B/C/D busy) cpuset of
> cgroupA requires complex policy. In this example, fairness and performance
> can be provided by existing scheduler, but when it comes to grouping hot
> cache or decreasing competion, both scheduler in kernel and action in
> userspace are hard to solve.

So, I get that it's not easy. In fact, we don't even yet know how to
properly compare loads across groups of CPUs - simple sums that you're using
break down when there are big gaps in weight numbers across tasks and can
become meaningless in the presence of CPU affinities. They can still work
when the configuration is fairly homogeenous and controlled but the standard
should be far higher for something we bake into the kernel and expose
userland-visible interface for.

> What's more, in many cloud computing scenes, there may be hundreds or
> thousands of containers, which are much larger than partition number. The=
se
> containers may be dynamically created and destroyed at any time. Making
> policy to manage them from userspace will not be practical.
>=20
> These problems become easy when going to kernelspace. We get info directly
> from scheduler, and help revising its decision at some key points, or do
> some support work(e.g., task migration if possible).

I don't think they become necessarily easy. Sure, you can hack up something
which works for some cases by poking into existing code; however, the bar
for acceptance is also way higher for a kernel interface - it should be
generic, consistent with other interfaces (I won't go into cgroup interface
issues here), and work orthogonally with other kernel features (ie. task /
group weights should work in an explainable way). I don't think the proposed
patches are scoring high in those axes.

I'm not against the goal here. Given that cgroups express the logical
structure of applications running on the system, it does make sense to
factor that into scheduling decisions. However, what's proposed seems too
premature and I have a hard time seeing why this level of functionality
would be difficult to be implement from userspace with some additions in
terms of visibility which is really easy to do these days.

Thanks.

--=20
tejun
