From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] cpuset: Skip possible unwanted CPU-mask updates.
Date: Fri, 11 Nov 2022 12:34:33 -0500
Message-ID: <f28a00c4-534c-d74a-a14a-f85a1849566e@redhat.com>
References: <20221102105530.1795429-1-bigeasy@linutronix.de>
 <d0b43b7d-54d3-00bd-abe0-78212ee9355a@redhat.com>
 <Y25rcHYzix+kAJF9@linutronix.de>
 <6948de71-a3e3-b6c2-bc67-1bb39cbdff69@redhat.com>
 <Y259IcCb937bw3AZ@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668188084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZdU6y9ltVApdyYYlrN641BgzGsKKrzFrvsbZdaNIWec=;
        b=KqDRMLsaTtIX8Irwj4DRRIgRcUlSn4qurWx6xaVcXB0byriTadhzWITU51jid/U5BzYIqc
        i086y9geb0AzoRhiwy6vCG4DC/8pWErr3ZPlMUftT8OBnxcYJrGiB6oSsNhvRmFr75/5Wn
        viIv6QGLHg4RThGUh1OquZJO6s83FzA=
Content-Language: en-US
In-Reply-To: <Y259IcCb937bw3AZ-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>


On 11/11/22 11:49, Sebastian Andrzej Siewior wrote:
> On 2022-11-11 11:37:03 [-0500], Waiman Long wrote:
>> On 11/11/22 10:34, Sebastian Andrzej Siewior wrote:
>>> On 2022-11-02 09:20:48 [-0400], Waiman Long wrote:
>>> Hi,
>>>
>>>> Yes, that is a known issue which is especially problematic when cgroup v2 is
>>>> used. That is why I have recently posted a set of patches to enable
>>>> persistent user requested affinity and they have been merged into tip:
>>>>
>>>> 851a723e45d1 sched: Always clear user_cpus_ptr in do_set_cpus_allowed()
>>>> da019032819a sched: Enforce user requested affinity
>>>> 8f9ea86fdf99 sched: Always preserve the user requested cpumask
>>>> 713a2e21a513 sched: Introduce affinity_context
>>>> 5584e8ac2c68 sched: Add __releases annotations to affine_move_task()
>>>> They should be able to address the problem that you list here. Please let me
>>>> know if there are still problem remaining.
>>> Thank you. This solves the most pressing issue. The CPU-mask is still
>>> reset upon activation of the cpuset controller.
>>> This is due to the set_cpus_allowed_ptr() in cpuset_attach().
>>>
>>> Is is possible to push these patches stable?
>> Actually, I prefer to not call set_cpus_allowed_ptr() if the cpumask of the
>> old and new cpusets are the same. That will save some cpu cycles. Similarly
>> for node_mask. If there is any changes in the cpumask, we have to call
>> set_cpus_allowed_ptr(). I will work out a patch to that effect when I have
>> spare cycle.
> But couldn't we skip that set_cpus_allowed_ptr() if the current mask is
> a subset of the new mask and keep the behavior that the mask isn't
> changed if the cgroup's mask changes but is still a subset?
> That cpuset_attach() callback is only invoked while the task is
> initially added to the cgroup which happens during enabling of the
> controller. Or do I miss another common usecase?

The only way a userspace task can have a cpumask different from that of 
its cpuset is by calling sched_setaffinity() which will be covered by 
the persistent user requested mask change. So your patch 2 isn't really 
needed.

Your patch 1 is relatively simple and I don't have a big objection to 
that. I will let others chime in on what their thoughts are.

Cheers,
Longman

