From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: kernfs memcg accounting
Date: Fri, 6 May 2022 11:37:40 +0300
Message-ID: <1aa4cd22-fcb6-0e8d-a1c6-23661d618864@openvz.org>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
 <20220427140153.GC9823@blackbody.suse.cz>
 <7509fa9f-9d15-2f29-cb2f-ac0e8d99a948@openvz.org>
 <YnBLge4ZQNbbxufc@blackbook>
 <52a9f35b-458b-44c4-7fc8-d05c8db0c73f@openvz.org>
 <20220504141001.GA10890@blackbody.suse.cz>
 <65244222-02c5-6e8d-7f4b-83651f378ce2@openvz.org>
 <20220505094704.GB10890@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aBTMT471I9stUbpF2UehdHUpsXmRCKk3eSoYzUSJuAk=;
        b=CzymT0keOAYq12hGiC9tdUPQ+0cbAR90o88Qaqegg+N9B43VyAFIxespm3LzMUVyio
         buGgFfOdndcJv+JlqyjTo6csz3qIr8IrXGbque9gxX6eB/WwKvysxFqnIsSJ3+n1txdw
         oqttcvlX/H50Jy+OQp2sk9DjEjxmPYusG9gOF+uwE74MXlduAS5Uh0GNTguObFy+l+M7
         Rw3tdHe2g/k5IljLNqdhHU90r92CBV7/v5jJa6X0G5EM4agu91pZoDdGy9R9bQKawB+f
         dKCYNoJyk+PeBe6AmMQ+3xnKwiddLgAQaCUCZUYf+duZb7t5B+m2+ubZ1xnHvsUjLAZT
         iMqw==
Content-Language: en-US
In-Reply-To: <20220505094704.GB10890-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 5/5/22 12:47, Michal Koutn=C3=BD wrote:
> On Thu, May 05, 2022 at 12:16:12AM +0300, Vasily Averin <vvs-GEFAQzZX7r8d=
nm+yROfE0A@public.gmane.org> wrote:
>> I think it should allocate at least 2 pages.
>=20
> After decoding kmalloc_type(), I agree this falls into a global
> (unaccouted) kmalloc_cache.
>=20
>> However if cgroup_mkdir() calls mem_cgroup_alloc() it correctly account =
huge percpu
>> allocations but ignores neighbour multipage allocation.
>=20
> So, the spillover is bound and proportional to memcg limit (same ration
> like these two sizes).
> But it may be better to account it properly, especially if it's
> contribution form an offlined mem_cgroup.

I've traced mkdir /sys/fs/cgroup/vvs.test on 4cpu VM with Fedora=20
and self-complied upstream kernel, see table with results below.
These calculations are not precise, it depends on kernel config options,
number of cpus, enabled controllers, ignores possible page allocations etc
However I think this is enough to clarify the general situation.

Results:
- Total sum of accounted memory is ~60Kb.
- Accounted only 2 huge percpu allocation marked '=3D', ~18Kb.
  (and can be 0 without memory controller)
- kernfs nodes and iattrs are among the main memory consumers.
   they are marked '++' to be accounted first
- cgroup_mkdir always allocates 4Kb,
   so I think it should be accounted first too.
- mem_cgroup_css_alloc allocations consumes 10K,
   it's enough to be accounted, especially for VMs with 1-2 CPUs
- Almost all other allocations are quite small and can be ignored.
  Exceptions are percpu allocations in alloc_fair_sched_group(),
   this can consume a significant amount of memory on nodes
   with multiple processors.
   marked by '+', can be accounted later.
- kernfs nodes consumes ~6Kb memory inside simple_xattr_set()=20
   and simple_xattr_alloc(). This is quite high numbers,
   but is not critical, and I think we can ignore it at the moment.
- If all proposed memory will be accounted it gives us ~47Kb,=20
   or ~75% of all allocated memory.

Any comments are welcome.

Thank you,
	Vasily Averin

number	bytes	$1*$2	sum	note	call_site
of	alloc
allocs
------------------------------------------------------------
1       14448   14448   14448   =3D       percpu_alloc_percpu:
1       8192    8192    22640   ++      (mem_cgroup_css_alloc+0x54)
49      128     6272    28912   ++      (__kernfs_new_node+0x4e)
49      96      4704    33616   ?       (simple_xattr_alloc+0x2c)
49      88      4312    37928   ++      (__kernfs_iattrs+0x56)
1       4096    4096    42024   ++      (cgroup_mkdir+0xc7)
1       3840    3840    45864   =3D       percpu_alloc_percpu:
4       512     2048    47912   +       (alloc_fair_sched_group+0x166)
4       512     2048    49960   +       (alloc_fair_sched_group+0x139)
1       2048    2048    52008   ++      (mem_cgroup_css_alloc+0x109)
49      32      1568    53576   ?       (simple_xattr_set+0x5b)
2       584     1168    54744           (radix_tree_node_alloc.constprop.0+=
0x8d)
1       1024    1024    55768           (cpuset_css_alloc+0x30)
1       1024    1024    56792           (alloc_shrinker_info+0x79)
1       768     768     57560           percpu_alloc_percpu:
1       640     640     58200           (sched_create_group+0x1c)
33      16      528     58728           (__kernfs_new_node+0x31)
1       512     512     59240           (pids_css_alloc+0x1b)
1       512     512     59752           (blkcg_css_alloc+0x39)
9       48      432     60184           percpu_alloc_percpu:
13      32      416     60600           (__kernfs_new_node+0x31)
1       384     384     60984           percpu_alloc_percpu:
1       256     256     61240           (perf_cgroup_css_alloc+0x1c)
1       192     192     61432           percpu_alloc_percpu:
1       64      64      61496           (mem_cgroup_css_alloc+0x363)
1       32      32      61528           (ioprio_alloc_cpd+0x39)
1       32      32      61560           (ioc_cpd_alloc+0x39)
1       32      32      61592           (blkcg_css_alloc+0x6b)
1       32      32      61624           (alloc_fair_sched_group+0x52)
1       32      32      61656           (alloc_fair_sched_group+0x2e)
3       8       24      61680           (__kernfs_new_node+0x31)
3       8       24      61704           (alloc_cpumask_var_node+0x1b)
1       24      24      61728           percpu_alloc_percpu:
