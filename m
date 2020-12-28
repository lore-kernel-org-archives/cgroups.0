From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: Remove stale URLs in the MAINTAINERS entry
Date: Mon, 28 Dec 2020 14:31:52 +0800
Message-ID: <39449cc4-15bf-4570-2bbd-dd47ea73b86c@huawei.com>
References: <42668f2c-5ea1-da38-918e-ac4c86e3f03d@huawei.com>
 <2822d565280536f36ea6ddd521a7716813ef85a2.camel@perches.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2822d565280536f36ea6ddd521a7716813ef85a2.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wahl <steve.wahl-ZPxbGqLxI0U@public.gmane.org>

On 2020/12/28 14:01, Joe Perches wrote:
> On Mon, 2020-12-28 at 11:17 +0800, Zefan Li wrote:
>> Those URLs are no longer accessable.
>>
>> Reported-by: Steve Wahl <steve.wahl-ZPxbGqLxI0U@public.gmane.org>
>> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  MAINTAINERS | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ae9b1dd748c4..2fe8eb54639e 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -4477,8 +4477,6 @@ CONTROL GROUP - CPUSET
>>  M:	Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>  L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>  S:	Maintained
>> -W:	http://www.bullopensource.org/cpuset/
>> -W:	http://oss.sgi.com/projects/cpusets/
> 
> The general argument to avoid removal of these no longer valid links
> is that they may still be available from archive.org.
> 
> For instance:
> 
> https://web.archive.org/web/20170512010721/http://oss.sgi.com/projects/cpusets/
> 
> It may be appropriate to copy the content into a local Documentation
> file somewhere to avoid the need to lookup old reference links.
> 

I don't think the contents in those links provide valuable information about cpusets.
We have documents in Documentation/admin-guide/cgroup/ and man cpuset(7). So I think
we can just remove them.
