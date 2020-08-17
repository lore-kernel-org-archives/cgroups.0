From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [RFC PATCH 1/8] memcg: Enable fine-grained control of over
 memory.high action
Date: Mon, 17 Aug 2020 09:44:42 -0700
Message-ID: <CALvZod5V3N3K9-tDoaq=JgkeuAK=0TkRf97Vua0khXL+Lxw+Pg@mail.gmail.com>
References: <20200817140831.30260-1-longman@redhat.com> <20200817140831.30260-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ustc/Co8E0AQhbcerO/qjyS5RAvKGH1AciZ7eOvqsmA=;
        b=c+qkjdRRVAF0xvWA9+DkkVLwK7sGF1z8hQM3CtGa1YD+bJI6w1nj5+9S70Q8FvCQqi
         2Ei0s13pec+cTVm+0OSOFIdw7vP7XLcSIvUcZ6EGrALSHKiZ7PPGzM4XEb029aajiYyC
         aEhBUOpbzPBTQSG4Cdn7X1BjMfLQqn745I4HqH3Abk31kJgYxjgeUpKk7qwB2tzxmqpe
         AtkUyANm5zAbjaLbrp8RlEB5I2UccCxi0HQae47ThK7uHUPNGSHd8fX+Y3ltxcsiL9Kl
         3ENiFhFOnYGf8LXV3bRXJi1SUgcycpC5v7MIYDrXtB34VmBj+Nk2YpIHRR25BtbB6i8Q
         lRBw==
In-Reply-To: <20200817140831.30260-2-longman@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On Mon, Aug 17, 2020 at 7:11 AM Waiman Long <longman@redhat.com> wrote:
>
> Memory controller can be used to control and limit the amount of
> physical memory used by a task. When a limit is set in "memory.high"
> in a non-root memory cgroup, the memory controller will try to reclaim
> memory if the limit has been exceeded. Normally, that will be enough
> to keep the physical memory consumption of tasks in the memory cgroup
> to be around or below the "memory.high" limit.
>
> Sometimes, memory reclaim may not be able to recover memory in a rate
> that can catch up to the physical memory allocation rate especially
> when rotating disks are used for swapping or writing dirty pages. In
> this case, the physical memory consumption will keep on increasing.

Isn't this the real underlying issue? Why not make the guarantees of
memory.high more strict instead of adding more interfaces and
complexity?

By the way, have you observed this issue on real workloads or some
test cases? It would be good to get a repro with simple test cases.
