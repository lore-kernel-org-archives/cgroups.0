From: Chris Down <chris@chrisdown.name>
Subject: Re: [RFC PATCH 1/8] memcg: Enable fine-grained control of over
 memory.high action
Date: Mon, 17 Aug 2020 17:11:32 +0100
Message-ID: <20200817161132.GA5171@chrisdown.name>
References: <20200817140831.30260-1-longman@redhat.com>
 <20200817140831.30260-2-longman@redhat.com>
 <20200817143044.GA1987@chrisdown.name>
 <934e4bc3-bab6-b19a-49f9-6a6ae8638570@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=EPZNWjTuoNbn3/0iITSmRZt5ivNwv7BWW6z1AtL/Hmc=;
        b=Z23cJzvoZmVLpOK2aT+f4XT4iV2NnQq1w6sWZWEGLYa39+S+I66Qx1sJuEz0lgvGq1
         9MafbfOp+fkSCLAdwkxY3sqWfa/7Ya+r03VJzdWTWGLlMGY81AwTZ2a03DaIZWFHcudU
         YK2AWWX4x4DALRmK9f7+jCQ+8hCmXiM0ppCuA=
Content-Disposition: inline
In-Reply-To: <934e4bc3-bab6-b19a-49f9-6a6ae8638570@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Waiman Long <longman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

Waiman Long writes:
>On 8/17/20 10:30 AM, Chris Down wrote:
>>Astractly, I think this really overcomplicates the API a lot. If=20
>>these are truly generally useful (and I think that remains to be=20
>>demonstrated), they should be additions to the existing API, rather=20
>>than a sidestep with prctl.
>This patchset is derived from customer requests. With existing API, I=20
>suppose you mean the memory cgroup API. Right? The reason to use=20
>prctl() is that there are users out there who want some kind of=20
>per-process control instead of for a whole group of processes unless=20
>the users try to create one cgroup per process which is not very=20
>efficient.

If using one cgroup per process is inefficient, then that's what needs to b=
e=20
fixed. Making the API extremely complex to reason about for every user isn'=
t a=20
good compromise when we're talking about an already niche use case.

>>I also worry about some other more concrete things:
>>
>>1. Doesn't this allow unprivileged applications to potentially=20
>>bypass =A0=A0 memory.high constraints set by a system administrator?
>The memory.high constraint is for triggering memory reclaim. The new=20
>mitigation actions introduced by this patchset will only be applied if=20
>memory reclaim alone fails to limit the physical memory consumption.=20
>The current memory cgroup memory reclaim code will not be affected by=20
>this patchset.

memory.high isn't only for triggering memory reclaim, it's also about activ=
e=20
throttling when the application fails to come under. Fundamentally it's=20
supposed to indicate the point at which we expect the application to either=
=20
cooperate or get forcibly descheduled -- take a look at where we call=20
schedule_timeout_killable.

I really struggle to think about how all of those things should interact in=
=20
this patchset.

>>2. What's the purpose of PR_MEMACT_KILL, compared to memory.max?
>A user can use this to specify which processes are less important and=20
>can be sacrificed first instead of the other more important ones in=20
>case they are really in a OOM situation. IOW, users can specify the=20
>order where OOM kills can happen.

You can already do that with something like oomd, which has way more=20
flexibility than this. Why codify this in the kernel instead of in a usersp=
ace=20
agent?
