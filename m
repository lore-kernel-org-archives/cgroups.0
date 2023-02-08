From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 2/2] sched/psi: iterate through cgroups directly
Date: Wed, 8 Feb 2023 23:03:19 +0100
Message-ID: <Y+QcJ2OvTmJzrObn@blackbook>
References: <20230208161654.99556-1-ryncsn@gmail.com>
 <20230208161654.99556-3-ryncsn@gmail.com>
 <Y+P0wLTdZcOPiKPZ@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675893802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RQV4Rg+rxKSLEejj3EobTgqtBroMYBCoiGQS4TDitEs=;
        b=H0iy8tmDDQdBeQtaT0hVpMy0C0LFYb0gfPffGYJgv/No4r1/lgD7VBtsFY5aekxWd8lN2x
        LvXJ4TZekdMl+ea3WPzw4EzBlSavSQ1JTYb/96HtR7QB+DdhrRRkQnb0FiIAlmwuwUZZNQ
        YW4x//NtUzWGuvK0OuIudgHgZ16mwu0=
Content-Disposition: inline
In-Reply-To: <Y+P0wLTdZcOPiKPZ@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>, Suren Baghdasaryan <surenb@google.com>, Chengming Zhou <zhouchengming@bytedance.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>

On Wed, Feb 08, 2023 at 02:15:12PM -0500, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Please name these psi_groups_first() and psi_groups_next().

One more suggestion: s/next/parent/ to avoid impression of (sub)tree
iteration and consistence with cg-related iters.

Thanks,
Michal

