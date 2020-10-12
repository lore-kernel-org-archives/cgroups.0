From: Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: fix device private memcg accounting
Date: Mon, 12 Oct 2020 10:11:07 -0700
Message-ID: <1d029649-7f34-4f8a-3721-0154001a63ac@nvidia.com>
References: <20201009215952.2726-1-rcampbell@nvidia.com>
 <20201009155055.f87de51ea04d4ea879e3981a@linux-foundation.org>
 <d1aab0b0-4327-38da-6587-98f1740228fd@nvidia.com>
 <20201012132859.GD163830@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201012132859.GD163830-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602522658; bh=LQh2H3qyxp3qJsZdje88nocGHD8ApGuulqjnVFd+f0M=;
        h=Subject:To:CC:References:X-Nvconfidentiality:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=pdinanZ3WSo3hvEXLhjY3+I1OdTsCFPXR/so9doT6WLjiCZ900YJfHXigHEIdA3BH
         eBzuzXwGbMAokDvcMdlvwMnhRroK2u5iwqpAUW+KOqw2R0qlVU2G+N55GKkRVND0G9
         SgeNKeXDWCW5+c9QeRvkROP5MkM34rlOQYEt+jX2t1DB/szIN7yHVFG70hdcoGYKx3
         NDnfqJkRWnUwjiwSsnOvbIWFZc27fqhxcchQu/rXTiQogEXz5FLzxafOCNXkLEhg1z
         N/yWpTI9PXZap0CwvA47nsaFJcjR5+MwnQDPF+cOLLJiUilH5cyTg7k62n/7Qup+Td
         uDC/A81hnSbxA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On 10/12/20 6:28 AM, Johannes Weiner wrote:
> On Fri, Oct 09, 2020 at 05:00:37PM -0700, Ralph Campbell wrote:
>>
>> On 10/9/20 3:50 PM, Andrew Morton wrote:
>>> On Fri, 9 Oct 2020 14:59:52 -0700 Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>>> The code in mc_handle_swap_pte() checks for non_swap_entry() and returns
>>>> NULL before checking is_device_private_entry() so device private pages
>>>> are never handled.
>>>> Fix this by checking for non_swap_entry() after handling device private
>>>> swap PTEs.
> 
> The fix looks good to me.
> 
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> 
>>> But this makes me suspect the answer is "there aren't any that we know
>>> of".  Are you sure a cc:stable is warranted?
>>>
>>
>> I assume the memory cgroup accounting would be off somehow when moving
>> a process to another memory cgroup.
>> Currently, the device private page is charged like a normal anonymous page
>> when allocated and is uncharged when the page is freed so I think that path is OK.
>> Maybe someone who knows more about memory cgroup accounting can comment?
> 
> As for whether to CC stable, I'm leaning toward no:
> 
> - When moving tasks, we'd leave their device pages behind in the old
>    cgroup. This isn't great, but it doesn't cause counter imbalances or
>    corruption or anything - we also skip locked pages, we used to skip
>    pages mapped by more than one pte, the user can select whether to
>    move pages along tasks at all, and if so, whether only anon or file.
> 
> - Charge moving itself is a bit of a questionable feature, and users
>    have been moving away from it. Leaving tasks in a cgroup and
>    changing the configuration is a heck of a lot cheaper than moving
>    potentially gigabytes of pages to another configuration domain.
> 
> - According to the Fixes tag, this isn't a regression, either. Since
>    their inception, we have never migrated device pages.

Thanks for the Acked-by and the comments.
I assume Andrew will update the tags when queuing this up unless he wants me to resend.
