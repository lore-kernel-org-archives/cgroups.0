From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Tue, 18 Aug 2020 11:17:56 +0100
Message-ID: <20200818101756.GA155582@chrisdown.name>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
 <20200818092617.GN28270@dhcp22.suse.cz>
 <20200818095910.GM2674@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m1d0Rse+qIi8qOmerhrf+MBXKELTuAtcs3p/xFrqf9w=;
        b=s4u3GuRFjGb61CKAXSbV1lMqnOMke9WVYpJMh0BBQqdPfrVKbnnOMGI9JvyBbgPm6e
         x6rVvOlI1ANNxy8+m3bcc1IECDj2KsJGcWVy2WR+CvANx/bwNtWdEoEKDgNVzfp3pHop
         hA9rOJBnJ6hFK8QUbuzjs02965lEQZmkx0qyA=
Content-Disposition: inline
In-Reply-To: <20200818095910.GM2674-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org writes:
>But then how can it run-away like Waiman suggested?

Probably because he's not running with that commit at all. We and others use 
this to prevent runaway allocation on a huge range of production and desktop 
use cases and it works just fine.

>/me goes look... and finds MEMCG_MAX_HIGH_DELAY_JIFFIES.
>
>That's a fail... :-(

I'd ask that you understand a bit more about the tradeoffs and intentions of 
the patch before rushing in to declare its failure, considering it works just 
fine :-)

Clamping the maximal time allows the application to take some action to 
remediate the situation, while still being slowed down significantly. 2 seconds 
per allocation batch is still absolutely plenty for any use case I've come 
across. If you have evidence it isn't, then present that instead of vague 
notions of "wrongness".
