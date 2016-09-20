From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH v1] cgroup,bpf: Add access check for cgroup_get_from_fd()
Date: Tue, 20 Sep 2016 18:53:35 +0200
Message-ID: <57E1698F.1090106@digikod.net>
References: <20160919224913.24808-1-mic@digikod.net>
 <20160920003007.GB91808@ast-mbp.thefacebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="gqTQrLUAL1wnVt5RMHoqXmLtPVKWEBsXb"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160920003007.GB91808-+o4/htvd0TDFYCXBM6kdu7fOX0fSgVTm@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gqTQrLUAL1wnVt5RMHoqXmLtPVKWEBsXb
Content-Type: multipart/mixed; boundary="4r9evc1Ug8vm63B6TfhRVQGMQ2nsHHtdv";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Borkmann
 <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>,
 "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
 James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
 Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <57E1698F.1090106-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH v1] cgroup,bpf: Add access check for cgroup_get_from_fd()
References: <20160919224913.24808-1-mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
 <20160920003007.GB91808-+o4/htvd0TDFYCXBM6kdu7fOX0fSgVTm@public.gmane.org>
In-Reply-To: <20160920003007.GB91808-+o4/htvd0TDFYCXBM6kdu7fOX0fSgVTm@public.gmane.org>

--4r9evc1Ug8vm63B6TfhRVQGMQ2nsHHtdv
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable


On 20/09/2016 02:30, Alexei Starovoitov wrote:
> On Tue, Sep 20, 2016 at 12:49:13AM +0200, Micka=EBl Sala=FCn wrote:
>> Add security access check for cgroup backed FD. The "cgroup.procs" fil=
e
>> of the corresponding cgroup should be readable to identify the cgroup,=

>> and writable to prove that the current process can manage this cgroup
>> (e.g. through delegation). This is similar to the check done by
>> cgroup_procs_write_permission().
>>
>> Fixes: 4ed8ec521ed5 ("cgroup: bpf: Add BPF_MAP_TYPE_CGROUP_ARRAY")
>=20
> I don't understand what 'fixes' is about.
> Looks like new feature or tightening?
> Since cgroup was opened by the process and it got an fd,
> it had an access, so extra check here looks unnecessary.

It may not be a "fix", but this patch tighten the access control. The
current cgroup_get_from_fd() only rely on the access check done on the
passed FD. However, this FD come from a cgroup directory, not a
"cgroup.procs" (in this directory). The "cgroup.procs" is used for
cgroup delegation by cgroup_procs_write_permission(). Checking
"cgroup.procs" is then more consistent with access checks done by other
part of the cgroup code. Being able to open a cgroup directory only
means that the current process is able to list the cgroup hierarchy, not
necessarily to list the tasks in this cgroups.

A BPF_MAP_TYPE_CGROUP_ARRAY should then only contains cgroups readable
by the process that filled the map. It is currently possible to call
bpf_skb_in_cgroup() and know if a packet come from a task in a cgroup,
whereas the loading process may not be able to list this tasks.

Write access to a cgroup directory means to be able to create
sub-cgroups, not to add or remove tasks from that cgroup. This will be
important for future use like the Daniel Mack's patch (attach an eBPF
program to a cgroup). Indeed, with the current code, a process with
CAP_NET_ADMIN (but without the right to manage a cgroup) would be able
to attach programs to a cgroup. Similar thing goes for Landlock.

>=20
>> -struct cgroup *cgroup_get_from_fd(int fd)
>> +struct cgroup *cgroup_get_from_fd(int fd, int access_mask)
>>  {
>>  	struct cgroup_subsys_state *css;
>>  	struct cgroup *cgrp;
>>  	struct file *f;
>> +	struct inode *inode;
>> +	int ret;
>> =20
>>  	f =3D fget_raw(fd);
>>  	if (!f)
>>  		return ERR_PTR(-EBADF);
>> =20
>>  	css =3D css_tryget_online_from_dir(f->f_path.dentry, NULL);
>> -	fput(f);
>=20
> why move it down?

Because it is used by kernfs_get_inode().

>=20
>> -	if (IS_ERR(css))
>> -		return ERR_CAST(css);
>> +	if (IS_ERR(css)) {
>> +		ret =3D PTR_ERR(css);
>> +		goto put_f;
>> +	}
>> =20
>>  	cgrp =3D css->cgroup;
>>  	if (!cgroup_on_dfl(cgrp)) {
>> -		cgroup_put(cgrp);
>> -		return ERR_PTR(-EBADF);
>> +		ret =3D -EBADF;
>> +		goto put_cgrp;
>> +	}
>> +
>> +	ret =3D -ENOMEM;
>> +	inode =3D kernfs_get_inode(f->f_path.dentry->d_sb, cgrp->procs_file.=
kn);
>> +	if (inode) {
>> +		ret =3D inode_permission(inode, access_mask);
>> +		iput(inode);
>>  	}
>> +	if (ret)
>> +		goto put_cgrp;
>> =20
>> +	fput(f);
>>  	return cgrp;
>> +
>> +put_cgrp:
>> +	cgroup_put(cgrp);
>> +put_f:
>> +	fput(f);
>> +	return ERR_PTR(ret);
>>  }
>>  EXPORT_SYMBOL_GPL(cgroup_get_from_fd);
>> =20
>> --=20
>> 2.9.3
>>
>=20


--4r9evc1Ug8vm63B6TfhRVQGMQ2nsHHtdv--

--gqTQrLUAL1wnVt5RMHoqXmLtPVKWEBsXb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJX4WmUAAoJECLe/t9zvWqVns0IAJbO2KXKLVygWNciwXlVPqHd
28Pl9UTf+jnjhZZj8wAhDbKl3wsZbJiaV9zn2SwbAEHPtmdQ1xydhsOtDApooD1U
gk4eZBin0ZlQjQgL1cFIA7ebM0thEGjBBPNC8ltpO+/ROZ4uiuuGoNaP3vEYaozv
FunW0PcfiQ2r5LH0muQheKsry9YO+tL299L2QPWevS57Rn170hPXMWQgOzBSvpU2
tpARB1LxCLM1hwdqDv3nC7NW6pPknV68tVU+RSuUtu/zHfo8+CDJR90ZcWhu1HT3
8vWzGS0GxCeFh0NpuMvr8eJrQpWpn91hmB5qtEoW5XruHdajddy4lbRRtMN7tGQ=
=Et4a
-----END PGP SIGNATURE-----

--gqTQrLUAL1wnVt5RMHoqXmLtPVKWEBsXb--
