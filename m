From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CLONE_INTO_CGROUP probably needs to call controller attach
 handlers
Date: Tue, 28 Mar 2023 21:30:20 -0400
Message-ID: <c3d9cf24-1c3a-cda4-5063-6b7d27e9116f@redhat.com>
References: <20230328153943.op62j3sw7qaixdsq@wittgenstein>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680053427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CspT4SBj2OPAfTD4GX2xH3Q/n47a5hkXe6pVA2r6P70=;
        b=cqR/3z/jV6E7nlWrqMpjJ0LXU8eyWdqLl1SOfFA7czIwSor0TcJsptZmuaUXvq83KPUJJx
        jvg3AfbzN9U5Bm1ed+8lGOzgyiuUhMHDz5iZ1wODbglVDaIllVIEPNc1uf7gtYb9LUmoCd
        pcJbT82w19hPaJk0WL1fQGkZwQO4arU=
Content-Language: en-US
In-Reply-To: <20230328153943.op62j3sw7qaixdsq@wittgenstein>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On 3/28/23 11:39, Christian Brauner wrote:
> Hey,
>
> Giuseppe reported that the the affinity mask isn't updated when a
> process is spawned directly into the target cgroup via
> CLONE_INTO_CGROUP. However, migrating a process will cause the affinity
> mask to be updated (see the repro at [1].
>
> I took a quick look and the issue seems to be that we don't call the
> various attach handlers during CLONE_INTO_CGROUP whereas we do for
> migration. So the solution seems to roughly be that we need to call the
> various attach handlers during CLONE_INTO_CGROUP as well when the
> parent's cgroups is different from the child cgroup. I think we need to
> call all of them, can, cancel and attach.
>
> The plumbing here might be a bit intricate since the arguments that the
> fork handlers take are different from the attach handlers.
>
> Christian
>
> [1]: https://paste.centos.org/view/f434fa1a
>
I saw that the current cgroup code already have the can_fork, fork and 
cancel_fork callbacks. Unfortunately such callbacks are not defined for 
cpuset yet. That is why the cpu affinity isn't correctly updated. I can 
post a patch to add those callback functions to cpuset which should then 
able to correctly address this issue.

Cheers,
Longman

