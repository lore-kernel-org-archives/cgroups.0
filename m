From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 0/5] kernel: Introduce CPU Namespace
Date: Mon, 11 Oct 2021 07:42:27 -1000
Message-ID: <YWR3g+ZE2j3w1Npz@slm.duckdns.org>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
 <20211011101124.d5mm7skqfhe5g35h@wittgenstein>
 <20211011141737.GA58758@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cv+8p4QBr+yumNO08E52pdNZjmudW0YvW+eKFeVXzNw=;
        b=X2Ln10Tg4qFyX1S7WwFgytlT9WmcLpxGM4Zit5dEo/o+1WnWYfpNX3gNqY4uzNIAN6
         Ntyju7CQJyfW85aoc0hfLy+G7n+1MefYEgfBKmm0h1ZuvROPAUWv3EVbcTtD4vcfc+pg
         XrIwgPiXVy1qkK/HWnDaeiKTRSPRwPmqGK278qGMcqunMoECVG4wY8sKczSXTrp5P7dG
         p8gHyjLlv03q7Um00Npt36ae6F98ErTGhZoMrEuwsh+yY3MijosVvecksUfE/jMtXzxj
         vkO9BV7RzVaMhR3xGwb8bNFnp3uyzr8dBPSYQ+ONNzOqyFNGGEhOqfefekQeLs1fMCxj
         +bCA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211011141737.GA58758@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, "Pratik R. Sampat" <psampat@linux.ibm.com>, bristot@redhat.com, christian@brauner.io, ebiederm@xmission.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, mingo@kernel.org, juri.lelli@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, containers@lists.linux.dev, containers@lists.linux-foundation.org, pratik.r.sampat@gmail.com

Hello,

On Mon, Oct 11, 2021 at 04:17:37PM +0200, Michal Koutn=FD wrote:
> The problem as I see it is the mapping from a real dedicated HW to a
> cgroup restricted environment ("container"), which can be shared. In
> this instance, the virtualized view would not be able to represent a
> situation when a CPU is assigned non-exclusively to multiple cpusets.

There is a fundamental problem with trying to represent a resource shared
environment controlled with cgroup using system-wide interfaces including
procfs because the goal of many cgroup resource control includes
work-conservation, which also is one of the main reason why containers are
more attractive in resource-intense deployments. System-level interfaces
naturally describe a discrete system, which can't express the dynamic
distribution with cgroups.

There are aspects of cgroups which are akin to hard partitioning and thus
can be represented by diddling with system level interfaces. Whether those
are worthwhile to pursuit depends on how easy and useful they are; however,
there's no avoiding that each of those is gonna be a very partial and
fragmented thing, which significantly contributes the default cons list of
such attempts.

> > Existing solutions to the problem include userspace tools like LXCFS
> > which can fake the sysfs information by mounting onto the sysfs online
> > file to be in coherence with the limits set through cgroup cpuset.
> > However, LXCFS is an external solution and needs to be explicitly setup
> > for applications that require it. Another concern is also that tools
> > like LXCFS don't handle all the other display mechanism like procfs load
> > stats.
> >
> > Therefore, the need of a clean interface could be advocated for.
>=20
> I'd like to write something in support of your approach but I'm afraid th=
at the
> problem of the mapping (dedicated vs shared) makes this most suitable for=
 some
> external/separate entity such as the LCXFS already.

This is more of a unit problem than an interface one - ie. the existing
numbers in the system interface doesn't really fit what needs to be
described.

One approach that we've found useful in practice is dynamically changing
resource consumption based on shortage, as measured by PSI, rather than some
number representing what's available. e.g. for a build service, building a
feedback loop which monitors its own cpu, memory and io pressures and
modulates the number of concurrent jobs.

There are some numbers which would be fundamentlaly useful - e.g. ballpark
number of threads needed to saturate the computing capacity available to the
cgroup, or ballpark bytes of memory available without noticeable contention.
Those, I think we definitely need to work on, but I don't see much point in
trying to bend existing /proc numbers for them.

Thanks.

--=20
tejun
