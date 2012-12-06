From: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] cgroup_rm_file: don't delete the uncreated files
Date: Thu, 06 Dec 2012 14:12:31 +0800
Message-ID: <50C0374F.508@cn.fujitsu.com>
References: <1354763350-3139-1-git-send-email-gaofeng@cn.fujitsu.com> <50C03505.3070801@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50C03505.3070801-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

=E4=BA=8E 2012=E5=B9=B412=E6=9C=8806=E6=97=A5 14:02, Li Zefan =E5=86=99=
=E9=81=93:
> On 2012/12/6 11:09, Gao feng wrote:
>> in cgroup_add_file,when creating files for cgroup,
>> some of creation may be skipped. So we need to avoid
>> deleting these uncreated files in cgroup_rm_file,
>> otherwise the warning msg will be triggered.
>>
>> "cgroup_addrm_files: failed to remove memory_pressure_enabled, err=3D=
-2"
>>
>> Signed-off-by: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
>> ---
>>  kernel/cgroup.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 5cc3724..6928b3e 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -932,6 +932,12 @@ static int cgroup_rm_file(struct cgroup *cgrp, =
const struct cftype *cft)
>>  	lockdep_assert_held(&cgrp->dentry->d_inode->i_mutex);
>>  	lockdep_assert_held(&cgroup_mutex);
>> =20
>> +	/* does @cft->flags tell us this file isn't created on @cgrp? */
>> +	if ((cft->flags & CFTYPE_NOT_ON_ROOT) && !cgrp->parent)
>> +		return 0;
>> +	if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgrp->parent)
>> +		return 0;
>> +
>=20
> We should move those checks to cgroup_addrm_files() to avoid code dup=
lication.
>=20

Get it,and the null check of cft in cgroup_rm_file is no need too.
Thanks!
