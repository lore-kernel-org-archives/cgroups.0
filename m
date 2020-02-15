From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 4/9] hugetlb: disable region_add file_region
 coalescing
Date: Fri, 14 Feb 2020 17:27:40 -0800
Message-ID: <21db60be-221d-339c-412a-6bb2509c4262@oracle.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211213128.73302-4-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=c25DV/PWTqDQtmzKwshNZ8aSa23KEScWw4d7ve/5NJo=;
 b=OKBBBUD9klBKnQJPAy1l96os99u0TJPrIDcVjhk4lbLvt3KprfUhWhgGr+FS9n6/JAxg
 2mieSPv7cApr2dOfIAt57zcjnFDpyiqXZaBS45Ina3pMnzwMh6e1MbKzTlRP/x5Tmr7Y
 XMPZ78oB/138uxSXwoWAwogpCMLCw1FYzKO1VbhLrE6NL28kbfH09iSPr4WqXJgJFQz3
 yEjcXLzp+8IRl+BT22PoFC+PGHpdLpvRJpZfKzp4D6cPfnx+P7CEFFy2Ez+BJHl2ZrnT
 M2/Hjfz7iMDQKP0+3dpqhVgFI005GmvQUV/fi0iLDojmp5bMogQ2qdhLe90oWmSX570V tw== 
In-Reply-To: <20200211213128.73302-4-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/11/20 1:31 PM, Mina Almasry wrote:
> A follow up patch in this series adds hugetlb cgroup uncharge info the
> file_region entries in resv->regions. The cgroup uncharge info may
> differ for different regions, so they can no longer be coalesced at
> region_add time. So, disable region coalescing in region_add in this
> patch.
> 
> Behavior change:
> 
> Say a resv_map exists like this [0->1], [2->3], and [5->6].
> 
> Then a region_chg/add call comes in region_chg/add(f=0, t=5).
> 
> Old code would generate resv->regions: [0->5], [5->6].
> New code would generate resv->regions: [0->1], [1->2], [2->3], [3->5],
> [5->6].
> 
> Special care needs to be taken to handle the resv->adds_in_progress
> variable correctly. In the past, only 1 region would be added for every
> region_chg and region_add call. But now, each call may add multiple
> regions, so we can no longer increment adds_in_progress by 1 in region_chg,
> or decrement adds_in_progress by 1 after region_add or region_abort. Instead,
> region_chg calls add_reservation_in_range() to count the number of regions
> needed and allocates those, and that info is passed to region_add and
> region_abort to decrement adds_in_progress correctly.
> 
> We've also modified the assumption that region_add after region_chg
> never fails. region_chg now pre-allocates at least 1 region for
> region_add. If region_add needs more regions than region_chg has
> allocated for it, then it may fail.
> 
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 

Reviewed-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

My reason for previously asking my Reviewed-by be removed is because I did
not realize the suboptimal behavior for private mappings would be addressed
in a subsequent patch.  That should be OK as nobody should be using just
part of this series.  If we need to respin, it might be worth noting this in
the commit message.  Something like:
With file_region coalescing disabled, private mappings will have one
file_region for each page in the mapping.  This suboptimal behavior will
be addressed in a later patch in this series.

> ---
> 
> Changes in v12:
> - Removed Mike's Reviewed-by until coalescing is reviewed per his
> request.
> - Added VM_BUG_ON that was mistakingly in a follow up patch.
