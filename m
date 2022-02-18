From: "Masami Ichikawa(CIP)" <masami.ichikawa-PrdBLQq2n+6wLyZP7ziBtg@public.gmane.org>
Subject: Re: [PATCH] cgroup-v1: Correct privileges check in release_agent writes
Date: Fri, 18 Feb 2022 10:05:26 +0900
Message-ID: <CAODzB9qKWpQ5Rn4SwHUMa8xM6jfd-EuHPLyCPFHEbTFETM4Vvg@mail.gmail.com>
References: <20220217161128.20291-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220217161128.20291-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Masami Ichikawa <masami.ichikawa-PrdBLQq2n+6wLyZP7ziBtg@public.gmane.org>, Tabitha Sable <tabitha.c.sable-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Feb 18, 2022 at 1:11 AM Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org> wrote:
>
> The idea is to check: a) the owning user_ns of cgroup_ns, b)
> capabilities in init_user_ns.
>
> The commit 24f600856418 ("cgroup-v1: Require capabilities to set
> release_agent") got this wrong in the write handler of release_agent
> since it checked user_ns of the opener (may be different from the owning
> user_ns of cgroup_ns).
> Secondly, to avoid possibly confused deputy, the capability of the
> opener must be checked.
>
> Fixes: 24f600856418 ("cgroup-v1: Require capabilities to set release_agent")
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Link: https://lore.kernel.org/stable/20220216121142.GB30035-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org/
> Signed-off-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
> ---
>  kernel/cgroup/cgroup-v1.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> index 0e877dbcfeea..afc6c0e9c966 100644
> --- a/kernel/cgroup/cgroup-v1.c
> +++ b/kernel/cgroup/cgroup-v1.c
> @@ -546,6 +546,7 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
>                                           char *buf, size_t nbytes, loff_t off)
>  {
>         struct cgroup *cgrp;
> +       struct cgroup_file_ctx *ctx;
>
>         BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
>
> @@ -553,8 +554,9 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
>          * Release agent gets called with all capabilities,
>          * require capabilities to set release agent.
>          */
> -       if ((of->file->f_cred->user_ns != &init_user_ns) ||
> -           !capable(CAP_SYS_ADMIN))
> +       ctx = of->priv;
> +       if ((ctx->ns->user_ns != &init_user_ns) ||
> +           !file_ns_capable(of->file, &init_user_ns, CAP_SYS_ADMIN))
>                 return -EPERM;
>
>         cgrp = cgroup_kn_lock_live(of->kn, false);
> --
> 2.34.1

Thank you. Looks good to me.

Reviewed-by: Masami Ichikawa(CIP) <masami.ichikawa-PrdBLQq2n+6wLyZP7ziBtg@public.gmane.org>
