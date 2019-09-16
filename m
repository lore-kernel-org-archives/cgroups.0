From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v4 6/9] hugetlb: disable region_add file_region coalescing
Date: Mon, 16 Sep 2019 16:57:04 -0700
Message-ID: <abe11781-7267-e54e-0b81-46dc4ea6d5a4@oracle.com>
References: <20190910233146.206080-1-almasrymina@google.com>
 <20190910233146.206080-7-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=IuSLh0fb/BvGl8pVix7sy0MqWGyNSfMj/T9waRFCoi8=;
 b=Tl3ojxBSLNTUyPlp46F0uqZ9+/J9tk6YWvuggRkE92WBOn3WxBpiam3c9Z1CvBLiV1pt
 r4GLLmcvDbTKOvsl9CphukxDVJCHsFkY0V8F7IkXWmAS0joTBNXJWCPwH07xRCRqgvU+
 9ac1clwPeFGamvbU1FKqYV8dPEArhoQuD9z9HST34oU4i6COHUwmF2fEfJMxbwv/ujid
 bW5jXOXoTaI6wLbG1Vr3UwqZd3GUxWMdhxeBDBicSYxqhekT1N3XkXuvwhyFHNDsSpnU
 Vev/1ep5bPue2h9jdCJ7Y06i/J/ZHcp1GDtGAxemTiAOJE/SGtHj/jENTVkorZWGQ1KH /g== 
In-Reply-To: <20190910233146.206080-7-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, khalid.aziz@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com, mkoutny@suse.com

On 9/10/19 4:31 PM, Mina Almasry wrote:
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

Hate to throw more theoretical examples at you but ...

Consider an existing reserv_map like [3-10]
Then a region_chg/add call comes in region_chg/add(f=0, t=10).
The region_chg is going to return 3 (additional reservations needed), and
also out_regions_needed = 1 as it would want to create a region [0-3].
Correct?
But, there is nothing to prevent another thread from doing a region_del [5-7]
after the region_chg and before region_add.  Correct?
If so, it seems the region_add would need to create two regions, but there
is only one in the cache and we would BUG in get_file_region_entry_from_cache.
Am I reading the code correctly?

The existing code wants to make sure region_add called after region_chg will
never return error.  This is why all needed allocations were done in the
region_chg call, and it was relatively easy to do in existing code when
region_chg would only need one additional region at most.

I'm thinking that we may have to make region_chg allocate the worst case
number of regions (t - f)/2, OR change to the code such that region_add
could return an error.
-- 
Mike Kravetz
