From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memcg: Enable fine-grained per process memory
 control
Date: Sat, 22 Aug 2020 22:49:19 -0400
Message-ID: <989570d6-639e-6385-d638-c4729665c2e4@redhat.com>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200818091453.GL2674@hirez.programming.kicks-ass.net>
 <20200818092617.GN28270@dhcp22.suse.cz>
 <20200818095910.GM2674@hirez.programming.kicks-ass.net>
 <20200818101756.GA155582@chrisdown.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598150971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TE0Zpj1FO1fCF2Nzd7hXL6TqjYYA4mP9yp1lb4isM3o=;
        b=JM5MxWv2runwv2RZGRyMKLt3iwn7rfxIb1bA4/ig6Z8sl4dQ2Rpm3AU4j9laospM+cNkBl
        xGALO70hsHC2IkWrCO1TyDdLiQ4EAmIbOBnuPtXTiUqBMaDxeWFHlUflUq5Jyf5p2OhvlA
        HlTRu3CGURoP/sq6tI19z0rbSsmAHXc=
In-Reply-To: <20200818101756.GA155582-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 8/18/20 6:17 AM, Chris Down wrote:
> peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org writes:
>> But then how can it run-away like Waiman suggested?
>
> Probably because he's not running with that commit at all. We and 
> others use this to prevent runaway allocation on a huge range of 
> production and desktop use cases and it works just fine.
>
>> /me goes look... and finds MEMCG_MAX_HIGH_DELAY_JIFFIES.
>>
>> That's a fail... :-(
>
> I'd ask that you understand a bit more about the tradeoffs and 
> intentions of the patch before rushing in to declare its failure, 
> considering it works just fine :-)
>
> Clamping the maximal time allows the application to take some action 
> to remediate the situation, while still being slowed down 
> significantly. 2 seconds per allocation batch is still absolutely 
> plenty for any use case I've come across. If you have evidence it 
> isn't, then present that instead of vague notions of "wrongness".
>
Sorry for the late reply.

I ran some test on the latest kernel and and it seems to work as 
expected. I was running the test on an older kernel that doesn't have 
this patch and I was not aware of it before hand.

Sorry for the confusion.

Cheers,
Longman

