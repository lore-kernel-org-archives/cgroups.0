From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 07/10] memcg: Stop res_counter underflows.
Date: Wed, 29 Feb 2012 14:05:52 -0300
Message-ID: <4F4E5AF0.1080303@parallels.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org> <1330383533-20711-8-git-send-email-ssouhlal@FreeBSD.org> <4F4CD731.60908@parallels.com> <CABCjUKCaJVGShRKRkvBMrz_XNVGNrcguQ1uTP8Am1fQ1Te6PWA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABCjUKCaJVGShRKRkvBMrz_XNVGNrcguQ1uTP8Am1fQ1Te6PWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 02/28/2012 08:07 PM, Suleiman Souhlal wrote:
> On Tue, Feb 28, 2012 at 5:31 AM, Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>> I don't fully understand this.
>> To me, the whole purpose of having a cache tied to a memcg, is that we know
>> all allocations from that particular cache should be billed to a specific
>> memcg. So after a cache is created, and has an assigned memcg,
>> what's the point in bypassing it to root?
>>
>> It smells like you're just using this to circumvent something...
>
> In the vast majority of the cases, we will be able to account to the cgroup.
> However, there are cases when __mem_cgroup_try_charge() is not able to
> do so, like when the task is being killed.
> When this happens, the allocation will not get accounted to the
> cgroup, but the slab accounting code will still think the page belongs
> to the memcg's kmem_cache.
> So, when we go to free the page, we assume that the page belongs to
> the memcg and uncharge it, even though it was never charged to us in
> the first place.
>
> This is the situation this patch is trying to address, by keeping a
> counter of how much memory has been bypassed like this, and uncharging
> from the root if we have any outstanding bypassed memory.
>
> Does that make sense?
>
Yes, but how about the following:

I had a similar problem in tcp accounting, and solved that by adding 
res_counter_charge_nofail().

I actually implemented something very similar to your bypass (now that I 
understand it better...) and gave up in favor of this.

The tcp code has its particularities, but still, that could work okay 
for the general slab.

Reason being:

Consider you have a limit of X, and is currently at X-1. You bypassed a 
page.

So in reality, you should fail the next allocation, but you will not - 
(unless you start considering the bypassed memory at allocation time as 
well).

If you use res_counter_charge_nofail(), you will:

  1) Still proceed with the allocations that shouldn't fail - so no
     difference here
  2) fail the normal allocations if you have "bypassed" memory filling
     up your limit
  3) all that without coupling something alien to the res_counter API.



