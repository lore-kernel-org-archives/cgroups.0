From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 1/8] memcg: Enable fine-grained control of over
 memory.high action
Date: Tue, 18 Aug 2020 15:12:22 -0400
Message-ID: <d55bc1b8-da20-0366-8a54-d7dc6e2cc21d@redhat.com>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200817140831.30260-2-longman@redhat.com>
 <CALvZod5V3N3K9-tDoaq=JgkeuAK=0TkRf97Vua0khXL+Lxw+Pg@mail.gmail.com>
 <20200817165608.GA58383@chrisdown.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597777954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FrkRbCQkgSp3Ii7GT5sFQHM/1w0xlNAEg5ZSV7ZGgc4=;
        b=b8KHYQtHBq2B9ji6dQRr9xx6Op6RSqo4KBr0yvWj2XzAIFAaHQILHh4BbESzcmy4WjXFDs
        nOGDP4GuO+eMhcs4OZiT8gOc9UI4b6UKGnN7KLO4ii0GzHhhUs27LEJANoCR4V6Iwcqytt
        DsR5tG3sBYH7g2kF6LFKIzXNgjpTnP4=
In-Reply-To: <20200817165608.GA58383@chrisdown.name>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Chris Down <chris@chrisdown.name>, Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On 8/17/20 12:56 PM, Chris Down wrote:
> Shakeel Butt writes:
>>> Sometimes, memory reclaim may not be able to recover memory in a rate
>>> that can catch up to the physical memory allocation rate especially
>>> when rotating disks are used for swapping or writing dirty pages. In
>>> this case, the physical memory consumption will keep on increasing.
>>
>> Isn't this the real underlying issue? Why not make the guarantees of
>> memory.high more strict instead of adding more interfaces and
>> complexity?
>
> Oh, thanks Shakeel for bringing this up. I missed this in the original 
> changelog and I'm surprised that it's mentioned, since we do have 
> protections against that.
>
> Waiman, we already added artificial throttling if memory reclaim is 
> not sufficiently achieved in 0e4b01df8659 ("mm, memcg: throttle 
> allocators when failing reclaim over memory.high"), which has been 
> present since v5.4. This should significantly inhibit physical memory 
> consumption from increasing. What problems are you having with that? :-)
>
Oh, I think I overlooked your patch. You are right. There are already 
throttling in place. So I need to re-examine my patch to see if it is 
still necessary or reduce the scope of the patch.

Thanks,
Longman

