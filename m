From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [RFC 0/5] kernel: Introduce CPU Namespace
Date: Mon, 11 Oct 2021 16:17:37 +0200
Message-ID: <20211011141737.GA58758@blackbody.suse.cz>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
 <20211011101124.d5mm7skqfhe5g35h@wittgenstein>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633961859; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kDLAV9SFvv6vvtysZB9q0KJpBPqNcjMVD5EZZnKETRs=;
        b=pRmZ6LUSpykrXlML92cDxnZ8PEAkK1C0LwRxg2CWpfUisB/+GnN7aBbb0rDkdjhwzWL1dZ
        z+AMaJzy8s/EzxpI/hZq9Fa+gnd03qTH0XVHintHLUI9p24dgjs4O881erPy+qWYiGkiKl
        Kp/0fvtZPRYL7/bt2hVfXi5fhaKtYi0=
Content-Disposition: inline
In-Reply-To: <20211011101124.d5mm7skqfhe5g35h@wittgenstein>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: "Pratik R. Sampat" <psampat@linux.ibm.com>, bristot@redhat.com, christian@brauner.io, ebiederm@xmission.com, lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, juri.lelli@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, containers@lists.linux.dev, containers@lists.linux-foundation.org, pratik.r.sampat@gmail.com

On Mon, Oct 11, 2021 at 12:11:24PM +0200, Christian Brauner <christian.brau=
ner@ubuntu.com> wrote:
> Fundamentally I think making this a new namespace is not the correct
> approach.

I tend to agree.=20

Also, generally, this is not only problem of cpuset but some other
controllers well (the original letter mentions CPU bandwidth limits, another
thing are memory limits (and I wonder whether some apps already adjust their
behavior to available IO characteristics)).

The problem as I see it is the mapping from a real dedicated HW to a
cgroup restricted environment ("container"), which can be shared. In
this instance, the virtualized view would not be able to represent a
situation when a CPU is assigned non-exclusively to multiple cpusets.

(Although, one speciality of the CPU namespace approach here is the
remapping/scrambling of the CPU topology. Not sure if good or bad.)

> I think that either we need to come up with new non-syscall based
> interfaces that allow to query virtualized cpu information and buy into
> the process of teaching userspace about them. This is even independent
> of containers.

For the reason above, I also agree with this. And I think this interface
(mostly) exists -- the userspace could query the cgroup files
(cpuset.cpus.effective in this case), they would even have the liberty
to decide between querying available resources in their "container"
(root cgroup (cgroup NS)) or further subdivision of that (the
immediately encompassing cgroup).


On Sat, Oct 09, 2021 at 08:42:38PM +0530, "Pratik R. Sampat" <psampat@linux=
.ibm.com> wrote:
> Existing solutions to the problem include userspace tools like LXCFS
> which can fake the sysfs information by mounting onto the sysfs online
> file to be in coherence with the limits set through cgroup cpuset.
> However, LXCFS is an external solution and needs to be explicitly setup
> for applications that require it. Another concern is also that tools
> like LXCFS don't handle all the other display mechanism like procfs load
> stats.
>
> Therefore, the need of a clean interface could be advocated for.

I'd like to write something in support of your approach but I'm afraid that=
 the
problem of the mapping (dedicated vs shared) makes this most suitable for s=
ome
external/separate entity such as the LCXFS already.

My .02=E2=82=AC,
Michal

