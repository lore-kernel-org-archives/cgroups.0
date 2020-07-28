From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: memcontrol: restore proper dirty throttling when
 memory.high changes
Date: Tue, 28 Jul 2020 08:07:09 -0700
Message-ID: <CALvZod6nFiUvcCViwwiHY9x5xw=JCYM_NUOQCkLMeLD8-JNCaw@mail.gmail.com>
References: <20200728135210.379885-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MqKK7cF3q5e7l52iOkJoCa4f73ZLky3ZxfyYCXCSh3Y=;
        b=fOFXTXHHi/1EGMPH8IGLT8Q44caG1seCiZf4b2tdKys5AN6daPLz58LLMJX2ebJ/cc
         AQWC5c4ocJTpnfJFPSoc9f2APOdbHKeBKRbmx26YbLYcFgcQ4x8dhAWpuF+7u2iPFY1y
         hcTYR5Ha1vBv1AOWloZ+DogIi8d6LX27zvjrDSpvIvCtx8hdJDz/dP15WzCSY/sO3Cnr
         +E4ZT8HUyUEWOz8342hH7kQ4UBQzZQ8DX3y2lVOe3wKTNsIC83j0ioCKaKTmjKmgg2ZL
         /voZUK3EQaTO8pYbpQ6KZXZttUyFTwVzu9WJ7YQxGnR/PgyJd7V01NwF5FUNLNdykiPk
         41Xg==
In-Reply-To: <20200728135210.379885-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Tue, Jul 28, 2020 at 6:53 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> Commit 8c8c383c04f6 ("mm: memcontrol: try harder to set a new
> memory.high") inadvertently removed a callback to recalculate the
> writeback cache size in light of a newly configured memory.high limit.
>
> Without letting the writeback cache know about a potentially heavily
> reduced limit, it may permit too many dirty pages, which can cause
> unnecessary reclaim latencies or even avoidable OOM situations.
>
> This was spotted while reading the code, it hasn't knowingly caused
> any problems in practice so far.
>
> Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
