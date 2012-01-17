From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcg: hierarchical soft limit reclaim
Date: Tue, 17 Jan 2012 12:25:31 -0800
Message-ID: <CALWz4iwYpkP6Dfz+3NFXQK9ToaKdm8WCsbBmHRLVwRjVp0wjOQ@mail.gmail.com>
References: <1326207772-16762-1-git-send-email-hannes@cmpxchg.org>
	<1326207772-16762-3-git-send-email-hannes@cmpxchg.org>
	<CALWz4izwNBN_qcSsqg-qYw-Esc9vBL3=4cv3Wsg1jf6001_fWQ@mail.gmail.com>
	<20120112085904.GG24386@cmpxchg.org>
	<CALWz4iz3sQX+pCr19rE3_SwV+pRFhDJ7Lq-uJuYBq6u3mRU3AQ@mail.gmail.com>
	<20120113224424.GC1653@cmpxchg.org>
	<4F158418.2090509@gmail.com>
	<20120117145348.GA3144@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:x-system-of-record:content-type:content-transfer-encoding;
        bh=ehd0yCOk4iUtnIibYW09aOC+zROO1ti1c5j2rCEItB8=;
        b=Pg5Ad4TzsJMH0+oVNVFJEdU8Q3CzwvukVqIS9piPzWLKdgmsO41xqTwwnE/WUpeZy2
         40Ppb+cXEr7SDQofKzVOPRQFeWQlI2Vy8ZzypkTn7Oq52lx9wZX+dl9F3NQpIr/qykg4
         +fikucbhmbe/KPYv5fDwhhi6CidZLx37xWers=
In-Reply-To: <20120117145348.GA3144-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Sha <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 17, 2012 at 6:53 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> w=
rote:
> On Tue, Jan 17, 2012 at 10:22:16PM +0800, Sha wrote:
>> On 01/14/2012 06:44 AM, Johannes Weiner wrote:
>> >On Fri, Jan 13, 2012 at 01:31:16PM -0800, Ying Han wrote:
>> >>On Thu, Jan 12, 2012 at 12:59 AM, Johannes Weiner<hannes@cmpxchg.o=
rg> =A0wrote:
>> >>>On Wed, Jan 11, 2012 at 01:42:31PM -0800, Ying Han wrote:
>> >>>>On Tue, Jan 10, 2012 at 7:02 AM, Johannes Weiner<hannes@cmpxchg.=
org> =A0wrote:
>> >>>>>@@ -1318,6 +1123,36 @@ static unsigned long mem_cgroup_margin(s=
truct mem_cgroup *memcg)
>> >>>>> =A0 =A0 =A0 =A0return margin>> =A0PAGE_SHIFT;
>> >>>>> =A0}
>> >>>>>
>> >>>>>+/**
>> >>>>>+ * mem_cgroup_over_softlimit
>> >>>>>+ * @root: hierarchy root
>> >>>>>+ * @memcg: child of @root to test
>> >>>>>+ *
>> >>>>>+ * Returns %true if @memcg exceeds its own soft limit or contr=
ibutes
>> >>>>>+ * to the soft limit excess of one of its parents up to and in=
cluding
>> >>>>>+ * @root.
>> >>>>>+ */
>> >>>>>+bool mem_cgroup_over_softlimit(struct mem_cgroup *root,
>> >>>>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0st=
ruct mem_cgroup *memcg)
>> >>>>>+{
>> >>>>>+ =A0 =A0 =A0 if (mem_cgroup_disabled())
>> >>>>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
>> >>>>>+
>> >>>>>+ =A0 =A0 =A0 if (!root)
>> >>>>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 root =3D root_mem_cgroup;
>> >>>>>+
>> >>>>>+ =A0 =A0 =A0 for (; memcg; memcg =3D parent_mem_cgroup(memcg))=
 {
>> >>>>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* root_mem_cgroup does not have =
a soft limit */
>> >>>>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (memcg =3D=3D root_mem_cgroup)
>> >>>>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> >>>>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (res_counter_soft_limit_excess=
(&memcg->res))
>> >>>>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
>> >>>>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (memcg =3D=3D root)
>> >>>>>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> >>>>>+ =A0 =A0 =A0 }
>> >>>>Here it adds pressure on a cgroup if one of its parents exceeds =
soft
>> >>>>limit, although the cgroup itself is under soft limit. It does c=
hange
>> >>>>my understanding of soft limit, and might introduce regression o=
f our
>> >>>>existing use cases.
>> >>>>
>> >>>>Here is an example:
>> >>>>
>> >>>>Machine capacity 32G and we over-commit by 8G.
>> >>>>
>> >>>>root
>> >>>> =A0 -> =A0A (hard limit 20G, soft limit 15G, usage 16G)
>> >>>> =A0 =A0 =A0 =A0-> =A0A1 (soft limit 5G, usage 4G)
>> >>>> =A0 =A0 =A0 =A0-> =A0A2 (soft limit 10G, usage 12G)
>> >>>> =A0 -> =A0B (hard limit 20G, soft limit 10G, usage 16G)
>> >>>>
>> >>>>under global reclaim, we don't want to add pressure on A1 althou=
gh its
>> >>>>parent A exceeds its soft limit. Assume that if we set the soft =
limit
>> >>>>corresponding to each cgroup's working set size (hot memory), an=
d it
>> >>>>will introduce regression to A1 in that case.
>> >>>>
>> >>>>In my existing implementation, i am checking the cgroup's soft l=
imit
>> >>>>standalone w/o looking its ancestors.
>> >>>Why do you set the soft limit of A in the first place if you don'=
t
>> >>>want it to be enforced?
>> >>The soft limit should be enforced under certain condition, not alw=
ays.
>> >>The soft limit of A is set to be enforced when the parent of A and=
 B
>> >>is under memory pressure. For example:
>> >>
>> >>Machine capacity 32G and we over-commit by 8G
>> >>
>> >>root
>> >>-> =A0A (hard limit 20G, soft limit 12G, usage 20G)
>> >> =A0 =A0 =A0 =A0-> =A0A1 (soft limit 2G, usage 1G)
>> >> =A0 =A0 =A0 =A0-> =A0A2 (soft limit 10G, usage 19G)
>> >>-> =A0B (hard limit 20G, soft limit 10G, usage 0G)
>> >>
>> >>Now, A is under memory pressure since the total usage is hitting i=
ts
>> >>hard limit. Then we start hierarchical reclaim under A, and each
>> >>cgroup under A also takes consideration of soft limit. In this cas=
e,
>> >>we should only set priority =3D 0 to A2 since it contributes to A'=
s
>> >>charge as well as exceeding its own soft limit. Why punishing A1 (=
set
>> >>priority =3D 0) also which has usage under its soft limit ? I can
>> >>imagine it will introduce regression to existing environment which=
 the
>> >>soft limit is set based on the working set size of the cgroup.
>> >>
>> >>To answer the question why we set soft limit to A, it is used to
>> >>over-commit the host while sharing the resource with its sibling (=
B in
>> >>this case). If the machine is under memory contention, we would li=
ke
>> >>to push down memory to A or B depends on their usage and soft limi=
t.
>> >D'oh, I think the problem is just that we walk up the hierarchy one
>> >too many when checking whether a group exceeds a soft limit. =A0The=
 soft
>> >limit is a signal to distribute pressure that comes from above, it'=
s
>> >meaningless and should indeed be ignored on the level the pressure
>> >originates from.
>> >
>> >Say mem_cgroup_over_soft_limit(root, memcg) would check everyone up=
 to
>> >but not including root, wouldn't that do exactly what we both want?
>> >
>> >Example:
>> >
>> >1. If global memory is short, we reclaim with root=3Droot_mem_cgrou=
p.
>> > =A0 =A0A1 and A2 get soft limit reclaimed because of A's soft limi=
t
>> > =A0 =A0excess, just like the current kernel would do.
>> >
>> >2. If A hits its hard limit, we reclaim with root=3DA, so we only m=
ind
>> > =A0 =A0the soft limits of A1 and A2. =A0A1 is below its soft limit=
, all
>> > =A0 =A0good. =A0A2 is above its soft limit, gets treated according=
ly. =A0This
>> > =A0 =A0is new behaviour, the current kernel would just reclaim the=
m
>> > =A0 =A0equally.
>> >
>> >Code:
>> >
>> >bool mem_cgroup_over_soft_limit(struct mem_cgroup *root,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mem=
_cgroup *memcg)
>> >{
>> > =A0 =A0 if (mem_cgroup_disabled())
>> > =A0 =A0 =A0 =A0 =A0 =A0 return false;
>> >
>> > =A0 =A0 if (!root)
>> > =A0 =A0 =A0 =A0 =A0 =A0 root =3D root_mem_cgroup;
>> >
>> > =A0 =A0 for (; memcg; memcg =3D parent_mem_cgroup(memcg)) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 if (memcg =3D=3D root)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > =A0 =A0 =A0 =A0 =A0 =A0 if (res_counter_soft_limit_excess(&memcg->=
res))
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
>> > =A0 =A0 }
>> > =A0 =A0 return false;
>> >}
>> Hi Johannes,
>>
>> I don't think it solve the root of the problem, example:
>> root
>> -> A (hard limit 20G, soft limit 12G, usage 20G)
>> =A0 =A0 -> A1 ( soft limit 2G, =A0 usage 1G)
>> =A0 =A0 -> A2 ( soft limit 10G, usage 19G)
>> =A0 =A0 =A0 =A0 =A0 =A0->B1 (soft limit 5G, usage 4G)
>> =A0 =A0 =A0 =A0 =A0 =A0->B2 (soft limit 5G, usage 15G)
>>
>> Now A is hitting its hard limit and start hierarchical reclaim under=
 A.
>> If we choose B1 to go through mem_cgroup_over_soft_limit, it will
>> return true because its parent A2 has a large usage and will lead to
>> priority=3D0 reclaiming. But in fact it should be B2 to be punished.
>
> Because A2 is over its soft limit, the whole hierarchy below it shoul=
d
> be preferred over A1, so both B1 and B2 should be soft limit reclaime=
d
> to be consistent with behaviour at the root level.
>
>> IMHO, it may checking the cgroup's soft limit standalone without
>> looking up its ancestors just as Ying said.
>
> Again, this would be a regression as soft limits have been applied
> hierarchically forever.

If we are comparing it to the current implementation, agree that the
soft reclaim is applied hierarchically. In the example above, A2 will
be picked for soft reclaim while A is hitting its hard limit, which in
turns reclaim from B1 and B2 regardless of their soft limit setting.
However, I haven't convinced myself this is how we are gonna use the
soft limit.

The soft limit setting for each cgroup is a hit for applying pressure
under memory contention. One way of setting the soft limit is based on
the cgroup's working set size. Thus, we allow cgroup to grow above its
soft limit with cold page cache unless there is a memory pressure
comes from above. Under the hierarchical reclaim, we will exam the
soft limit and only apply extra pressure to the ones above their soft
limit. Here the same example:

root
-> A (hard limit 20G, soft limit 12G, usage 20G)
   -> A1 ( soft limit 2G,   usage 1G)
   -> A2 ( soft limit 10G, usage 19G)

          ->B1 (soft limit 5G, usage 4G)
          ->B2 (soft limit 5G, usage 15G)

If A is hitting its hard limit, we will reclaim all the children under
A hierarchically but only adding extra pressure to the ones above
their soft limits (A2, B2). Adding extra pressure to B1 will introduce
known regression based on customer expectation since the 4G usage are
hot memory.

I am not aware of how the existing soft reclaim being used, i bet
there are not a lot. If we are making changes on the current
implementation, we should also take the opportunity to think about the
initial design as well. Thoughts?

--Ying
