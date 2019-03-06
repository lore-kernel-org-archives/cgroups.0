From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sched/core: check format and overflows in cgroup2 cpu.max
Date: Wed, 6 Mar 2019 08:11:54 -0800
Message-ID: <20190306161154.GF50184@devbig004.ftw2.facebook.com>
References: <155125520155.293746.7017401430432481979.stgit@buzz>
 <20190305155741.GD50184@devbig004.ftw2.facebook.com>
 <4c0f1d90-b147-e1cd-20c1-0cdd869f4f15@yandex-team.ru>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j2ShychGTMUsUT8Zfh0SFhrOWqGhIAMgWTkjKkiV4qg=;
        b=L7gfRNkxcA5vWx7QJVX4sBp0N3pcNjxGTwMViloTi6CFxQyN0OjRLX90j18nNi2Kyn
         itmCaheEvuQKqTP+5l/5PBBRR8GSXDjGrkwxpYcZCFr+K/f3kNa/Wuacyh6M2k/Gr8XX
         g/RgwSGKcBq04OJi++uh7hFLDLhzk7YV4QjXy3ggHqTCzWjLWP00cLz1CWqPl2hArcYm
         pwAZNDuUSxdTbTiS20+K0nFEp9AK8ZG7KcIIlS5cQL7L5qESyGaB248LrhpcceSL1n/P
         sHaSeUdasPc1VDzhNd0N88XQO8z+DnUQtEQl18RwGoUsWYmKzn+bD/WiZC3DuBqpSk2t
         pWJg==
Content-Disposition: inline
In-Reply-To: <4c0f1d90-b147-e1cd-20c1-0cdd869f4f15@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>

Hello, Konstantin.

On Tue, Mar 05, 2019 at 08:03:24PM +0300, Konstantin Khlebnikov wrote:
> >Ditto as the blkio patch.  Unless there is a correctness problem, my
> >preference is towards keeping the parsing functions simple and I don't
> >think the kernel needs to play the role of strict input verifier here
> >as long as the only foot getting shot is the user's own.
> 
> IMHO non-strict interface more likely hides bugs and could cause
> problems for future changes.
> 
> Here is only only one fatal bug - buffer overflow in sscanf because
> %s has no limit.

Ah, indeed.  Can you please post a patch to fix that problem first?

> Strict validation could be done as more strict sscanf variant or
> some kind of extension for format string.

I don't necessarily disagree with you; however, what often ends up
with these manually crafted parsing approach are 1. code which is
unnecessarily difficult to follow 2. different subset of validations
and parsing bugs (of course) everywhere.

Given the above, I tend to lean towards dump sscanf() parsing.  If we
wanna improve the situation, I think the right thing to do is either
improving sscanf or introducing new helpers to parse these things
rather than hand-crafting each site.  It is really error-prone.

Thanks.

-- 
tejun
