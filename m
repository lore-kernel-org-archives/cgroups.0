From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] Documentation: Clarify usage of memory limits
Date: Thu, 1 Jun 2023 15:53:45 -0400
Message-ID: <20230601195345.GB157732@cmpxchg.org>
References: <20230601183820.3839891-1-schatzberg.dan@gmail.com>
 <e6ae97f4-cdae-e655-d118-a11b3d679fd6@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1685649226; x=1688241226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w3wsMJdspm7z8NQJJLLZwkqA93PAgwpcnaWodZ7jv3E=;
        b=zyyOiaeKEXDVRnfiSYoFMNi6zsJHqBMzLi1N71yQ7rl7aeNEFHJXtP/mYtCzWz4vS4
         xsz4tLWaE8JItcAX+DEptMCyTHfeB9DRdmrgQlGvcnH6Yl/FDqrvnM7uIBOc57vAd36K
         893GToJbh29EIbLSuehhEcEzgR44PkZ4HJ6WbDP5o9bnyLxjQLoqrSBeaSn8POUq+7B+
         +mW6QF5qavI2dyw2VQsbJ8bHGPBZdxwt9/ZLNlul87Bxzps2UybEE9KXZqNJbAPlyNZL
         exbRvpQrRHE2RtkiVYlsJLqQ5c7NZKsHEGeKJBQa++X3ICWdJXUyXTTjBt7iNaSO80G8
         /3IA==
Content-Disposition: inline
In-Reply-To: <e6ae97f4-cdae-e655-d118-a11b3d679fd6@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, Tejun Heo <tj@kernel.org>, Chris Down <chris@chrisdown.name>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

On Thu, Jun 01, 2023 at 03:15:28PM -0400, Waiman Long wrote:
> On 6/1/23 14:38, Dan Schatzberg wrote:
> > The existing documentation refers to memory.high as the "main mechanism
> > to control memory usage." This seems incorrect to me - memory.high can
> > result in reclaim pressure which simply leads to stalls unless some
> > external component observes and actions on it (e.g. systemd-oomd can be
> > used for this purpose). While this is feasible, users are unaware of
> > this interaction and are led to believe that memory.high alone is an
> > effective mechanism for limiting memory.
> > 
> > The documentation should recommend the use of memory.max as the
> > effective way to enforce memory limits - it triggers reclaim and results
> > in OOM kills by itself.
> 
> That is not how my understanding of memory.high works. When memory usage
> goes past memory.high, memory reclaim will be initiated to reclaim the
> memory back. Stall happens when memory.usage keep increasing like by
> consuming memory faster than what memory reclaim can recover. When
> memory.max is reached, OOM killer will then kill off the tasks.

This was the initial plan indeed: Slow down the workload and thus slow
the growth; hope that the workload recovers with voluntary frees; set
memory.max as a safety if it keeps going beyond.

This never panned out. Once workloads are stuck, they might not back
down on their own. By increasingly slowing growth, it becomes harder
and harder for them to reach the memory.max intervention point.

It's a very brittle configuration strategy. Unless you very carefully
calibrate memory.high and memory.max together with awareness of the
throttling algorithm, workloads that hit memory.high will just go to
sleep indefinitely. They require outside intervention that either
adjusts limits or implements kill policies based on observed sleeps
(they're reported as pressure via psi).

So the common usecases today end up being that memory.max is for
enforcing kernel OOM kills, and memory.high is a tool to implement
userspace OOM killing policies.

Dan is right to point out the additional expectations for userspace
management when memory.high is in used. And memory.max is still the
primary, works-out-of-the-box method of memory containment.
