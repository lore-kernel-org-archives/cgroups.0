From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/6] cgroup/cpuset: Clarify the use of invalid
 partition root
Date: Fri, 16 Jul 2021 17:28:58 -0400
Message-ID: <4a804edc-17ec-d8fa-d8c1-273252ba0ee4@redhat.com>
References: <20210621184924.27493-1-longman@redhat.com>
 <20210621184924.27493-3-longman@redhat.com>
 <YNcHOe3o//pIiByh@mtj.duckdns.org>
 <6ea1ac38-73e1-3f78-a5d2-a4c23bcd8dd1@redhat.com>
 <YONGk3iw/zrNzwLK@mtj.duckdns.org>
 <c6ae2d9b-ad6e-9bbd-b25c-f52b0ff6fb9b@redhat.com>
 <1bb119a1-d94a-6707-beac-e3ae5c03fae5@redhat.com>
 <8c44b659-3fe4-b14f-fac1-cbd5b23010c3@redhat.com>
 <YPHwG61qGDa3h6Wg@mtj.duckdns.org>
 <e8c538a8-bf5c-b04c-1b21-ac22cd158dd1@redhat.com>
 <YPH3sF56gK71CxXY@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626470941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YABHDSw9b5sWUS8tb4/mSbwzJgD3Ug0F6zV+ryBO8W8=;
        b=L6e5tkVhaRSc5L4Z++0GnAfZ9RkQMD1kWHT4uI2smNMQh0paOnoeztbcvxl/7PRaKnVnVK
        EJHhxoHtg2T7oalrLidI+Ys7hx/qRfFLDrjQgIBfqSPG+WjIv7Ve5gWuL51O7PBkrBX5KR
        CxRHTlNXJaS+LcXlXOKpuZQb0rRU2l8=
In-Reply-To: <YPH3sF56gK71CxXY-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 7/16/21 5:18 PM, Tejun Heo wrote:
> Hello,
>
> On Fri, Jul 16, 2021 at 05:12:17PM -0400, Waiman Long wrote:
>> Are you suggesting that we add a cpuset.cpus.events file that allows
>> processes to be notified if an event (e.g. hotplug) that changes a partition
>> root to invalid partition happens or when explicit change to a partition
>> root fails? Will that be enough to satisfy your requirement?
> Yeah, something like that or make the current state file generate events on
> state transitions.


Sure. I will change the patch to make cpuset.cpus.partition generates 
event when its state change. Thanks for the suggestion. It definitely 
makes it better.

Cheers,
Longman

