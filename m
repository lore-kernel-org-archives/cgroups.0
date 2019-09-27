From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v5 0/7] hugetlb_cgroup: Add hugetlb_cgroup reservation
 limits
Date: Fri, 27 Sep 2019 14:59:17 -0700
Message-ID: <794398cc-07a4-d235-a0da-0246f5a09f6e@oracle.com>
References: <20190919222421.27408-1-almasrymina@google.com>
 <3c73d2b7-f8d0-16bf-b0f0-86673c3e9ce3@oracle.com>
 <CAHS8izOj2AT4tX-+Hcb8LB2TOUKJDHScDtJ80u4M6OWpwktq0g@mail.gmail.com>
 <a8e9c533-1593-35ee-e65d-1f2fc2b0fb48@oracle.com>
 <CAHS8izPfKQA8qTndyzWSm9fR_xJ=X-xmE+4P4K+ZFdxrYNuLBA@mail.gmail.com>
 <alpine.DEB.2.21.1909261220150.39830@chino.kir.corp.google.com>
 <8f7db4f1-9c16-def5-79dc-d38d6b9d150e@oracle.com>
 <CAHS8izM3=ZDNukx5xhWmeJT+78Ekfff9J4s5Vqkqpx-DtH=C-A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=q7WvLzPyUVDxnfSPZC1SgNGak5YEXm7HxP2DMgL+p+Q=;
 b=mWn09GYjV4guHlpVnkiOPepptZLjc70Mw7Us0Es0uISfV8HwAM71Xvn/i5DehhjXLDgA
 NVQ5ZLh8t8TFdjdSY3zaeLGtBkBdrcoGQWPEzLuZEIoiYeBqDgpDXuHLCRFlzDJ9pHDR
 i84Qezf1W8+FWF/t1dIUaEvwsI1JS9Dz3VY3DZBxa9Z2XBh7ir/kYr402sbKB7mxuUjd
 UkVKAnSqnMlL7xS9kR7oFp+IKDJqvuq/D6JrvpJbSUbgsd6cRo64WcZQVsYQn0K0vfoe
 xfoTUv2//Xc8BOENpyF3m06PkDlI0RxB3iremcGTq9jUrNjXLKyCGepqMorhkShol8kM zg== 
In-Reply-To: <CAHS8izM3=ZDNukx5xhWmeJT+78Ekfff9J4s5Vqkqpx-DtH=C-A@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>, Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, shuah <shuah@kernel.org>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, khalid.aziz@oracle.com, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 9/26/19 5:55 PM, Mina Almasry wrote:
> Provided we keep the existing controller untouched, should the new
> controller track:
> 
> 1. only reservations, or
> 2. both reservations and allocations for which no reservations exist
> (such as the MAP_NORESERVE case)?
> 
> I like the 'both' approach. Seems to me a counter like that would work
> automatically regardless of whether the application is allocating
> hugetlb memory with NORESERVE or not. NORESERVE allocations cannot cut
> into reserved hugetlb pages, correct?

Correct.  One other easy way to allocate huge pages without reserves
(that I know is used today) is via the fallocate system call.

>                                       If so, then applications that
> allocate with NORESERVE will get sigbused when they hit their limit,
> and applications that allocate without NORESERVE may get an error at
> mmap time but will always be within their limits while they access the
> mmap'd memory, correct?

Correct.  At page allocation time we can easily check to see if a reservation
exists and not charge.  For any specific page within a hugetlbfs file,
a charge would happen at mmap time or allocation time.

One exception (that I can think of) to this mmap(RESERVE) will not cause
a SIGBUS rule is in the case of hole punch.  If someone punches a hole in
a file, not only do they remove pages associated with the file but the
reservation information as well.  Therefore, a subsequent fault will be
the same as an allocation without reservation.

I 'think' the code to remove/truncate a file will work corrctly as it
is today, but I need to think about this some more.

> mmap'd memory, correct? So the 'both' counter seems like a one size
> fits all.
> 
> I think the only sticking point left is whether an added controller
> can support both cgroup-v2 and cgroup-v1. If I could get confirmation
> on that I'll provide a patchset.

Sorry, but I can not provide cgroup expertise.
-- 
Mike Kravetz
