From: Chris Down <chris@chrisdown.name>
Subject: Re: [RFC PATCH 1/8] memcg: Enable fine-grained control of over
 memory.high action
Date: Mon, 17 Aug 2020 17:56:08 +0100
Message-ID: <20200817165608.GA58383@chrisdown.name>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200817140831.30260-2-longman@redhat.com>
 <CALvZod5V3N3K9-tDoaq=JgkeuAK=0TkRf97Vua0khXL+Lxw+Pg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Sre2n1Pi8KkTqGTv1s6yeby+p8079BRqjBOJcwiSLww=;
        b=e0lnhMNX4rbCpfxhO+gQeYAWXdMT9zu80lFA0njs6xwsW1qMBlgAAwdV2fB0ZrDmbI
         DJwU3H9e/x24KArsI3bcQm9YF2fnooWNYRP2u0lBlOJpfLosNy8hnAKjfFXmNtk1tfH5
         iHxLc3XXadcqboQN3EKUpEvNmXTEMAqp2DHM4=
Content-Disposition: inline
In-Reply-To: <CALvZod5V3N3K9-tDoaq=JgkeuAK=0TkRf97Vua0khXL+Lxw+Pg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Waiman Long <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

Shakeel Butt writes:
>> Sometimes, memory reclaim may not be able to recover memory in a rate
>> that can catch up to the physical memory allocation rate especially
>> when rotating disks are used for swapping or writing dirty pages. In
>> this case, the physical memory consumption will keep on increasing.
>
>Isn't this the real underlying issue? Why not make the guarantees of
>memory.high more strict instead of adding more interfaces and
>complexity?

Oh, thanks Shakeel for bringing this up. I missed this in the original 
changelog and I'm surprised that it's mentioned, since we do have protections 
against that.

Waiman, we already added artificial throttling if memory reclaim is not 
sufficiently achieved in 0e4b01df8659 ("mm, memcg: throttle allocators when 
failing reclaim over memory.high"), which has been present since v5.4. This 
should significantly inhibit physical memory consumption from increasing. What 
problems are you having with that? :-)
