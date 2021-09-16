From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v3 1/3] misc_cgroup: introduce misc.events to count
 failures
Date: Thu, 16 Sep 2021 19:47:31 +0200
Message-ID: <20210916174731.GB9090@blackbody.suse.cz>
References: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631814453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1UXGxl36cCRWagHQx1D/4h9BCgAVpOE3Af+7fYOJUV0=;
        b=dLDaSykl5mJR7jcwRnUhxcauNzcBfc2gCtJt0X6VjDaaQPGiRZ6kqREm42HSHFP7BjyPBz
        gZBqtJs2KSomO0SiqC7mfpXTbuuui65pkm1+BsbDHWMuPiFQdS+1GL4W0XdPPqfsdZjYah
        vcqv3ZcEYYJkkff26vT71jIz3uVG/g4=
Content-Disposition: inline
In-Reply-To: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: brookxu <brookxu.cn@gmail.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, vipinsh@google.com, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Wed, Sep 15, 2021 at 10:18:49AM +0800, brookxu <brookxu.cn@gmail.com> wr=
ote:
> From: Chunguang Xu <brookxu@tencent.com>
>=20
> Introduce misc.events to make it easier for us to understand
> the pressure of resources. Currently only the 'max' event is
> implemented, which indicates the times the resource is about
> to exceeds the max limit.
>=20
> Signed-off-by: Chunguang Xu <brookxu@tencent.com>
> ---
>=20
> v3: remove misc.events.local.
> v2: remove cgroup v1 files.
>=20
>  include/linux/misc_cgroup.h |  5 +++++
>  kernel/cgroup/misc.c        | 24 ++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)

LGTM,
Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>
