From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 1 Dec 2021 09:26:43 -0500
Message-ID: <0bdfb7f2-61ee-7b2a-fdb2-3c41f6d6ade0@redhat.com>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211018143619.205065-6-longman@redhat.com>
 <20211115193122.GA16798@blackbody.suse.cz>
 <8f68692b-bd8f-33fd-44ae-f6f83bf2dc00@redhat.com>
 <20211116175411.GA50019@blackbody.suse.cz>
 <293d7abf-aff6-fcd8-c999-b1dbda1cffb8@redhat.com>
 <YaZbXArNIMNvwJD/@slm.duckdns.org>
 <2347fe66-dc68-6d58-e63b-7ed2b8077b48@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638368827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aXrqNOrDvSgD387N15SkHeYtKspYajLx2tWsnOoBWmw=;
        b=XFjjfA/qsAGgmpeK12okClbS5nnO648FvGoqH22hqbT5RfUaPFqbEDgmzKArObZljJw1DU
        kWFZH+hKH0efhNQoe7ZR7tvOU2GdsTE9mCvvUH/N4fah0WrNvloLESh6YwWDaBtS2MPUXd
        OIV/QNYNJnfHkfeD3pkn3boyMroDXvU=
Content-Language: en-US
In-Reply-To: <2347fe66-dc68-6d58-e63b-7ed2b8077b48-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 11/30/21 22:56, Waiman Long wrote:
> On 11/30/21 12:11, Tejun Heo wrote:
>
>
>>>      Once becoming a partition root, the following two rules restrict
>>>      what changes can be made to "cpuset.cpus".
>>>
>>>      1) The value must be exclusive.
>>>      2) If child cpusets exist, the value must be a superset of what
>>>         are defined in the child cpusets.
>>>
>>>      The second rule applies even for "member". Other changes to
>>>      "cpuset.cpus" that do not violate the above rules are always
>>>      allowed.
>> While it isn't necessarily tied to this series, it's a big no-no to 
>> restrict
>> what a parent can do depending on what its descendants are doing. A 
>> cgroup
>> higher up in the hierarchy should be able to change configuration 
>> however it
>> sees fit as deligation breaks down otherwise.
>>
>> Maybe you can argue that cpuset is special and shouldn't be subject 
>> to such
>> convention but I can't see strong enough justifications especially given
>> that most of these restrictions can be broken by hotplug operations 
>> anyway
>> and thus need code to handle those situations.
>
> These are all pre-existing restrictions before the introduction of 
> partition. These are checks done in validate_change(). I am just 
> saying out loud the existing behavior. If you think that needs to be 
> changed, I am fine with that. However, it will be a separate patch as 
> it is not a behavior that is introduced by this series.

Of the 2 restrictions listed above, the exclusivity rule is due to the 
use of CS_CPU_EXCLUSIVE flag. I think it is reasonable as it affects 
only siblings, not the parent.

The second restriction was found during my testing. It is caused by the 
following code in validate_change():

         /* Each of our child cpusets must be a subset of us */
         ret = -EBUSY;
         cpuset_for_each_child(c, css, cur)
                 if (!is_cpuset_subset(c, trial))
                         goto out;

It seems that this code was there since v2.6.12 (the beginning of the 
git era). Later in function, we have

         /* On legacy hierarchy, we must be a subset of our parent 
cpuset. */
         ret = -EACCES;
         if (!is_in_v2_mode() && !is_cpuset_subset(trial, par))
                 goto out;

This is actually a duplicate in the case of legacy hierarchy.

I can add a patch to take out the first code block above which I think 
is where most of your objections are. Then I can remove the 2nd 
restriction in my documentation. I would like to emphasize that this is 
a pre-existing behavior which I just happen to document.

Cheers,
Longman

