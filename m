From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 11 Aug 2021 14:19:04 -0400
Message-ID: <26180e1d-1fa9-f175-66f8-297cf0685a11@redhat.com>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-6-longman@redhat.com>
 <YRQTy7eo5jOlHTc6@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628705949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ANzdLIOaIJbxnr8pVh5jQkoQ6kMweZt9tE4el1kTVKE=;
        b=hg9Ft9g1H9MW9ZFx7rwb9ujgQhABKOpaut+nljDABZBRwl0vhNnv2u3dGXEnzjOLqK03vQ
        E44YUOERFOMhsH230dqgUIbP/YtDXHXRYrl3w3X5uO7o5Se+xpkLLLZoH1tfsuTMc3vyKS
        gNMKyZvssvMhZ6J+53BuV9+wwxKiRLk=
In-Reply-To: <YRQTy7eo5jOlHTc6-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 8/11/21 2:15 PM, Tejun Heo wrote:
> Hello,
>
> On Tue, Aug 10, 2021 at 11:06:06PM -0400, Waiman Long wrote:
>> +	Poll and inotify events are triggered whenever the state
>> +	of "cpuset.cpus.partition" changes.  That includes changes
>> +	caused by write to "cpuset.cpus.partition" and cpu hotplug.
>> +	This will allow a user space agent to monitor changes caused
>> +	by hotplug events.
> It might be useful to emphasize that this is the primary mechanism to
> signify errors and thus should always be monitored.

Sure, will do that in the next version.

Cheers,
Longman

