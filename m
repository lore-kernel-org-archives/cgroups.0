From: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3 0/7] Split a folio to any lower order folios
Date: Mon, 17 Apr 2023 16:20:52 +0200
Message-ID: <b37d1876-0a74-aa52-7911-e6f78280caaa@redhat.com>
References: <20230403201839.4097845-1-zi.yan@sent.com>
 <20230404144727.e613116684dbd65a4b4745c1@linux-foundation.org>
 <49ee481e-452f-61c7-2da5-28de2cf3de2@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681741257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hXXWTVEI1mMsVSpGycpPWe1J+aRrdeZCdqy7/mR/vH0=;
        b=Mbe9gMqv3KDIjrZYVgpGaok4s3fIhIVlR8W8qEkToGyFMP2DDwIU+vDkJBhAn0gn0jZJuZ
        lLtoPIRqbCFjGKpAhZjbjoEhqeffP/gLfx/CkdnsI6ZIC49TaIndxSMrDea4hGz4FiuoED
        f7wHMGfKJIBTn6kq4X9+1kEyyDa2R3c=
Content-Language: en-US
In-Reply-To: <49ee481e-452f-61c7-2da5-28de2cf3de2@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Zi Yan <zi.yan@sent.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yang Shi <shy828301@gmail.com>, Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ryan Roberts <ryan.roberts@arm.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, Zach O'Keefe <zokeefe@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org

On 16.04.23 20:11, Hugh Dickins wrote:
> On Tue, 4 Apr 2023, Andrew Morton wrote:
>> On Mon,  3 Apr 2023 16:18:32 -0400 Zi Yan <zi.yan@sent.com> wrote:
>>
>>> File folio supports any order and people would like to support flexible orders
>>> for anonymous folio[1] too. Currently, split_huge_page() only splits a huge
>>> page to order-0 pages, but splitting to orders higher than 0 is also useful.
>>> This patchset adds support for splitting a huge page to any lower order pages
>>> and uses it during file folio truncate operations.
>>
>> This series (and its v1 & v2) don't appear to have much in the way of
>> detailed review.  As it's at v3 and has been fairly stable I'll queue
>> it up for some testing now, but I do ask that some reviewers go through
>> it please.
> 
> Andrew, please don't let this series drift into 6.4-rc1.
> 
> I've seen a bug or two (I'll point out in response to those patches),
> but overall I don't see what the justification for the series is: done
> because it could be done, it seems to me, but liable to add surprises.
> 
> The cover letter says "splitting to orders higher than 0 is also useful",
> but it's not clear why; and the infrastructure provided seems unsuited
> to the one use provided - I'll say more on that truncation patch.

I agree. Maybe this patch set is something we want to have in the future 
once actual consumers that can benefit are in place, such that we can 
show actual performance numbers with/without.

Until then, "365 insertions(+), 68 deletions(-)" certainly needs some 
reasonable motivation.

-- 
Thanks,

David / dhildenb

