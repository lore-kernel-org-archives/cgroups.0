From: chenzhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Date: Fri, 15 Jan 2021 19:09:23 +0800
Message-ID: <4abe04f8-e7a9-ab2e-f5d1-bb569e2dc157@huawei.com>
References: <20201218061755.121205-1-chenzhou10@huawei.com>
 <YABDWvI2PWQpnv59@blackbook>
 <d4ba14b0-ee06-b793-a840-2c2ff369d890@huawei.com>
 <YAB3Wuu+hFpN698N@blackbook>
 <7804658e-7644-8edb-5ca8-0c97389c8c62@huawei.com>
 <YAFpt6aYW4nVQoZf@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YAFpt6aYW4nVQoZf@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Michal,

On 2021/1/15 18:08, Michal Koutn=FD wrote:
> On Fri, Jan 15, 2021 at 09:55:43AM +0800, chenzhou <chenzhou10-hv44wF8Li9=
3QT0dZR+AlfA@public.gmane.org> wrote:
>> Yeah, this will select all enabled controllers, but which doesn't the be=
havior we want.
> I see what the issue is now.
>
>> See above. Just the mount behavior isn't what we what.
> I agree this a bug and your I find your approach correct
>
> Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
I have sent the v3, which updates the description and add Fixes.=20
[v3]: https://lore.kernel.org/patchwork/patch/1365535/
If it is ok for you to add Reviewed-by there.

Thanks,
Chen Zhou
>
>> The behavior was changed since commit f5dfb5315d34 ("cgroup: take
>> options parsing into ->parse_monolithic()"), will add this as Fixes.
> Thanks.
>
> Michal

