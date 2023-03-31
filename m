From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CLONE_INTO_CGROUP probably needs to call controller attach
 handlers
Date: Fri, 31 Mar 2023 14:27:26 -0400
Message-ID: <174663c9-84f6-1ea1-192b-cdc756802bdf@redhat.com>
References: <20230328153943.op62j3sw7qaixdsq@wittgenstein>
 <c3d9cf24-1c3a-cda4-5063-6b7d27e9116f@redhat.com>
 <5937b51b-164a-b6b3-532d-43b46f2d49a2@redhat.com>
 <20230329-unripe-imminent-655bed17aad2@brauner>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680287249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pYhblDY2uVVuzGjt43iHxyxL8ZY1RhpsgBR731PMnOU=;
        b=WPG/0F/5R+kVpQhTIKjp/QNHkvMYsGbJN/H2H323eV4UzfRmAGlcCqu0MIX8hmbwAKDzMG
        yCGyymU9+AYBSJyhe7AAdd3h1tJYjGm06jDk9m1gZUajx66FlpIsNlF8aV+wgDVek6en3Y
        RaIaEzyPq29H1kspKmOObImaZj9qSqM=
Content-Language: en-US
In-Reply-To: <20230329-unripe-imminent-655bed17aad2@brauner>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On 3/29/23 03:19, Christian Brauner wrote:
> On Tue, Mar 28, 2023 at 10:48:49PM -0400, Waiman Long wrote:
>> On 3/28/23 21:30, Waiman Long wrote:
>>> On 3/28/23 11:39, Christian Brauner wrote:
>>>> Hey,
>>>>
>>>> Giuseppe reported that the the affinity mask isn't updated when a
>>>> process is spawned directly into the target cgroup via
>>>> CLONE_INTO_CGROUP. However, migrating a process will cause the affinity
>>>> mask to be updated (see the repro at [1].
>>>>
>>>> I took a quick look and the issue seems to be that we don't call the
>>>> various attach handlers during CLONE_INTO_CGROUP whereas we do for
>>>> migration. So the solution seems to roughly be that we need to call the
>>>> various attach handlers during CLONE_INTO_CGROUP as well when the
>>>> parent's cgroups is different from the child cgroup. I think we need to
>>>> call all of them, can, cancel and attach.
>>>>
>>>> The plumbing here might be a bit intricate since the arguments that the
>>>> fork handlers take are different from the attach handlers.
>>>>
>>>> Christian
>>>>
>>>> [1]: https://paste.centos.org/view/f434fa1a
>>>>
>>> I saw that the current cgroup code already have the can_fork, fork and
>>> cancel_fork callbacks. Unfortunately such callbacks are not defined for
>>> cpuset yet. That is why the cpu affinity isn't correctly updated. I can
>>> post a patch to add those callback functions to cpuset which should then
>>> able to correctly address this issue.
>> Looking further into this issue, I am thinking that forking into a cgroup
>> should be equivalent to write the child pid into the "cgroup.threads" file
>> of the target cgroup. By taking this route, all the existing can_attach,
>> attach and cancel_attach methods can be used. I believe the original fork
>> method is for the limited use case of forking into the same cgroup. So right
>> now, only the pids controller has the fork methods. Otherwise, we will have
>> to modify a number of different controllers to add the necessary fork
>> methods. They will be somewhat similar to the existing attach methods and so
>> it will be a lot of duplication. What do you think about this idea?
> The overall plan sounds good to me. I have one comment and question
> about making this equivalent to a write of the child pid into the
> cgroup.threads file.
>
> The paragraph above seems to imply that CLONE_INTO_CGROUP currently
> isn't equivalent to a write to cgroup.threads. But it's not that
> straightforward. CLONE_INTO_CGROUP needs to handle both threads and
> threadgroups aka being or-ed with CLONE_THREAD or not. It does that in
> cgroup_css_set_fork() when calling
> cgroup_attach_permissions([...] !(kargs->flags & CLONE_THREAD), [...]).
>
> What it's missing is calling the relevant handlers that would be
> executed in the migration path. They might be different between the
> CLONE_THREAD and !CLONE_THREAD case. But the crux remains that
> CLONE_INTO_CGROUP needs to handle both cases.
>
> So afaict, what you're proposing is equivalent to what I sketched in the
> initial mail? Or is there something else you mean by making this
> equivalent to cgroup.threads that goes beyond adding the missing
> handlers? Just trying to make sure we're not accidently changing
> semantics.

It turns out that cpuset does have a cpuset_fork() method defined and so 
is the legacy freezer even though they don't have a can_fork method. So 
the simplest way to fix this problem is to extend the existing 
cpuset_fork() method to handle the CLONE_INTO_CGROUP case. I have sent 
out an upstream patch to fix that issue.

Cheers,
Longman

