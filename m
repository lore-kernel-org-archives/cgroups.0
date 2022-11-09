From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v1 0/3] Avoid scheduling cache draining to isolated cpus
Date: Wed, 9 Nov 2022 09:05:28 +0100
Message-ID: <Y2tfSAgt/lBVcdvf@dhcp22.suse.cz>
References: <20221102020243.522358-1-leobras@redhat.com>
 <Y2IwHVdgAJ6wfOVH@dhcp22.suse.cz>
 <07810c49ef326b26c971008fb03adf9dc533a178.camel@redhat.com>
 <Y2Pe45LHANFxxD7B@dhcp22.suse.cz>
 <0183b60e79cda3a0f992d14b4db5a818cd096e33.camel@redhat.com>
 <Y2TQLavnLVd4qHMT@dhcp22.suse.cz>
 <3c4ae3bb70d92340d9aaaa1856928476641a8533.camel@redhat.com>
 <Y2i9h+TRdX9EOs0T@dhcp22.suse.cz>
 <4a4a6c73f3776d65f70f7ca92eb26fc90ed3d51a.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667981128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NtpuDwdakbsSweUDnOE8zAX0zXuYtEwWTzH9ZnpMCs8=;
        b=lViDlySknjzjl7K3UwqMWkFkLRCXSNasuR0ZF0+MldKSfQJZ3QyiiPpUXRzAJg95iSXXIn
        fdbGXvK8zzgSbxslolLq7XdBqXTtd0E5KCtQHOyy2Nn2/3EBrfweJRkiBn44TId/IZOOzo
        WCspmBuikEMQfpAIci0sYwXsNfU9Aig=
Content-Disposition: inline
In-Reply-To: <4a4a6c73f3776d65f70f7ca92eb26fc90ed3d51a.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 08-11-22 20:09:25, Leonardo Br=E1s wrote:
[...]
> > Yes, with a notable difference that with your spin lock option there is
> > still a chance that the remote draining could influence the isolated CPU
> > workload throug that said spinlock. If there is no pcp cache for that
> > cpu being used then there is no potential interaction at all.
>=20
> I see.=20
> But the slow path is slow for some reason, right?
> Does not it make use of any locks also? So on normal operation there coul=
d be a
> potentially larger impact than a spinlock, even though there would be no
> scheduled draining.

Well, for the regular (try_charge) path that is essentially page_counter_tr=
y_charge
which boils down to atomic_long_add_return of the memcg counter + all
parents up the hierarchy and high memory limit evaluation (essentially 2
atomic_reads for the memcg + all parents up the hierchy). That is not
whole of a lot - especially when the memcg hierarchy is not very deep.

Per cpu batch amortizes those per hierarchy updates as well as atomic
operations + cache lines bouncing on updates.

On the other hand spinlock would do the unconditional atomic updates as
well and even much more on CONFIG_RT. A plus is that the update will be
mostly local so cache line bouncing shouldn't be terrible. Unless
somebody heavily triggers pcp cache draining but this shouldn't be all
that common (e.g. when a memcg triggers its limit.

All that being said, I am still not convinced that the pcp cache bypass
for isolated CPUs would make a dramatic difference. Especially in the
context of workloads that tend to run on isolated CPUs and rarely enter
kernel.
=20
> > It is true true that appart from user
> > space memory which can be under full control of the userspace there are
> > kernel allocations which can be done on behalf of the process and those
> > could be charged to memcg as well. So I can imagine the pcp cache could
> > be populated even if the process is not faulting anything in during RT
> > sensitive phase.
>=20
> Humm, I think I will apply the change and do a comparative testing with
> upstream. This should bring good comparison results.

That would be certainly appreciated!
=20
> > > On the other hand, compared to how it works now now, this should be a=
 more
> > > controllable way of introducing latency than a scheduled cache drain.
> > >=20
> > > Your suggestion on no-stocks/caches in isolated CPUs would be great f=
or
> > > predictability, but I am almost sure the cost in overall performance =
would not
> > > be fine.
> >=20
> > It is hard to estimate the overhead without measuring that. Do you think
> > you can give it a try? If the performance is not really acceptable
> > (which I would be really surprised) then we can think of a more complex
> > solution.
>=20
> Sure, I can try that.
> Do you suggest any specific workload that happens to stress the percpu ca=
che
> usage, with usual drains and so? Maybe I will also try with synthetic wor=
loads
> also.

I really think you want to test it on the isolcpu aware workload.
Artificial benchmark are not all that useful in this context.
--=20
Michal Hocko
SUSE Labs
