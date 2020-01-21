From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v10 4/8] hugetlb: disable region_add file_region
 coalescing
Date: Tue, 21 Jan 2020 10:50:59 -0800
Message-ID: <f7a07154-fba3-7ad7-7a6b-161e660a37c1@oracle.com>
References: <20200115012651.228058-1-almasrymina@google.com>
 <20200115012651.228058-4-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=f6ft9tle0RFZKhACFekrVTFG0KAq5griDIXNsdbXFDs=;
 b=TxRHhCibOlH2/ma9Ipo+Q1WBFLuQRf1qCSyLLimmT1NqWMh7UFMkL+GxGY5iYsQRdOuw
 SFVEpMtEdVpjjlz4Fx5B+d27z5fpIj4s91wvbQVwPETAyZ8mRaN6+7+VlvZCEsp+T212
 JXhhPQWlfrcC2PW+x54j6BZTArq1kTkQ8xnUp/FhYSYmCgfpvrud8EqKpX3NzgJhd9p8
 Kt3kXVgYthEoK1hgLNRbG3aMQbzZtQTObJLtP6JR9MHxAMNqXA52W5vFc2TP7vrXs0kB
 029K/1pTOASVeiCdea1r7kRtMP8sA4xZsjc6YffBtAscNSlfegSpEEAfJVVnTJ2vk3H+ uA== 
In-Reply-To: <20200115012651.228058-4-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>, rientjes@google.com, shakeelb@google.com
Cc: shuah@kernel.org, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com

On 1/14/20 5:26 PM, Mina Almasry wrote:
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

Some time back we briefly discussed an optimization to coalesce file
region entries if they were from the same cgroup.  At the time, the
thought was that such an optimization could wait.  For large mappings,
known users will reserve the entire area.  Smaller mappings such as
those in the commit log are not the common case and are mentioned mostly
to illustrate what the code must handle.

However, I just remembered that for private mappings file region entries
are allocated at page fault time: one per page.  Since we are no longer
coalescing, there will be one file region struct for each page in a
private mapping.  Is that correct?

I honestly do not know how common private mappings are today.  But,
this would cause excessive overhead for any large private mapping.

-- 
Mike Kravetz
