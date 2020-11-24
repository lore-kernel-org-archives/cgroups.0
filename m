From: Aaron Tomlin <atomlin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: add support to generate the total count of
 children from root
Date: Tue, 24 Nov 2020 13:36:00 +0000
Message-ID: <CANfR36hBxRsHV+JZfT6_RZRXBvCu0p=4xUOSxzco-BvrTEP37w@mail.gmail.com>
References: <20201124105836.713371-1-atomlin@redhat.com> <20201124112612.GV27488@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606224976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NmB+/CVA1mnMQlH6qVDGPxzbBFzcsBI6srHn67igccA=;
        b=gsV9KdM/YQkMxbJBYxOowUm3+1oWNEUVlQatMAZTy3tySUu90rTuYOtNtMoR8hmT3ElC1A
        kGyhRAAigowjx3Fwvv8HFIDlYSj01UQaGmfg9JMWgXwAGXG/DaaB7J5dh6y9mYAQkCj8fs
        mDSLFDs7mMI7SILqUHioJwuV4wy0W1w=
In-Reply-To: <20201124112612.GV27488-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, 24 Nov 2020 at 11:26, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Tue 24-11-20 10:58:36, Aaron Tomlin wrote:
> > Each memory-controlled cgroup is assigned a unique ID and the total
> > number of memory cgroups is limited to MEM_CGROUP_ID_MAX.
> >
> > This patch provides the ability to determine the number of
> > memory cgroups from the root memory cgroup, only.
> > A value of 1 (i.e. self count) is returned if there are no children.
> > For example, the number of memory cgroups can be established by
> > reading the /sys/fs/cgroup/memory/memory.total_cnt file.
>

Hi Michal,

> Could you add some explanation why is this information useful for
> userspace? Who is going to use it and why a simple scripting on top of
> cgroupfs is insufficient.

Thank you for your feedback.

Indeed, one can use a command/script to manually calculate this.
Having said that, one that creates a significant number of
memory-controlled cgroups may prefer a quick, simple and reliable method
to generate the aforementioned data, for management purposes only.
As such, I thought this patch might be particularly useful.

Kind regards,
-- 
Aaron Tomlin

