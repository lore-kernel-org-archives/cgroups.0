From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH] psi: fix monitor for root cgroup
Date: Tue, 8 Dec 2020 19:22:06 -0800
Message-ID: <CAJuCfpFjdE3k+eWoJLZMp9miffmueZ0hgLLF1b_V6Kb4=i+D3g@mail.gmail.com>
References: <20201208083510.14344-1-odin@uged.al>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tEWLaiABhfSkvT1cOB+vXvjqCQDKr8VP2HOqqGxlXaU=;
        b=pcvicRPw5fYEgoz+vgcA1n+jR1qIiuAy8vpfCm59ZqryG+PILmlYM1YTrFKF/wyXpZ
         v1pywrJXjxoRPB8GkzlTagFXSd7kNkJGHzhriOnPCNwCDMK9i28G3mSf5EmV5tFFWE4Z
         6VGGhT0BHDl63+AbvGzdMKqnakYnPxEZqOnlVrW8DEu4/xzih1VVvbKwacsHZeI7IW/b
         XrzN4RVG4uKI220wjgDbdVZmGVqg1S/v9pzn8EPUQiis1Dv7fNabFblXHL9iULtncz1V
         DdUZ7ySgDlhUQI5aYOh+BUKMieD+QCltb5ahUFhEoxsmGo1HCWbkmLUnwyv8b5KtDrFM
         YCkw==
In-Reply-To: <20201208083510.14344-1-odin@uged.al>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin@uged.al>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups mailinglist <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, dschatzberg@fb.com

On Tue, Dec 8, 2020 at 12:35 AM Odin Ugedal <odin@uged.al> wrote:
>
> Fix NULL pointer dereference when adding new psi monitor to the root
> cgroup. PSI files for root cgroup was introduced in df5ba5be742 by using
> system wide psi struct when reading, but file write/monitor was not
> properly fixed. Since the PSI config for the root cgroup isn't
> initialized, the current implementation tries to lock a NULL ptr,
> resulting in a crash.
>
> Can be triggered by running this as root:
> $ tee /sys/fs/cgroup/cpu.pressure <<< "some 10000 1000000"
>
>
> Signed-off-by: Odin Ugedal <odin@uged.al>
> ---
>  kernel/cgroup/cgroup.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index e41c21819ba0..5d1fdf7c3ec6 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3567,6 +3567,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
>  {
>         struct psi_trigger *new;
>         struct cgroup *cgrp;
> +       struct psi_group *psi;
>
>         cgrp = cgroup_kn_lock_live(of->kn, false);
>         if (!cgrp)
> @@ -3575,7 +3576,8 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
>         cgroup_get(cgrp);
>         cgroup_kn_unlock(of->kn);
>
> -       new = psi_trigger_create(&cgrp->psi, buf, nbytes, res);
> +       psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
> +       new = psi_trigger_create(psi, buf, nbytes, res);
>         if (IS_ERR(new)) {
>                 cgroup_put(cgrp);
>                 return PTR_ERR(new);
> --
> 2.29.2
>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
