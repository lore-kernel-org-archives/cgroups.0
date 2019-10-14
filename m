From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v5 0/7] hugetlb_cgroup: Add hugetlb_cgroup reservation
 limits
Date: Mon, 14 Oct 2019 10:33:05 -0700
Message-ID: <f042aba0-7e0f-80c5-1285-6b6fd2b3cbac@oracle.com>
References: <20190919222421.27408-1-almasrymina@google.com>
 <3c73d2b7-f8d0-16bf-b0f0-86673c3e9ce3@oracle.com>
 <CAHS8izN1Q7XH84Srem_McB+Jz67-fu6KPCMQjzbnPDTPzgwC2A@mail.gmail.com>
 <CAHS8izNhZc8zsdf=eXU5L_ouKwk9s00S-Q21P=QA+vAF3BsXcg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=SgoPaXtNxXkqZxvIC3mKHam0uE1SQovKYmuch0B2NlQ=;
 b=DhDyMkuZYE70IGS8w2tWI14yqTSd4ojJOq8VBEmTIOAJckSPdzfnWPzc4flTyhibnsbF
 Rjov5ug2GK6wQbwJRzkbk96SrugA2pLFHHgikNI74GFogfeUGnRoJsjr2OpsfiL39PTs
 YHE5N/R+9T8QXIHDz6J6mzga6yKxYFW/Wj5AoSZB8hb8NYNJ+cZ6soIWfsQeZHGBxYWe
 +rQ10X6ZL0Xl4Hzg76Zr3JVwnU6U8fkj5UxdGTLf6dlw9y0Edj+NJLvngXroOE0viV/m
 6zS26bvgQFnbAvQ7YTkS8KBV+0hH2FhbtJKKxlSTSfzwqZ+WSSSXkTJoRxpMk2Z8fGER qA== 
In-Reply-To: <CAHS8izNhZc8zsdf=eXU5L_ouKwk9s00S-Q21P=QA+vAF3BsXcg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, khalid.aziz@oracle.com, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 10/11/19 1:41 PM, Mina Almasry wrote:
> On Fri, Oct 11, 2019 at 12:10 PM Mina Almasry <almasrymina@google.com> wrote:
>>
>> On Mon, Sep 23, 2019 at 10:47 AM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>>>
>>> On 9/19/19 3:24 PM, Mina Almasry wrote:
>>
>> Mike, note your suggestion above to check if the page hugetlb_cgroup
>> is null doesn't work if we want to keep the current counter working
>> the same: the page will always have a hugetlb_cgroup that points that
>> contains the old counter. Any ideas how to apply this new counter
>> behavior to a private NORESERVE mappings? Is there maybe a flag I can
>> set on the pages at allocation time that I can read on free time to
>> know whether to uncharge the hugetlb_cgroup or not?
> 
> Reading the code and asking around a bit, it seems the pointer to the
> hugetlb_cgroup is in page[2].private. Is it reasonable to use
> page[3].private to store the hugetlb_cgroup to uncharge for the new
> counter and increment HUGETLB_CGROUP_MIN_ORDER to 3? I think that
> would solve my problem. When allocating a private NORESERVE page, set
> page[3].private to the hugetlb_cgroup to uncharge, then on
> free_huge_page, check page[3].private, if it is non-NULL, uncharge the
> new counter on it.

Sorry for not responding sooner.  This approach should work, and it looks like
you have a v6 of the series.  I'll take a look.

-- 
Mike Kravetz
