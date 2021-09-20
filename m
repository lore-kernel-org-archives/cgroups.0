From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH mm] vmalloc: back off when the current task is OOM-killed
Date: Mon, 20 Sep 2021 13:59:35 +0300
Message-ID: <c9d43874-138e-54a9-3222-a08c269eeeb5@virtuozzo.com>
References: <YT8PEBbYZhLixEJD@dhcp22.suse.cz>
 <d07a5540-3e07-44ba-1e59-067500f024d9@virtuozzo.com>
 <20210919163126.431674722b8db218453dc18c@linux-foundation.org>
 <bb5616b0-faa6-e12a-102b-b9c402e27ec1@i-love.sakura.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=fcfmlYi3oAy4mMPZc/zpifYS2k4Mu/wKqEuxn9NCLX4=; b=EhkzUTTiPeP0y6QIE
        tS5yZapeEnmboz9k8rcjYQVLemv3ZB7BlHR7WxOxSQlcuirn39nyxvtPU6OpMxggj32Oxd8GkTELH
        iBig6CzhI8Yf4h49HvGp/nyMcA4lKhB3UwLQtv2FemHd4TnAPw9+ItZfEPuTGGNEldqb4uv1Nay6o
        =;
In-Reply-To: <bb5616b0-faa6-e12a-102b-b9c402e27ec1-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Uladzislau Rezki (Sony)" <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 9/20/21 4:22 AM, Tetsuo Handa wrote:
> On 2021/09/20 8:31, Andrew Morton wrote:
>> On Fri, 17 Sep 2021 11:06:49 +0300 Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>>
>>> Huge vmalloc allocation on heavy loaded node can lead to a global
>>> memory shortage. A task called vmalloc can have the worst badness
>>> and be chosen by OOM-killer, however received fatal signal and
>>> oom victim mark does not interrupt allocation cycle. Vmalloc will
>>> continue allocating pages over and over again, exacerbating the crisis
>>> and consuming the memory freed up by another killed tasks.
>>>
>>> This patch allows OOM-killer to break vmalloc cycle, makes OOM more
>>> effective and avoid host panic.
>>>
>>> Unfortunately it is not 100% safe. Previous attempt to break vmalloc
>>> cycle was reverted by commit b8c8a338f75e ("Revert "vmalloc: back off when
>>> the current task is killed"") due to some vmalloc callers did not handled
>>> failures properly. Found issues was resolved, however, there may
>>> be other similar places.
>>
>> Well that was lame of us.
>>
>> I believe that at least one of the kernel testbots can utilize fault
>> injection.  If we were to wire up vmalloc (as we have done with slab
>> and pagealloc) then this will help to locate such buggy vmalloc callers.

Andrew, could you please clarify how we can do it?
Do you mean we can use exsiting allocation fault injection infrastructure to trigger
such kind of issues? Unfortunately I found no ways to reach this goal.
It  allows to emulate single faults with small probability, however it is not enough,
we need to completely disable all vmalloc allocations. 
I've tried to extend fault injection infrastructure however found that it is not trivial.

That's why I've added direct fatal_signal_pending() check into my patch.
 
> __alloc_pages_bulk() has three callers.
> 
>   alloc_pages_bulk_list() => No in-tree users.
> 
>   alloc_pages_bulk_array() => Used by xfs_buf_alloc_pages(), __page_pool_alloc_pages_slow(), svc_alloc_arg().
> 
>     xfs_buf_alloc_pages() => Might retry forever until all pages are allocated (i.e. effectively __GFP_NOFAIL). This patch can cause infinite loop problem.

You are right, I've missed it.
However __alloc_pages_bulk() can return no new pages without my patch too:
- due to fault injection inside  prepare_alloc_pages()
- if __rmqueue_pcplist() returns NULL and if array already had some assigned pages,
- if both __rmqueue_pcplist() and following __alloc_pages(0) cannot get any page.
On the other hand I cannot say that it is 100% xfs-related issue, it looks strange
but they have some chance to get page after few attemps.

So I think I can change 'break' to 'goto failed_irq', call __alloc_pages(0) and
return 1 page. It seems is handled correctly in all callers too.

>     __page_pool_alloc_pages_slow() => Will not retry if allocation failed. This patch might help.
> 
>     svc_alloc_arg() => Will not retry if signal pending. This patch might help only if allocating a lot of pages.
> 
>   alloc_pages_bulk_array_node() => Used by vm_area_alloc_pages().
> 
> vm_area_alloc_pages() => Used by __vmalloc_area_node() from __vmalloc_node_range() from vmalloc functions. Needs !__GFP_NOFAIL check?

Comments in description of __vmalloc_node() and kvmalloc() claim that __GFP_NOFAIL is not supported,
I did not found any other callers used this flag.
