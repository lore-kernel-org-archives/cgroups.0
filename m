From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup/cpuset: introduce cpuset.mems.migration
Date: Wed, 5 May 2021 18:30:44 -0400
Message-ID: <YJMclPw7OVYxboEE@cmpxchg.org>
References: <20210426065946.40491-1-wuyun.abel@bytedance.com>
 <20210426065946.40491-3-wuyun.abel@bytedance.com>
 <YIgjE6CgU4nDsJiR@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SPq92WwUkkbUZi8i20jXBtq5YFPc01M81BIgdGcCXik=;
        b=1XsoNbpEqhTeEDcH7JxyK1q4zEs5Rwp9aoUuhagED0iCyc41POI1c/VVIoc67o9OjE
         a3Jb3Siz5tq48y7cWLCSTOm33rfApdoNOrKkwEdQt0YnzYm9fi3qMnjHZ3BYKCT02QiX
         0VphxMM7zC+tWpB5PSY6bUR2xGMZqvPoif6p5qHIecAcllv23Hk710cDnh+RoL9WJ6eP
         t+IXCXBHlMZdWEcUZsCJCGvilm+OZYcCTYYD44m6NbH0DXuOHl+1cMO9wrTg+OW7f3cW
         hIjacaScsm+ZUwPQ70PCCQD2ycyzWsb2o1ZH9gcOP0dFIhTmI7U4y3yVboLv2Dnp+c23
         16ew==
Content-Disposition: inline
In-Reply-To: <YIgjE6CgU4nDsJiR-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 27, 2021 at 10:43:31AM -0400, Tejun Heo wrote:
> Hello,
>=20
> On Mon, Apr 26, 2021 at 02:59:45PM +0800, Abel Wu wrote:
> > When a NUMA node is assigned to numa-service, the workload
> > on that node needs to be moved away fast and complete. The
> > main aspects we cared about on the eviction are as follows:
> >=20
> > a) it should complete soon enough so that numa-services
> >    won=E2=80=99t wait too long to hurt user experience
> > b) the workloads to be evicted could have massive usage on
> >    memory, and migrating such amount of memory may lead to
> >    a sudden severe performance drop lasting tens of seconds
> >    that some certain workloads may not afford
> > c) the impact of the eviction should be limited within the
> >    source and destination nodes
> > d) cgroup interface is preferred
> >=20
> > So we come to a thought that:
> >=20
> > 1) fire up numa-services without waiting for memory migration
> > 2) memory migration can be done asynchronously by using spare
> >    memory bandwidth
> >=20
> > AutoNUMA seems to be a solution, but its scope is global which
> > violates c&d. And cpuset.memory_migrate performs in a synchronous
>=20
> I don't think d) in itself is a valid requirement. How does it violate c)?
>=20
> > fashion which breaks a&b. So a mixture of them, the new cgroup2
> > interface cpuset.mems.migration, is introduced.
> >=20
> > The new cpuset.mems.migration supports three modes:
> >=20
> >  - "none" mode, meaning migration disabled
> >  - "sync" mode, which is exactly the same as the cgroup v1
> >    interface cpuset.memory_migrate
> >  - "lazy" mode, when walking through all the pages, unlike
> >    cpuset.memory_migrate, it only sets pages to protnone,
> >    and numa faults triggered by later touch will handle the
> >    movement.
>=20
> cpuset is already involved in NUMA allocation but it always felt like
> something bolted on - it's weird to have cpu to NUMA node settings at glo=
bal
> level and then to have possibly conflicting direct NUMA configuration via
> cpuset. My preference would be putting as much configuration as possible =
on
> the mm / autonuma side and let cpuset's node confinements further restrict
> their operations rather than cpuset having its own set of policy
> configurations.
>=20
> Johannes, what are your thoughts?

This is basically a cgroup interface for the existing MPOL_MF_LAZY /
MPOL_F_MOF flags, which are per task (set_mempolicy()) and per-vma
(mbind()) scope respectively. They're not per-node, so cannot be
cgroupified through cpuset's node restrictions alone, and I understand
why a cgroup interface could be convenient.

On the other hand, this is not really about configuring a shared
resource. Rather it's using cgroups to set an arbitrary task parameter
on a bunch of tasks simultaneously. It's the SIMD type usecase of
cgroup1 that we tried to get away from in cgroup2, simply because it's
so unbounded in scope. There are *a lot* of possible task parameters,
and we could add a lot of kernel interfaces that boil down to
css_task_iter and setting or clearing a task flag.

So I'm also thinking this cgroup interface isn't desirable.

If you want to control numa policies of tasks from the outside, it's
probably best to extend the numa syscall interface to work on pids.
And then use cgroup.procs to cgroupify the operation from userspace.

Or extend the NUMA interface to make the system-wide default behavior
configurable, so that you can set MPOL_F_MOF in there (without having
to enable autonuma).

But yeah, cgroups doesn't seem like the right place to do this.

Thanks
