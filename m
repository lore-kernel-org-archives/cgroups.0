From: peterz@infradead.org
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Tue, 18 Aug 2020 12:36:37 +0200
Message-ID: <20200818103637.GR2674@hirez.programming.kicks-ass.net>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
 <20200818092617.GN28270@dhcp22.suse.cz>
 <20200818095910.GM2674@hirez.programming.kicks-ass.net>
 <20200818100516.GO28270@dhcp22.suse.cz>
 <20200818101844.GO2674@hirez.programming.kicks-ass.net>
 <20200818103059.GP28270@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PxEaa92aYsiybSQz7oa3HYw1NYI/WkEv9koOqjkqg9g=; b=ZIG+qq8oCuBvwA6kUWik1qng6i
        gsAHaPDDaBpBiqmSE+bS+HV0Am2meWwZ/5N2iApKqvG82BvkrYckosoFUPFeVdtoPIGxRJLIGHG5t
        RE8DMo8VfBnHb1OVTyx9cXhLAtMAO79PAXH2sn7L5XgU7REAOmlfJIiASqIf6wGbS/Gxha5Z/XUzH
        OAVioWo7QCzixURvFN8KwYPR/N9gkEcppIQDoY6sqf/DVwzGAhiOVqeRqAshnGTklMfHCDo6ojldT
        7qUlMgUAAii5usQ4/2CQiOvYqv91YNC56GXLP24yc3ZhYTRLZsxbPnXU6bHz/Goss7ihx+L07PvAd
        TK+aRVPg==;
Content-Disposition: inline
In-Reply-To: <20200818103059.GP28270@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Waiman Long <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue, Aug 18, 2020 at 12:30:59PM +0200, Michal Hocko wrote:
> The proposal also aims at much richer interface to define the
> oom behavior.

Oh yeah, I'm not defending any of that prctl() nonsense.

Just saying that from a math / control theory point of view, the current
thing is a abhorrent failure.
