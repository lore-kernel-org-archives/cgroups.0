From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Thu, 13 Apr 2023 21:22:19 -0400
Message-ID: <226cb2da-e800-6531-4e57-cbf991022477@redhat.com>
References: <20230412153758.3088111-1-longman@redhat.com>
 <ZDcGVebCpyktxyWh@slm.duckdns.org>
 <1ce6a073-e573-0c32-c3d8-f67f3d389a28@redhat.com>
 <ZDcS_yVCgh6g1LoM@slm.duckdns.org>
 <e38f72aa-9705-cf0c-a565-fb790f16c53e@redhat.com>
 <ZDdG1K0kTETZMTCu@slm.duckdns.org>
 <cd4c3f92-4a01-e636-7390-8c6a3d0cfe6c@redhat.com>
 <ZDdNy2NAfj2_1CbW@slm.duckdns.org>
 <1b8d9128-d076-7d37-767d-11d6af314662@redhat.com>
 <ZDdYOI9LB87ra2t_@slm.duckdns.org>
 <9862da55-5f41-24c3-f3bb-4045ccf24b2e@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681435345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zhMvhm7mcviP5pv7MPTwxWQbVy7/SnaH+sAFoMwChHM=;
        b=QkqyFtYgHaWabLPIhDmAr53h2nivH7ToC418NKr7PN2+uTj2ZzpXSLwMCu/GbGszzefnOo
        8hR/+lAQQworOA7+zSXA2+cB40u4HlIlUCXjlmKsvSAgTyKkiVr6Olo+ZpWOaMwTIdKie0
        puXq6nDZ9OqRCCPIHevQZmGkmUts3O0=
Content-Language: en-US
In-Reply-To: <9862da55-5f41-24c3-f3bb-4045ccf24b2e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


On 4/12/23 21:55, Waiman Long wrote:
> On 4/12/23 21:17, Tejun Heo wrote:
>> Hello, Waiman.
>>
>> On Wed, Apr 12, 2023 at 08:55:55PM -0400, Waiman Long wrote:
>>>> Sounds a bit contrived. Does it need to be something defined in the 
>>>> root
>>>> cgroup?
>>> Yes, because we need to take away the isolated CPUs from the 
>>> effective cpus
>>> of the root cgroup. So it needs to start from the root. That is also 
>>> why we
>>> have the partition rule that the parent of a partition has to be a 
>>> partition
>>> root itself. With the new scheme, we don't need a special cgroup to 
>>> hold the
>> I'm following. The root is already a partition root and the cgroupfs 
>> control
>> knobs are owned by the parent, so the root cgroup would own the first 
>> level
>> cgroups' cpuset.cpus.reserve knobs. If the root cgroup wants to 
>> assign some
>> CPUs exclusively to a first level cgroup, it can then set that cgroup's
>> reserve knob accordingly (or maybe the better name is
>> cpuset.cpus.exclusive), which will take those CPUs out of the root 
>> cgroup's
>> partition and give them to the first level cgroup. The first level 
>> cgroup
>> then is free to do whatever with those CPUs that now belong 
>> exclusively to
>> the cgroup subtree.
>
> I am OK with the cpuset.cpus.reserve name, but not that much with the 
> cpuset.cpus.exclusive name as it can get confused with cgroup v1's 
> cpuset.cpu_exclusive. Of course, I prefer the cpuset.cpus.isolated 
> name a bit more. Once an isolated CPU gets used in an isolated 
> partition, it is exclusive and it can't be used in another isolated 
> partition.
>
> Since we will allow users to set cpuset.cpus.reserve to whatever value 
> they want. The distribution of isolated CPUs is only valid if the cpus 
> are present in its parent's cpuset.cpus.reserve and all the way up to 
> the root. It is a bit expensive, but it should be a relatively rare 
> operation.

I now have a slightly different idea of how to do that. We already have 
an internal cpumask for partitioning - subparts_cpus. I am thinking 
about exposing it as cpuset.cpus.reserve. The current way of creating 
subpartitions will be called automatic reservation and require a direct 
parent/child partition relationship. But as soon as a user write 
anything to it, it will break automatic reservation and require manual 
reservation going forward.

In that way, we can keep the old behavior, but also support new use 
cases. I am going to work on that.

Cheers,
Longman

