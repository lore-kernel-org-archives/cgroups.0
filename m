From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Fri, 5 May 2023 12:25:41 -0400
Message-ID: <759603dd-7538-54ad-e63d-bb827b618ae3@redhat.com>
References: <226cb2da-e800-6531-4e57-cbf991022477@redhat.com>
 <ZDmFLfII8EUX_ocY@slm.duckdns.org>
 <c61ca9d0-c514-fb07-c2f2-3629e8898984@redhat.com>
 <ZDmOjeBVsIcgSLIV@slm.duckdns.org>
 <60ec12dc-943c-b8f0-8b6f-97c5d332144c@redhat.com>
 <46d26abf-a725-b924-47fa-4419b20bbc02@redhat.com>
 <jqkf7jkuyxqiupmxmdbmpnbpojub2pjsz3oogwncmwqdghlsgk@phsqzirmmlyl>
 <f2bd7b1e-190e-1d08-f085-b4cae36fb5be@redhat.com>
 <ZFGOTHQj3k5rzmyR@blackbook>
 <deb7b684-3d7c-b3ae-7b36-5b7ba2dd8001@redhat.com>
 <ZFUo5IYAIwTEKR4_@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683303947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttq1OS4Xt/+1PhRFtnRIzajv6W4m8JyhFIEC4N9Qslw=;
        b=NfB5e4JMq3ddAx0Y/w5CuMTEcOjYTCpkmdNrntPTbyRrZT71ZVudQacxupHL1bqOrM2Ti3
        DrFNndop+4AePnarragADEjwXSS10MmCoIsWDfYqXVULodBhBLyAeQJwwW2Ool9iTQ4PUy
        LfyxaXYLTZJ4A/pNGMg9TZmRleiuhxM=
Content-Language: en-US
In-Reply-To: <ZFUo5IYAIwTEKR4_-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


On 5/5/23 12:03, Tejun Heo wrote:
> On Wed, May 03, 2023 at 11:01:36PM -0400, Waiman Long wrote:
>> On 5/2/23 18:27, Michal Koutný wrote:
>>> On Tue, May 02, 2023 at 05:26:17PM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>> In the new scheme, the available cpus are still directly passed down to a
>>>> descendant cgroup. However, isolated CPUs (or more generally CPUs dedicated
>>>> to a partition) have to be exclusive. So what the cpuset.cpus.reserve does
>>>> is to identify those exclusive CPUs that can be excluded from the
>>>> effective_cpus of the parent cgroups before they are claimed by a child
>>>> partition. Currently this is done automatically when a child partition is
>>>> created off a parent partition root. The new scheme will break it into 2
>>>> separate steps without the requirement that the parent of a partition has to
>>>> be a partition root itself.
>>> new scheme
>>>     1st step:
>>>     echo C >p/cpuset.cpus.reserve
>>>     # p/cpuset.cpus.effective == A-C (1)
>>>     2nd step (claim):
>>>     echo C' >p/c/cpuset.cpus # C'⊆C
>>>     echo root >p/c/cpuset.cpus.partition
>> It is something like that. However, the current scheme of automatic
>> reservation is also supported, i.e. cpuset.cpus.reserve will be set
>> automatically when the child cgroup becomes a valid partition as long as the
>> cpuset.cpus.reserve file is not written to. This is for backward
>> compatibility.
>>
>> Once it is written to, automatic mode will end and users have to manually
>> set it afterward.
> I really don't like the implicit switching behavior. This is interface
> behavior modifying internal state that userspace can't view or control
> directly. Regardless of how the rest of the discussion develops, this part
> should be improved (e.g. would it work to always try to auto-reserve if the
> cpu isn't already reserved?).

After some more thought yesterday, I have a slight change in my design 
that auto-reserve as it is now will stay for partitions that have a 
partition root parent. For remote partition that doesn't have a 
partition root parent, its creation will require pre-allocating 
additional CPUs into top_cpuset's cpuset.cpus.reserve first. So there 
will be no change in behavior for existing use cases whether a remote 
partition is created or not.

Cheers,
Longman

