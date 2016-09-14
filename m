From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [RFC v3 22/22] samples/landlock: Add sandbox example
Date: Wed, 14 Sep 2016 14:24:43 -0700
Message-ID: <20160914212442.GD57174@ast-mbp.thefacebook.com>
References: <20160914072415.26021-1-mic@digikod.net>
 <20160914072415.26021-23-mic@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=FcAgNx/GPNTCaNIZDJNaSVfsjB6B9MPHvz6ywZ5B6f4=;
        b=q57fkJ6zG2DDwS99TFCT5GLFMz8hxnSUmjQLEf14eiPG7mxfr34viFGK6T+Q61aom5
         09l2uamXMdp+5MoFu67yQpP/f1/mzd6wkLWWl+FaOmZlg5d9J0JaXeAZz5dGiqYW8mNT
         EJ6GvmZ6gLGxhuoWnkeBF3yfeJo7LUj6NUvCMrxqJViUPH9uCaZekRc4cllZ07OOnkOp
         /s6VfPEJ74a69I5e+PHr3gffV8iGKrDGeMsl8SPrdqMziZ4TIz+dJsODgHtL++bDUbn6
         eFGip8APOn4lUaK3ISrDB+1PZBP+U8hvmdo4PSfPAZ1B27mJiEVR7eHFZw4djdfqUy6c
         uOew==
Content-Disposition: inline
In-Reply-To: <20160914072415.26021-23-mic@digikod.net>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Tejun Heo <tj@kernel.org>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kern

On Wed, Sep 14, 2016 at 09:24:15AM +0200, Micka=EBl Sala=FCn wrote:
> Add a basic sandbox tool to create a process isolated from some part of
> the system. This can depend of the current cgroup.
>=20
> Example with the current process hierarchy (seccomp):
>=20
>   $ ls /home
>   user1
>   $ LANDLOCK_ALLOWED=3D'/bin:/lib:/usr:/tmp:/proc/self/fd/0' \
>       ./samples/landlock/sandbox /bin/sh -i
>   Launching a new sandboxed process.
>   $ ls /home
>   ls: cannot open directory '/home': Permission denied
>=20
> Example with a cgroup:
>=20
>   $ mkdir /sys/fs/cgroup/sandboxed
>   $ ls /home
>   user1
>   $ LANDLOCK_CGROUPS=3D'/sys/fs/cgroup/sandboxed' \
>       LANDLOCK_ALLOWED=3D'/bin:/lib:/usr:/tmp:/proc/self/fd/0' \
>       ./samples/landlock/sandbox
>   Ready to sandbox with cgroups.
>   $ ls /home
>   user1
>   $ echo $$ > /sys/fs/cgroup/sandboxed/cgroup.procs
>   $ ls /home
>   ls: cannot open directory '/home': Permission denied
>=20
> Changes since v2:
> * use BPF_PROG_ATTACH for cgroup handling
>=20
> Signed-off-by: Micka=EBl Sala=FCn <mic@digikod.net>
...
> +	struct bpf_insn hook_path[] =3D {
> +		/* specify an option, if any */
> +		BPF_MOV32_IMM(BPF_REG_1, 0),
> +		/* handles to compare with */
> +		BPF_LD_MAP_FD(BPF_REG_2, map_fs),
> +		BPF_MOV64_IMM(BPF_REG_3, BPF_MAP_ARRAY_OP_OR),
> +		/* hook argument (struct file) */
> +		BPF_LDX_MEM(BPF_DW, BPF_REG_4, BPF_REG_6, offsetof(struct
> +					landlock_data, args[0])),
> +		/* checker function */
> +		BPF_EMIT_CALL(BPF_FUNC_landlock_cmp_fs_beneath_with_struct_file),

the example is sweet!
Since only that helper is used, could you skip the other one
from the patches (for now) ?

