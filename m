From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v5 0/7] hugetlb_cgroup: Add hugetlb_cgroup reservation
 limits
Date: Fri, 27 Sep 2019 15:56:24 -0700
Message-ID: <1dbe668d-ec16-7f84-5398-472e7b375c4f@oracle.com>
References: <20190919222421.27408-1-almasrymina@google.com>
 <3c73d2b7-f8d0-16bf-b0f0-86673c3e9ce3@oracle.com>
 <CAHS8izOj2AT4tX-+Hcb8LB2TOUKJDHScDtJ80u4M6OWpwktq0g@mail.gmail.com>
 <a8e9c533-1593-35ee-e65d-1f2fc2b0fb48@oracle.com>
 <CAHS8izPfKQA8qTndyzWSm9fR_xJ=X-xmE+4P4K+ZFdxrYNuLBA@mail.gmail.com>
 <alpine.DEB.2.21.1909261220150.39830@chino.kir.corp.google.com>
 <8f7db4f1-9c16-def5-79dc-d38d6b9d150e@oracle.com>
 <CAHS8izM3=ZDNukx5xhWmeJT+78Ekfff9J4s5Vqkqpx-DtH=C-A@mail.gmail.com>
 <794398cc-07a4-d235-a0da-0246f5a09f6e@oracle.com>
 <CAHS8izMg4=mJd_d-f3ueiq6Q1AfTFBSjLXeNkkuZO0iV0Dk-iA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=cn8H1mWLJV2KFmDp+M2Q4jV4DaWXWTqsiRwHZZfFt5Q=;
 b=ofjxNvBaa/a5m8YcntEw69FxNNL9mXkaGQsgrKdXjDzKuq76XP+3j0bMbA98X7XGOfC2
 TmFvEMX9Sb5idd2FmgQfCA9k3bJBiOgIQVQUEirc8ZsxY7FCW3joePEHY5tO/NPNFrGC
 harhOKWtGI3chOFbj9p9ifkTYgQqMpD3ohacQKPOtbtyGG3Kr8rbBULRr12VmCoiEzYJ
 SneNxb03qPFgHiyFYhm4LE8ZF3pzhy4mD8rhKkq/dOijmxJEPVO3gmrNAc+YOjXLHrbN
 Dh0bImOveXFZRIF9Y05odKZwFhfTsVYn/OAagAhVYuv6oAgKscPhYi0+ctHjuVSh7CLT qg== 
In-Reply-To: <CAHS8izMg4=mJd_d-f3ueiq6Q1AfTFBSjLXeNkkuZO0iV0Dk-iA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, shuah <shuah@kernel.org>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, khalid.aziz@oracle.com, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 9/27/19 3:51 PM, Mina Almasry wrote:
> On Fri, Sep 27, 2019 at 2:59 PM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>>
>> On 9/26/19 5:55 PM, Mina Almasry wrote:
>>> Provided we keep the existing controller untouched, should the new
>>> controller track:
>>>
>>> 1. only reservations, or
>>> 2. both reservations and allocations for which no reservations exist
>>> (such as the MAP_NORESERVE case)?
>>>
>>> I like the 'both' approach. Seems to me a counter like that would work
>>> automatically regardless of whether the application is allocating
>>> hugetlb memory with NORESERVE or not. NORESERVE allocations cannot cut
>>> into reserved hugetlb pages, correct?
>>
>> Correct.  One other easy way to allocate huge pages without reserves
>> (that I know is used today) is via the fallocate system call.
>>
>>>                                       If so, then applications that
>>> allocate with NORESERVE will get sigbused when they hit their limit,
>>> and applications that allocate without NORESERVE may get an error at
>>> mmap time but will always be within their limits while they access the
>>> mmap'd memory, correct?
>>
>> Correct.  At page allocation time we can easily check to see if a reservation
>> exists and not charge.  For any specific page within a hugetlbfs file,
>> a charge would happen at mmap time or allocation time.
>>
>> One exception (that I can think of) to this mmap(RESERVE) will not cause
>> a SIGBUS rule is in the case of hole punch.  If someone punches a hole in
>> a file, not only do they remove pages associated with the file but the
>> reservation information as well.  Therefore, a subsequent fault will be
>> the same as an allocation without reservation.
>>
> 
> I don't think it causes a sigbus. This is the scenario, right:
> 
> 1. Make cgroup with limit X bytes.
> 2. Task in cgroup mmaps a file with X bytes, causing the cgroup to get charged
> 3. A hole of size Y is punched in the file, causing the cgroup to get
> uncharged Y bytes.
> 4. The task faults in memory from the hole, getting charged up to Y
> bytes again. But they will be still within their limits.
> 
> IIUC userspace only gets sigbus'd if the limit is lowered between
> steps 3 and 4, and it's ok if it gets sigbus'd there in my opinion.

You are correct.  That was my mistake.  I was still thinking of behavior
for a reservation only cgroup model.  It would behave as you describe
above (no SIGBUS) for a combined reservation/allocate model.
-- 
Mike Kravetz
