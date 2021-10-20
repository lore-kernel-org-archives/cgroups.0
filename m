From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Date: Wed, 20 Oct 2021 10:17:41 +0800
Message-ID: <YW98RTBdzqin+9Ko@T590>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590>
 <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590>
 <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
 <YW78AohHqgqM9Cuw@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634696293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D74GYl4Q75+oXj/aMCjO7YTPXeKQjd+IcbtXAGLf308=;
        b=Bs2r5YFJXMOX61pXNAEqEnnG1ilWnSguIV8DwERM8Ui4u6QEm0fbH07Fk03l2H7QT7Nz/L
        IwS8bh7OOFq4SF9eWN7qw3ae07Y1g4t35BUABs2g3RRgp1YRhz3dGLJCsb2x52krb6UV5l
        b/s2yWCaciS625SLcSsN74CSkvj0kSg=
Content-Disposition: inline
In-Reply-To: <YW78AohHqgqM9Cuw@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Quanyang Wang <quanyang.wang@windriver.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org

On Tue, Oct 19, 2021 at 07:10:26PM +0200, Michal Koutn=FD wrote:
> Hi.
>=20
> On Tue, Oct 19, 2021 at 06:41:14PM +0800, Quanyang Wang <quanyang.wang@wi=
ndriver.com> wrote:
> > So I add 2 "Fixes tags" here to indicate that 2 commits introduce two
> > different issues.
>=20
> AFAIU, both the changes are needed to cause the leak, a single patch
> alone won't cause the issue. Is that correct? (Perhaps not as I realize,
> see below.)
>=20
> But on second thought, the problem is the missing percpu_ref_exit() in
> the (root) cgroup release path and percpu counter would allocate the
> percpu_count_ptr anyway, so 4bfc0bb2c60e is only making the leak more
> visible. Is this correct?
>=20
> I agree the commit 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of
> percpu_ref in fast path") alone did nothing wrong.

If only precpu_ref data is leaked, it is fine to add "Fixes: 2b0d3d3e4fcf",
I thought cgroup_bpf_release() needs to release more for root cgroup, but
looks not true.


Thanks,
Ming

