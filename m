From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v5 0/9] memcg: accounting for objects allocated by
 mkdir, cgroup
Date: Sun, 10 Jul 2022 21:53:34 +0300
Message-ID: <1a64fc6a-a33d-03f4-ec12-980e42148061@openvz.org>
References: <4e685057-b07d-745d-fdaa-1a6a5a681060@openvz.org>
 <0fe836b4-5c0f-0e32-d511-db816d359748@openvz.org>
 <c516033f-a9e4-3485-26d9-a68afa694c1d@openvz.org>
 <YrSP25ebDmXE+kPS@dhcp22.suse.cz>
 <CALvZod4WsmrpfZtfnP4AmvtnkvBRngXXGyhM6+aQzkdfjsinAQ@mail.gmail.com>
 <YrXDV7uPpmDigh3G@dhcp22.suse.cz>
 <CALvZod6U8DvMUcuUNfpQRwfkevQB7=nP4ZLA2gWGNf_JGdyARQ@mail.gmail.com>
 <Yr7Ukyy0vhBjebo4@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MjnWXdJX+ay9kx38kvyoZNCAXjqkrOK+MR+sD5e42MA=;
        b=cCAnTvGpgv1VOxq4QkKFQPUKm0OlnZAicTALdTpQkPW6ZkfzK5lfFKgErveXFEI1Wd
         MpatJxtSvCVNb95GYpikEYkKUaEBzwBkS6TTqh+P+ByzCWcD91l/slOwCYBvcoyDdiMP
         5U32Dk4It78u4TtWOvdC+Q2jefWz2Al03roAtnxw6M9T7VrkgpbUXJTLFdFHU5zpxEF1
         5MGKdk5/L6AomK9B5OhwJK0Oru6FNGSTj+8GrmvdRjVKZ3n4gqdRSpQTiCYNkpw1E2I4
         8nE96IEzRTQRZEDAwq0erFlfDJd8w6p28D+5kWQ5nF3YFdUXUoSQCpFFdkEIxGT0n0kb
         JaPw==
Content-Language: en-US
In-Reply-To: <Yr7Ukyy0vhBjebo4-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 7/1/22 14:03, Michal Hocko wrote:
> On Mon 27-06-22 09:37:14, Shakeel Butt wrote:
>> On Fri, Jun 24, 2022 at 6:59 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> [...]
>>> Is it even possible to prevent from id
>>> depletion by the memory consumption? Any medium sized memcg can easily
>>> consume all the ids AFAICS.
>>
>> Though the patch series is pitched as protection against OOMs, I think
>> it is beneficial irrespective. Protection against an adversarial actor
>> should not be the aim here. IMO this patch series improves the memory
>> association to the actual user which is better than unattributed
>> memory treated as system overhead.
> 
> Considering the amount of memory and "normal" cgroup usage (I guess we
> can agree that delegated subtrees do not count their cgroups in
> thousands) is this really something that is worth bothering with?
> 
> I mean, these patches are really small and not really disruptive so I do
> not really see any problem with them. Except that they clearly add a
> maintenance overhead. Not directly with the memory they track but any
> future cgroup/memcg metadata related objects would need to be tracked as
> well and I am worried this will get quickly out of sync. So we will have
> a half assed solution in place that doesn't really help any containment
> nor it provides a good and robust consumption tracking.
> 
> All that being said I find these changes rather without a great value or
> use.

Dear Michal,
I sill have 2 questions:
1) if you do not want to account any memory allocated for cgroup objects,
should you perhaps revert commit 3e38e0aaca9e "mm: memcg: charge memcg percpu
memory to the parent cgroup". Is it an exception perhaps?
(in fact I hope you will not revert this patch, I just would like to know 
your explanations about this accounting)
2) my patch set includes kernfs accounting required for proper netdevices accounting

Allocs  Alloc   Allocation
number  size
--------------------------------------------
1   +  128      (__kernfs_new_node+0x4d)	kernfs node
1   +   88      (__kernfs_iattrs+0x57)		kernfs iattrs
1   +   96      (simple_xattr_alloc+0x28)	simple_xattr, can grow over 4Kb
1       32      (simple_xattr_set+0x59)
1       8       (__kernfs_new_node+0x30)

 2/9] memcg: enable accounting for kernfs nodes
 3/9] memcg: enable accounting for kernfs iattrs
 4/9] memcg: enable accounting for struct simple_xattr

What do you think about them? Should I resend them as a new separate patch set?

Thank you,
	Vasily Averin
