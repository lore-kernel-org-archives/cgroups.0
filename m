From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: Re: [PATCH] memcg: fix a bad line
Date: Thu, 28 Feb 2019 17:26:47 +0530
Message-ID: <CAFqt6za55vjCHvmk3smZYQ2cGLTsTyAcs6B1SLwCoYcm+XSiSA@mail.gmail.com>
References: <20190227205242.77355-1-cai@lca.pw>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L8fcmR+rQmEReDcuYpUYxW0tKYPUtWoev1VscFLxHis=;
        b=dMhcgLXPtaIJ8dCC63OVyx+y559roriUbGChDiEyK76D9mm2mvpV+Mr47Uzk5F5zBs
         V79QA6AXgTBm3/Ww/X0wjRbY6VmTWxxftRvCDpAk7zBPU2BXSGgkwd1hYK04SUoFKST6
         M/Qt5bDlNhN07ksiqepq8iSHE2zJGTK+IagegRaVbteW3txRORTNC9u1GFiBBE/iM0Hb
         QcCzKZKLj1dHRkjUh4tRAu5Qmu/tmLb6SGUAKqrxPOX5rOltee5eSX0J5u/tHAGLby/z
         VGgC7v+aZIqB4j0LdHlVwBw0IRklfOgpgW5TxMI9bdSRjYfdjwUaIAS89bu9kHfh+rDh
         PRRw==
In-Reply-To: <20190227205242.77355-1-cai@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: hannes@cmpxchg.org, Michal Hocko <mhocko@kernel.org>, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-kernel@vger.kernel.org

On Thu, Feb 28, 2019 at 2:22 AM Qian Cai <cai@lca.pw> wrote:
>
> Miss a star.
>
> Signed-off-by: Qian Cai <cai@lca.pw>

I think, the change log is too short and could be little more. Otherwise,
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index af7f18b32389..d4b96dc4bd8a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5747,7 +5747,7 @@ struct cgroup_subsys memory_cgrp_subsys = {
>   *
>   *             | memory.current, if memory.current < memory.low
>   * low_usage = |
> -              | 0, otherwise.
> + *            | 0, otherwise.
>   *
>   *
>   * Such definition of the effective memory.low provides the expected
> --
> 2.17.2 (Apple Git-113)
>
