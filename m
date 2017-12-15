From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Fri, 15 Dec 2017 05:22:22 -0800
Message-ID: <20171215132222.GF3919388@devbig577.frc2.facebook.com>
References: <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <4e63b5e9-1696-910f-16ac-4d4d7eb98725@codeaurora.org>
 <40968aea-cd73-5ce4-d559-962d91e315c5@codeaurora.org>
 <20171211153258.GI2421075@devbig577.frc2.facebook.com>
 <c54d904e-13bc-8e2b-c9c1-8bf9cb8a33a3@codeaurora.org>
 <20171213154041.GP3919388@devbig577.frc2.facebook.com>
 <c282b638-95ef-b688-9249-f23a733c0a43@codeaurora.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MoG4qmEHUiYeVLyD6tom5crgrz0c9Qr/b5zB/SsZNUA=;
        b=dRf1E30tuXgsFpiKvc5gCrs3MzrsChMCO4BJMUssHdBjGfUx98bji/8cMGNoFPa8yS
         qHwII3x4oL6zvxyfFrMtHcb5evvzFY596LsBD6fE1IcAw5gZMXcsXP3BEWu/mMkd8eUY
         Hm2aX/J9BA3wMxx3fycNnSL0YWSJ346NwN+fRzgL+xslwWuG88eCcno4uzPoxXwOZ0eu
         GfgZ6QyKCNSNcIVk+nH5OrDQhkQAxIObIxNW5rgEfzK9DL7yOlvdSagwUKP5mmwlocVa
         xoyegSwJu4dchXRCKULPkkcKUJLkQrZmzyEDhDfLFLFMF1dtAsje2wbuUBBQSnmVqVEb
         N7gA==
Content-Disposition: inline
In-Reply-To: <c282b638-95ef-b688-9249-f23a733c0a43@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood@codeaurora.org>
Cc: Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org

Hello, Prateek.

On Fri, Dec 15, 2017 at 02:24:55PM +0530, Prateek Sood wrote:
> Following are two ways to improve cgroup_transfer_tasks(). In
> both cases task in PF_EXITING state would be left in source
> cgroup. It would be removed from cgroup_exit() in exit path.
> 
> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> index 024085d..e2bdcdb 100644
> --- a/kernel/cgroup/cgroup-v1.c
> +++ b/kernel/cgroup/cgroup-v1.c
> @@ -123,7 +123,10 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
>          */
>         do {
>                 css_task_iter_start(&from->self, 0, &it);
> -               task = css_task_iter_next(&it);
> +               do {
> +                       task = css_task_iter_next(&it);
> +               } while (task && (task & PF_EXITING))
> +

Yeah, this looks good to me.  We can't just make a single pass as in
the other one because we can race aginst fork.  And PF_EXITING being
left behind is what was happening previously too anyway.  They can't
be moved.

Thanks.

-- 
tejun
