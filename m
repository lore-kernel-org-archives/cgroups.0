From: peterz@infradead.org
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Tue, 18 Aug 2020 12:18:44 +0200
Message-ID: <20200818101844.GO2674@hirez.programming.kicks-ass.net>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
 <20200818092617.GN28270@dhcp22.suse.cz>
 <20200818095910.GM2674@hirez.programming.kicks-ass.net>
 <20200818100516.GO28270@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HP1xqIyJ0Z2PoaT6LGQfex8u1OM0JhiMqZ+Gafs9dGw=; b=d/+duAZaAzefByp0XFpldd9XZZ
        jb+OHF+tlem68S9hFSgzLn8Lv930zbK8UGuObZMxRQkG8PQodkdob/LCun4ESFOfTCVmTlpEYtAyN
        L7xKkWBAaw6dkyz3SH1NbPjVWjqOnR0JALmHyBepqV2JsNZMGGqSqOqrq3ANaQ8FHNtRmWAGdhGY8
        CxYR1esL35L+rLFC+fmRgkdP202MA8VJOooRf6uPDxbrwSO66qa1GSQXfkCpydHmHkzF1rAvHCGVR
        OJ8BXBD6e9EFiG9Qr/FobVl2ssBynzUAwK6/mIbz+B5rNph2oywm4zIIHKlcVLe7ezr5ugiaNHrVn
        PgFwbcKw==;
Content-Disposition: inline
In-Reply-To: <20200818100516.GO28270@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Waiman Long <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue, Aug 18, 2020 at 12:05:16PM +0200, Michal Hocko wrote:
> > But then how can it run-away like Waiman suggested?
> 
> As Chris mentioned in other reply. This functionality is quite new.
>  
> > /me goes look... and finds MEMCG_MAX_HIGH_DELAY_JIFFIES.
> 
> We can certainly tune a different backoff delays but I suspect this is
> not the problem here.

Tuning? That thing needs throwing out, it's fundamentally buggered. Why
didn't anybody look at how the I/O drtying thing works first?

What you need is a feeback loop against the rate of freeing pages, and
when you near the saturation point, the allocation rate should exactly
match the freeing rate.

But this thing has nothing what so ever like that.
