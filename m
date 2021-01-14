From: chenzhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Date: Thu, 14 Jan 2021 22:08:19 +0800
Message-ID: <d4ba14b0-ee06-b793-a840-2c2ff369d890@huawei.com>
References: <20201218061755.121205-1-chenzhou10@huawei.com>
 <YABDWvI2PWQpnv59@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YABDWvI2PWQpnv59@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Michal,

On 2021/1/14 21:12, Michal Koutn=FD wrote:
> Hello Chen.
>
> On Fri, Dec 18, 2020 at 02:17:55PM +0800, Chen Zhou <chenzhou10-hv44wF8Li=
93QT0dZR+AlfA@public.gmane.org> wrote:
>> When mounting a cgroup hierarchy with disabled controller in cgroup v1,
>> all available controllers will be attached.
> Not sure if I understand the situation -- have you observed a v1
> controller attached to a hierarchy while specifying cgroup_no_v1=3D kernel
> cmdline arg?
Yeah, this is the situation.
In this case, at the beginning of function check_cgroupfs_options(), the ma=
sk
ctx->subsys_mask will be 0. And if we mount without 'none' and 'name=3D' op=
tions,
then in check_cgroupfs_options(), the flag ctx->all_ss will be set, that is=
, select all the subsystems.

Thanks,
Chen Zhou
>
> AFAICS, the disabled controllers are honored thanks to
> check_cgroupfs_options().
>
> Michal

