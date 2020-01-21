From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v9 4/8] hugetlb: disable region_add file_region coalescing
Date: Tue, 21 Jan 2020 09:40:56 -0800
Message-ID: <7fb223ea-3e99-550b-d19c-1352de0d296d@oracle.com>
References: <20191217231615.164161-1-almasrymina@google.com>
 <20191217231615.164161-4-almasrymina@google.com>
 <2afb05c1-8d85-a0cf-aad1-041054aad529@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=KuXXyrwg/MgtdCcSYgFFofBQXbFXA1rvjP1SoYziw7k=;
 b=Bdz6tW1EYBuC02kKgnN7rpfsrjzIsiS2nhohEHMhWCfM+lTz5JvMdA9Ph3gch71+y1dx
 3fDrtKYDk9e/2EdqRw+pJcO8NW65p46yV07nP+EAhvWHXEVdWo8jk6WbO6QQdQTiTkjp
 Y9hDefprzobo/7O0gH4aMpZYxAst6wH6Abt2rlqbwZfJ01PrIBHc4yq28DFK9p0Ts84W
 WemR0Kxy5oYlTBBDVQWxdnNNrhV2A1ZygMe2sr8O/izeG9D14pQgZrHmi4pboQfOM5lc
 7zQrb+mSN4MiXT6VuAXCMbeyorN7Vu9HLXYAfPvwG47PjALqi3NTRztbj2cc7BaM6+Ty eQ== 
In-Reply-To: <2afb05c1-8d85-a0cf-aad1-041054aad529@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com, mkoutny@suse.com

On 1/21/20 9:38 AM, Mike Kravetz wrote:
> On 12/17/19 3:16 PM, Mina Almasry wrote:
>> A follow up patch in this series adds hugetlb cgroup uncharge info the
> 
> *nit*
> A follow up patch in this series adds hugetlb cgroup uncharge info to the
> 
>> file_region entries in resv->regions. The cgroup uncharge info may
>> differ for different regions, so they can no longer be coalesced at
>> region_add time. So, disable region coalescing in region_add in this
>> patch.
>>
>> Behavior change:
>>
>> Say a resv_map exists like this [0->1], [2->3], and [5->6].
>>
>> Then a region_chg/add call comes in region_chg/add(f=0, t=5).
>>
>> Old code would generate resv->regions: [0->5], [5->6].
>> New code would generate resv->regions: [0->1], [1->2], [2->3], [3->5],
>> [5->6].
>>
>> Special care needs to be taken to handle the resv->adds_in_progress
>> variable correctly. In the past, only 1 region would be added for every
>> region_chg and region_add call. But now, each call may add multiple
>> regions, so we can no longer increment adds_in_progress by 1 in region_chg,
>> or decrement adds_in_progress by 1 after region_add or region_abort. Instead,
>> region_chg calls add_reservation_in_range() to count the number of regions
>> needed and allocates those, and that info is passed to region_add and
>> region_abort to decrement adds_in_progress correctly.
>>
>> We've also modified the assumption that region_add after region_chg
>> never fails. region_chg now pre-allocates at least 1 region for
>> region_add. If region_add needs more regions than region_chg has
>> allocated for it, then it may fail.
>>
>> Signed-off-by: Mina Almasry <almasrymina@google.com>
>> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> 
> Thanks for the updated comments.  Still,
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>


Sorry, that comment was directed at V10 of the patch.

-- 
Mike Kravetz
