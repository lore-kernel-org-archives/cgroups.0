From: Guillaume Morin <guillaume-/FyPzM6KSZdAfugRpC6u6w@public.gmane.org>
Subject: Re: [BUG] potential hugetlb css refcounting issues
Date: Sat, 28 Aug 2021 00:58:43 +0200
Message-ID: <20210827225841.GA30891@bender.morinfr.org>
References: <8a4f2fbc-76e8-b67b-f110-30beff2228f5@oracle-com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
        ; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:To:
        From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7DJVtMpzm9oxuyqntlCJVVhZoeJfYs38uQ3cZd0skFs=; b=4rlRF3Hd5lDAg9L8xjFB/XxBl8
        k1Mmg1v5cHtDuzaaYMcznDw4/DDEOGB3yNMe9scXQmd32494EbEXscjyb0dajfSnWIwpeR11/pufy
        aZpJf7iVXLCTGi4Q6qkXqQnASllosSdNLgXpKv3HZp+xp/Xnnt0RlkQItUEgiR7FlH4U=;
Content-Disposition: inline
In-Reply-To: <8a4f2fbc-76e8-b67b-f110-30beff2228f5@oracle-com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guillaume-/FyPzM6KSZdAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello Mike,

I really appreciate the quick reply

Mike Kravets wrote: 
> There have been other hugetlb cgroup fixes since 5.10.  I do not believe
> they are related to the underflow issue you have seen.  Just FYI.

Yes, I am aware. Actually I did my best to look at all recent changes
not backported to 5.10 and couldn't find anything related. I tried to
cherry-pick a couple of fixes in case but the bug did not go away.

> However, when a vma is split both resulting vmas would be 'owners' of
> private mapping reserves without incrementing the refcount which would
> lead to the underflow you describe.

Indeed and I do know that programs running on my reproducer machines do
split vmas.

>> 2. After 08cf9faf75580, __free_huge_page() decrements the css
>> refcount for _each_ page unconditionally by calling
>> hugetlb_cgroup_uncharge_page_rsvd().  But a per-page reference count
>> is only taken *per page* outside the reserve case in
>> alloc_huge_page() (i.e hugetlb_cgroup_charge_cgroup_rsvd() is called
>> only if deferred_reserve is true).  In the reserve case, there is
>> only one css reference linked to the resv map (taken in
>> hugetlb_reserve_pages()).  This also leads to an underflow of the
>> counter.  A similar scheme to HPageRestoreReserve can be used to
>> track which pages were allocated in the deferred_reserve case and
>> call hugetlb_cgroup_uncharge_page_rsvd() only for these during
>> freeing.

> I am not sure about the above analysis.  It is true that
> hugetlb_cgroup_uncharge_page_rsvd is called unconditionally in
> free_huge_page.  However, IIUC hugetlb_cgroup_uncharge_page_rsvd will
> only decrement the css refcount if there is a non-NULL hugetlb_cgroup
> pointer in the page.  And, the pointer in the page would only be set
> in the 'deferred_reserve' path of alloc_huge_page.  Unless I am
> missing something, they seem to balance.

Now that you explain, I am pretty sure that you're right and I was
wrong.

I'll confirm that I can't reproduce without my change for 2.

Thank you,

Guillaume.

-- 
Guillaume Morin <guillaume-/FyPzM6KSZdAfugRpC6u6w@public.gmane.org>
