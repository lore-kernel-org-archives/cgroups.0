From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v3 1/2] mm/memcg: try harder to decrease [memory,memsw].limit_in_bytes
Date: Tue, 9 Jan 2018 09:22:53 -0800
Message-ID: <CALvZod4WCsrcx+Zrj9pNSoJFyhB7_5OZxBxT_kiy0unprKMdcA@mail.gmail.com>
References: <20171220135329.GS4831@dhcp22.suse.cz> <20180109165815.8329-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=f3+vKTfCZ5BU2ia71DuqgJ2Tw8n+e7Jb7VHuriGpktc=;
        b=Buw8cKItLsqLJCBEalxSiZwsTkOvOW+P4Z0vgLBDuhEiHWbNK3Gned31Vk5ywejtWL
         45Oy5e2/IIQ/oiDnx7UPYNaxx2L45KBf8u9OVb2VQzyxvuiyVX7f1+oZfbhyDFMKRxzf
         x1uvXNNiX84YtJ+0Wh2w4a/vxHDe99m/DmqtcViHfQDKhRJKWf5E1G4EixeJ1Ypgh4/K
         h+IxNc7lm8GCvH8qXt1NoFYsXy3GSyjNAdDgWTzoQ6d4ImMx7c5IYxzhMxFC+p4ZE6H0
         oYs+peP5GXT3XI/Yufo0GLY4wZU3hJiZFXtfwq+d3pAZy/3hIGQ2DwHXV7v1C4GBMaJo
         38OA==
In-Reply-To: <20180109165815.8329-1-aryabinin@virtuozzo.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, Jan 9, 2018 at 8:58 AM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
> mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
> pages on each iteration. This makes practically impossible to decrease
> limit of memory cgroup. Tasks could easily allocate back 32 pages,
> so we can't reduce memory usage, and once retry_count reaches zero we return
> -EBUSY.
>
> Easy to reproduce the problem by running the following commands:
>
>   mkdir /sys/fs/cgroup/memory/test
>   echo $$ >> /sys/fs/cgroup/memory/test/tasks
>   cat big_file > /dev/null &
>   sleep 1 && echo $((100*1024*1024)) > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>   -bash: echo: write error: Device or resource busy
>
> Instead of relying on retry_count, keep retrying the reclaim until
> the desired limit is reached or fail if the reclaim doesn't make
> any progress or a signal is pending.
>
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
