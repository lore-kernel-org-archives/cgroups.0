From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: update parent subparts cpumask while
 holding css refcnt
Date: Wed, 12 Jul 2023 09:56:56 +0800
Message-ID: <7233195b-63bc-ff1a-3b14-6eca0db7cc25@huawei.com>
References: <20230701065049.1758266-1-linmiaohe@huawei.com>
 <fbabnjfly5w6fxrhe3eu6ebspngz2hd3tqs6rrbropcdvylnhs@ayjdpq73kwui>
 <74f1906e-fe58-c745-a851-b160374f7acf@redhat.com>
 <30b1f809-a11b-efe8-289c-04a801f20207@huawei.com>
 <tebnrmbl6ouz567vlalojcynk25siwwom7et7yn2vvi6zyv6nv@jj3r5o3kl52j>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <tebnrmbl6ouz567vlalojcynk25siwwom7et7yn2vvi6zyv6nv@jj3r5o3kl52j>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2023/7/11 19:52, Michal Koutn=FD wrote:
> On Tue, Jul 11, 2023 at 10:52:02AM +0800, Miaohe Lin <linmiaohe-hv44wF8Li=
93QT0dZR+AlfA@public.gmane.org> wrote:
>> commit 2bdfd2825c9662463371e6691b1a794e97fa36b4
>> Author: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Date:   Wed Feb 2 22:31:03 2022 -0500
>>
>>     cgroup/cpuset: Fix "suspicious RCU usage" lockdep warning
>=20
> Aha, thanks for the pointer.
>=20
> I've also found a paragraph in [1]:
>> In addition, the -rt patchset turns spinlocks into a sleeping locks so
>> that the corresponding critical sections can be preempted, which also
>> means that these sleeplockified spinlocks (but not other sleeping
>> locks!) may be acquire within -rt-Linux-kernel RCU read-side critical
>> sections.
>=20
> That suggests (together with practical use) that dicussed spinlocks
> should be fine in RCU read section. And the possible reason is deeper in
> generate_sched_domains() that do kmalloc(..., GFP_KERNEL).

update_parent_subparts_cpumask() would call update_flag() that do kmemdup(.=
.., GFP_KERNEL)?

>=20
> Alas update_cpumask_hier() still calls generate_sched_domains(), OTOH,
> update_parent_subparts_cpumask() doesn't seem so.

It seems update_parent_subparts_cpumask() doesn't call generate_sched_domai=
ns().

>=20
> The idea to not relieve rcu_read_lock() in update_cpumask() iteration
> (instead of the technically unneeded refcnt bump) would have to be
> verified with CONFIG_PROVE_RCU && CONFIG_LOCKDEP. WDYT?

The idea to relieve rcu_read_lock() in update_cpumask() iteration was initi=
ally introduced
via the below commit:

commit d7c8142d5a5534c3c7de214e35a40a493a32b98e
Author: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Thu Sep 1 16:57:43 2022 -0400

    cgroup/cpuset: Make partition invalid if cpumask change violates exclus=
ivity rule

    Currently, changes in "cpust.cpus" of a partition root is not allowed if
    it violates the sibling cpu exclusivity rule when the check is done
    in the validate_change() function. That is inconsistent with the
    other cpuset changes that are always allowed but may make a partition
    invalid.

    Update the cpuset code to allow cpumask change even if it violates the
    sibling cpu exclusivity rule, but invalidate the partition instead
    just like the other changes. However, other sibling partitions with
    conflicting cpumask will also be invalidated in order to not violating
    the exclusivity rule. This behavior is specific to this partition
    rule violation.

    Note that a previous commit has made sibling cpu exclusivity rule check
    the last check of validate_change(). So if -EINVAL is returned, we can
    be sure that sibling cpu exclusivity rule violation is the only rule
    that is broken.

It would be really helpful if @Waiman can figure this out.

Thanks both.

