From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH mm] vmalloc: back off when the current task is OOM-killed
Date: Mon, 20 Sep 2021 10:22:46 +0900
Message-ID: <bb5616b0-faa6-e12a-102b-b9c402e27ec1@i-love.sakura.ne.jp>
References: <YT8PEBbYZhLixEJD@dhcp22.suse.cz>
 <d07a5540-3e07-44ba-1e59-067500f024d9@virtuozzo.com>
 <20210919163126.431674722b8db218453dc18c@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20210919163126.431674722b8db218453dc18c@linux-foundation.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vvs@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel@openvz.org, "Uladzislau Rezki (Sony)" <urezki@gmail.com>

On 2021/09/20 8:31, Andrew Morton wrote:
> On Fri, 17 Sep 2021 11:06:49 +0300 Vasily Averin <vvs@virtuozzo.com> wrote:
> 
>> Huge vmalloc allocation on heavy loaded node can lead to a global
>> memory shortage. A task called vmalloc can have the worst badness
>> and be chosen by OOM-killer, however received fatal signal and
>> oom victim mark does not interrupt allocation cycle. Vmalloc will
>> continue allocating pages over and over again, exacerbating the crisis
>> and consuming the memory freed up by another killed tasks.
>>
>> This patch allows OOM-killer to break vmalloc cycle, makes OOM more
>> effective and avoid host panic.
>>
>> Unfortunately it is not 100% safe. Previous attempt to break vmalloc
>> cycle was reverted by commit b8c8a338f75e ("Revert "vmalloc: back off when
>> the current task is killed"") due to some vmalloc callers did not handled
>> failures properly. Found issues was resolved, however, there may
>> be other similar places.
> 
> Well that was lame of us.
> 
> I believe that at least one of the kernel testbots can utilize fault
> injection.  If we were to wire up vmalloc (as we have done with slab
> and pagealloc) then this will help to locate such buggy vmalloc callers.

__alloc_pages_bulk() has three callers.

  alloc_pages_bulk_list() => No in-tree users.

  alloc_pages_bulk_array() => Used by xfs_buf_alloc_pages(), __page_pool_alloc_pages_slow(), svc_alloc_arg().

    xfs_buf_alloc_pages() => Might retry forever until all pages are allocated (i.e. effectively __GFP_NOFAIL). This patch can cause infinite loop problem.

    __page_pool_alloc_pages_slow() => Will not retry if allocation failed. This patch might help.

    svc_alloc_arg() => Will not retry if signal pending. This patch might help only if allocating a lot of pages.

  alloc_pages_bulk_array_node() => Used by vm_area_alloc_pages().

vm_area_alloc_pages() => Used by __vmalloc_area_node() from __vmalloc_node_range() from vmalloc functions. Needs !__GFP_NOFAIL check?
