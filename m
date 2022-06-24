From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v5 0/9] memcg: accounting for objects allocated by
 mkdir, cgroup
Date: Fri, 24 Jun 2022 13:40:14 +0300
Message-ID: <0f8146e3-5865-b7e6-6728-5baada375cf2@openvz.org>
References: <4e685057-b07d-745d-fdaa-1a6a5a681060@openvz.org>
 <0fe836b4-5c0f-0e32-d511-db816d359748@openvz.org>
 <c516033f-a9e4-3485-26d9-a68afa694c1d@openvz.org>
 <YrSP25ebDmXE+kPS@dhcp22.suse.cz>
 <CALvZod4WsmrpfZtfnP4AmvtnkvBRngXXGyhM6+aQzkdfjsinAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AJmnLzRfv3CKjpAFSm8w5uUX4zkxlzpS9NJDok/nCk8=;
        b=7HedpVdtZRLHDg268+oLo/eUh38UD497b1xuP0kyTrOApUY9ey+kT8c0TnmBPY+t9U
         mL3HMOpxmxQIYWukMfePC89vZe9yHBTYZIR98SC8JnF5PNc4ICv87ZpVlu0TxWY8d45R
         d9z0Mgc5yU0iDhbJBhLbs8Baz9W25uKdFESjuRdahXy0c+L74oYBwxW/vkQdtCl/Zp2b
         o7Ofb3Rb/6lKL6zcj87m09gmw0mAbgTtb4y8Hd8FQfwViCQZAfDmOdf8Vt7L2w/ctbFt
         osjhl7TXYXzxDD/VddKOpv5+aF5y9/2rtyKZkQcDfn86chNYao3fOf/kYoH3POPiDcmI
         cuLQ==
Content-Language: en-US
In-Reply-To: <CALvZod4WsmrpfZtfnP4AmvtnkvBRngXXGyhM6+aQzkdfjsinAQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 6/23/22 19:55, Shakeel Butt wrote:
> On Thu, Jun 23, 2022 at 9:07 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>>
>> On Thu 23-06-22 18:03:31, Vasily Averin wrote:
>>> Dear Michal,
>>> do you still have any concerns about this patch set?
>>
>> Yes, I do not think we have concluded this to be really necessary. IIRC
>> Roman would like to see lingering cgroups addressed in not-so-distant
>> future (http://lkml.kernel.org/r/Ypd2DW7id4M3KJJW@carbon) and we already
>> have a limit for the number of cgroups in the tree. So why should we
>> chase after allocations that correspond the cgroups and somehow try to
>> cap their number via the memory consumption. This looks like something
>> that will get out of sync eventually and it also doesn't seem like the
>> best control to me (comparing to an explicit limit to prevent runaways).
>> --
> 
> Let me give a counter argument to that. On a system running multiple
> workloads, how can the admin come up with a sensible limit for the
> number of cgroups? There will definitely be jobs that require much
> more number of sub-cgroups. Asking the admins to dynamically tune
> another tuneable is just asking for more complications. At the end all
> the users would just set it to max.
> 
> I would recommend to see the commit ac7b79fd190b ("inotify, memcg:
> account inotify instances to kmemcg") where there is already a sysctl
> (inotify/max_user_instances) to limit the number of instances but
> there was no sensible way to set that limit on a multi-tenant system.

I've found that MEM_CGROUP_ID_MAX limits memory cgroups only. Other types
of cgroups do not have similar restrictions. Yes, we can set some per-container 
limit for all cgroups, but to me it looks like workaround while
proper memory accounting looks like real solution.

Btw could you please explain why memory cgroups have MEM_CGROUP_ID_MAX limit
Why it is required at all and why it was set to USHRT_MAX? I believe that
in the future it may be really reachable:

Let's set up per-container cgroup limit to some small numbers, 
for example to 512 as OpenVz doing right now. On real node with 300
containers we can easily get 100*300 = 30000 cgroups, and consume ~3Gb memory, 
without any misuse. I think it is too much to ignore its accounting.

Thank you,
	Vasily Averin
