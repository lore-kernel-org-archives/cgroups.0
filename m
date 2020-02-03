From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 7/8] hugetlb_cgroup: Add hugetlb_cgroup reservation tests
Date: Mon, 3 Feb 2020 15:18:55 -0800
Message-ID: <CAHS8izOh5nbTbv3+UxdLH-LHD-RKNEHoCzHCExggTbvgta-itg@mail.gmail.com>
References: <20200115012651.228058-1-almasrymina@google.com>
 <20200115012651.228058-7-almasrymina@google.com> <7ce6d59f-fd73-c529-2ad6-edda9937966d@linux.ibm.com>
 <alpine.DEB.2.21.2001291257510.175731@chino.kir.corp.google.com> <98c83a41-b864-5950-488c-443f6ef60b91@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JZG+WtSGQs6QhG818eTrKWkOuEkoqiXKe+iz1pu4uMw=;
        b=kiJFgYh6yNJ0L2ecPXo+0jXN+6U8xrb9JtkyYqy3sE8LUhPMl5p9RBaffqUCdGGebE
         LV+1NURfNHCoklIRGG5UNpDL9JKrjRsBcDgdIU3Iy/5OBH0RAIagWOKEuawsfHnf+6Mn
         s/jyyzcRMDOKwGgOLBGycQM/xhhQapE69IRjL5t9dVaxVA4H4X/DSJWWMUV00IWeo6/n
         UmoAq69ILXgEvKgYpWH2xqUdIJkUvgeG30WzbMVUAt5FG9mvhFfM9KfAG1lmqVurAUfI
         lW5YiBxG4Bah8vesGavRLFwf9pBAk2vCpClJHZs2LMQlSNGHpYa9ZepQ1UvIUxR/Yxsz
         lNrg==
In-Reply-To: <98c83a41-b864-5950-488c-443f6ef60b91-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sandipan Das <sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

On Wed, Jan 29, 2020 at 10:11 PM Sandipan Das <sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org> wrote:
>
> Hi David,
>
> On 30/01/20 2:30 am, David Rientjes wrote:
> > On Thu, 23 Jan 2020, Sandipan Das wrote:
> >
> >> For powerpc64, either 16MB/16GB or 2MB/1GB huge pages are supported depending
> >> on the MMU type (Hash or Radix). I was just running these tests on a powerpc64
> >> system with Hash MMU and ran into problems because the tests assume that the
> >> hugepage size is always 2MB. Can you determine the huge page size at runtime?
> >>
> >
> > I assume this is only testing failures of the tools/testing/selftests
> > additions that hardcode 2MB paths and not a kernel problem?  In other
> > words, you can still boot, reserve, alloc, and free hugetlb pages on ppc
> > after this patchset without using the selftests?
> >
>
> Yes, its just the hardcoded paths. I didn't run into any kernel problems.
>

Sandipan, I updated the tests to not assume 2MB page size, but I'm
having trouble getting a setup with a non-2MB default size to test
with. I'm uploading v11 of the series shortly, please let me know if
the problem persists.

> - Sandipan
>
