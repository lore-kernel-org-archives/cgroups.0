From: chenzhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Date: Fri, 15 Jan 2021 09:55:43 +0800
Message-ID: <7804658e-7644-8edb-5ca8-0c97389c8c62@huawei.com>
References: <20201218061755.121205-1-chenzhou10@huawei.com>
 <YABDWvI2PWQpnv59@blackbook>
 <d4ba14b0-ee06-b793-a840-2c2ff369d890@huawei.com>
 <YAB3Wuu+hFpN698N@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YAB3Wuu+hFpN698N@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2021/1/15 0:54, Michal Koutn=FD wrote:
> On Thu, Jan 14, 2021 at 10:08:19PM +0800, chenzhou <chenzhou10-hv44wF8Li9=
3QT0dZR+AlfA@public.gmane.org> wrote:
>> In this case, at the beginning of function check_cgroupfs_options(), the=
 mask
>> ctx->subsys_mask will be 0. And if we mount without 'none' and 'name=3D'=
 options,
>> then in check_cgroupfs_options(), the flag ctx->all_ss will be set, that=
 is, select all the subsystems.
> But even then, the line
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/k=
ernel/cgroup/cgroup-v1.c?h=3Dv5.11-rc3#n1012
> would select only 'enabled' controllers, wouldn't it?
Yeah, this will select all enabled controllers, but which doesn't the behav=
ior we want.
I think the case should return error with information "Disabled controller =
xx" rather than
attaching all the other enabled controllers.

For example, boot with cgroup_no_v1=3Dcpu, and then mount with
"mount -t cgroup -o cpu cpu /sys/fs/cgroup/cpu", then all enabled controlle=
rs will
be attached expect cpu.
>
> It's possible I missed something but if this means that cgroup_no_v1=3D
> doesn't hold to its expectations, I'd suggest adding proper Fixes: tag
> to the patch.
See above. Just the mount behavior isn't what we what.
The behavior was changed since commit f5dfb5315d34 ("cgroup: take options p=
arsing into ->parse_monolithic()"),
will add this as Fixes.

Thanks,
Chen Zhou
>
> Thanks,
> Michal

