From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Fri, 27 Aug 2021 21:14:01 -0400
Message-ID: <f1168ddc-cb67-ecfd-6644-4963c857a0a0@redhat.com>
References: <20210825213750.6933-1-longman@redhat.com>
 <20210825213750.6933-6-longman@redhat.com> <YSfQ0mYWs2zUyqGY@mtj.duckdns.org>
 <32e27fcc-32f1-b26c-ae91-9e03f7e433af@redhat.com>
 <YShjb2WwvuB4s4gX@slm.duckdns.org>
 <d22ea3be-2429-5923-a80c-5af3b384def9@redhat.com>
 <YSlY0H/qeXQIGOfk@slm.duckdns.org>
 <392c3724-f583-c7fc-cfa1-a3f1665114c9@redhat.com>
 <YSl2yxEvnDrPxzUV@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630113246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nj7lN9b3OW9PxFPw9p3QaG1rQrZn9spoM1KJO1HMw1U=;
        b=A4dzNDypRsANDa1pVg1DfcJKC3AeuzVqI/F2sN9U5WyLrRgudYokmWn6/FKp29JdUtpDNU
        OGw349B1vwMuvYMNMev+arKbHt1fAAgPZ1aRSdSemGsBd0tfpZTPP4W2ECt8avwlCJKjgq
        ekctGLWwbBEl2uru6xbRluuaPsqoHzE=
In-Reply-To: <YSl2yxEvnDrPxzUV-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 8/27/21 7:35 PM, Tejun Heo wrote:
> Hello,
>
> On Fri, Aug 27, 2021 at 06:50:10PM -0400, Waiman Long wrote:
>> The cpu exclusivity rule is due to the setting of CPU_EXCLUSIVE bit. This is
>> a pre-existing condition unless you want to change how the
>> cpuset.cpu_exclusive works.
>>
>> So the new rules will be:
>>
>> 1) The "cpuset.cpus" is not empty and the list of CPUs are exclusive.
> Empty cpu list can be considered an exclusive one.
It doesn't make sense to me to have a partition with no cpu configured 
at all. I very much prefer the users to set cpuset.cpus first before 
turning it into a partition.
>
>> 2) The parent cgroup is a partition root (can be an invalid one).
> Does this mean a partition parent can't stop being a partition if one or
> more of its children become partitions? If so, it violates the rule that a
> descendant shouldn't be able to restrict what its ancestors can do.

No. As I said in the documentation, transitioning from partition root to 
member is allowed. Against, it is illogical to allow a cpuset to become 
a potential partition if it parent is not even a partition root at all. 
In the case that the parent is reverted back to a member, the child 
partitions will stay invalid forever unless the parent become a valid 
partition again.

>
>> 3) The "cpuset.cpus" is a subset of the parent's cpuset.cpus.allowed.
> Why not just go by effective? This would mean that a parent can't withdraw
> CPUs from its allowed set once descendants are configured. Restrictions like
> this are fine when the entire hierarchy is configured by a single entity but
> become awkward when configurations are multi-tiered, automated and dynamic.

The original rule is to be based on effective cpus. However, to properly 
handle the case of allowing offlined cpus to be included in the 
partition, I have to change it to cpu_allowed instead. I can certainly 
change it back to effective if you prefer.

>
>> 4) No child cgroup with cpuset enabled.
> idk, maybe? I'm having a hard time seeing the point in adding these
> restrictions when the state transitions are asynchronous anyway. Would it
> help if we try to separate what's absoluately and technically necessary and
> what seems reasonable or high bar and try to justify why each of the latter
> should be added?

This rule is there mainly for ease of implementation. Otherwise, I need 
to add additional code to handle the conversion of child cpusets which 
can be rather complex and require a lot more debugging. This rule will 
no longer apply once the cpuset becomes a partition root.

Cheers,
Longman


