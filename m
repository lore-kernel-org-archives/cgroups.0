From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 4/9] cgroup/cpuset: Enable event notification when
 partition become invalid
Date: Tue, 27 Jul 2021 16:26:31 -0400
Message-ID: <8bed1ac2-f5f4-6d17-d539-4cd274b0f39e@redhat.com>
References: <20210720141834.10624-1-longman@redhat.com>
 <20210720141834.10624-5-longman@redhat.com>
 <YP9BxKXfhaoTE+LO@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627417595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=14yyXo490T12NnJQD+zcubFFrNkcCdNPIIlyx7xSn8U=;
        b=FCeyBepd1lOeuzAS3lfmeLiw6vUCHYpymxLQIJRGKoGdZRC+P/wdFTMWyQFSQLZL4QuBos
        bIxtlX+CsfaKDdDWm0qalDSV2VEb8h6ojYEdwmmx0gzRRIX4W0N1FtB9pktukfZt1LKzbL
        beCL4sCBxo7yF+6jLgG1MV26bS6MFPg=
In-Reply-To: <YP9BxKXfhaoTE+LO-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 7/26/21 7:14 PM, Tejun Heo wrote:
> On Tue, Jul 20, 2021 at 10:18:29AM -0400, Waiman Long wrote:
>> +static inline void notify_partition_change(struct cpuset *cs,
>> +					   int old_prs, int new_prs)
>> +{
>> +	if ((old_prs == new_prs) ||
>> +	   ((old_prs != PRS_ERROR) && (new_prs != PRS_ERROR)))
>> +		return;
>> +	cgroup_file_notify(&cs->partition_file);
> I'd generate an event on any state changes. The user have to read the file
> to find out what happened anyway.
>
> Thanks.

 From my own testing with "inotify_add_watch(fd, file, IN_MODIFY)", 
poll() will return with a event whenever a user write to 
cpuset.cpus.partition control file. I haven't really look into the sysfs 
code yet, but I believe event generation will be automatic in this case. 
So I don't think I need to explicitly add a cgroup_file_notify() when 
users modify the control file directly. Other indirect modification may 
cause the partition value to change to/from PRS_ERROR and I should have 
captured all those changes in this patchset. I will update the patch to 
note this point to make it more clear.

Cheers,
Longman


