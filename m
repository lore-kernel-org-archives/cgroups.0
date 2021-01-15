From: chenzhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Date: Fri, 15 Jan 2021 13:58:20 +0800
Message-ID: <c4e62492-4b12-c516-3c17-77d18f3ddfe2@huawei.com>
References: <20201218061755.121205-1-chenzhou10@huawei.com>
 <YABDWvI2PWQpnv59@blackbook>
 <d4ba14b0-ee06-b793-a840-2c2ff369d890@huawei.com>
 <YAB3Wuu+hFpN698N@blackbook>
 <7804658e-7644-8edb-5ca8-0c97389c8c62@huawei.com>
 <YAEJPs4DJIgAXWul@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YAEJPs4DJIgAXWul-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2021/1/15 11:17, Tejun Heo wrote:
> Hello,
>
> On Fri, Jan 15, 2021 at 09:55:43AM +0800, chenzhou wrote:
>> Yeah, this will select all enabled controllers, but which doesn't the behavior we want.
>> I think the case should return error with information "Disabled controller xx" rather than
>> attaching all the other enabled controllers.
>>
>> For example, boot with cgroup_no_v1=cpu, and then mount with
>> "mount -t cgroup -o cpu cpu /sys/fs/cgroup/cpu", then all enabled controllers will
>> be attached expect cpu.
> Okay, that explanation actually makes sense. Can you please update the
> description to include what's broken and how it's being fixed? It really
> isn't clear what the patch is trying to achieve from the current
> description.
Ok, will update the description.
>
> Thanks.
>

