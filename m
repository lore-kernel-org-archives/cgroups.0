From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] mm/memcontrol.c: remove unused private flag of memory.oom_control
Date: Thu, 21 Apr 2022 08:25:09 -0700
Message-ID: <CALvZod7pHY590zt8Dq14Fn+VB+p7bfHdpFf39M9dSn8mtzU_+A@mail.gmail.com>
References: <20220421122755.40899-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rALYp+if0darmPSdMoPhbeuPNfcV/0b9+KgF06gqnp4=;
        b=h7SF1jQML2/ahIwe/O5GKTiG1aB/cO1z10lLaoo8KEftSnI4VQ5FBhy94oUwIjTBW2
         BcCgTJQ/jNiDqPMzA6h2bCtOz3M0I8FX/lohbyxUhjZ9Y6pYJCEAr7YcGJbgqoacaaXC
         LeGWRXBd3JsWl6IGB5NdMuj7HumqzA7fJHF6u65mtphSD/g2NdC+stP76m7SKbA06EVX
         RCeMhwroBR+SHz9WBoSR83dwz6cpJ3nCeNzC77W6WRvBPIJdgGCjJtLo2Ks01HHBAVEL
         n1ekSleAKYEk0PI3CKgKCdaMSLiKQ+B5P5VuDIAOBWugNxiv5r9Ts6BQweYZjVp7TmYa
         Xiwg==
In-Reply-To: <20220421122755.40899-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Wang Weiyang <wangweiyang2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Thu, Apr 21, 2022 at 5:29 AM Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> There is no use for the private value, __OOM_TYPE and OOM notifier
> OOM_CONTROL. Therefore remove them to make the code clean.
>
> Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
