From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Mon, 22 May 2023 09:49:38 -1000
Message-ID: <ZGvHUjOCjwat91Gq@slm.duckdns.org>
References: <ZDmOjeBVsIcgSLIV@slm.duckdns.org>
 <60ec12dc-943c-b8f0-8b6f-97c5d332144c@redhat.com>
 <46d26abf-a725-b924-47fa-4419b20bbc02@redhat.com>
 <jqkf7jkuyxqiupmxmdbmpnbpojub2pjsz3oogwncmwqdghlsgk@phsqzirmmlyl>
 <f2bd7b1e-190e-1d08-f085-b4cae36fb5be@redhat.com>
 <ZFGOTHQj3k5rzmyR@blackbook>
 <deb7b684-3d7c-b3ae-7b36-5b7ba2dd8001@redhat.com>
 <ZFUo5IYAIwTEKR4_@slm.duckdns.org>
 <759603dd-7538-54ad-e63d-bb827b618ae3@redhat.com>
 <405b2805-538c-790b-5bf8-e90d3660f116@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684784981; x=1687376981;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ko/ib0DbbBIkYeF2ySdhWs5YudE4zxsP9MRqrw+BLoI=;
        b=BHPHExlQjMdC1v2AlWCLoTJz495eSqFbI+OF9by02n2sfozwxdUWrjSK+k5DNG+tFM
         0jXmVCZy15YjYtpqRupyHQWDzCgOMrfYB8x7fusFUnIIOy7OWv+0Ur+/tulnIG8ionbK
         5ACCwNe65d9/G8bQONpgwu7gPsz6di3IeHfd9NgbznMRGplWO/LSP66bzPAlIxFbTuhp
         l0EohHPfuCQsy8XwLElVEnFKB8GUXEZXoPVpbwGRG8kjSvspXtSzoW+59K8LbNccSI+U
         Zy8GgtoF7Ak+whIz33YDy2AXryq4EL7GgumSVCjXzPWRAWU/tu4xO1EHkrANlY42nsDJ
         T/6w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <405b2805-538c-790b-5bf8-e90d3660f116@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman@redhat.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

Hello, Waiman.

On Sun, May 07, 2023 at 09:03:44PM -0400, Waiman Long wrote:
...
> =A0 cpuset.cpus.reserve
> =A0=A0 =A0A read-write multiple values file which exists only on root
> =A0=A0 =A0cgroup.
>=20
> =A0=A0 =A0It lists all the CPUs that are reserved for adjacent and remote
> =A0=A0 =A0partitions created in the system.=A0 See the next section for
> =A0=A0 =A0more information on what an adjacent or remote partitions is.
>=20
> =A0=A0 =A0Creation of adjacent partition does not require touching this
> =A0=A0 =A0control file as CPU reservation will be done automatically.
> =A0=A0 =A0In order to create a remote partition, the CPUs needed by the
> =A0=A0 =A0remote partition has to be written to this file first.
>=20
> =A0=A0 =A0A "+" prefix can be used to indicate a list of additional
> =A0=A0 =A0CPUs that are to be added without disturbing the CPUs that are
> =A0=A0 =A0originally there.=A0 For example, if its current value is "3-4",
> =A0=A0 =A0echoing ""+5" to it will change it to "3-5".
>
> =A0=A0 =A0Once a remote partition is destroyed, its CPUs have to be
> =A0=A0 =A0removed from this file or no other process can use them.=A0 A "=
-"
> =A0=A0 =A0prefix can be used to remove a list of CPUs from it.=A0 However,
> =A0=A0 =A0removing CPUs that are currently used in existing partitions
> =A0=A0 =A0may cause those partitions to become invalid.=A0 A single "-"
> =A0=A0 =A0character without any number can be used to indicate removal
> =A0=A0 =A0of all the free CPUs not allocated to any partitions to avoid
> =A0=A0 =A0accidental partition invalidation.

Why is the syntax different from .cpus? Wouldn't it be better to keep them
the same?

> =A0 cpuset.cpus.partition
> =A0=A0 =A0A read-write single value file which exists on non-root
> =A0=A0 =A0cpuset-enabled cgroups.=A0 This flag is owned by the parent cgr=
oup
> =A0=A0 =A0and is not delegatable.
>=20
> =A0=A0 =A0It accepts only the following input values when written to.
>=20
> =A0=A0 =A0=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=A0=A0=A0 =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> =A0=A0 =A0=A0 "member"=A0=A0=A0 Non-root member of a partition
> =A0=A0 =A0=A0 "root"=A0=A0=A0 Partition root
> =A0=A0 =A0=A0 "isolated"=A0=A0=A0 Partition root without load balancing
> =A0=A0 =A0=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=A0=A0=A0 =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>=20
> =A0=A0 =A0A cpuset partition is a collection of cgroups with a partition
> =A0=A0 =A0root at the top of the hierarchy and its descendants except
> =A0=A0 =A0those that are separate partition roots themselves and their
> =A0=A0 =A0descendants.=A0 A partition has exclusive access to the set of
> =A0=A0 =A0CPUs allocated to it.=A0 Other cgroups outside of that partition
> =A0=A0 =A0cannot use any CPUs in that set.
>=20
> =A0=A0 =A0There are two types of partitions - adjacent and remote.=A0 The
> =A0=A0 =A0parent of an adjacent partition must be a valid partition root.
> =A0=A0 =A0Partition roots of adjacent partitions are all clustered around
> =A0=A0 =A0the root cgroup.=A0 Creation of adjacent partition is done by
> =A0=A0 =A0writing the desired partition type into "cpuset.cpus.partition".
>=20
> =A0=A0 =A0A remote partition does not require a partition root parent.
> =A0=A0 =A0So a remote partition can be formed far from the root cgroup.
> =A0=A0 =A0However, its creation is a 2-step process.=A0 The CPUs needed
> =A0=A0 =A0by a remote partition ("cpuset.cpus" of the partition root)
> =A0=A0 =A0has to be written into "cpuset.cpus.reserve" of the root
> =A0=A0 =A0cgroup first.=A0 After that, "isolated" can be written into
> =A0=A0 =A0"cpuset.cpus.partition" of the partition root to form a remote
> =A0=A0 =A0isolated partition which is the only supported remote partition
> =A0=A0 =A0type for now.
>=20
> =A0=A0 =A0All remote partitions are terminal as adjacent partition cannot
> =A0=A0 =A0be created underneath it.

Can you elaborate this extra restriction a bit further?

In general, I think it'd be really helpful if the document explains the
reasoning behind the design decisions. ie. Why is reserving for? What
purpose does it serve that the regular isolated ones cannot? That'd help
clarifying the design decisions.

Thanks.

--=20
tejun
