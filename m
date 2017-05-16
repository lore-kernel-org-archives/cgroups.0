From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: per-cgroup memory reclaim stats
Date: Tue, 16 May 2017 14:13:16 +0100
Message-ID: <20170516131316.GA7834@castle>
References: <1494530183-30808-1-git-send-email-guro@fb.com>
 <20170516092956.GF2481@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=qvnqdHW/kl6stuQqEzv4sPcpXH5Nw+WVCOk80rJNYs8=;
 b=JkofeoO47pbTD7U+artLaAhh6jupZc8flpu0RdR///ylgH1DS5UthfNJGthIXAVWdyQR
 X4AyJesmku11AE/Vlv9Rujh4Hp+nhACqPMWHLCZoXUb68/2p0xhsaM7aSW8cbGEeaVyZ
 fdlZfPFJGWZwSlE59Pf/TOvgq1PeZr1762w= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qvnqdHW/kl6stuQqEzv4sPcpXH5Nw+WVCOk80rJNYs8=;
 b=EmpLrxlsp6pfx3rc4Trm7IIGP3GJyAJFPFRjjdri7SnOPmqpHx+hpcXT9Nyy+qPRP/zdMY7Re5Sg5ayNxlbI9OObqHr5JNt7WGKUjA6jDT+4Kizz8H0zY8sEma5rl7zTAFUHe1UEP4W8tTDreKnITMXoOorb41lH0+v+ySjyXc4=
Content-Disposition: inline
In-Reply-To: <20170516092956.GF2481@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Hi Michal!

On Tue, May 16, 2017 at 11:29:56AM +0200, Michal Hocko wrote:
> On Thu 11-05-17 20:16:23, Roman Gushchin wrote:
> > Track the following reclaim counters for every memory cgroup:
> > PGREFILL, PGSCAN, PGSTEAL, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE and
> > PGLAZYFREED.
> 
> yes, those are definitely useful. I have an old patch to add them as
> well but never managed to clean it up and post...
> 
> > These values are exposed using the memory.stats interface of cgroup v2.
> 
> Is there any reason to not add them to v1?

Not really, I'm just not sure, if it worth it to change v1 interface here.
If you want, I can add them.

> This should be rather trivial after recent changes from Johannes.

If you're about memcg1_events[]/memcg1_event_names[], they can't be reused,
because the pgscan and pgsteal values are both sums of direct and kswapd values:
e.g. events[PGSTEAL_KSWAPD] + events[PGSTEAL_DIRECT].

> 
> > The meaning of each value is the same as for global counters,
> > available using /proc/vmstat.
> > 
> > Also, for consistency, rename mem_cgroup_count_vm_event() to
> > count_memcg_event_mm().
> > 
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Li Zefan <lizefan@huawei.com>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > Cc: cgroups@vger.kernel.org
> > Cc: linux-doc@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-mm@kvack.org
> 
> the patch itself looks good to me. I will have to double check it after
> I am done with what I am doing currently and then will add my Acked-by

Thank you!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
