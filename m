From: Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v10 2/8] hugetlb_cgroup: add interface for charge/uncharge
 hugetlb reservations
Date: Fri, 17 Jan 2020 11:34:38 -0800
Message-ID: <CAHS8izMRrOOMV3v3gEuFHcX-YfQ5YOywGFu+K4-9zMXrAGFYbQ@mail.gmail.com>
References: <20200115012651.228058-1-almasrymina@google.com>
 <20200115012651.228058-2-almasrymina@google.com> <7e1d2c5f-3b07-4d16-9e1b-bd89d25e7fb3@oracle.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wnbjoT0j5ag9BS3W7d99gmYHDerGz9fZIduxI8d9DlM=;
        b=TT8zNjpuzdDlDWtxUF3ROPfakHa88TVeTCCzR5vCXgxUY7gnjtDdV908bvnyE5y4oV
         QU36Uh70B8zBcLbEC5WsV9OQuSgknaM4MnZ+6jDRyDTKzq1HngpAdAAs3mElPkgX1Ngs
         w8RxWNVZZmLjGd/pbBFQ57NF0JHpuxd7a1wSLqAAJwqSwurny5s+HaCNXAxlSd2TrGbE
         I0HJnlRsjj6jLQu5Cu7qeoUYEz1c4KM83fzEb63Qt4ALXNdDhAqG60fYhmckugqonIpN
         Q31HLAuMmqxdrdOBjnJmAuE2XH93asNdBTd9rXjxonqLYa1bomCyyydoau0rPmn4pocx
         0aNQ==
In-Reply-To: <7e1d2c5f-3b07-4d16-9e1b-bd89d25e7fb3@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, shuah <shuah@kernel.org>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>

On Fri, Jan 17, 2020 at 11:26 AM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> On 1/14/20 5:26 PM, Mina Almasry wrote:
> > Augments hugetlb_cgroup_charge_cgroup to be able to charge hugetlb
> > usage or hugetlb reservation counter.
> >
> > Adds a new interface to uncharge a hugetlb_cgroup counter via
> > hugetlb_cgroup_uncharge_counter.
> >
> > Integrates the counter with hugetlb_cgroup, via hugetlb_cgroup_init,
> > hugetlb_cgroup_have_usage, and hugetlb_cgroup_css_offline.
> >
> > Signed-off-by: Mina Almasry <almasrymina@google.com>
> >
> > ---
> >
> > Changes in v10:
> > - Added missing VM_BUG_ON
>
> Thanks for addressing my comments.
> I see that patch 8 was updated to address David's comments.  I will also
> review patch 8 later.
>
> I am again requesting that someone with more cgroup experience comment on
> this patch.  I do not have enough experience to determine if the code to
> not reparent/zombie cgroup is correct.
>

Thank you very much for your continued reviews and I'm sorry I'm
having so much trouble getting anyone with cgroup experience to look
deeply into this. My guess is that it's not very active feature and
the patchseries is long and complex so folks are not interested.
Nevertheless I'm continually poking David and Shakeel and they will
hopefully continue to look into this.

FWIW, I have a test for repartenting/counting zombies and the tests at
least don't uncover any problems.

> For now,
> Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
> while waiting for cgroup comments.
>
> --
> Mike Kravetz
