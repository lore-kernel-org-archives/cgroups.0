From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup/cpuset: Optimize cpuset_attach() on v2
Date: Wed, 23 Nov 2022 16:19:44 +0100
Message-ID: <Y346ENzM4+FAjRnn@linutronix.de>
References: <20221112221939.1272764-1-longman@redhat.com>
 <20221112221939.1272764-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669216786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oTwzhKU9n4ncsH7FV/LSW7qnOCWI7kAJ1Y5x5I67+ZY=;
        b=RarddSxY8wubej+5CMsEi0c4ueQywT1Xj6BsflZ7pW0Q3OcLh2fBHBWi7eUN1tqNOwNV2x
        c01JSTuG16x8QV34k9HdUYZV9ZiYuvgZTcxQ3ePuamINLp2gKArsQShyxgKzW9afIeLBRN
        zQjRVJXWuH0JXaEd5tEy3DQtUiabK0RhA0HC3xPoNsJDtf9GbAMLEMN9fI4JqgXt4ifh0f
        H5rTILxPo1GeT8xST2ZLqY9jrEQSZxnVdsw7JEn/uRXgmpl2MpHF0dpktPDqZDRounwffN
        pm0jxzXeAvDljQ4arTP1+T6Xz/eqxyyZ1IUEJMFeSCrZXFRQ5WcUTgovVZpquw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669216786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oTwzhKU9n4ncsH7FV/LSW7qnOCWI7kAJ1Y5x5I67+ZY=;
        b=jDl6R+HoPDbfmAaXlS5ltWdEQcWIFx2SBmdf9vr/0n1PVc+h+OAhbp9dtDAHm/pjrJBaVk
        Mwez3VfTMJ13etDg==
Content-Disposition: inline
In-Reply-To: <20221112221939.1272764-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2022-11-12 17:19:39 [-0500], Waiman Long wrote:
> It was found that with the default hierarchy, enabling cpuset in the
> child cgroups can trigger a cpuset_attach() call in each of the child
> cgroups that have tasks with no change in effective cpus and mems. If
> there are many processes in those child cgroups, it will burn quite a
> lot of cpu cycles iterating all the tasks without doing useful work.

Thank you.

So this preserves the CPU mask upon attaching the cpuset container.

| ~# taskset -pc $$
| pid 1564's current affinity list: 0-2

default mask after boot due to isolcpus=

| ~# echo "+cpu" >> /sys/fs/cgroup/cgroup.subtree_control ; echo "+cpuset" >> /sys/fs/cgroup/cgroup.subtree_control
| ~# taskset -pc $$
| pid 1564's current affinity list: 0-2

okay.

| ~# echo 1-3 > /sys/fs/cgroup/user.slice/cpuset.cpus
| ~# taskset -pc $$
| pid 1564's current affinity list: 1-3

wiped away.

| ~# taskset -pc 2-3 $$ 
| pid 1564's current affinity list: 1-3
| pid 1564's new affinity list: 2,3
| ~# echo 2-4 > /sys/fs/cgroup/user.slice/cpuset.cpus
| ~# taskset -pc 2-3 $$ 
| pid 1564's current affinity list: 2,3
| pid 1564's new affinity list: 2,3

But it works if the mask was changed on purpose.

Sebastian
