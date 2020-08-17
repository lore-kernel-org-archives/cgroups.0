From: Chris Down <chris@chrisdown.name>
Subject: Re: [RFC PATCH 1/8] memcg: Enable fine-grained control of over
 memory.high action
Date: Mon, 17 Aug 2020 15:30:44 +0100
Message-ID: <20200817143044.GA1987@chrisdown.name>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200817140831.30260-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=njqeGiWtXLg5+jOB3X5A+tJKa5oFt5uNxmm5GwqrJhw=;
        b=qMjHrx7t7+r44ug3VoLGOer7utNoQQG6VakgF8M2r1F1bVok4SFkN/vtuqLMQN/+jq
         in9MgdaZlN/g1nheeMXL0M1J7mEy0Ben0ZovQ/Es3wg1c8xsOXS9Z6p1XfiOBl273060
         R5XLxrqxPBXuoAlHrseGf5+k0UeOXGw1BjnIQ=
Content-Disposition: inline
In-Reply-To: <20200817140831.30260-2-longman@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

Astractly, I think this really overcomplicates the API a lot. If these are 
truly generally useful (and I think that remains to be demonstrated), they 
should be additions to the existing API, rather than a sidestep with prctl.

I also worry about some other more concrete things:

1. Doesn't this allow unprivileged applications to potentially bypass 
    memory.high constraints set by a system administrator?
2. What's the purpose of PR_MEMACT_KILL, compared to memory.max?
3. Why add this entirely separate signal delivery path when we already have 
    eventfd/poll/inotify support, which makes a lot more sense for modern 
    applications?
