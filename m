From: Xiubo Li <lixiubo-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] cgroup: add opts release function to simplify the code
Date: Mon, 14 Mar 2016 09:30:36 +0800
Message-ID: <56E6143C.6060400@cmss.chinamobile.com>
References: <1457680035-26772-1-git-send-email-lixiubo@cmss.chinamobile.com> <20160311172617.GE24046@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160311172617.GE24046-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 12/03/2016 01:26, Tejun Heo wrote:
> On Fri, Mar 11, 2016 at 03:07:15PM +0800, Xiubo Li wrote:
>> The old code is a bit confusing for the readers by thinking why
>> these two members of opts should be released?
>>
>> The resources allocated by whom has the possiblity to release it,
>> But this will make the opts parse function more complex. So add
>> opts release function to simplify the code, and at the same time
>> to make the code more easy to read and be understood.
>
> I'm not really sure this improves anything.
>

Okay

Thanks,

> Thanks.
>

