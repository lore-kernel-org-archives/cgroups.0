From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: Return error when attempting to migrate a
 zombie process
Date: Fri, 5 May 2023 09:04:37 -1000
Message-ID: <ZFVTRdP6eK1soMVR@slm.duckdns.org>
References: <20230503125359.14789-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683313479; x=1685905479;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GEPgHiIOCiYrMnaimD0D7235Mb8MCc1N6gYw0WH5GLs=;
        b=Au926MGGOcupcwgRZNPEgfjNbK0PODV7VIpOzZqOU78a0/d5A/nhZgSe44BHtoRbCl
         N8yC+LTAbpe691HIteKMgub3UY1Fmc6asWv+2XB0OmiqcaK9giMLMF9dDQRBydnj9IfC
         Srpke8eUMka6WLDIFI0BIS9r95VGQUhzjxnQmOuZvBEGC8iIJgeTL3EVnIubxDDs2fdT
         nOF57loKxP+rhjB1irK/WnYXFYicmCzNdZYPq6E5M+GHVZL+15qKCaTwtqP0UTZM2anX
         RXwbF34otYxQNVgQhK1gSYDBZAqYRLgsCIdgLw/4E+NLqG2ZummrrMYm1cJ5K01Fyh5a
         LbQg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230503125359.14789-1-mkoutny-IBi9RG/b67k@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>

Hello,

On Wed, May 03, 2023 at 02:53:59PM +0200, Michal Koutn=FD wrote:
> Zombies aren't migrated. However, return value of a migration write may
> suggest a zombie process was migrated and causing confusion about lack
> of cgroup.events:populated between origin and target cgroups (e.g.
> target cgroup rmdir).
>=20
> Notify the users about no effect of their action by a return value.
> (update_dfl_csses migration of zombies still silently passes since it is
> not meant to be user-visible migration anyway.)
>=20
> Suggested-by: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane=
.org>
> Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> ---
>  kernel/cgroup/cgroup.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> Reasons for RFC:
> 1) Some users may notice the change,
> 2) EINVAL vs ESCHR,
> 3) add a selftest?
>=20
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 625d7483951c..306547dd7b76 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -2968,7 +2968,8 @@ struct task_struct *cgroup_procs_write_start(char *=
buf, bool threadgroup,
>  	 * become trapped in a cpuset, or RT kthread may be born in a
>  	 * cgroup with no rt_runtime allocated.  Just say no.
>  	 */
> -	if (tsk->no_cgroup_migration || (tsk->flags & PF_NO_SETAFFINITY)) {
> +	if (tsk->no_cgroup_migration || (tsk->flags & PF_NO_SETAFFINITY) ||
> +	    !atomic_read(&tsk->signal->live)) {

This seems racy to me. The liveness state can change between here and the
PF_EXITING check in cgroup_migrate_add_task(), right? Wouldn't it be better
to just track how many tasks are tracked and return -ESRCH if none was
migrated?

Thanks.

--=20
tejun
