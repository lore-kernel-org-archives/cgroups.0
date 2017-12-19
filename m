From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [RFC PATCH] mm: memcontrol: memory+swap accounting for cgroup-v2
Date: Tue, 19 Dec 2017 09:23:29 -0800
Message-ID: <CALvZod5sWWBX69QovOeLBSx9vij7=5cmoSocdTUvh2Uq8=noyQ@mail.gmail.com>
References: <20171219000131.149170-1-shakeelb@google.com> <20171219124908.GS2787@dhcp22.suse.cz>
 <CALvZod5jU9vPoJaf44TVT0_HQpEESiELJU5MD_DDRbcOkPNQbg@mail.gmail.com> <20171219152444.GP3919388@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=SLmGlDW37+VqAgbmBvhmVAsZ1hF5+igALyCI09Q2LkM=;
        b=ngz9PEgRZla8Z+lBYJnrmEA/kflnospDDL3lj6ouRcZDv8nqi0kfNnFLtpZUU35G4i
         j1guOQcFG5IaBXG0GXpPcfZIQhs2nuvp4/xnCMv6h/pWTMNalWRAgoBTGWpPjJWqSZOw
         8BZ0p+0/czpdAPmKdZDRqzmuVZ9ynclWbBUdFTOzo9lja2b/MCH4u0EKwR/VruN82HzK
         6fGZxmmz/qZZtjZZFeQY+z14gXklannrJWPDS79QPrdwuxpBk2bhHdGhIYdFogYaFO+4
         e5gh0FaBKSx1TncP8RDOqwqMxBTlWyeNtqW8QV2GYk/D1q+z+IF577MX4U9iPBCCMrTy
         D9pg==
In-Reply-To: <20171219152444.GP3919388@devbig577.frc2.facebook.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>, Li Zefan <lizefan@huawei.com>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org

On Tue, Dec 19, 2017 at 7:24 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Dec 19, 2017 at 07:12:19AM -0800, Shakeel Butt wrote:
>> Yes, there are pros & cons, therefore we should give users the option
>> to select the API that is better suited for their use-cases and
>
> Heh, that's not how API decisions should be made.  The long term
> outcome would be really really bad.
>
>> environment. Both approaches are not interchangeable. We use memsw
>> internally for use-cases I mentioned in commit message. This is one of
>> the main blockers for us to even consider cgroup-v2 for memory
>> controller.
>
> Let's concentrate on the use case.  I couldn't quite understand what
> was missing from your description.  You said that it'd make things
> easier for the centralized monitoring system which isn't really a
> description of a use case.  Can you please go into more details
> focusing on the eventual goals (rather than what's currently
> implemented)?
>

The goal is to provide an interface that provides:

1. Consistent memory usage history
2. Consistent memory limit enforcement behavior

By consistent I mean, the environment should not affect the usage
history. For example, the presence or absence of swap or memory
pressure on the system should not affect the memory usage history i.e.
making environment an invariant. Similarly, the environment should not
affect the memcg OOM or memcg memory reclaim behavior.

To provide consistent memory usage history using the current
cgroup-v2's 'swap' interface, an additional metric expressing the
intersection of memory and swap has to be exposed. Basically memsw is
the union of memory and swap. So, if that additional metric can be
used to find the union. However for consistent memory limit
enforcement, I don't think there is an easy way to use current 'swap'
interface.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
