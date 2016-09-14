From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v3 07/22] landlock: Handle file comparisons
Date: Wed, 14 Sep 2016 14:06:50 -0700
Message-ID: <20160914210649.GA57174@ast-mbp.thefacebook.com>
References: <20160914072415.26021-1-mic@digikod.net>
 <20160914072415.26021-8-mic@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Qc1vZS3h3l7BLq7OrisFOeZuh8OL21FJSZB5MovE534=;
        b=zSwllXQ7+qksli07/FJu6fVs8DtMxjGbrN86ivStKaY22hoMaxQ5YqC4QBmNUDXdwF
         SHtbC6++DR5U3okFftbhL28xGV642JB72ujNDtmvlB6w+y5OsIZsEYN3balZQqKKx20V
         1+89mH006kvVVL6wlfdK6U/EMYuAn2SAJzabffmeRCn4S1/Hl4RpaTHOGliHPirPkpEZ
         UJap2t9oTC8vb/RhLFiEyqeDyDHx/7UPoM6afQEw37qaGxsfiWWEYAjDPzVZ7pxESKey
         UmgmawN1elTqId+Z1xrdqAnoU6MGkIK6y8iwCP5qf8j4pl+9gxVn336VIW6eI+wrR6Ha
         t8vw==
Content-Disposition: inline
In-Reply-To: <20160914072415.26021-8-mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29Tb/PtFMR13I2A@public.gmane.org

On Wed, Sep 14, 2016 at 09:24:00AM +0200, Micka=EBl Sala=FCn wrote:
> Add eBPF functions to compare file system access with a Landlock file
> system handle:
> * bpf_landlock_cmp_fs_prop_with_struct_file(prop, map, map_op, file)
>   This function allows to compare the dentry, inode, device or mount
>   point of the currently accessed file, with a reference handle.
> * bpf_landlock_cmp_fs_beneath_with_struct_file(opt, map, map_op, file)
>   This function allows an eBPF program to check if the current accessed
>   file is the same or in the hierarchy of a reference handle.
>=20
> The goal of file system handle is to abstract kernel objects such as a
> struct file or a struct inode. Userland can create this kind of handle
> thanks to the BPF_MAP_UPDATE_ELEM command. The element is a struct
> landlock_handle containing the handle type (e.g.
> BPF_MAP_HANDLE_TYPE_LANDLOCK_FS_FD) and a file descriptor. This could
> also be any descriptions able to match a struct file or a struct inode
> (e.g. path or glob string).
>=20
> Changes since v2:
> * add MNT_INTERNAL check to only add file handle from user-visible FS
>   (e.g. no anonymous inode)
> * replace struct file* with struct path* in map_landlock_handle
> * add BPF protos
> * fix bpf_landlock_cmp_fs_prop_with_struct_file()
>=20
> Signed-off-by: Micka=EBl Sala=FCn <mic-WFhQfpSGs3bR7s880joybQ@public.gman=
e.org>
> Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> Cc: Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
> Cc: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> Cc: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
> Link: https://lkml.kernel.org/r/CALCETrWwTiz3kZTkEgOW24-DvhQq6LftwEXh77FD=
2G5o71yD7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org

thanks for keeping the links to the previous discussion.
Long term it should help, though I worry we already at the point
where there are too many outstanding issues to resolve before we
can proceed with reasonable code review.

> +/*
> + * bpf_landlock_cmp_fs_prop_with_struct_file
> + *
> + * Cf. include/uapi/linux/bpf.h
> + */
> +static inline u64 bpf_landlock_cmp_fs_prop_with_struct_file(u64 r1_prope=
rty,
> +		u64 r2_map, u64 r3_map_op, u64 r4_file, u64 r5)
> +{
> +	u8 property =3D (u8) r1_property;
> +	struct bpf_map *map =3D (struct bpf_map *) (unsigned long) r2_map;
> +	enum bpf_map_array_op map_op =3D r3_map_op;
> +	struct file *file =3D (struct file *) (unsigned long) r4_file;

please use just added BPF_CALL_ macros. They will help readability of the a=
bove.

> +	struct bpf_array *array =3D container_of(map, struct bpf_array, map);
> +	struct path *p1, *p2;
> +	struct map_landlock_handle *handle;
> +	int i;
> +
> +	/* ARG_CONST_PTR_TO_LANDLOCK_HANDLE_FS is an arraymap */
> +	if (unlikely(!map)) {
> +		WARN_ON(1);
> +		return -EFAULT;
> +	}
> +	if (unlikely(!file))
> +		return -ENOENT;
> +	if (unlikely((property | _LANDLOCK_FLAG_FS_MASK) !=3D _LANDLOCK_FLAG_FS=
_MASK))
> +		return -EINVAL;
> +
> +	/* for now, only handle OP_OR */
> +	switch (map_op) {
> +	case BPF_MAP_ARRAY_OP_OR:
> +		break;
> +	case BPF_MAP_ARRAY_OP_UNSPEC:
> +	case BPF_MAP_ARRAY_OP_AND:
> +	case BPF_MAP_ARRAY_OP_XOR:
> +	default:
> +		return -EINVAL;
> +	}
> +	p2 =3D &file->f_path;
> +
> +	synchronize_rcu();

that is completely broken.
bpf programs are executing under rcu_lock.
please enable CONFIG_PROVE_RCU and retest everything.

I would suggest for the next RFC to do minimal 7 patches up to this point
with simple example that demonstrates the use case.
I would avoid all unpriv stuff and all of seccomp for the next RFC as well,
otherwise I don't think we can realistically make forward progress, since
there are too many issues raised in the subsequent patches.

The common part that is mergeable is prog's subtype extension to
the verifier that can be used for better tracing and is the common
piece of infra needed for both landlock and checmate LSMs
(which must be one LSM anyway)
