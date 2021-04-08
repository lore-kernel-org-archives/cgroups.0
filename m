From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 0/1] Introduce new attribute "priority" to control group
Date: Thu, 8 Apr 2021 13:58:20 -0700
Message-ID: <CALvZod6JagEjzkn+2hVg+npFp=+X5mv4GLWAH-QbvJFP=udtgA@mail.gmail.com>
References: <cover.1617355387.git.yuleixzhang@tencent.com> <YGn3iHBp5UweFv2/@mtj.duckdns.org>
 <CACZOiM0xA+6kAeM2sk3SfVV9Vu+5dOzC7APoNmB0Zw3jQKbg+w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xkxHhJqNProKhVzizVTFQYR4zVgXz8q4oP2NJJdcs/E=;
        b=XMaJZNgyutfANSdggd1yIuEbwRbGBdcUhhpTV4tyd52LO06noE0SU+OllRrBcwnLJS
         m4WRnbwddW+o5lMg+Obk+rHkHQui5eb8ooVFnFJxnx/kMYOXUwobOQ9C9PnIxtyGgXQe
         hbmxWxwHXWceC0OEUglJz1TOOvw97vEz3lU9SAKjLH1fQ3vo7LrdnM4tFqG7zBnmnp5h
         GxxuwrQXOrkX7EwCQJeD4bXRy/Rn0rbKTXOlesjAhbPNA+k/7JL851XuMKu0bT/CJucK
         1fUMWz9xCv5eJ1Mj+D9Cr3GBkWDIp9bgClgJ2x3A7NKe3UOxvPbChFcuLDcxOQTAaD5T
         EXUw==
In-Reply-To: <CACZOiM0xA+6kAeM2sk3SfVV9Vu+5dOzC7APoNmB0Zw3jQKbg+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Wanpeng Li <kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haiwei Li <lihaiwei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linussli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, herberthbli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, lennychen-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, allanyuliu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Thu, Apr 8, 2021 at 9:51 AM yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Mon, Apr 5, 2021 at 1:29 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Sun, Apr 04, 2021 at 10:51:53PM +0800, yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> > > From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> > >
> > > This patch is the init patch of a series which we want to present the idea
> > > of prioritized tasks management. As the cloud computing introduces intricate
> > > configurations to provide customized infrasturctures and friendly user
> > > experiences, in order to maximum utilization of sources and improve the
> > > efficiency of arrangement, we add the new attribute "priority" to control
> > > group, which could be used as graded factor by subssystems to manipulate
> > > the behaviors of processes.
> > >
> > > Base on the order of priority, we could apply different resource configuration
> > > strategies, sometimes it will be more accuracy instead of fine tuning in each
> > > subsystem. And of course to set fundamental rules, for example, high priority
> > > cgroups could seize the resource from cgroups with lower priority all the time.
> > >
> > > The default value of "priority" is set to 0 which means the highest
> > > priority, and the totally levels of priority is defined by
> > > CGROUP_PRIORITY_MAX. Each subsystem could register callback to receive the
> > > priority change notification for their own purposes.
> > >
> > > We would like to send out the corresponding features in the coming weeks,
> > > which are relaying on the priority settings. For example, the prioritized
> > > oom, memory reclaiming and cpu schedule strategy.
> >
> > We've been trying really hard to give each interface semantics which is
> > logical and describable independent of the implementation details. This runs
> > precisely against that.
> >
> > Thanks.
> >
> > --
> > tejun
>
> Thanks for the feedback. I am afraid that I didn't express myself clearly
> about the idea of the priority attribute. We don't want to overwrite
> the semantics
> for each interface in cgroup, just hope to introduce another factor that could
> help us apply the management strategy. For example, In our production
> environment
> K8s has its own priority class to implement the Qos, and it will be
> very helpful
> if control group could provide corresponding priority to assist the
> implementation.

IMHO the 'priority' is a high level concept mainly to define policies
and should not be part of user API. The meaning of priority changes
with each use-case and it can be more than one dimension. For example
I can have two jobs running on a machine. One is a batch and the
second is a latency sensitive job, let's say web server. For oom-kill
use-case, I might prefer to kill the web server as there will be
multiple instances running and the load balancer will redirect the
load. However for memory reclaim, I would prefer to reclaim from batch
as the cost of refaults in the web server is visible to end customers.

Basically we should have mechanisms in the kernel which can be used to
define and enforce high level priorities. I can set memory.low of the
web server to prefer reclaim from batch job. For oom-kill, Android's
lmkd and fb's oomd are the examples of user space oom-killer where
policies are in user space.
