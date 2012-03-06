From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 04/10] memcg: Introduce __GFP_NOACCOUNT.
Date: Tue, 6 Mar 2012 14:36:43 +0400
Message-ID: <4F55E8BB.5060704@parallels.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org> <1330383533-20711-5-git-send-email-ssouhlal@FreeBSD.org> <20120229150041.62c1feeb.kamezawa.hiroyu@jp.fujitsu.com> <CABCjUKBHjLHKUmW6_r0SOyw42WfV0zNO7Kd7FhhRQTT6jZdyeQ@mail.gmail.com> <20120301091044.1a62d42c.kamezawa.hiroyu@jp.fujitsu.com> <4F4EC1AB.8050506@parallels.com> <20120301150537.8996bbf6.kamezawa.hiroyu@jp.fujitsu.com> <4F522910.1050402@parallels.com> <CABCjUKBngJx0o5jnJk3FEjWUDA6aNTAiFENdEF+M7BwB85NaLg@mail.gmail.com> <4F52A81A.3030408@parallels.com> <CABCjUKBP=pKgDP5RkD4BimTjoE=bQQO7NxNNAiGUfy602T4c7A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABCjUKBP=pKgDP5RkD4BimTjoE=bQQO7NxNNAiGUfy602T4c7A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 03/04/2012 04:10 AM, Suleiman Souhlal wrote:
> On Sat, Mar 3, 2012 at 3:24 PM, Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>> On 03/03/2012 01:38 PM, Suleiman Souhlal wrote:
>>> Another possible example might be the skb data, which are just kmalloc
>>> and are already accounted by your TCP accounting changes, so we might
>>> not want to account them a second time.
>>
>>
>> How so?
>>
>> struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>>                             int fclone, int node)
>> {
>>         [ ... ]
>>         cache = fclone ? skbuff_fclone_cache : skbuff_head_cache;
>>
>>         /* Get the HEAD */
>>         skb = kmem_cache_alloc_node(cache, gfp_mask&  ~__GFP_DMA, node);
>
> Just a few lines below:
>
>          data = kmalloc_node_track_caller(size, gfp_mask, node);
>
> -- Suleiman
Can't we just make sure those come from the root cgroup's slabs?
Then we need no flag.
