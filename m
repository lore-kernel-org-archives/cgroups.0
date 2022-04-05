From: Bui Quang Minh <minhquangbui99@gmail.com>
Subject: Re: [PATCH v2] cgroup: Kill the parent controller when its last child
 is killed
Date: Tue, 5 Apr 2022 21:58:01 +0700
Message-ID: <bdd4104d-390e-74c7-0de1-a275044831a5@gmail.com>
References: <20220404142535.145975-1-minhquangbui99@gmail.com>
 <Ykss1N/VYX7femqw@slm.duckdns.org> <20220405091158.GA13806@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iE/Y9WscNLHu6w2KEIZCPXwIElVoVHM0BzES9hjgoSw=;
        b=phlbuxVtZrq+ny/cBitrnv1EdI2+ifY+dU7QMLrWR4vTUYhhs5DmvkW8pGnjEt00dY
         aeztRgO/rJiLIbsJOMkp2X5p+zBpqygo3MmguP1fKSF3+Lf8WmwLmYa414Z6tbkq7PtB
         ZlM8l2daOyMhZ2URU1jsuj+cAFosdKMB1hJVwUE82ZFfIxAwOpVLrf4SjgSs9s9MuxmX
         RLSMFtHho+fNSTZvCXpwoVQPSjCeD+aUdFQhTpIpZuUCgFohEgx7bCH/+TM6bTLv0uvp
         1FIYjib+PWttI6jjFrcNZVQV5hky9BB97FMuLw/RLCV3Wb1dJv9c8ovyUbgUvR0hSBfX
         5MtA==
Content-Language: en-US
In-Reply-To: <20220405091158.GA13806@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, kernel test robot <lkp@intel.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

On 4/5/22 16:11, Michal Koutn=C3=BD wrote:
> On Mon, Apr 04, 2022 at 07:37:24AM -1000, Tejun Heo <tj@kernel.org> wrote:
>> And the suggested behavior doesn't make much sense to me. It doesn't
>> actually solve the underlying problem but instead always make css
>> destructions recursive which can lead to surprises for normal use cases.
>=20
> I also don't like the nested special-case use percpu_ref_kill().

After thinking more carefully, I agree with your points. The recursive=20
css destruction only does not fixup the previous parents' metadata=20
correctly and it is not a desirable behavior too.

> I looked at this and my supposed solution turned out to be a revert of
> commit 3c606d35fe97 ("cgroup: prevent mount hang due to memory
> controller lifetime"). So at the unmount time it's necessary to distingui=
sh
> children that are in the process of removal from children than are online=
 or
> pinned indefinitely.
>=20
> What about:
>=20
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -2205,11 +2205,14 @@ static void cgroup_kill_sb(struct super_block *sb)
>          struct cgroup_root *root =3D cgroup_root_from_kf(kf_root);
>=20
>          /*
> -        * If @root doesn't have any children, start killing it.
> +        * If @root doesn't have any children held by residual state (e.g.
> +        * memory controller), start killing it, flush workqueue to filte=
r out
> +        * transiently offlined children.
>           * This prevents new mounts by disabling percpu_ref_tryget_live(=
).
>           *
>           * And don't kill the default root.
>           */
> +       flush_workqueue(cgroup_destroy_wq);
>          if (list_empty(&root->cgrp.self.children) && root !=3D &cgrp_dfl=
_root &&
>              !percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
>                  cgroup_bpf_offline(&root->cgrp);
>=20
> (I suspect there's technically still possible a race between concurrent u=
nmount
> and the last rmdir but the flush on kill_sb path should be affordable and=
 it
> prevents unnecessarily conserved cgroup roots.)

Your proposed solution looks good to me. As with my example the flush=20
will guarantee the rmdir and its deferred work has been executed before=20
cleaning up in umount path.

But what do you think about

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f01ff231a484..5578ee76e789 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2215,6 +2215,7 @@ static void cgroup_kill_sb(struct super_block *sb)
                 cgroup_bpf_offline(&root->cgrp);
                 percpu_ref_kill(&root->cgrp.self.refcnt);
         }
+       root->cgrp.flags |=3D CGRP_UMOUNT;
         cgroup_put(&root->cgrp);
         kernfs_kill_sb(sb);
  }
@@ -5152,12 +5153,28 @@ static void css_release_work_fn(struct=20
work_struct *work)
                 container_of(work, struct cgroup_subsys_state,=20
destroy_work);
         struct cgroup_subsys *ss =3D css->ss;
         struct cgroup *cgrp =3D css->cgroup;
+       struct cgroup *parent =3D cgroup_parent(cgrp);

         mutex_lock(&cgroup_mutex);

         css->flags |=3D CSS_RELEASED;
         list_del_rcu(&css->sibling);

+       /*
+        * If parent doesn't have any children, start killing it.
+        * And don't kill the default root.
+        */
+       if (parent && list_empty(&parent->self.children) &&
+           parent->flags & CGRP_UMOUNT &&
+           parent !=3D &cgrp_dfl_root.cgrp &&
+           !percpu_ref_is_dying(&parent->self.refcnt)) {
+#ifdef CONFIG_CGROUP_BPF
+               if (!percpu_ref_is_dying(&cgrp->bpf.refcnt))
+                       cgroup_bpf_offline(parent);
+#endif
+               percpu_ref_kill(&parent->self.refcnt);
+       }
+
         if (ss) {
                 /* css release path */
                 if (!list_empty(&css->rstat_css_node)) {

The idea is to set a flag in the umount path, in the rmdir it will=20
destroy the css in case its direct parent is umounted, no recursive=20
here. This is just an incomplete example, we may need to reset that flag=20
when remounting.

Thanks,
Quang Minh.
