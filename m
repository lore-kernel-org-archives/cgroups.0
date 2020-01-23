From: Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v10 7/8] hugetlb_cgroup: Add hugetlb_cgroup reservation tests
Date: Thu, 23 Jan 2020 12:05:30 -0800
Message-ID: <CAHS8izNmhxja_0+b2DudpXB+1DQfpnjUu+Qak+wnsApgYrvU=Q@mail.gmail.com>
References: <20200115012651.228058-1-almasrymina@google.com>
 <20200115012651.228058-7-almasrymina@google.com> <7ce6d59f-fd73-c529-2ad6-edda9937966d@linux.ibm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VyznYH5jQ6Vy0xxWHMJMOnmd05+7Te8s8tuSLOem1vc=;
        b=NEFtawHLgzySPes5yhMKn043r+gEGRFGKhG2aJibWy+YdIIw0CJVynUf/h7t5SDCAn
         YCLGg0okwgHeebwoD2fSmlXxTPzE+8OqgOFxOfSXKIjZI6xLy+zqNphZwdd2Tl3HNdb9
         F+bOjMFMa/rjrcxnOi4Uv4WZy/wdxN2W8Nb0aKewvUoYFlPfCCwLGvMXURaKpP3IPhAy
         Vp7d3t7P3GCpDZy5GL/uWB/BtJVgZPiTYeU3t+OjdbL0MzYC+L/KPsM2qvjVN1iPjPEf
         Ccr0Fq0QlZZfD85rtYSLJWpgC5B4L6fMT7Gk1Ub9GJZ/JSAOlZbDhxtdfgH8LTyMuqxP
         +XHQ==
In-Reply-To: <7ce6d59f-fd73-c529-2ad6-edda9937966d@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sandipan Das <sandipan@linux.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, shuah <shuah@kernel.org>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>

On Thu, Jan 23, 2020 at 1:15 AM Sandipan Das <sandipan@linux.ibm.com> wrote:
>
> For powerpc64, either 16MB/16GB or 2MB/1GB huge pages are supported depending
> on the MMU type (Hash or Radix). I was just running these tests on a powerpc64
> system with Hash MMU and ran into problems because the tests assume that the
> hugepage size is always 2MB. Can you determine the huge page size at runtime?
>

Absolutely. Let me try to reproduce this failure and it should be
fixed in the next patchset version.
