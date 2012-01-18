From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] cgroup: revise how we re-populate root directory
Date: Wed, 18 Jan 2012 15:59:57 +0800
Message-ID: <4F167BFD.7010307@cn.fujitsu.com>
References: <4F13DA90.2000603@cn.fujitsu.com> <CAFj3OHUQzShbmdCKYhWMum=hqM5XqK-_wcDyUajnZ1XWFGX1Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFj3OHUQzShbmdCKYhWMum=hqM5XqK-_wcDyUajnZ1XWFGX1Xg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Sha <handai.szj@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Lennart Poettering <mzxreary@0pointer.de>, Kay Sievers <kay.sievers@vrfy.org>

>> @@ -1284,6 +1296,7 @@ static int cgroup_remount(struct super_block *=
sb, int *flags, char *data)
>>        struct cgroupfs_root *root =3D sb->s_fs_info;
>>        struct cgroup *cgrp =3D &root->top_cgroup;
>>        struct cgroup_sb_opts opts;
>> +       unsigned long added_bits, removed_bits;
>>
>>        mutex_lock(&cgrp->dentry->d_inode->i_mutex);
>>        mutex_lock(&cgroup_mutex);
>> @@ -1294,6 +1307,9 @@ static int cgroup_remount(struct super_block *=
sb, int *flags, char *data)
>>        if (ret)
>>                goto out_unlock;
>>
>> +       added_bits =3D opts.subsys_bits & ~root->subsys_bits;
>> +       removed_bits =3D root->subsys_bits & ~opts.subsys_bits;
>> +
>=20
> Should it be the following=EF=BC=9F=EF=BC=9A
>           added_bits =3D opts.subsys_bits & ~root->actual_subsys_bits=
;
>           removed_bits =3D root->actual_subsys_bits & ~opts.subsys_bi=
ts;
>=20

subsys_bits and actual_subsys_bits differ during cgroup_mount() only,
and in other places they are replaceable with each other.

Thanks for looking into this.
