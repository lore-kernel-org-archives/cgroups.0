From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH bpf-next v9 1/5] bpf: Introduce cgroup iter
Date: Thu, 25 Aug 2022 17:24:55 +0200
Message-ID: <20220825152455.GA29058@blackbody.suse.cz>
References: <20220824030031.1013441-1-haoluo@google.com>
 <20220824030031.1013441-2-haoluo@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661441098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZxGr3EJuIrdktJcj6rqi0sQ+aGd1Ypmw1/Whqwd5Z6M=;
        b=KlyxheLvPhb35mhUe6o65ZtCuyxtUnup4XT0WXWnOhRRyiBYHQNoMyxbDAQKpldAvy8HTI
        VTUhgQqvcD6Xnx7r4TA10dDXC1rc04BurgKLEmEkeqF1BRhyqTrTw/9cetePdYDkBvHtVf
        AyLXvkT0Y1HGv5E1NcG8RV2ARcHqJTY=
Content-Disposition: inline
In-Reply-To: <20220824030031.1013441-2-haoluo@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hao Luo <haoluo@google.com>
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, KP Singh <kpsingh@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Jiri Olsa <jolsa@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Shakeel Butt <shakeelb@google.com>, Yosry Ahmed <yosryahmed@google.com>

Hello.

On Tue, Aug 23, 2022 at 08:00:27PM -0700, Hao Luo <haoluo@google.com> wrote:
> +static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
> +				  union bpf_iter_link_info *linfo,
> +				  struct bpf_iter_aux_info *aux)
> +{
> +	int fd =3D linfo->cgroup.cgroup_fd;
> +	u64 id =3D linfo->cgroup.cgroup_id;
> +	int order =3D linfo->cgroup.order;
> +	struct cgroup *cgrp;
> +
> +	if (order !=3D BPF_ITER_DESCENDANTS_PRE &&
> +	    order !=3D BPF_ITER_DESCENDANTS_POST &&
> +	    order !=3D BPF_ITER_ANCESTORS_UP &&
> +	    order !=3D BPF_ITER_SELF_ONLY)
> +		return -EINVAL;
> +
> +	if (fd && id)
> +		return -EINVAL;
> +
> +	if (fd)
> +		cgrp =3D cgroup_get_from_fd(fd);
> +	else if (id)
> +		cgrp =3D cgroup_get_from_id(id);
> +	else /* walk the entire hierarchy by default. */
> +		cgrp =3D cgroup_get_from_path("/");
> +
> +	if (IS_ERR(cgrp))
> +		return PTR_ERR(cgrp);

This section caught my eye.

Perhaps the simpler way for the default hierachy fallback would be

		cgrp =3D &cgrp_dfl_root.cgrp;
		cgroup_get(cgroup)

But maybe it's not what is the intention if cgroup NS should be taken
into account and cgroup_get_from_path() is buggy in this regard.

Would it make sense to prepend the patch below to your series?

Also, that makes me think about iter initialization with ID. In contrast
with FD passing (that's subject to some permissions and NS checks), the
retrieval via ID is not equipped with that, ids are not unguessable and
I'd consider cgroup IDs an implementation detail.

So, is the ID initialization that much useful? (I have no idea about
permissions model of BPF here, so it might be just fine but still it'd
be good to take cgroup NS into account. Likely for BPF_ITER_ANCESTORS_UP
too.)

HTH,
Michal

----8<----
From 1098e60e89d4d901b7eef04e531f2c889309a91b Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Michal=3D20Koutn=3DC3=3DBD?=3D <mkoutny@suse.com>
Date: Thu, 25 Aug 2022 15:19:04 +0200
Subject: [PATCH] cgroup: Honor caller's cgroup NS when resolving path
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

cgroup_get_from_path() is not widely used function. Its callers presume
the path is resolved under cgroup namespace. (There is one caller
currently and resolving in init NS won't make harm (netfilter). However,
future users may be subject to different effects when resolving
globally.)
Since, there's currently no use for the global resolution, modify the
existing function to take cgroup NS into account.

Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
Signed-off-by: Michal Koutn=FD <mkoutny@suse.com>
---
 kernel/cgroup/cgroup.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ffaccd6373f1..9280f4b41d8b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6603,8 +6603,12 @@ struct cgroup *cgroup_get_from_path(const char *path)
 {
 	struct kernfs_node *kn;
 	struct cgroup *cgrp =3D ERR_PTR(-ENOENT);
+	struct cgroup *root_cgrp;
=20
-	kn =3D kernfs_walk_and_get(cgrp_dfl_root.cgrp.kn, path);
+	spin_lock_irq(&css_set_lock);
+	root_cgrp =3D current_cgns_cgroup_from_root(&cgrp_dfl_root);
+	kn =3D kernfs_walk_and_get(root_cgrp->kn, path);
+	spin_unlock_irq(&css_set_lock);
 	if (!kn)
 		goto out;
=20

base-commit: 3cc40a443a04d52b0c95255dce264068b01e9bfe
--=20
2.37.0

