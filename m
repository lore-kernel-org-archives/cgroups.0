From: xiujianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] cgroup: Make cgroup_debug static
Date: Wed, 18 May 2022 14:48:36 +0800
Message-ID: <c099059c-2953-232d-3d53-e8863c221cb0@huawei.com>
References: <20220517112523.243386-1-xiujianfeng@huawei.com>
 <YoPWJZ+RJmlvBLwV@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YoPWJZ+RJmlvBLwV-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


在 2022/5/18 1:06, Tejun Heo 写道:
> On Tue, May 17, 2022 at 07:25:23PM +0800, Xiu Jianfeng wrote:
>> Make cgroup_debug static since it's only used in cgroup.c
>>
>> Signed-off-by: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> The only thing it does is gating CFTYPE_DEBUG which isn't used anymore.
> Can you remove both CFTYPE_DEBUG and cgroup_debug() instead?

It's ok to me, but I found CFTYPE_DEBUG is still used in cpuset subsys,

   .name = "cpus.subpartitions",
   .seq_show = cpuset_common_seq_show,
   .private = FILE_SUBPARTS_CPULIST,
   .flags = CFTYPE_DEBUG,

if remove CFTYPE_DEBUG and cgroup_debug,  cpus.subpartitions will be 
showed by default,  is this ok?

>
> Thanks.
>
