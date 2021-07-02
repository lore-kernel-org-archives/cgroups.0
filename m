From: Krzysztof Kozlowski <krzysztof.kozlowski-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: Process memory accounting (cgroups) accuracy
Date: Fri, 2 Jul 2021 12:40:28 +0200
Message-ID: <85b8a4f9-b9e9-a6ca-5d0c-c1ecb8c11ef3@canonical.com>
References: <69ffd3a0-2cb7-8baa-17d0-ae45a52595af@canonical.com>
 <YN7XgzB4bE2K9int@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YN7XgzB4bE2K9int-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 02/07/2021 11:08, Michal Hocko wrote:
> On Fri 02-07-21 09:50:11, Krzysztof Kozlowski wrote:
> [...]
>> The questions: How accurate are now the cgroup counters?
> 
> The precision depends on the number of CPUs the workload is running on
> as we do a per-cpu charge caching to optimize the accounting. This is
> MEMCG_CHARGE_BATCH (32) pages currently. You can learn more by checking
> try_charge function (mm/memcontrol.c).

This explains the 32 pages, thanks!

> 
>> I understood they should charge only pages allocated by the process, so
>> why mmap(4 kB) causes max_usage_in_bytes=132 kB?
> 
> Please note that kernel allocations (marked by __GFP_ACCOUNT) are
> accounted as well so this is not only about mmaped memory.
> 
>> Why mmap(4 MB) causes max_usage_in_bytes=4 MB + 34 pages?
> 
> The specific number will depend on the executing - e.g. use up all but 3
> pages from CPU0 batch and have 31 pages on another cpu.
> 
>> What is being accounted there (stack guards?)?
>>
>> Or maybe the entire LTP test checking so carefully memcg limits is useless?
> 
> Well, I haven't really checked details of those tests and their
> objective but aiming for an absolute precision is not really something
> that is very useful IMHO. We are very likely to do optimizations like
> the one mentioned above as the runtime tends to be much more important
> than to-the-page precision.
> 
> Hope this clarifies this a bit.

Yes, thanks!


Best regards,
Krzysztof
