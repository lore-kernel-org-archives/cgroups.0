From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH for-4.6] cgroup: ignore css_sets associated with dead
 cgroups during migration
Date: Wed, 16 Mar 2016 13:29:17 -0700
Message-ID: <20160316202917.GD21104@mtj.duckdns.org>
References: <20160316004304.GC3447@mtj.duckdns.org>
 <20160316104527.GG25010@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Gl0cIpzbRfUi5JJ8o8eJE30+r2TvFBhbafn+g6gFgvQ=;
        b=mbXdbdUo7nRrybGbJ5p0eT13NPRJACpF5xB2N5lW2Fa2iB9cUpDXrVBg6gSq64g9C3
         Ysi8ynEdom/8QH3NcxxT6S1D8DRvZbUClOUgBBJ1aLkdC0fzkrELkfceyUhDyRb5jl+n
         D9eHz9NLUQwYn+/9VKDmcgOJo62mgpYkBZH5AdDZnT3Wz7xPsWqIDkRKi3KabjlgC+sa
         JG9xfD9ulEjM9G40MHlc1gz0FLvSqFvqJliVruXxJ+PQvKifWAE46u/NY9/Nvd7xXoE/
         U8ErQJO9bk/4wzA3EHDAt4WGpCt0iodtsqf0O2TGwgu7z3NE/qcw+wKg9U+d+ypfYQZZ
         8fHQ==
Content-Disposition: inline
In-Reply-To: <20160316104527.GG25010@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Mar 16, 2016 at 11:45:27AM +0100, Peter Zijlstra wrote:
> This doesn't fix the problem that those zombies might actually still
> want to use the cgroups they're tied to, as reported here:
> 
>   lkml.kernel.org/r/20160314112057.GT6356@twins.programming.kicks-ass.net
> 
> I would strongly suggest to revert 2e91fa7f6d45 wholesale (and mark for
> stable) and try again later.

For the record, this issue was caused by the cpu controller taking
down its css too early during destruction at ->css_offline() and is
fixed by switching to ->css_released() instead.

Thanks.

-- 
tejun
