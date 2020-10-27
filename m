From: chenzhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup-v1: add disabled controller check in
 cgroup1_parse_param()
Date: Tue, 27 Oct 2020 09:42:08 +0800
Message-ID: <eb5092f1-1f88-5ca3-360e-da0816a42407@huawei.com>
References: <20201012102757.83192-1-chenzhou10@huawei.com>
 <20201026134711.GB73258@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201026134711.GB73258-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



On 2020/10/26 21:47, Tejun Heo wrote:
> On Mon, Oct 12, 2020 at 06:27:57PM +0800, Chen Zhou wrote:
>> When mounting a cgroup hierarchy with disabled controller in cgroup v1,
>> all available controllers will be attached.
>>
>> Add disabled controller check in cgroup1_parse_param() and return directly
>> if the specified controller is disabled.
>>
>> Signed-off-by: Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> check_cgroupfs_options() is already checking the condition. How does also
> checking in parse_param() help?

Hi Tejun,

Function check_cgroupfs_options() don't check if the mounted controller is disabled.
It just gets the enabled controllers firstly, and then do & opteration with the mounted
controller. If the result is NULL, just select all the enabled controllers.

This patch check if the specified controller of mount is disabled, and return
"Disabled controller xx" error if true.

Thanks,
Chen Zhou
>
> Thanks.
>

