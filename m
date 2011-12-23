From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] cgroup: move a check to parse_cgroupfs_options()
Date: Fri, 23 Dec 2011 11:40:36 +0800
Message-ID: <4EF3F834.0@cn.fujitsu.com>
References: <4EF2EDA7.4010004@cn.fujitsu.com> <20111222152011.GA17084@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111222152011.GA17084-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

=E4=BA=8E 2011=E5=B9=B412=E6=9C=8822=E6=97=A5 23:20, Tejun Heo =E5=86=99=
=E9=81=93:
> Hello,
>=20
> On Thu, Dec 22, 2011 at 04:43:19PM +0800, Li Zefan wrote:
>> Always check the validity of mount options in parse_cgroupfs_options=
().
>>
>> No functional change.
>>
>> Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
>> ---
>>  kernel/cgroup.c |   15 +++++++--------
>>  1 files changed, 7 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 4936d88..bdb7994 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -1218,7 +1218,6 @@ static int parse_cgroupfs_options(char *data, =
struct cgroup_sb_opts *opts)
>>  	    (opts->subsys_bits & mask))
>>  		return -EINVAL;
>> =20
>> -
>>  	/* Can't specify "none" and some subsystems */
>>  	if (opts->subsys_bits && opts->none)
>>  		return -EINVAL;
>> @@ -1231,6 +1230,13 @@ static int parse_cgroupfs_options(char *data,=
 struct cgroup_sb_opts *opts)
>>  		return -EINVAL;
>> =20
>>  	/*
>> +	 * This can happen only when none of the subsystems is enabled
>> +	 * in the system.
>> +	 */
>> +	if (!opts->subsys_bits && !opts->none)
>> +		return -EINVAL;
>=20
> The three ifs here share a lot and I think sharing the common parts
> would make the logic clearer.  e.g. The first and this can be easily
> combined to (bool)opts->subsys_bits !=3D (bool)opts->none which would
> explain the logic better too.
>=20

ok.

>> @@ -1442,10 +1445,6 @@ static int cgroup_set_super(struct super_bloc=
k *sb, void *data)
>>  	int ret;
>>  	struct cgroup_sb_opts *opts =3D data;
>> =20
>> -	/* If we don't have a new root, we can't set up a new sb */
>> -	if (!opts->new_root)
>> -		return -EINVAL;
>> -
>=20
> And where did this one go?
>=20

The other one I removed sets opts->new_root to NULL, and this one detec=
ts
the NULL ptr:

if (!opts->subsys_bits && !opts->none)
	return NULL;
=2E..
opts->new_root =3D NULL;
=2E..
if (!opts->new_root)
	return -EINVAL;

shortcut to:

if (!opts->subsys_bits && !opts->none)
	return -EINVAL;
