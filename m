From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Thu, 26 Aug 2021 23:01:30 -0400
Message-ID: <32e27fcc-32f1-b26c-ae91-9e03f7e433af@redhat.com>
References: <20210825213750.6933-1-longman@redhat.com>
 <20210825213750.6933-6-longman@redhat.com> <YSfQ0mYWs2zUyqGY@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630033295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K4jOE7EOyJEUtyvbzwon/FpGiE9ELVYRNObVBK/Xg7Q=;
        b=I4Krasr7KLrpSkNAg5+wq0d12gkVocEvCi8tf7hTdukjeAEkUAfqn5kxGTkqOXW5nNLYdk
        msSqeFPon0VCAeMg2ZDyiapytq6S/fi3BlQwXBRlWx88tkcNHbscTjD2Asyjsw3GDeUVRY
        7NrOJNh0cw0jPjgPuCkYInW2FkoD0SY=
In-Reply-To: <YSfQ0mYWs2zUyqGY-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 8/26/21 1:35 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> Let's stop iterating on the patchset until we reach a consensus.
>
> On Wed, Aug 25, 2021 at 05:37:49PM -0400, Waiman Long wrote:
>>   	1) The "cpuset.cpus" is not empty and the list of CPUs are
>>   	   exclusive, i.e. they are not shared by any of its siblings.
> Part of it can be reached by cpus going offline.
>
>>   	2) The parent cgroup is a partition root.
> This condition can happen if a parent stop being a partition.
>
>> -	3) The "cpuset.cpus" is also a proper subset of the parent's
>> +	3) The "cpuset.cpus" is a subset of the parent's
>>   	   "cpuset.cpus.effective".
> This can happen if cpus go offline.
>
>>   	4) There is no child cgroups with cpuset enabled.  This is for
>>   	   eliminating corner cases that have to be handled if such a
>>   	   condition is allowed.
> This may make sense as a short cut for us but doesn't really stem from
> interface or behavior requirements.
>
> Of the four conditions listed, two are bogus (the states can be
> reached through a different path and the configuration success or
> failure can be timing dependent if configuration racaes against cpu
> hotplug operations) and one maybe makes sense half-way and one is more
> of a shortcut.
>
> Can't we just replace these with transitions to invalid state with
> proper explanation? That'd get rid of the error handling duplications
> from both the kernel and user side, make automated configurations
> which may race against hot plug operations reliable, and consistently
> provide users with why something failed.

What I am doing here is setting a high bar for transitioning from member 
to either "root" or "isolated". Once it becomes a partition, there are 
multiple ways that can make it invalid. I am fine with that. However, I 
am not sure it is a good idea to allow users to echo "root" to 
cpuset.cpus.partition anywhere in the cgroup hierarchy and require them 
to read it back to see if it succeed.

All the checking are done with cpuset_rwsem held. So there shouldn't be 
any racing. Of course, a hotplug can immediately follow and make the 
partition invalid.

Cheers,
Longman

