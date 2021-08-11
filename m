From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 4/6] cgroup/cpuset: Allow non-top parent partition root
 to distribute out all CPUs
Date: Wed, 11 Aug 2021 14:46:24 -0400
Message-ID: <ef02d96b-325c-87f6-a6a3-d840feefef24@redhat.com>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-5-longman@redhat.com>
 <YRQTTf+bJZ8f3O3+@slm.duckdns.org>
 <abfa6f2f-aa13-f18e-5a16-f568082d07bc@redhat.com>
 <YRQVFkNX5DcKixzy@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628707588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BOILZBJ0R4YxSBlomh5xiyJL3tlxmw5VR/2YYVBHfVY=;
        b=EwW1Lt7iXin0ZAb0YDhwtWWbqICvcow1T6t8TIqgeW3Ycfjhdzi922VTdJiwbiHaW0D6lo
        KiPxSoeE3+2kQIULIqK1c0ZlGxHafOYUwdeTAlxaUWRfdYSfAH699RDYx822sQBQX+OBvH
        pPP5DqI00Tuhdr0k0VS6u5M5lpUaEw0=
In-Reply-To: <YRQVFkNX5DcKixzy-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 8/11/21 2:21 PM, Tejun Heo wrote:
> On Wed, Aug 11, 2021 at 02:18:17PM -0400, Waiman Long wrote:
>> I don't think that is true. A task can reside anywhere in the cgroup
>> hierarchy. I have encountered no problem moving tasks around.
> Oh, that shouldn't be happening with controllers enabled. Can you please
> share a repro?

I have done further testing. Enabling controllers won't prohibit moving 
a task into a parent cgroup as long as the child cgroups have no tasks. 
Once the child cgroup has task, moving another task to the parent is not 
allowed (-EBUSY). Similarly if a parent cgroup has tasks, you can't put 
new tasks into the child cgroup. I don't realize that we have such 
constraints as I usually do my testing with a cgroup hierarchy with no 
tasks initially. Anyway, a new lesson learned.

I will try to see how to address that in the patch, but the additional 
check added is still valid in some special case.

Cheers,
Longman





