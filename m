From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/1] psi: remove 500ms min window size limitation for triggers
Date: Thu, 2 Mar 2023 17:16:33 -0800
Message-ID: <CAJuCfpHcgu5Cti0t+U=S1C5-0ZgebhxzrOnhDiSu5qCyuq5_Wg@mail.gmail.com>
References: <20230303011346.3342233-1-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677806204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pnHArXpnIln4mR9B6GQIrF77J/3Fo4zMukNf/BHzahY=;
        b=RHZ/5e8m9fy3BrS8H8EuZi/rzgU5IOzlIA8zeJ5GS+PM41zVTymZSYbmzfQmb6OvVl
         XbYMzhWI2XYBouWUFdAi3S9YuNgZK4dQ1pMEbzVemOlITarcYhDbrAvpvUNLOmNO0uNb
         nSN08VzpIdhLwlFCfmEhEXARu67/KiCdyKcZSIchfC/ToxDkZAJw/Y8hlcpRiWPmdpYo
         UOZ5Ki7t/dMFspouEbW3kmRb+c1YsfQu1ym8WzCEiHGbwjfUFG1ZEmhkWkGcbRH78lrw
         I+jlQIAUVSmtMxCjT2ToCcbJlQoCCnkSOQIyYGh5aqimOH1BKDiZMWJk9SIIbMS4ANiY
         SU6A==
In-Reply-To: <20230303011346.3342233-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 2, 2023 at 5:13=E2=80=AFPM Suren Baghdasaryan <surenb-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
>
> Current 500ms min window size for psi triggers limits polling interval
> to 50ms to prevent polling threads from using too much cpu bandwidth by
> polling too frequently. However the number of cgroups with triggers is
> unlimited, so this protection can be defeated by creating multiple
> cgroups with psi triggers (triggers in each cgroup are served by a single
> "psimon" kernel thread).
> Instead of limiting min polling period, which also limits the latency of
> psi events, it's better to limit psi trigger creation to authorized users
> only, like we do for system-wide psi triggers (/proc/pressure/* files can
> be written only by processes with CAP_SYS_RESOURCE capability). This also
> makes access rules for cgroup psi files consistent with system-wide ones.
> Add a CAP_SYS_RESOURCE capability check for cgroup psi file writers and
> remove the psi window min size limitation.
>
> Suggested-by: Sudarshan Rajagopalan <quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
> Link: https://lore.kernel.org/all/cover.1676067791.git.quic_sudaraja@quic=
inc.com/
> Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Forgot to change the --to field from Tejun to PeterZ.
Peter, just to clarify, this change is targeted for inclusion in your tree.
Thanks!

> ---
>  kernel/cgroup/cgroup.c | 10 ++++++++++
>  kernel/sched/psi.c     |  4 +---
>  2 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 935e8121b21e..b600a6baaeca 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3867,6 +3867,12 @@ static __poll_t cgroup_pressure_poll(struct kernfs=
_open_file *of,
>         return psi_trigger_poll(&ctx->psi.trigger, of->file, pt);
>  }
>
> +static int cgroup_pressure_open(struct kernfs_open_file *of)
> +{
> +       return (of->file->f_mode & FMODE_WRITE && !capable(CAP_SYS_RESOUR=
CE)) ?
> +               -EPERM : 0;
> +}
> +
>  static void cgroup_pressure_release(struct kernfs_open_file *of)
>  {
>         struct cgroup_file_ctx *ctx =3D of->priv;
> @@ -5266,6 +5272,7 @@ static struct cftype cgroup_psi_files[] =3D {
>         {
>                 .name =3D "io.pressure",
>                 .file_offset =3D offsetof(struct cgroup, psi_files[PSI_IO=
]),
> +               .open =3D cgroup_pressure_open,
>                 .seq_show =3D cgroup_io_pressure_show,
>                 .write =3D cgroup_io_pressure_write,
>                 .poll =3D cgroup_pressure_poll,
> @@ -5274,6 +5281,7 @@ static struct cftype cgroup_psi_files[] =3D {
>         {
>                 .name =3D "memory.pressure",
>                 .file_offset =3D offsetof(struct cgroup, psi_files[PSI_ME=
M]),
> +               .open =3D cgroup_pressure_open,
>                 .seq_show =3D cgroup_memory_pressure_show,
>                 .write =3D cgroup_memory_pressure_write,
>                 .poll =3D cgroup_pressure_poll,
> @@ -5282,6 +5290,7 @@ static struct cftype cgroup_psi_files[] =3D {
>         {
>                 .name =3D "cpu.pressure",
>                 .file_offset =3D offsetof(struct cgroup, psi_files[PSI_CP=
U]),
> +               .open =3D cgroup_pressure_open,
>                 .seq_show =3D cgroup_cpu_pressure_show,
>                 .write =3D cgroup_cpu_pressure_write,
>                 .poll =3D cgroup_pressure_poll,
> @@ -5291,6 +5300,7 @@ static struct cftype cgroup_psi_files[] =3D {
>         {
>                 .name =3D "irq.pressure",
>                 .file_offset =3D offsetof(struct cgroup, psi_files[PSI_IR=
Q]),
> +               .open =3D cgroup_pressure_open,
>                 .seq_show =3D cgroup_irq_pressure_show,
>                 .write =3D cgroup_irq_pressure_write,
>                 .poll =3D cgroup_pressure_poll,
> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index 02e011cabe91..0945f956bf80 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -160,7 +160,6 @@ __setup("psi=3D", setup_psi);
>  #define EXP_300s       2034            /* 1/exp(2s/300s) */
>
>  /* PSI trigger definitions */
> -#define WINDOW_MIN_US 500000   /* Min window size is 500ms */
>  #define WINDOW_MAX_US 10000000 /* Max window size is 10s */
>  #define UPDATES_PER_WINDOW 10  /* 10 updates per window */
>
> @@ -1278,8 +1277,7 @@ struct psi_trigger *psi_trigger_create(struct psi_g=
roup *group,
>         if (state >=3D PSI_NONIDLE)
>                 return ERR_PTR(-EINVAL);
>
> -       if (window_us < WINDOW_MIN_US ||
> -               window_us > WINDOW_MAX_US)
> +       if (window_us =3D=3D 0 || window_us > WINDOW_MAX_US)
>                 return ERR_PTR(-EINVAL);
>
>         /* Check threshold */
> --
> 2.40.0.rc0.216.gc4246ad0f0-goog
>
