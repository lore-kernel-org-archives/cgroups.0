From: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Fix a race between cpuset_attach() and cpu
 hotplug
Date: Sat, 22 Jan 2022 15:37:32 +0800
Message-ID: <eab13a50-463d-3d45-d58a-77dfebd3b4dd@huawei.com>
References: <20220121101210.84926-1-zhangqiao22@huawei.com>
 <20220121155705.GA2394@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220121155705.GA2394-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, bblum-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org



在 2022/1/21 23:57, Michal Koutný 写道:
> On Fri, Jan 21, 2022 at 06:12:10PM +0800, Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> Fixes: be367d099270 ("cgroups: let ss->can_attach and ss->attach do whole threadgroups at a time")
> 
> What a deep stratigraphy (not sure if it's this one but anything else
> would likely come from eras ago too).

Yes, I checked again and this bug may have existed since the tag Linux-2.6.12-rc2.
>> Reported-by: Zhao Gongyi <zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  kernel/cgroup/cpuset.c | 2 ++
>>  1 file changed, 2 insertions(+)
> 
> Feel free to include
> Reviewed-by: Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org>
> 
Thanks for your review!

Regards,
Qiao
.

> .
> 
