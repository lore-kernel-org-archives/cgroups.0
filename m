From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: kernfs memcg accounting
Date: Thu, 5 May 2022 00:16:12 +0300
Message-ID: <65244222-02c5-6e8d-7f4b-83651f378ce2@openvz.org>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
 <20220427140153.GC9823@blackbody.suse.cz>
 <7509fa9f-9d15-2f29-cb2f-ac0e8d99a948@openvz.org>
 <YnBLge4ZQNbbxufc@blackbook>
 <52a9f35b-458b-44c4-7fc8-d05c8db0c73f@openvz.org>
 <20220504141001.GA10890@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tdFt0uQlPJ4mzIwCT11tWacBOCFR/O+DCJD9m2elhvY=;
        b=4BtgJE6tIVi5spqKRy2safmJJvFhDwqig/gu8SOgJVMNlQoN7e6oyggAGtbh0Ai3u+
         mR+n9pawKCECW0w4KaZIWSRlsLDNrXNLicQze8WR7YOF14HoGfcdcRrLoH9tjDGrbzFy
         WDWbyL2Nu4xZje0kDJ17xDqguvfoDCMUQSyM3hLgoAUlMcGEsTF7qPjnbhKhdYfxmucs
         wHUTkWv/1+fU/qFlF5OKiFmii/NXaHWgs3XvRrl4Eifnz5ATici85iWc4YhEkszOJAxc
         Bha+LOrKUOvCCgZ0Q3zYOFb0L/mULFRJtIuA6ZizjW+wmIlKvPAcW/NJrfdYapYD95QF
         c2mg==
Content-Language: en-US
In-Reply-To: <20220504141001.GA10890-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 5/4/22 17:10, Michal Koutn=C3=BD wrote:
> On Wed, May 04, 2022 at 12:00:18PM +0300, Vasily Averin <vvs-GEFAQzZX7r8d=
nm+yROfE0A@public.gmane.org> wrote:
>> As far as I understand, Roman chose the parent memcg because it was a sp=
ecial
>> case of creating a new memory group. He temporally changed active memcg
>> in mem_cgroup_css_alloc() and properly accounted all required memcg-spec=
ific
>> allocations.
>=20
>> However, he ignored accounting for a rather large struct mem_cgroup
>> therefore I think we can do not worry about 128 bytes of kernfs node.
>=20
> Are you referring to the current code (>=3D v5.18-rc2)? All big structs
> related to mem_cgroup should be accounted. What is ignored?

mm/memcontrol.c:
5079 static struct mem_cgroup *mem_cgroup_alloc(void)
5080 {
5081         struct mem_cgroup *memcg;
...
5086         memcg =3D kzalloc(struct_size(memcg, nodeinfo, nr_node_ids), G=
FP_KERNEL);

I think it should allocate at least 2 pages.

>> Primary I mean here struct mem_cgroup allocation in mem_cgroup_alloc().
>=20
> Just note that memory controller may not be always enabled so
> cgroup_mkdir !=3D mem_cgroup_alloc().

However if cgroup_mkdir() calls mem_cgroup_alloc() it correctly account hug=
e percpu
allocations but ignores neighbour multipage allocation.

>> However, I think we need to take into account any other distributions ca=
lled
>> inside cgroup_mkdir: struct cgroup and kernefs node in common part and=20
>> any other cgroup-cpecific allocations in other .css_alloc functions.
>> They all can be called from inside container, allocates non-accountable
>> memory and by this way theoretically can be misused.
>=20
> Also note that (if you're purely on unified hierachy) you can protect
> against that with cgroup.max.descendants and cgroup.max.depth.

In past OpenVz had a lot of limits for various resources (for example we ha=
d a limit=20
for iptable rules), but it was very hard to configure them properly.
Finally we  decided to replace all such custom limits by common memory limi=
t.
It isn't important how many resources tries to use container as long as
it doesn't exceed the memory limit.
Such resource limits can be useful, especially to prevent possible misuses.
However sooner or later there will be a legal user who will rest against th=
em.
All you can do in this situation is to recommend him just increase the limi=
t,
that makes the limit senseless.
Memory limits looks much more reasonable and understandable.

Thank you,
	Vasily Averin
