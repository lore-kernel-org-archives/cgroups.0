From: yulei zhang <yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/1] Introduce new attribute "priority" to control group
Date: Fri, 9 Apr 2021 00:49:30 +0800
Message-ID: <CACZOiM0xA+6kAeM2sk3SfVV9Vu+5dOzC7APoNmB0Zw3jQKbg+w@mail.gmail.com>
References: <cover.1617355387.git.yuleixzhang@tencent.com> <YGn3iHBp5UweFv2/@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BvgEZr+K7yzxkeeyCsAz2iteiOgpmUKfpWfzbHaQazM=;
        b=GM0Wm4vFW/wf2eICOC4yCXvbYGJwlw9Qzt8P3f39zrRJ6Gza4ov6DMssm5SoYpypYQ
         ejN+t5t7XH1HFSXNTlX+8YT+tcY6j+DnuxieEZsXpF7TqjI7aoLMPCvN5XTXl5z89ddw
         aOxex4Y4omGcHPFpe+7B/rEQJx+Wz4Fe8JPKPwTR1HbRrWwJTBxXyvZkFYoxmeEdmf70
         DCPwDo1keA2LHj6ufy6XOIXsSlLF0zbDqcQ5d/vfgkY//tbOIZqru1jm0YvwwUWatsxe
         HipsoNE2hu8vclcBy+TtkXtrPgYu7K7VTICtJ9+DMrFSBRSleeBivrlHYJ4/faSPFVGD
         HgzA==
In-Reply-To: <YGn3iHBp5UweFv2/@mtj.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Wanpeng Li <kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haiwei Li <lihaiwei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linussli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, herberthbli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, lennychen-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, allanyuliu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Mon, Apr 5, 2021 at 1:29 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Sun, Apr 04, 2021 at 10:51:53PM +0800, yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> > From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> >
> > This patch is the init patch of a series which we want to present the idea
> > of prioritized tasks management. As the cloud computing introduces intricate
> > configurations to provide customized infrasturctures and friendly user
> > experiences, in order to maximum utilization of sources and improve the
> > efficiency of arrangement, we add the new attribute "priority" to control
> > group, which could be used as graded factor by subssystems to manipulate
> > the behaviors of processes.
> >
> > Base on the order of priority, we could apply different resource configuration
> > strategies, sometimes it will be more accuracy instead of fine tuning in each
> > subsystem. And of course to set fundamental rules, for example, high priority
> > cgroups could seize the resource from cgroups with lower priority all the time.
> >
> > The default value of "priority" is set to 0 which means the highest
> > priority, and the totally levels of priority is defined by
> > CGROUP_PRIORITY_MAX. Each subsystem could register callback to receive the
> > priority change notification for their own purposes.
> >
> > We would like to send out the corresponding features in the coming weeks,
> > which are relaying on the priority settings. For example, the prioritized
> > oom, memory reclaiming and cpu schedule strategy.
>
> We've been trying really hard to give each interface semantics which is
> logical and describable independent of the implementation details. This runs
> precisely against that.
>
> Thanks.
>
> --
> tejun

Thanks for the feedback. I am afraid that I didn't express myself clearly
about the idea of the priority attribute. We don't want to overwrite
the semantics
for each interface in cgroup, just hope to introduce another factor that could
help us apply the management strategy. For example, In our production
environment
K8s has its own priority class to implement the Qos, and it will be
very helpful
if control group could provide corresponding priority to assist the
implementation.
-Yulei
