From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] memcg: always enable kmemcg on the default hierarchy
Date: Fri, 4 Sep 2015 12:18:45 -0400
Message-ID: <20150904161845.GB25329@mtj.duckdns.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-5-git-send-email-tj@kernel.org>
 <20150828164918.GJ9610@esperanza>
 <20150828171438.GD21463@dhcp22.suse.cz>
 <20150828174140.GN26785@mtj.duckdns.org>
 <20150901124459.GC8810@dhcp22.suse.cz>
 <20150901185157.GD18956@htj.dyndns.org>
 <20150904133038.GC8220@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5ioJntjPQssZn26i8ZlfWrNuMD7+eL6WzbuHgjSAn6I=;
        b=EXndCaaXv01xKMovn8qKF3Kru18M4+2GTRdRORFA3p6wDKPOqlYQNFF7/++F1Whygh
         uJXB2lhN0+uiaDfTbkKgRdBBtO5DMvTho2Bkjamnko4A4j88iYtd+A3w7FyXHprIb154
         B7ZRY2EKumpcz11L1hkvVTwu9P3gdSi0+8LO1PXn5XNLDUgh5uJxn4CGwlIFU6/dD9QL
         wMJnI5WmgK/Cw6OOW2/YFKQUlDDZUheB2rlyaP7QGPzFcTZz4x7veKMOZed4okG5oEFx
         Z8WwkNm8q296jpycjN+I4pV1FafWVhkoSI1aQdlGq77RLDn+ZFHLZ7kIyeSKkKsAmzuO
         cQCA==
Content-Disposition: inline
In-Reply-To: <20150904133038.GC8220@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

Hello, Michal.

On Fri, Sep 04, 2015 at 03:30:38PM +0200, Michal Hocko wrote:
> The overhead was around 4% for the basic kbuild test without ever
> triggering the [k]memcg limit last time I checked. This was quite some
> time ago and things might have changed since then. Even when this got
> better there will still be _some_ overhead because we have to track that
> memory and that is not free.

So, I just ran small scale tests and I don't see any meaningful
difference between kmemcg disabled and enabled for kbuild workload
(limit is never reached in both cases, memory is reclaimed from global
pressure).  The difference in kernel time usage.  I'm sure there's
*some* overhead buried in the noise but given the current
implementation, I can't see how enabling kmem would lead to 4%
overhead in kbuild tests.  It isn't that kernel intensive to begin
with.

> The question really is whether kmem accounting is so generally useful
> that the overhead is acceptable and it is should be enabled by
> default. From my POV it is a useful mitigation of untrusted users but
> many loads simply do not care because they only care about a certain
> level of isolation.

I don't think that's the right way to approach the problem.  Given
that the cost isn't prohibitive, no user only care about a certain
level of isolation willingly.  Distributing memory is what it's all
about after all and memory is memory, user or kernel.  We have kmem
on/off situation for historical reasons and because the early
implementation wasn't good enough to be enabled by default.  I get
that there can be special cases, temporary or otherwise, where
disabling kmem is desirable but that gotta be the exception, not the
norm.

> I might be wrong here of course but if the default should be switched it
> would deserve a better justification with some numbers so that people
> can see the possible drawbacks.
>
> I agree that the per-cgroup knob is better than the global one. We
> should also find consensus whether the legacy semantic of k < u limit
> should be preserved. It made sense to me at the time it was introduced
> but I recall that Vladimir found it not really helpful when we discussed
> that at LSF. I found it interesting e.g. for the rough task count
> limiting use case which people were asking for.

Let's please not hinge major design decisions on short-sighted hacks
and overhead considerations.  If task count is an actual resource
which needs to be regulated separatley, we should add a proper
controller for it and we did.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
