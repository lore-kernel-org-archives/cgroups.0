From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: Replace all instances of time_t with time64_t
Date: Thu, 26 Nov 2015 20:08:42 +0800
Message-ID: <5656F64A.609@huawei.com>
References: <2798266.9VZu01a7d1@wuerfel>
 <20151125190150.GA14240@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151125190150.GA14240-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Heena Sirwani <heenasirwani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On 2015/11/26 3:01, Tejun Heo wrote:
> On Wed, Nov 25, 2015 at 04:16:55PM +0100, Arnd Bergmann wrote:
>> The following patch replaces all instances of time_t with time64_t i.e.
>> change the type used for representing time from 32-bit to 64-bit. All
>> 32-bit kernels to date use a signed 32-bit time_t type, which can only
>> represent time until January 2038. Since embedded systems running 32-bit
>> Linux are going to survive beyond that date, we have to change all
>> current uses, in a backwards compatible way.
>>
>> The patch also changes the function get_seconds() that returns a 32-bit
>> integer to ktime_get_seconds() that returns seconds as 64-bit integer.
>>
>> The patch changes the type of ticks from time_t to u32. We keep ticks as
>> 32-bits as the function uses 32-bit arithmetic which would prove less
>> expensive than 64-bit arithmetic and the function is expected to be
>> called atleast once every 32 seconds.
>>
>> Signed-off-by: Heena Sirwani <heenasirwani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Reviewed-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
>> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
>
> Applied to cgroup/for-4.5.
>

Acked
