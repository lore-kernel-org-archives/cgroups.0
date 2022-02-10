From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 4/4] memcg: synchronously enforce memory.high
Date: Thu, 10 Feb 2022 15:29:23 -0800
Message-ID: <YgWf0wL5RoSpNrWn@carbon.dhcp.thefacebook.com>
References: <20220210081437.1884008-1-shakeelb@google.com>
 <20220210081437.1884008-5-shakeelb@google.com>
 <YgVyZrDPxVgP6OLG@carbon.dhcp.thefacebook.com>
 <CALvZod5xFmCVV_AZO1be8pYakmDvYh-QXmNYtTNT4zvCw-m4bQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=LDxavjBAtLlIiuVK0anxtJ929PlDwlRJ0qoJxwiRFRA=;
 b=E3IWEAzKwV+YvGSef8OBPfY5wm6aB/B1VKKS8et+XNkpnBZKVz9DiOY5WjdWnw2uipCt
 lilLZOP2EtkRbpM056TFAgB1Y1r4WBXxbflYQXZcep9Yp0jPdUIGJ5kbx24p97TA/cLc
 C/1uZFtkwyyVaD5xzywgEAiagoZbmkHU5Mk= 
Content-Disposition: inline
In-Reply-To: <CALvZod5xFmCVV_AZO1be8pYakmDvYh-QXmNYtTNT4zvCw-m4bQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Feb 10, 2022 at 02:22:36PM -0800, Shakeel Butt wrote:
> On Thu, Feb 10, 2022 at 12:15 PM Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> >
> [...]
> >
> > Has this approach been extensively tested in the production?
> >
> > Injecting sleeps at return-to-userspace moment is safe in terms of priority
> > inversions: a slowed down task will unlikely affect the rest of the system.
> >
> > It way less predictable for a random allocation in the kernel mode, what if
> > the task is already holding a system-wide resource?
> >
> > Someone might argue that it's not better than a system-wide memory shortage
> > and the same allocation might go into a direct reclaim anyway, but with
> > the way how memory.high is used it will happen way more often.
> >
> 
> Thanks for the review.
> 
> This patchset is tested in the test environment for now and I do plan
> to test this in production but that is a slow process and will take
> some time.
> 
> Let me answer the main concern you have raised i.e. the safety of
> throttling a task synchronously in the charge code path. Please note
> that synchronous memory reclaim and oom-killing can already cause the
> priority inversion issues you have mentioned. The way we usually
> tackle such issues are through userspace controllers. For example oomd
> is the userspace solution for catering such issues related to
> oom-killing. Here we have a similar userspace daemon monitoring the
> workload and deciding if it should let the workload grow or kill it.
> 
> Now should we keep the current high limit enforcement implementation
> and let it be ineffective for some real workloads or should we make
> the enforcement more robust and let the userspace tackle some corner
> case priority inversion issues. I think we should follow the second
> option as we already have precedence of doing the same for reclaim and
> oom-killing.

Well, in a theory it sounds good and I have no intention to oppose the
idea. However in practice we might easily get quite serious problems.
So I think we should be extra careful here. In the end we don't want to
pull and then revert this patch.

The difference between the system-wide direct reclaim and this case is that
usually kswapd is doing a good job of refilling the empty buffer, so we don't
usually work in the circumstances of the global memory shortage. And when we do,
often it's not working out quite well, this is why oomd and other similar
solutions are required.

Another option is to use your approach only for special cases (e.g. huge
allocations) and keep the existing approach for most other allocations.

Thanks!
