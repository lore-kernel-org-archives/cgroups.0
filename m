From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 4/9] cgroup/cpuset: Enable event notification when
 partition become invalid
Date: Tue, 27 Jul 2021 16:46:18 -0400
Message-ID: <5d1b7995-87f8-afde-5845-c97ff88bf431@redhat.com>
References: <20210720141834.10624-1-longman@redhat.com>
 <20210720141834.10624-5-longman@redhat.com>
 <YP9BxKXfhaoTE+LO@slm.duckdns.org>
 <8bed1ac2-f5f4-6d17-d539-4cd274b0f39e@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627418782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jLNxJhgGZlPkzEzVhm7oQCluwCd8GOHL0Cl+fYd1lV8=;
        b=LGk5E7MPwbVBazHUM2ei9I5m9jOeQXqrU4Yen7lMaf1oZmzIxiPGP8xKQ2zVtiAiX9Jabu
        RLdDUnpz/f7X3k1tF6jew2EH0cAP5F8Z2zWEaaQw8U3TNPRmMB0b2R00afI66XSzvEVP/j
        RwRNTGO7SqyxccitD9ZTKJ7vTpnZgdM=
In-Reply-To: <8bed1ac2-f5f4-6d17-d539-4cd274b0f39e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 7/27/21 4:26 PM, Waiman Long wrote:
> On 7/26/21 7:14 PM, Tejun Heo wrote:
>> On Tue, Jul 20, 2021 at 10:18:29AM -0400, Waiman Long wrote:
>>> +static inline void notify_partition_change(struct cpuset *cs,
>>> +                       int old_prs, int new_prs)
>>> +{
>>> +    if ((old_prs == new_prs) ||
>>> +       ((old_prs != PRS_ERROR) && (new_prs != PRS_ERROR)))
>>> +        return;
>>> +    cgroup_file_notify(&cs->partition_file);
>> I'd generate an event on any state changes. The user have to read the 
>> file
>> to find out what happened anyway.
>>
>> Thanks.
>
> From my own testing with "inotify_add_watch(fd, file, IN_MODIFY)", 
> poll() will return with a event whenever a user write to 
> cpuset.cpus.partition control file. I haven't really look into the 
> sysfs code yet, but I believe event generation will be automatic in 
> this case. So I don't think I need to explicitly add a 
> cgroup_file_notify() when users modify the control file directly. 
> Other indirect modification may cause the partition value to change 
> to/from PRS_ERROR and I should have captured all those changes in this 
> patchset. I will update the patch to note this point to make it more 
> clear. 

After thinking about it a bit more it, it is probably not a problem to 
call cgroup_file_notify() for every change as this is not in a 
performance critical path anyway. I will do some more testing to find 
out if doing cgroup_file_notify() for regular file write will cause an 
extra duplicated event to be sent out, I will probably stay with the 
current patch. Otherwise, I can change it to always call 
cgroup_file_notify().

Cheers,
Longman

