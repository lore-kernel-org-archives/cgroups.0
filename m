From: Chris Down <chris@chrisdown.name>
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Tue, 18 Aug 2020 11:35:39 +0100
Message-ID: <20200818103539.GA156577@chrisdown.name>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
 <20200818092617.GN28270@dhcp22.suse.cz>
 <20200818095910.GM2674@hirez.programming.kicks-ass.net>
 <20200818101756.GA155582@chrisdown.name>
 <20200818102616.GP2674@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qlc8i4WcaLGzjuzLCQuYqKKSVFT1SJwivNfqZW5VqT4=;
        b=D+AXs5u4icCFXOrccNIya9OfdiSVGHptiCbS4U4MtOZK/btvSa9eX8FVKZBh1negDV
         FemQeVyJCt8wUbC+K0euzqx7jvOmXbQm5Dn3nJcMx6aDQnmw0A/HkuGACqgYd2kPfJiG
         vdcnekXyohzB2PvtYEUWuln9SFWFdhspRM8oM=
Content-Disposition: inline
In-Reply-To: <20200818102616.GP2674@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org
Cc: Michal Hocko <mhocko@suse.com>, Waiman Long <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

peterz@infradead.org writes:
>On Tue, Aug 18, 2020 at 11:17:56AM +0100, Chris Down wrote:
>
>> I'd ask that you understand a bit more about the tradeoffs and intentions of
>> the patch before rushing in to declare its failure, considering it works
>> just fine :-)
>>
>> Clamping the maximal time allows the application to take some action to
>> remediate the situation, while still being slowed down significantly. 2
>> seconds per allocation batch is still absolutely plenty for any use case
>> I've come across. If you have evidence it isn't, then present that instead
>> of vague notions of "wrongness".
>
>There is no feedback from the freeing rate, therefore it cannot be
>correct in maintaining a maximum amount of pages.

memory.high is not about maintaining a maximum amount of pages. It's strictly 
best-effort, and the ramifications of a breach are typically fundamentally 
different than for dirty throttling.

>0.5 pages / sec is still non-zero, and if the free rate is 0, you'll
>crawl across whatever limit was set without any bounds. This is math
>101.
>
>It's true that I haven't been paying attention to mm in a while, but I
>was one of the original authors of the I/O dirty balancing, I do think I
>understand how these things work.

You're suggesting we replace a well understood, easy to reason about model with 
something non-trivially more complex, all on the back of you suggesting that 
the current approach is "wrong" without any evidence or quantification.

Peter, we're not going to throw out perfectly function memcg code simply 
because of your say so, especially when you've not asked for information or 
context about the tradeoffs involved, or presented any evidence that something 
perverse is actually happening.

Prescribing a specific solution modelled on some other code path here without 
producing evidence or measurements specific to the nuances of this particular 
endpoint is not a recipe for success.
