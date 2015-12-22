From: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RESEND PATCH 2/2] cpuacct: split usage into user_usage and sys_usage.
Date: Tue, 22 Dec 2015 16:12:20 +0800
Message-ID: <567905E4.70108@cn.fujitsu.com>
References: <1450696483-2864-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1450696483-2864-2-git-send-email-yangds.fnst@cn.fujitsu.com> <20151221213328.GP4026@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151221213328.GP4026-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org

On 12/22/2015 05:33 AM, Tejun Heo wrote:
> On Mon, Dec 21, 2015 at 07:14:43PM +0800, Dongsheng Yang wrote:
>> Sometimes, cpuacct.usage is not detialed enough to user
>> to see how much usage a group used. We want to know how
>> much time it used in user mode and how much in kernel mode.
>
> cpuusage is being phased out.  If you need these stats, please
> implement it on cpu side.

Hi TJ, thanx, then I will look at introducing this feature in cpu side
then.

Thanx
Yang
>
> Thanks.
>


