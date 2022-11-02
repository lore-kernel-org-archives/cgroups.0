From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] cpuset: Skip possible unwanted CPU-mask updates.
Date: Wed, 2 Nov 2022 09:20:48 -0400
Message-ID: <d0b43b7d-54d3-00bd-abe0-78212ee9355a@redhat.com>
References: <20221102105530.1795429-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667395256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b49q1XHQiuNrTW4a7AJc1gkwX+9NO+6eMUUebYAkoIk=;
        b=DQCFMPWNg+7u4F6W4v1k8yZajlJeoqWvdiSoKA9oSu3trSOMEYEpqS4UEMrjlwEn/l6TpK
        teipeSUPEhBz3pCnNaZ+N6vXWHLbD6aJV/mi7jonQKuxngiFBH51xxQ+j0PE97IveTC5Ph
        C02sVYfsFTdObwfEFvPNsS3jYuz22S8=
Content-Language: en-US
In-Reply-To: <20221102105530.1795429-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On 11/2/22 06:55, Sebastian Andrzej Siewior wrote:
> Hi,
>
> while playing with cgroups and tasks which alter their CPU-mask I
> noticed a behaviour which is unwanted:
> - Upon enabling the cpuset controller, all currently set CPU-mask are
>    changed. Here one could argue how bad it is assuming that the
>    controller gets only enabled once during boot.
>
> - While having a task limited to only one CPU (or more but a subset of
>    the cpuset's mask) then adding an additional CPU (or removing an
>    unrelated CPU) from that cpuset results in changing the CPU-mask of
>    that task and adding additional CPUs.
>
> The test used to verify the behaviour:
>
> # Limit to CPU 0-1
> $ taskset -pc 0-1 $$
> # Enable the cpuset controller
> $  echo "+cpu" >> /sys/fs/cgroup/cgroup.subtree_control ; echo "+cpuset" >> /sys/fs/cgroup/cgroup.subtree_control
>
> # Query the CPU-mask. Expect to see 0-1 since it is a subset of
> # all-online-CPUs
> $ taskset -pc $$
>
> # Update the mask to CPUs 1-2
> $ taskset -pc 1-2 $$
>
> # Change the CPU-mask of the cgroup to CPUs 1-3.
> $ echo 1-3 > /sys/fs/cgroup/user.slice/cpuset.cpus
> # Expect to see 1-2 because it is a subset of 1-3
> $ taskset -pc $$
>
> # Change the CPU-mask of the cgroup to CPUs 2-3.
> $ echo 2-3 > /sys/fs/cgroup/user.slice/cpuset.cpus
> # Expect to see 2-3 because CPU 1 is not part of 2-3
> $ taskset -pc $$
>
> # Change the CPU-mask of the cgroup to CPUs 2-4.
> $ echo 2-4 > /sys/fs/cgroup/user.slice/cpuset.cpus
> # Expect to see 2-4 because task's old CPU-mask matches the old mask of
> # the cpuset.
> $ taskset -pc $$
>
> Posting this as RFC in case I'm missing something obvious or breaking an
> unknown (to me) requirement that this series would break.

Yes, that is a known issue which is especially problematic when cgroup 
v2 is used. That is why I have recently posted a set of patches to 
enable persistent user requested affinity and they have been merged into 
tip:

851a723e45d1 sched: Always clear user_cpus_ptr in do_set_cpus_allowed()
da019032819a sched: Enforce user requested affinity
8f9ea86fdf99 sched: Always preserve the user requested cpumask
713a2e21a513 sched: Introduce affinity_context
5584e8ac2c68 sched: Add __releases annotations to affine_move_task()

They should be able to address the problem that you list here. Please 
let me know if there are still problem remaining.

Thanks,
Longman

