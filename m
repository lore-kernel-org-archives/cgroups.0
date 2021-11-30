From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Tue, 30 Nov 2021 07:11:56 -1000
Message-ID: <YaZbXArNIMNvwJD/@slm.duckdns.org>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211018143619.205065-6-longman@redhat.com>
 <20211115193122.GA16798@blackbody.suse.cz>
 <8f68692b-bd8f-33fd-44ae-f6f83bf2dc00@redhat.com>
 <20211116175411.GA50019@blackbody.suse.cz>
 <293d7abf-aff6-fcd8-c999-b1dbda1cffb8@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ONrE5/Qkw4zkh7Cw4Mc/Cvd1DgPGRMMe+Dlw1qGvx2E=;
        b=lpdHoZHC+hlX1FXzDNnODOfKuB01wlK9cDytInDrRCRM5d3sfeu8SIa+VNjEXczz0j
         Kdgx0UH7nlKa7P1zxooslo/0wQ4o1ukUWRAmG10vy3ESoetmfvl4p9HWMi92xbZeMYnT
         vIjw4wdIX/HCptVJCo7lF9oiI6NfKd3Z/DYQ3MhttwzjqKTuI2BPOHDJKcdkm1NrwGv1
         9W11Fc3bo1OurBtgoGvBJyIPAN3+88Kq+f1R9BOP/tMQoNN3CZxklVpF3NSAtICcQk9x
         /63gjcPTtrTdoyUBcKAhQ4nclxtO+zT/Fg4ZsEmIrvKlTZSWFFeMRbrVwEJzbojAZnF1
         N7kQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <293d7abf-aff6-fcd8-c999-b1dbda1cffb8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Waiman.

On Tue, Nov 30, 2021 at 10:35:19AM -0500, Waiman Long wrote:
> =A0=A0 =A0On read, the "cpuset.cpus.partition" file can show the following
> =A0=A0 =A0values.
>=20
> =A0=A0 =A0=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=A0=A0=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =A0=A0 =A0=A0 "member"=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Non-root member of a =
partition
> =A0=A0 =A0=A0 "root"=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Partition root
> =A0=A0 =A0=A0 "isolated"=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 Partition root with=
out load balancing
> =A0=A0 =A0=A0 "root invalid (<reason>)"=A0=A0=A0 Invalid partition root
> =A0=A0 =A0=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=A0=A0=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

What happens if an isolated domain becomes invalid and then valid again due
to cpu hotplug? Does it go "root invalid" and then back to "isolated"?

...
> =A0=A0 =A0Before the "member" to partition root transition can happen,
> =A0=A0 =A0the following conditions must be met or the transition will
> =A0=A0 =A0not be allowed.
>=20
> =A0=A0 =A01) The "cpuset.cpus" is non-empty and exclusive, i.e. they are
> =A0=A0 =A0=A0=A0 not shared by any of its siblings.
> =A0=A0 =A02) The parent cgroup is a valid partition root.
> =A0=A0 =A03) The "cpuset.cpus" is a subset of parent's "cpuset.cpus".
> =A0=A0 =A04) There is no child cgroups with cpuset enabled.=A0 This avoids
> =A0=A0 =A0=A0=A0 cpu migrations of multiple cgroups simultaneously which =
can
> =A0=A0 =A0=A0=A0 be problematic.

So, I still have a hard time justifying the above restrictions. 1) can be
broken through hotplug anyway. 2) can be broken by the parent switching to
member. 3) would mean that we'd need to restrict parent's config changes
depending on what children are doing. 4) is more understandable but it's an
implementation detail that we can address in the future.

> =A0=A0 =A0Once becoming a partition root, the following two rules restrict
> =A0=A0 =A0what changes can be made to "cpuset.cpus".
>=20
> =A0=A0 =A01) The value must be exclusive.
> =A0=A0 =A02) If child cpusets exist, the value must be a superset of what
> =A0=A0 =A0=A0=A0 are defined in the child cpusets.
>
> =A0=A0 =A0The second rule applies even for "member". Other changes to
> =A0=A0 =A0"cpuset.cpus" that do not violate the above rules are always
> =A0=A0 =A0allowed.

While it isn't necessarily tied to this series, it's a big no-no to restrict
what a parent can do depending on what its descendants are doing. A cgroup
higher up in the hierarchy should be able to change configuration however it
sees fit as deligation breaks down otherwise.

Maybe you can argue that cpuset is special and shouldn't be subject to such
convention but I can't see strong enough justifications especially given
that most of these restrictions can be broken by hotplug operations anyway
and thus need code to handle those situations.

> =A0=A0 =A0Changing a partition root (valid or invalid) to "member" is
> =A0=A0 =A0always allowed.=A0 If there are child partition roots underneath
> =A0=A0 =A0it, however, they will be forced to be switched back to "member"
> =A0=A0 =A0too and lose their partitions. So care must be taken to double
> =A0=A0 =A0check for this condition before disabling a partition root.

Wouldn't it make more sense for them to retain their configuration and turn
invalid? Why is this special?

> =A0=A0 =A0A valid parent partition may distribute out all its CPUs to
> =A0=A0 =A0its child partitions as long as it is not the root cgroup and
> =A0=A0 =A0there is no task associated with it.

A valid parent partition which isn't root never has tasks in them to begin
with.

> =A0=A0 =A0An invalid partition root can be reverted back to a valid one
> =A0=A0 =A0if none of the validity constraints of a valid partition root
> =A0=A0 =A0are violated.
>=20
> =A0=A0 =A0Poll and inotify events are triggered whenever the state of
> =A0=A0 =A0"cpuset.cpus.partition" changes.=A0 That includes changes cause=
d by
> =A0=A0 =A0write to "cpuset.cpus.partition", cpu hotplug and other changes
> =A0=A0 =A0that make the partition invalid.=A0 This will allow user space
> =A0=A0 =A0agents to monitor unexpected changes to "cpuset.cpus.partition"
> =A0=A0 =A0without the need to do continuous polling.

Unfortunately, my sense is still that both the restrictions and behaviors
are pretty arbitrary. I can somewhat see how the restrictions may make sense
in a specific frame of mind but am having a hard time finding strong enough
justifications for them. There are many really specific rules and it isn't
clear why they are the way they are.

Thanks.

--=20
tejun
