From: Johannes Weiner <jweiner-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: memcontrol: drop unnecessary lru locking from
 mem_cgroup_migrate()
Date: Sun, 7 Feb 2016 18:57:49 +0000
Message-ID: <28CC6A8F-E642-4DF5-A8E5-DB9BB62DA429@fb.com>
References: <1454616467-8994-1-git-send-email-hannes@cmpxchg.org>
 <1454616467-8994-2-git-send-email-hannes@cmpxchg.org>,<20160207184059.GB19151@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=from : to : cc : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Onl8n58+kA3lF51Bl6Lp+FisZnDJcHsQHHzFaQWUvt0=;
 b=eSYilh++b7B9S7z9cmMDhsElaAN3nIRZXyhOX0tgjDWOGrF2udwmajVrsBS5W8js9QNr
 s0bh0DbLixAb1tUZStsZFjueamroYVD0cl/lvLW7XdGR7ktqtomEhEbJx+vdixXTiYWM
 hRp5jnHDjup40tBiNHREN0IyKXbv/z8vVoU= 
In-Reply-To: <20160207184059.GB19151@esperanza>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <Kernel-team-b10kYP2dOMg@public.gmane.org>

> On Feb 7, 2016, at 1:41 PM, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> 
>> On Thu, Feb 04, 2016 at 03:07:47PM -0500, Johannes Weiner wrote:
>> Migration accounting in the memory controller used to have to handle
>> both oldpage and newpage being on the LRU already; fuse's page cache
>> replacement used to pass a recycled newpage that had been uncharged
>> but not freed and removed from the LRU, and the memcg migration code
>> used to uncharge oldpage to "pass on" the existing charge to newpage.
>> 
>> Nowadays, pages are no longer uncharged when truncated from the page
>> cache, but rather only at free time, so if a LRU page is recycled in
>> page cache replacement it'll also still be charged. And we bail out of
>> the charge transfer altogether in that case. Tell commit_charge() that
>> we know newpage is not on the LRU, to avoid taking the zone->lru_lock
>> unnecessarily from the migration path.
>> 
>> But also, oldpage is no longer uncharged inside migration. We only use
>> oldpage for its page->mem_cgroup and page size, so we don't care about
>> its LRU state anymore either. Remove any mention from the kernel doc.
>> 
>> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> Suggested-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Acked-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Thanks!

> @@ -5483,6 +5483,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
>    unsigned int nr_pages;
>    bool compound;
> 
> +    VM_BUG_ON_PAGE(PageLRU(newpage), newpage);

That's actually possible for fuse. But in that case newpage is charged and we bail.--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
