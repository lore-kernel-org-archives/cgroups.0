From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 7/8] hugetlb_cgroup: Add hugetlb_cgroup reservation
 tests
Date: Wed, 29 Jan 2020 13:00:16 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001291257510.175731@chino.kir.corp.google.com>
References: <20200115012651.228058-1-almasrymina@google.com> <20200115012651.228058-7-almasrymina@google.com> <7ce6d59f-fd73-c529-2ad6-edda9937966d@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=mMHj7VQFJ/ru51SSc9JWwA5eIS4YpdouqCmEJIqSD3s=;
        b=gO1MuPCCzwJo6EXl1niF9Nc6Pd0XCURfNhJmEtuV0mF/2PRgvb2nXlZ62BvLzbgPoJ
         /x315s7W8W6TGg1qsy73Xm1Ujmx5N5x95A6L3xwbMJ5yzCz3tQv0+qN1xm+ac1uvJ3qi
         oq6FQIEde4mQG6wOn36dCV1T6iCQS7C10HI7Q0zEWfHyRrLwKycChsZC9pCTeFOK/XgS
         MLxk35KrU1T1sWDXMp3CHH2kJRQex6cDy2WqUJfkbYKhBWRmVrIhPTxQnYjpUQzrzjtf
         qKIm5qzhJMeVt9kj4Ugt4QQYIaUGtoOTXRQDvinBq0xHktYy+sMx//j60z5CIZEFB73T
         pTyw==
In-Reply-To: <7ce6d59f-fd73-c529-2ad6-edda9937966d-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sandipan Das <sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org

On Thu, 23 Jan 2020, Sandipan Das wrote:

> > The tests use both shared and private mapped hugetlb memory, and
> > monitors the hugetlb usage counter as well as the hugetlb reservation
> > counter. They test different configurations such as hugetlb memory usage
> > via hugetlbfs, or MAP_HUGETLB, or shmget/shmat, and with and without
> > MAP_POPULATE.
> > 
> > Also add test for hugetlb reservation reparenting, since this is
> > a subtle issue.
> > 
> > Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > 
> 
> For powerpc64, either 16MB/16GB or 2MB/1GB huge pages are supported depending
> on the MMU type (Hash or Radix). I was just running these tests on a powerpc64
> system with Hash MMU and ran into problems because the tests assume that the
> hugepage size is always 2MB. Can you determine the huge page size at runtime?
> 

I assume this is only testing failures of the tools/testing/selftests 
additions that hardcode 2MB paths and not a kernel problem?  In other 
words, you can still boot, reserve, alloc, and free hugetlb pages on ppc 
after this patchset without using the selftests?
