From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v7 06/10] memcg: enable accounting of ipc resources
Date: Tue, 27 Jul 2021 15:33:01 -0700
Message-ID: <CALvZod7w1ab+EDfYBU50KBg2JkB88ijanCakUiTLdWFZ8Hc0oQ@mail.gmail.com>
References: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
 <cover.1627362057.git.vvs@virtuozzo.com> <d6507b06-4df6-78f8-6c54-3ae86e3b5339@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1yVpnPDg8qZ7QPNZ+sfyroUAmvgOf5UoKJwBpXAopX0=;
        b=OVCobrnJ9+14bQ5fvgtof3vhnIr4IT+0De+FCovxI2+3wi6Zl8VVVHPuEHpvZBYC3H
         O/PsQdOtJCBsopByBERz/BrgdkP/0bvKhrcaeCI+IkyYjM6nKaxnJ92cAOehFMFyRhnS
         4j4U4dBe26WhX7BBdXBHd8afriot7wv+rG8kUS2E5itT1uNH07WjlP/7cdRbflQrj9xT
         zTa/flnhPm41oD2H68OH4/RmfYKQuR6kVeS9U0qV9hODFBYHa/tQPv0liv9K5zUXCy8A
         e3XI9UEyyTUQoKdDpu+TFLWBSzIS8RpkRDBkzt+bOKLDkE3NVY32PQ+/kxG5UobsaEPe
         xn2w==
In-Reply-To: <d6507b06-4df6-78f8-6c54-3ae86e3b5339@virtuozzo.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Alexey Dobriyan <adobriyan@gmail.com>, Dmitry Safonov <0x7f454c46@gmail.com>, Yutian Yang <nglaive@gmail.com>, LKML <linux-kernel@vger.kernel.org>

On Mon, Jul 26, 2021 at 10:33 PM Vasily Averin <vvs@virtuozzo.com> wrote:
>
> When user creates IPC objects it forces kernel to allocate memory for
> these long-living objects.
>
> It makes sense to account them to restrict the host's memory consumption
> from inside the memcg-limited container.
>
> This patch enables accounting for IPC shared memory segments, messages
> semaphores and semaphore's undo lists.
>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
