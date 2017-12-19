From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] mm: memcontrol: memory+swap accounting for cgroup-v2
Date: Tue, 19 Dec 2017 07:24:44 -0800
Message-ID: <20171219152444.GP3919388@devbig577.frc2.facebook.com>
References: <20171219000131.149170-1-shakeelb@google.com>
 <20171219124908.GS2787@dhcp22.suse.cz>
 <CALvZod5jU9vPoJaf44TVT0_HQpEESiELJU5MD_DDRbcOkPNQbg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JfAC+thC1gTW8Iojjrkcx0vLbQygKbMeE2RMN+uZgaM=;
        b=NH2iNAMKK2Ahq9/L0U56t6Q0mRW8u6SOYO7Hg8IdwTJjPGkZt395GbsmMYKna/TpLY
         IAp1/9k/PvSJauKEJnbtcaT8OaBQNqk4Cq4HvKk3RdJu/HcbA1JXll5OM6PJmz5T7BIt
         Ds4WQHo4gsyulsriop67UiZPbQyZig+ViffHisp9KoXH+WqIDEBECYVS+BbJxGMhYXcF
         8LHExdPzUovEogxiu4jRRkvY0mriGQgAGo0V/GhmiZqLVJytYJ5gN9Krpt/BObEl+49c
         LphkfqZnBSOu54NUfVpQT6rpY7V6kV+c5eOw7cVcGwKC2TsSw22sbJp4rH6iQnjC1F8M
         q4gg==
Content-Disposition: inline
In-Reply-To: <CALvZod5jU9vPoJaf44TVT0_HQpEESiELJU5MD_DDRbcOkPNQbg@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Li Zefan <lizefan@huawei.com>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org

Hello,

On Tue, Dec 19, 2017 at 07:12:19AM -0800, Shakeel Butt wrote:
> Yes, there are pros & cons, therefore we should give users the option
> to select the API that is better suited for their use-cases and

Heh, that's not how API decisions should be made.  The long term
outcome would be really really bad.

> environment. Both approaches are not interchangeable. We use memsw
> internally for use-cases I mentioned in commit message. This is one of
> the main blockers for us to even consider cgroup-v2 for memory
> controller.

Let's concentrate on the use case.  I couldn't quite understand what
was missing from your description.  You said that it'd make things
easier for the centralized monitoring system which isn't really a
description of a use case.  Can you please go into more details
focusing on the eventual goals (rather than what's currently
implemented)?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
