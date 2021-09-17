From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: A missing check bug in cgroup1_reconfigure()
Date: Fri, 17 Sep 2021 19:28:57 +0200
Message-ID: <20210917172857.GB13346@blackbody.suse.cz>
References: <CAA-qYXjxht4+GhTjNb0xmr4dLQYDVpDbO1R_FDcWtnsrQC=VNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631899739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rmT5s0ZIASojQz5Dpz34eZ0EtRJc756ScfCxuvg+I9w=;
        b=nJ6FLBUA73ozuG4UevY4HKy5btbpDi/FkXCilpowyOoZrTGQqvI91XT2ZG8QtcCMLxdpFV
        Qwq1mSfE28sIDMe78Fd9K+ztznY7QlOycZMAEGI1vu/rQyYYmlo2Ej4IyvC5Z+43TMoRgV
        eXzrPKcWoHGqsxMj1f3ce+Wq3BJlcB8=
Content-Disposition: inline
In-Reply-To: <CAA-qYXjxht4+GhTjNb0xmr4dLQYDVpDbO1R_FDcWtnsrQC=VNQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, shenwenbosmile@gmail.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org

On Thu, Sep 16, 2021 at 03:33:49PM +0800, Jinmeng Zhou <jjjinmeng.zhou@gmai=
l.com> wrote:
> Dear maintainers,
> hi, our team has found a missing check bug on Linux kernel v5.10.7
> using static analysis.
> There is a checking path where cgroup1_get_tree() calls cgroup1_root_to_u=
se()
> to mount cgroup_root after checking capability.
> However, another no-checking path exists, cgroup1_reconfigure() calls
> trace_cgroup_remount()
> to remount without checking capability.
> We think there is a missing check bug before mounting cgroup_root in
> cgroup1_reconfigure().

Thanks for the report.
AFAICS, the callers of the fs_context_operations callbacks do the checks
themselves, therefore I _think_ even the check in cgroup1_get_tree() is
superfluous (see also commit 23bf1b6be9c2 ("kernfs, sysfs, cgroup,
intel_rdt: Support fs_context")).

But let me CC also VFS folks for confirmation (rest of the message
below).

> Specifically, cgroup1_get_tree() uses ns_capable(ctx->ns->user_ns,
> CAP_SYS_ADMIN) to check
> the permission before calling the critical function
> cgroup1_root_to_use() to mount.
>=20
> 1. // check ns_capable() ////////////////////////////
> 2. int cgroup1_get_tree(struct fs_context *fc)
> 3. {
> 4.  struct cgroup_fs_context *ctx =3D cgroup_fc2context(fc);
> 5.  int ret;
> 6.  /* Check if the caller has permission to mount. */
> 7.  if (!ns_capable(ctx->ns->user_ns, CAP_SYS_ADMIN))
> 8.    return -EPERM;
> 9.  cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
> 10. ret =3D cgroup1_root_to_use(fc);
> 11. ...
> 12. }
>=20
> trace_cgroup_remount() is called to remount cgroup_root in
> cgroup1_reconfigure().
> However, it lacks the check.
> 1. int cgroup1_reconfigure(struct fs_context *fc)
> 2. {
> 3.  struct cgroup_fs_context *ctx =3D cgroup_fc2context(fc);
> 4.  struct kernfs_root *kf_root =3D kernfs_root_from_sb(fc->root->d_sb);
> 5.  struct cgroup_root *root =3D cgroup_root_from_kf(kf_root);
> 6.  int ret =3D 0;
> 7.  u16 added_mask, removed_mask;
> 8.  ...
> 9.  trace_cgroup_remount(root);
> 10. ...
> 11. }
>=20
> We find cgroup1_reconfigure() is only used in a variable initialization.
> Function cgroup1_get_tree() is also used in this initialization.
> Both functions are indirectly called which is hard to trace.
> We reasonably consider that the two functions can be equally reached
> by the user,
> therefore, there is a missing check bug.
> 1. static const struct fs_context_operations cgroup1_fs_context_ops =3D {
> 2. =E2=80=A6
> 3.  .get_tree =3D cgroup1_get_tree,
> 4.  .reconfigure =3D cgroup1_reconfigure,
> 5. };
>=20
>=20
> Thanks!
>=20
>=20
> Best regards,
> Jinmeng Zhou
>=20
