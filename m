From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Mon, 5 Jun 2023 08:03:42 -1000
Message-ID: <ZH4jfmypOXGJPu0D@slm.duckdns.org>
References: <46d26abf-a725-b924-47fa-4419b20bbc02@redhat.com>
 <jqkf7jkuyxqiupmxmdbmpnbpojub2pjsz3oogwncmwqdghlsgk@phsqzirmmlyl>
 <f2bd7b1e-190e-1d08-f085-b4cae36fb5be@redhat.com>
 <ZFGOTHQj3k5rzmyR@blackbook>
 <deb7b684-3d7c-b3ae-7b36-5b7ba2dd8001@redhat.com>
 <ZFUo5IYAIwTEKR4_@slm.duckdns.org>
 <759603dd-7538-54ad-e63d-bb827b618ae3@redhat.com>
 <405b2805-538c-790b-5bf8-e90d3660f116@redhat.com>
 <ZGvHUjOCjwat91Gq@slm.duckdns.org>
 <18793f4a-fd39-2e71-0b77-856afb01547b@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685988224; x=1688580224;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y7uQ8QjbEIiqKEh+gAYz/364Mw8hqnIeWQ0ws9py8v4=;
        b=ZZUUkU1id25XUT7xzdMGrfSeQBz12c6CsXPYvy99BkUDyNpTI8Nk3dtBpa6o0bB3Ye
         T1BzhXQbKlgXLWz0ONNcVvg9J2srMSm979nKkowd2Tdai2MxNYcR4Xv/Fd+gNnGWEcBj
         +tdGktnKGB7IHV4jcDkT+7h+8GuTAnS8BZ/YTER7GeCghLjr31+D8KWBUIX77NMsFRXr
         vmNig4VJKob0X9z1WU80jFxOmYtnYoopLn04QN6/gnTovH9KHRNJkTn++D1D+7SFcD3w
         qwL1PMsm3g0eokamoTOQwHPmREB1nQ9b/UD+TnHhjVjUblG4u0o9R3NUrwLkSZcNYgTD
         VHpQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <18793f4a-fd39-2e71-0b77-856afb01547b@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman@redhat.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

Hello, Waiman.

On Sun, May 28, 2023 at 05:18:50PM -0400, Waiman Long wrote:
> On 5/22/23 15:49, Tejun Heo wrote:
> Sorry for the late reply as I had been off for almost 2 weeks due to PTO.

And me too. Just moved.

> > Why is the syntax different from .cpus? Wouldn't it be better to keep t=
hem
> > the same?
>=20
> Unlike cpuset.cpus, cpuset.cpus.reserve is supposed to contains CPUs that
> are used in multiple partitions. Also automatic reservation of adjacent
> partitions can happen in parallel. That is why I think it will be safer if

Ah, I see, this is because cpu.reserve is only in the root cgroup, so you
can't say that the knob is owned by the parent cgroup and thus access is
controlled that way.

...
> > >  =A0=A0 =A0There are two types of partitions - adjacent and remote.=
=A0 The
> > >  =A0=A0 =A0parent of an adjacent partition must be a valid partition =
root.
> > >  =A0=A0 =A0Partition roots of adjacent partitions are all clustered a=
round
> > >  =A0=A0 =A0the root cgroup.=A0 Creation of adjacent partition is done=
 by
> > >  =A0=A0 =A0writing the desired partition type into "cpuset.cpus.parti=
tion".
> > >=20
> > >  =A0=A0 =A0A remote partition does not require a partition root paren=
t.
> > >  =A0=A0 =A0So a remote partition can be formed far from the root cgro=
up.
> > >  =A0=A0 =A0However, its creation is a 2-step process.=A0 The CPUs nee=
ded
> > >  =A0=A0 =A0by a remote partition ("cpuset.cpus" of the partition root)
> > >  =A0=A0 =A0has to be written into "cpuset.cpus.reserve" of the root
> > >  =A0=A0 =A0cgroup first.=A0 After that, "isolated" can be written into
> > >  =A0=A0 =A0"cpuset.cpus.partition" of the partition root to form a re=
mote
> > >  =A0=A0 =A0isolated partition which is the only supported remote part=
ition
> > >  =A0=A0 =A0type for now.
> > >=20
> > >  =A0=A0 =A0All remote partitions are terminal as adjacent partition c=
annot
> > >  =A0=A0 =A0be created underneath it.
> >
> > Can you elaborate this extra restriction a bit further?
>=20
> Are you referring to the fact that only remote isolated partitions are
> supported? I do not preclude the support of load balancing remote
> partitions. I keep it to isolated partitions for now for ease of
> implementation and I am not currently aware of a use case where such a
> remote partition type is needed.
>
> If you are talking about remote partition being terminal. It is mainly
> because it can be more tricky to support hierarchical adjacent partitions
> underneath it especially if it is not isolated. We can certainly support =
it
> if a use case arises. I just don't want to implement code that nobody is
> really going to use.
>=20
> BTW, with the current way the remote partition is created, it is not
> possible to have another remote partition underneath it.

The fact that the control is spread across a root-only file and per-cgroup
file seems hacky to me. e.g. How would it interact with namespacing? Are
there reasons why this can't be properly hierarchical other than the amount
of work needed? For example:

  cpuset.cpus.exclusive is a per-cgroup file and represents the mask of CPUs
  that the cgroup holds exclusively. The mask is always a subset of
  cpuset.cpus. The parent loses access to a CPU when the CPU is given to a
  child by setting the CPU in the child's cpus.exclusive and the CPU can't
  be given to more than one child. IOW, exclusive CPUs are available only to
  the leaf cgroups that have them set in their .exclusive file.

  When a cgroup is turned into a partition, its cpuset.cpus and
  cpuset.cpus.exclusive should be the same. For backward compatibility, if
  the cgroup's parent is already a partition, cpuset will automatically
  attempt to add all cpus in cpuset.cpus into cpuset.cpus.exclusive.

I could well be missing something important but I'd really like to see
something like the above where the reservation feature blends in with the
rest of cpuset.

Thanks.

--=20
tejun
