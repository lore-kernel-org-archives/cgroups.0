From: Qian Cai <cai@lca.pw>
Subject: Re: ptrace warning due to "cgroup: get rid of
 cgroup_freezer_frozen_exit()"
Date: Wed, 08 May 2019 09:10:21 -0400
Message-ID: <1557321021.6132.21.camel@lca.pw>
References: <1557259462.6132.20.camel@lca.pw>
         <20190507213752.GA24308@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bFa5fWOj2U39bADpZiNUIdboEoriIx8kxrH5dUaTGmo=;
        b=AaSAORnuiyrLy4PFh/pbfE/NUYTkNM9t+xn/oTFhNa7mX9sFbcaoVkJmtjF5sY1MXr
         eIqj3qnqmzXQf3o3O2SkcLx/OstU8qzgySEj2W774c/ByF6zLPv23RBIY4/AdgqDX69h
         EviloJdUjLgbLAaKBBr73X4eiqQGOVvj+ngtfEcjYbzHmsYnmkMhfwihIpIXwxyWhYC4
         P9wewZNWzPkhrAL+SemyWnARTqAOxs6aObkeomkAd+cUPUB9gKUlTbMdI1yFIc/blKLS
         prRJc8G/OKf329fbsQGzeslm5Dmgr/SUc0aGC1j/Ff9mMKPmoeDMAUkVDIggh9P0Q4cU
         WJGg==
In-Reply-To: <20190507213752.GA24308@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <guro@fb.com>
Cc: "oleg@redhat.com" <oleg@redhat.com>, "tj@kernel.org" <tj@kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, 2019-05-07 at 21:37 +0000, Roman Gushchin wrote:
> Can you, please, try if the following patch fixes the problem?

It works great.

> --
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 16b72f4f14df..bf2f268f1386 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2484,9 +2484,6 @@ bool get_signal(struct ksignal *ksig)
>                 sigdelset(&current->pending.signal, SIGKILL);
>                 recalc_sigpending();
>                 current->jobctl &= ~JOBCTL_TRAP_FREEZE;
> -               spin_unlock_irq(&sighand->siglock);
> -               if (unlikely(cgroup_task_frozen(current)))
> -                       cgroup_leave_frozen(true);
>                 goto fatal;
>         }
>  
> @@ -2608,8 +2605,10 @@ bool get_signal(struct ksignal *ksig)
>                         continue;
>                 }
>  
> -               spin_unlock_irq(&sighand->siglock);
>         fatal:
> +               spin_unlock_irq(&sighand->siglock);
> +               if (unlikely(cgroup_task_frozen(current)))
> +                       cgroup_leave_frozen(true);
>  
>                 /*
>                  * Anything else is fatal, maybe with a core dump.
