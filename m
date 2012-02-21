From: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: fix page_referencies cgroup filter on global
 reclaim
Date: Tue, 21 Feb 2012 15:38:04 +0400
Message-ID: <4F43821C.7080001@openvz.org>
References: <20120215162830.13902.60256.stgit@zurg> <20120221104622.GB1676@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=D2p3omjh1RsUO9reXkKYtdFR8CiBpsZuF4AcLQXIYmM=;
        b=aaUj4iuex2EmDsmGvgLEMkVytxMYqhOFwnTlWqMky57hOu+w01D3GmXf70dj+OBs8h
         KyJZ4p8BVW2iqjEf4/3otmKVBcq9O1jsOP+M01ETtZ879oZkPG+1EwZnWnDfXiM8c97i
         l75KTTK1l+m+sWVJ+5ets+wAiTXzgzm32943Y=
In-Reply-To: <20120221104622.GB1676-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Johannes Weiner wrote:
> On Wed, Feb 15, 2012 at 08:28:30PM +0400, Konstantin Khlebnikov wrote:
>> Global memory reclaimer should't skip referencies for any pages,
>> even if they are shared between different cgroups.
>
> Agreed: if we reclaim from one memcg because of its limit, we want to
> reclaim those pages that this group is not using.  If it's used by
> someone else, it should be evicted and refaulted by the group that
> needs it.
>
> If we reclaim globally, all references are "true" because we want to
> evict those pages that are not used by any cgroup.
>
> But if we reclaim a hierarchical subgroup, we don't want to evict
> pages that are shared among this hierarchy, either, even if the memcg
> that has the page charged to it is not using it.  Bouncing the page
> around the hierarchy is not sensible, because it does not solve the
> problem of the parent hitting its limit when the sibling group will
> refault it in a blink of an eye.  It should only be evicted if the
> memcg that's not using it nears its own limit, because only in that
> case would reclaiming the page remedy the situation.
>
>> This patch adds scan_control->current_mem_cgroup, which points to currently
>> shrinking sub-cgroup in hierarchy, at global reclaim it always NULL.
>
> So to be consistent, I'm wondering if we should pass
> sc->target_mem_cgroup - the limit-hitting hierarchy root - to
> page_referenced() and then have mm_match_cgroup() do a
> mem_cgroup_same_or_subtree() check to see if the vma is in the
> hierarchy rooted at sc->target_mem_cgroup.
>
> Global reclaim is handled automatically, because mm_match_cgroup() is
> not checked when the passed memcg is NULL, which sc->target_mem_cgroup
> is for global reclaim.

Also we can try to recharge page to other cgroup, if we found in rmap another its user
outsize of currently shrinking hierarchy, page there is isolated, so at the end we will
insert page directly to its lru.

But the main purpose of this patch for me is killing mz->mem_cgroup dereference,
because I plan to replace mz with direct reference to lruvec, which will be memcg-free object.
