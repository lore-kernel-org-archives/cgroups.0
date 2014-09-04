From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] cgroup: check cgroup liveliness before unbreaking
 kernfs
Date: Fri, 5 Sep 2014 01:38:40 +0900
Message-ID: <20140904163840.GA26364@mtj.dyndns.org>
References: <540809FB.8020901@huawei.com>
 <54080A1A.7070207@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=51SPIp4HnzAYnEnPcqJi1Wf19HJguttp5CEJnfqpEDM=;
        b=uVv/e9p3iY6brUCE+0EPXLJzUcyADXwuBr3+XkkABft/H4r9LnNDm52HzvID75oTc3
         bWrVFjr4G9NnfoeNo1qwOHC6M4mpa8EaeN5MddBpgjIelCEZkBNBox9MjVD2cLBDDnM3
         6dE1qkC13J2ZLcuRXOmEXtpDcA70L4cPol673PMvf/SCsj9mHSNJ0VbO/bNWA46Llsk4
         t8Ea4xyBNQ3nTtmdG19dq2rKqYGByRr12VGDIze3eq1jBIh3UOPvlc7HkUgmIbHEFyop
         274U6QKIfYoXfI5zDnc4FRJSBtDtoZfG9QfH/XyP6J0CY7cYRY12bAk4FXrHdOMvTcjY
         p4dg==
Content-Disposition: inline
In-Reply-To: <54080A1A.7070207@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Li Zefan <lizefan@huawei.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Thu, Sep 04, 2014 at 02:43:38PM +0800, Li Zefan wrote:
> When cgroup_kn_lock_live() is called through some kernfs operation an=
d
> another thread is calling cgroup_rmdir(), we'll trigger the warning i=
n
> cgroup_get().
>=20
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 1228 at kernel/cgroup.c:1034 cgroup_get+0x89/0xa=
0()
> ...
> Call Trace:
>  [<c16ee73d>] dump_stack+0x41/0x52
>  [<c10468ef>] warn_slowpath_common+0x7f/0xa0
>  [<c104692d>] warn_slowpath_null+0x1d/0x20
>  [<c10bb999>] cgroup_get+0x89/0xa0
>  [<c10bbe58>] cgroup_kn_lock_live+0x28/0x70
>  [<c10be3c1>] __cgroup_procs_write.isra.26+0x51/0x230
>  [<c10be5b2>] cgroup_tasks_write+0x12/0x20
>  [<c10bb7b0>] cgroup_file_write+0x40/0x130
>  [<c11aee71>] kernfs_fop_write+0xd1/0x160
>  [<c1148e58>] vfs_write+0x98/0x1e0
>  [<c114934d>] SyS_write+0x4d/0xa0
>  [<c16f656b>] sysenter_do_call+0x12/0x12
> ---[ end trace 6f2e0c38c2108a74 ]---
>=20
> Fix this by calling css_tryget() instead of cgroup_get().
>=20
> v2:
> - move cgroup_tryget() right below cgroup_get() definition. (Tejun)
>=20
> Cc: <stable@vger.kernel.org> # 3.15+
> Reported-by: Toralf F=F6rster <toralf.foerster@gmx.de>
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied 1-2 to cgroup/for-3.17-fixes.

Thanks.

--=20
tejun
