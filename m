From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/4] cgroup/cpuset: Include offline CPUs when tasks'
 cpumasks in top_cpuset are updated
Date: Fri, 17 Mar 2023 14:05:32 -0400
Message-ID: <11b5454b-42c7-fb0d-f071-c46712f76f3b@redhat.com>
References: <20230317151508.1225282-1-longman@redhat.com>
 <20230317151508.1225282-4-longman@redhat.com>
 <20230317180157.uqlleobldg53pgj6@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679076335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UIc+3uJLQO2epi9c5c7YBS9m+h9LmNMS++rx41y2Zn0=;
        b=NMv1AMPJSPkewjPbruq/EENxrv6IVB0QH5S57VFvKGldR7PNS0Cz83KPbLVbTzjM10BHMo
        tTGP5i5ckJFa0dvZmmbeBqIsYYL1RQzdBfkb0h6z6Z4maG2wWB5r+3YmuspEP2xfZ+iWHH
        BsXTBsFConJtRtV8rxqCxNORAbQhlck=
Content-Language: en-US
In-Reply-To: <20230317180157.uqlleobldg53pgj6@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


On 3/17/23 14:01, Michal Koutný wrote:
> Hello.
>
> On Fri, Mar 17, 2023 at 11:15:07AM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>    * Iterate through each task of @cs updating its cpus_allowed to the
>>    * effective cpuset's.  As this function is called with cpuset_rwsem held,
>> - * cpuset membership stays stable.
>> + * cpuset membership stays stable. For top_cpuset, task_cpu_possible_mask()
>> + * is used instead of effective_cpus to make sure all offline CPUs are also
>> + * included as hotplug code won't update cpumasks for tasks in top_cpuset.
>>    */
> On Wed, Mar 15, 2023 at 11:06:20AM +0100, Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org> wrote:
>> I see now that it returns offlined cpus to top cpuset's tasks.
> I considered only the "base" set change cs->effective_cpus ->
> possible_mask. (Apologies for that mistake.)
>
> However, I now read the note about subparts_cpus
>
>>          * effective_cpus contains only onlined CPUs, but subparts_cpus
>>          * may have offlined ones.
> So if subpart_cpus keeps offlined CPUs, they will be subtracted from
> possible_mask and absent in the resulting new_cpus, i.e. undesirable for
> the tasks in that cpuset :-/

A cpu will be in the subparts_cpus only if it has been given to the 
child partition. So when it becomes online, it will become part of the 
scheduling domain that child partition. Only the tasks in that child 
partition will get their cpumasks updated to use it, not those in the 
top cpuset.

Cheers,
Longman

