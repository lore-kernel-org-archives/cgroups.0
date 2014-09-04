From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: Delay the clearing of cgrp->kn->priv
Date: Thu, 4 Sep 2014 11:35:30 +0800
Message-ID: <5407DE02.8090805@huawei.com>
References: <5405A27A.3090605@huawei.com> <20140902153301.GA17424@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140902153301.GA17424-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

=E4=BA=8E 2014/9/2 23:33, Tejun Heo =E5=86=99=E9=81=93:
> Hello, Li.
>=20
> On Tue, Sep 02, 2014 at 06:56:58PM +0800, Li Zefan wrote:
>>     for ((; ;))
>>     {
>>         echo $$ > /cgroup/sub/cgroup.procs
>>         ech $$ > /cgce 6f2e0c38c2108a74 ]---
>           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>           copy & paste error?
> ...

oops

>> Reported-by: Toralf F=C3=B6rster <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>
>> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>
>> Toralf, Thanks for reporting the bug. I'm not able to repy to your e=
mail,
>> because I was kicked out of the cgroup mailing list so didn't receiv=
e
>> emails from mailing list for a week.
>>
>> ---
>>  kernel/cgroup.c | 19 +++++++++----------
>>  1 file changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 1c56924..e03fc62 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -4185,6 +4185,15 @@ static void css_release_work_fn(struct work_s=
truct *work)
>> =20
>>  	mutex_unlock(&cgroup_mutex);
>> =20
>> +	/*
>> +	 * There are two control paths which try to determine cgroup from
>> +	 * dentry without going through kernfs - cgroupstats_build() and
>> +	 * css_tryget_online_from_dir().  Those are supported by RCU
>> +	 * protecting clearing of cgrp->kn->priv backpointer.
>> +	 */
>> +	if (!ss && cgroup_parent(cgrp))
>> +		RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);
>=20
> Can we move the above into the preceding else block?  I don't think
> holding cgroup_mutex or not makes any difference here.=20

> Also, why do
> we need the cgroup_parent() check?  Do we deref root's kn->priv in th=
e
> destruction path?  If so, can you please note that in the comment?
>=20

I think the check is not necessary. I was trying to make smaller differ=
ence
than the original code, and RCU_INIT_POINTER() is in cgroup_rmdir() whi=
ch
won't be called on root cgroup.
