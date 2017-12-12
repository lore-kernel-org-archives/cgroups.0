From: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] cgroup: limit max copied char length for cgroup file name
Date: Tue, 12 Dec 2017 09:19:01 +0800
Message-ID: <5d335794-f8e1-c763-a81e-49413733b696@cn.fujitsu.com>
References: <20171209054758.13870-1-mashimiao.fnst@cn.fujitsu.com>
 <20171211150551.GC2421075@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171211150551.GC2421075-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-MW
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 12/11/2017 11:05 PM, Tejun Heo wrote:
> On Sat, Dec 09, 2017 at 01:47:58PM +0800, Ma Shimiao wrote:
>> the result of cgroup_file_name will be used by kernfs_remove_name,
>> and then by kernfs_remove_by_name_ns().
>> If reached the max length, may have problem printed by WARN() in
>> kernfs_remove_by_name_ns().
>>
>> Signed-off-by: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> 
> Can we use strscpy() instead?

OK, I will update the patch
> 
> Thanks.
> 


-- 
Ma Shimiao
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)

