From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcontrol: don't account swap failures not due
 to cgroup limits
Date: Thu, 2 Feb 2023 10:27:16 -0800
Message-ID: <CALvZod6m-XOb6LvjAD0wXv1doP_LJb1yUJ-QRpJt3H+G=xyQXg@mail.gmail.com>
References: <20230202155626.1829121-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pjDgomZIywp7e6CSQ2Vxhlha4qbmdscu2vXAz8lYKTA=;
        b=kBmTcd8o1o1lVFPHTCamTTlrH1XgzC6/Lm8P51JWY63/kZfoZBGAxxVnl7fM/nB325
         IxzufFGHbol1OmmWvAiywYQ+Fy1QBuXWrZwLlN1qQ9z7IxRm32vgeSaVK119yYYHHSqD
         TChuw3JNRefL7J6YRb8mNWhTuYUswyasUCYKhDwn09eouJjPhcFUN0BUZQV2duIsSs/+
         fYf40hTpoQqE25xwSQupwMUMWfX4lPXh6vDLt1AW/718EH/LIEdCdGVP5lsYKzieKxN9
         ASVVs6xST3c54vncqQG/W+tR2N8h6Dj53Uzd1jGD1vjnvlqo65wzLMf6u8eqeM5CeZar
         VTgw==
In-Reply-To: <20230202155626.1829121-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, Feb 2, 2023 at 7:56 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> Christian reports the following situation in a cgroup that doesn't
> have memory.swap.max configured:
>
>   $ cat memory.swap.events
>   high 0
>   max 0
>   fail 6218
>
> Upon closer examination, this is an ARM64 machine that doesn't support
> swapping out THPs. In that case, the first get_swap_page() fails, and
> the kernel falls back to splitting the THP and swapping the 4k
> constituents one by one. /proc/vmstat confirms this with a high rate
> of thp_swpout_fallback events.
>
> While the behavior can ultimately be explained, it's unexpected and
> confusing. I see three choices how to address this:
>
> a) Specifically exlude THP fallbacks from being counted, as the
>    failure is transient and the memory is ultimately swapped.
>
>    Arguably, though, the user would like to know if their cgroup's
>    swap limit is causing high rates of THP splitting during swapout.
>
> b) Only count cgroup swap events when they are actually due to a
>    cgroup's own limit. Exclude failures that are due to physical swap
>    shortage or other system-level conditions (like !THP_SWAP). Also
>    count them at the level where the limit is configured, which may be
>    above the local cgroup that holds the page-to-be-swapped.
>
>    This is in line with how memory.swap.high, memory.high and
>    memory.max events are counted.
>
>    However, it's a change in documented behavior.
>
> c) Leave it as is. The documentation says system-level events are
>    counted, so stick to that.
>
>    This is the conservative option, but isn't very user friendly.
>    Cgroup events are usually due to a local control choice made by the
>    user. Mixing in events that are beyond the user's control makes it
>    difficult to id root causes and configure the system properly.
>
> Implement option b).

I prefer option b too.

>
> Reported-by: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

I think we should CC stable as well for early exposure.
