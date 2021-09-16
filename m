From: Jinmeng Zhou <jjjinmeng.zhou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: A missing check bug in cgroup1_reconfigure()
Date: Thu, 16 Sep 2021 15:33:49 +0800
Message-ID: <CAA-qYXjxht4+GhTjNb0xmr4dLQYDVpDbO1R_FDcWtnsrQC=VNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=Bb9J2o84T3V9+Tf1rBXjmsTxCOrWhxebCsVPY9V9H3Q=;
        b=o7Hc/0r4/rqQZyDLh4oEdpb5eQFXFhD0EjPpk5hn/2A+g/usJSxSnLmJafVUoT38Zj
         8053Lv2OJY+wJyx+T0HEQgk3aFYMyzIw1m+wWScYol/9TSMGOTP/A1VCHz0yCXVOp9Io
         LzwSUt3Eqyfb9klM81ai+mwwcLv89gsJTUm30A8VQZpgs3tdG2nyb5yB+tOqxPfV5Yz4
         0TySfqplMUy9HvWeFvDi1pe+KyceI3mU/9146Shy6A8qUTYXeVgz6bn6Zu6L/aTARQwd
         4YJtIfql+wrNd11IzdnxdSk7yBqGnmPAMWP5VTHc7nrZ7PeI/dsinYip+3qzTTuBTK74
         hPaw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: shenwenbosmile-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Dear maintainers,
hi, our team has found a missing check bug on Linux kernel v5.10.7
using static analysis.
There is a checking path where cgroup1_get_tree() calls cgroup1_root_to_use=
()
to mount cgroup_root after checking capability.
However, another no-checking path exists, cgroup1_reconfigure() calls
trace_cgroup_remount()
to remount without checking capability.
We think there is a missing check bug before mounting cgroup_root in
cgroup1_reconfigure().

Specifically, cgroup1_get_tree() uses ns_capable(ctx->ns->user_ns,
CAP_SYS_ADMIN) to check
the permission before calling the critical function
cgroup1_root_to_use() to mount.

1. // check ns_capable() ////////////////////////////
2. int cgroup1_get_tree(struct fs_context *fc)
3. {
4.  struct cgroup_fs_context *ctx =3D cgroup_fc2context(fc);
5.  int ret;
6.  /* Check if the caller has permission to mount. */
7.  if (!ns_capable(ctx->ns->user_ns, CAP_SYS_ADMIN))
8.    return -EPERM;
9.  cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
10. ret =3D cgroup1_root_to_use(fc);
11. ...
12. }

trace_cgroup_remount() is called to remount cgroup_root in
cgroup1_reconfigure().
However, it lacks the check.
1. int cgroup1_reconfigure(struct fs_context *fc)
2. {
3.  struct cgroup_fs_context *ctx =3D cgroup_fc2context(fc);
4.  struct kernfs_root *kf_root =3D kernfs_root_from_sb(fc->root->d_sb);
5.  struct cgroup_root *root =3D cgroup_root_from_kf(kf_root);
6.  int ret =3D 0;
7.  u16 added_mask, removed_mask;
8.  ...
9.  trace_cgroup_remount(root);
10. ...
11. }

We find cgroup1_reconfigure() is only used in a variable initialization.
Function cgroup1_get_tree() is also used in this initialization.
Both functions are indirectly called which is hard to trace.
We reasonably consider that the two functions can be equally reached
by the user,
therefore, there is a missing check bug.
1. static const struct fs_context_operations cgroup1_fs_context_ops =3D {
2. =E2=80=A6
3.  .get_tree =3D cgroup1_get_tree,
4.  .reconfigure =3D cgroup1_reconfigure,
5. };


Thanks!


Best regards,
Jinmeng Zhou
