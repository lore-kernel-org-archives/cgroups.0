From: Vasily Averin <vvs@openvz.org>
Subject: Re: [PATCH memcg RFC] net: set proper memcg for net_init hooks
 allocations
Date: Fri, 22 Apr 2022 23:09:01 +0300
Message-ID: <e9cd84f2-d2e9-33a8-d74e-edcf60d35236@openvz.org>
References: <46c1c59e-1368-620d-e57a-f35c2c82084d@linux.dev>
 <55605876-d05a-8be3-a6ae-ec26de9ee178@openvz.org>
 <CALvZod47PARcupR4P41p5XJRfCaTqSuy-cfXs7Ky9=-aJQuoFA@mail.gmail.com>
 <964ae72a-0484-67de-8143-a9a2d492a520@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=B9p0FoMPwzRixWYKVWEjx56sWOvt3enSLFG849SajN4=;
        b=i1xRqM/AQD7+zHlviCXpKPZZPH+NCey1cLY0YH9FoGiR73p/X6PTLSYWksAgy2XKmM
         ksiRnL7gx+oyU+FNTO7SF58wlUemyiGD7RFZqO8+RoT1p8NIqoBwjr6bNOASrAsJ1UPa
         YEjor8or6jM8yb19a+Jv4wMbSUGBGFj1fsk8zUp+BhH4KT4geUPppJf+2cvULcwK594C
         Ify1KqH7eFxQGny0PELELVDTWBxzSbVh/a4r+fXHN5VQ7XPgWdPBC0veaqgeUbtBqSrI
         TFb6ms3NcP0CuGTa6PRcEB1utLkbyV3aUe24o+fgprm8x3rB5dwmvLiOnq5fX0atxqYg
         xUkg==
Content-Language: en-US
In-Reply-To: <964ae72a-0484-67de-8143-a9a2d492a520@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>, kernel@openvz.org, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>

On 4/22/22 23:01, Vasily Averin wrote:
> On 4/21/22 18:56, Shakeel Butt wrote:
>> On Sat, Apr 16, 2022 at 11:39 PM Vasily Averin <vvs@openvz.org> wrote:
>>> @@ -1147,7 +1148,13 @@ static int __register_pernet_operations(struct list_head *list,
>>>                  * setup_net() and cleanup_net() are not possible.
>>>                  */
>>>                 for_each_net(net) {
>>> +                       struct mem_cgroup *old, *memcg = NULL;
>>> +#ifdef CONFIG_MEMCG
>>> +                       memcg = (net == &init_net) ? root_mem_cgroup : mem_cgroup_from_obj(net);
>>
>> memcg from obj is unstable, so you need a reference on memcg. You can
>> introduce get_mem_cgroup_from_kmem() which works for both
>> MEMCG_DATA_OBJCGS and MEMCG_DATA_KMEM. For uncharged objects (like
>> init_net) it should return NULL.
> 
> Could you please elaborate with more details?
> It seems to me mem_cgroup_from_obj() does everything exactly as you say:
> - for slab objects it returns memcg taken from according slab->memcg_data
> - for ex-slab objects (i.e. page->memcg_data & MEMCG_DATA_OBJCGS)
>     page_memcg_check() returns NULL
> - for kmem objects (i.e. page->memcg_data & MEMCG_DATA_KMEM) 
>     page_memcg_check() returns objcg->memcg
> - in another cases
>     page_memcg_check() returns page->memcg_data,
>     so for uncharged objects like init_net NULL should be returned.
> 
> I can introduce exported get_mem_cgroup_from_kmem(), however it should only
> call mem_cgroup_from_obj(), perhaps under read_rcu_lock/unlock.

I think I finally got your point:
Do you mean I should use css_tryget(&memcg->css) for found memcg,
like get_mem_cgroup_from_mm() does?

Thank you,
	Vasily Averin
