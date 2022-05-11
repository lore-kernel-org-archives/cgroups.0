From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: kernfs memcg accounting
Date: Wed, 11 May 2022 09:01:40 +0300
Message-ID: <0eec6575-548e-23e0-0d99-4e079a33d338@openvz.org>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
 <20220427140153.GC9823@blackbody.suse.cz>
 <7509fa9f-9d15-2f29-cb2f-ac0e8d99a948@openvz.org>
 <YnBLge4ZQNbbxufc@blackbook>
 <52a9f35b-458b-44c4-7fc8-d05c8db0c73f@openvz.org> <YnsoMEuWjlpDcmt3@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KG2LP7lqw9uskhHUdz+/neRzxuQzhpKu6yMc7xnK/Nw=;
        b=ymECTCTfY6HysdomwfmKw5QWUX/LYJLfLVPUX3cID7988CkBbdzv4Aku3xtSvlHixS
         mLEUKjlqqEjDC/D0dqLnlo2CRSmatHUUKoX0cT2CfKO7C856mRyrIXYdTvYhusfPWxLA
         qgK4HNLVdHR50zn89GYGFuYzzQIPmwysOCOoGl0fi6a9fVknY6UH33Yk/lLXJvqdaKZC
         tphhA4klMvM9w/djtKoUNrB6JxH51OCpzoP6u8mQ2MulTxFfP9ygmlYJ2tbJQw5owmHm
         oC8clKUaILQ+G8AYEjejlZG6vDBahYAeBM+8p9Y3+ALCzbkyKzV6zMJwTti7o7nYmmsO
         mYrA==
Content-Language: en-US
In-Reply-To: <YnsoMEuWjlpDcmt3@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 5/11/22 06:06, Roman Gushchin wrote:
> On Wed, May 04, 2022 at 12:00:18PM +0300, Vasily Averin wrote:
>> From my point of view it is most important to account allocated memory
>> to any cgroup inside container. Select of proper memcg is a secondary goal here.
>> Frankly speaking I do not see a big difference between memcg of current process,
>> memcg of newly created child and memcg of its parent.
>>
>> As far as I understand, Roman chose the parent memcg because it was a special
>> case of creating a new memory group. He temporally changed active memcg
>> in mem_cgroup_css_alloc() and properly accounted all required memcg-specific
>> allocations.
> 
> My primary goal was to apply the memory pressure on memory cgroups with a lot
> of (dying) children cgroups. On a multi-cpu machine a memory cgroup structure
> is way larger than a page, so a cgroup which looks small can be really large
> if we calculate the amount of memory taken by all children memcg internals.
> 
> Applying this pressure to another cgroup (e.g. the one which contains systemd)
> doesn't help to reclaim any pages which are pinning the dying cgroups.
> 
> For other controllers (maybe blkcg aside, idk) it shouldn't matter, because
> there is no such problem there.
> 
> For consistency reasons I'd suggest to charge all *large* allocations
> (e.g. percpu) to the parent cgroup. Small allocations can be ignored.

I showed in [1] other large allocation:
"
number	bytes	$1*$2	sum	note	call_site
of	alloc
allocs
------------------------------------------------------------
1       14448   14448   14448   =       percpu_alloc_percpu:
1       8192    8192    22640   ++      (mem_cgroup_css_alloc+0x54)
49      128     6272    28912   ++      (__kernfs_new_node+0x4e)
49      96      4704    33616   ?       (simple_xattr_alloc+0x2c)
49      88      4312    37928   ++      (__kernfs_iattrs+0x56)
1       4096    4096    42024   ++      (cgroup_mkdir+0xc7)
1       3840    3840    45864   =       percpu_alloc_percpu:
4       512     2048    47912   +       (alloc_fair_sched_group+0x166)
4       512     2048    49960   +       (alloc_fair_sched_group+0x139)
1       2048    2048    52008   ++      (mem_cgroup_css_alloc+0x109)
"
[1] https://lore.kernel.org/all/1aa4cd22-fcb6-0e8d-a1c6-23661d618864-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org/
=	already accounted
++	to be accounted first
+	to be accounted a bit later

There is no problems with objects allocated in mem_cgroup_alloc(),
they will be accounted to parent's memcg.
However I do not understand how to handle other large objects?

We could move set_active_memcg(parent) call from mem_cgroup_css_alloc() 
to cgroup_apply_control_enable() and handle allocation in all .css_alloc()

However I need to handle allocations called from cgroup_mkdir() too and
badly understand how to do it properly.

Thank you,
	Vasily Averin
