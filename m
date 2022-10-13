From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
Date: Wed, 12 Oct 2022 17:17:38 -0700
Message-ID: <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
References: <20210817194003.2102381-1-weiwan@google.com> <20221012163300.795e7b86@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nqgh1ED8YLB3Lt0ws7IuNLmuxoK0yD2LR5GJPgsLVvA=;
        b=W1fbXQ4scCa8Aep6N0cQa85yRo+RHzhCjqU9C17a2GycoxpJKqsfwyTzqPU2P9Dgpa
         +l6W0OriU9nSD1VENAfnSKXeF274+lr4SyUHODPMPW2x3a8jcaKK9+eZV2uJWHoMir0T
         Vcx+kXS6Eqbpe7DbkwjZ49mEerz1hwPFIz8Ld0q/CoGVyfL/1HWyro0i9LugpgS4AXKN
         ign/P4AP/BpuWW/cHBjxOLuuTfXFsSMCMu8SHFtP5vt3KgodzfzfTUgJNCrxYR9bI9xY
         oUh275VlEVNfw+4YPxMuIedrLbqw9kCSZ7O2Z9Kd9snkSpDjZi3iJw9nDl14QfXbGHXd
         Q7Jg==
In-Reply-To: <20221012163300.795e7b86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Wei Wang <weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Wed, Oct 12, 2022 at 4:33 PM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Tue, 17 Aug 2021 12:40:03 -0700 Wei Wang wrote:
> > Add gfp_t mask as an input parameter to mem_cgroup_charge_skmem(),
> > to give more control to the networking stack and enable it to change
> > memcg charging behavior. In the future, the networking stack may decide
> > to avoid oom-kills when fallbacks are more appropriate.
> >
> > One behavior change in mem_cgroup_charge_skmem() by this patch is to
> > avoid force charging by default and let the caller decide when and if
> > force charging is needed through the presence or absence of
> > __GFP_NOFAIL.
>
> This patch is causing a little bit of pain to us, to workloads running
> with just memory.max set. After this change the TCP rx path no longer
> forces the charging.
>
> Any recommendation for the fix? Setting memory.high a few MB under
> memory.max seems to remove the failures.

Did the revert of this patch fix the issue you are seeing? The reason
I am asking is because this patch should not change the behavior.
Actually someone else reported the similar issue for UDP RX at [1] and
they tested the revert as well. The revert did not fix the issue for
them.

Wei has a better explanation at [2] why this patch is not the cause
for these issues.

[1] https://lore.kernel.org/all/CALvZod5_LVkOkF+gmefnctmx+bRjykSARm2JA9eqKJx85NYBGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
[2] https://lore.kernel.org/all/CAEA6p_BhAh6f_kAHEoEJ38nunY=c=4WqxhJQUjT+dCSAr_rm8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
