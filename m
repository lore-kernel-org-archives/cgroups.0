From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 1/7] small cleanup for memcontrol.c
Date: Wed, 29 Feb 2012 14:30:35 -0300
Message-ID: <4F4E60BB.9030007@parallels.com>
References: <1329824079-14449-1-git-send-email-glommer@parallels.com> <1329824079-14449-2-git-send-email-glommer@parallels.com> <20120222094619.caffc432.kamezawa.hiroyu@jp.fujitsu.com> <4F44F54A.8010902@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F44F54A.8010902-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 02/22/2012 12:01 PM, Glauber Costa wrote:
> On 02/22/2012 04:46 AM, KAMEZAWA Hiroyuki wrote:
>> On Tue, 21 Feb 2012 15:34:33 +0400
>> Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>>
>>> Move some hardcoded definitions to an enum type.
>>>
>>> Signed-off-by: Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>>> CC: Kirill A. Shutemov<kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
>>> CC: Greg Thelen<gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> CC: Johannes Weiner<jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> CC: Michal Hocko<mhocko-AlSwsSmVLrQ@public.gmane.org>
>>> CC: Hiroyouki Kamezawa<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>>> CC: Paul Turner<pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> CC: Frederic Weisbecker<fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> seems ok to me.
>>
>> Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>
> BTW, this series is likely to go through many rounds of discussion.
> This patch can be probably picked separately, if you want to.
>
>> a nitpick..
>>
>>> ---
>>> mm/memcontrol.c | 10 +++++++---
>>> 1 files changed, 7 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 6728a7a..b15a693 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -351,9 +351,13 @@ enum charge_type {
>>> };
>>>
>>> /* for encoding cft->private value on file */
>>> -#define _MEM (0)
>>> -#define _MEMSWAP (1)
>>> -#define _OOM_TYPE (2)
>>> +
>>> +enum mem_type {
>>> + _MEM = 0,
>>
>> =0 is required ?
> I believe not, but I always liked to use it to be 100 % explicit.
> Personal taste... Can change it, if this is a big deal.

Kame, would you like me to send this cleanup without the = 0 ?
