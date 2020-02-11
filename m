From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v11 6/9] hugetlb_cgroup: support noreserve mappings
Date: Tue, 11 Feb 2020 13:51:33 -0800
Message-ID: <6b097a9d-3b2c-94cb-21a8-7e7a55a8f635@oracle.com>
References: <20200203232248.104733-1-almasrymina@google.com>
 <20200203232248.104733-6-almasrymina@google.com>
 <6cc406e7-757f-4922-ffc0-681df3ee0d18@oracle.com>
 <CAHS8izMGreJgOhG8ivE2OH9bq98BmvxAqtBc=M9waTqOKv3eeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=q9CJH8blGd3JpsYmKV23Sgj8OEPJrRzAG9QrB6xaUUE=;
 b=gTnVVwFTBUdHJ9eyfYo5Hmcz5SmP6JFCX2FdoK9AAaKAy4pE/nPnVjvP2xA7yiAfSd51
 SV13Y+41lw/40Kz8+mkudhl4f25TKjG6pcLy27qm48RMTaC31bmONVIJdhxVoo6f3goM
 C+YrHyyim7kYOG4Zw1kkJb0PCJVT/QrAg1sN1TutWMj6YwjBqqkHVBWAJyf4LfxJN06C
 rH742UiXRU9FP7n9X6y6xBK/4QFovcvcwQZfpxznZUnsuJN0op3wgzcN8edxuaS1tjHD
 KQQdbyS8QaaV1L8dDKyhbmpWXBuTF6xK/4sVabr5eeelDDl4MbC9owbEyJZZZAUOOpXF vg== 
In-Reply-To: <CAHS8izMGreJgOhG8ivE2OH9bq98BmvxAqtBc=M9waTqOKv3eeQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On 2/11/20 1:35 PM, Mina Almasry wrote:
> On Thu, Feb 6, 2020 at 2:31 PM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>> On 2/3/20 3:22 PM, Mina Almasry wrote:
>>> +++ b/mm/hugetlb.c
>>> @@ -1339,6 +1339,9 @@ static void __free_huge_page(struct page *page)
>>>       clear_page_huge_active(page);
>>>       hugetlb_cgroup_uncharge_page(hstate_index(h), pages_per_huge_page(h),
>>>                                    page, false);
>>> +     hugetlb_cgroup_uncharge_page(hstate_index(h), pages_per_huge_page(h),
>>> +                                  page, true);
>>> +
>>
>> When looking at the code without change markings, the two above lines
>> look so similar my first thought is there must be a mistake.
>>
>> A suggestion for better code readability:
>> - hugetlb_cgroup_uncharge_page could just take "struct hstate *h" and
>>   get both hstate_index(h) and pages_per_huge_page(h).
>> - Perhaps make hugetlb_cgroup_uncharge_page and
>>   hugetlb_cgroup_uncharge_page_rsvd be wrappers around a common routine.
>>   Then the above would look like:
>>
>>   hugetlb_cgroup_uncharge_page(h, page);
>>   hugetlb_cgroup_uncharge_page_rsvd(h, page);
>>
> 
> I did modify the interfaces to this, as it's much better for
> readability indeed. Unfortunately the patch the adds interfaces
> probably needs a re-review now as it's changed quite a bit, I did not
> carry your or David's Reviewed-by.

No worries.  Happy to review again.

-- 
Mike Kravetz
