From: Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v12 1/9] hugetlb_cgroup: Add hugetlb_cgroup reservation counter
Date: Thu, 20 Feb 2020 11:22:58 -0800
Message-ID: <CAHS8izN_FJektipBwiLsCO8ysMTM7k=CR_k3OV7+_y0ZbrGw+A@mail.gmail.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211151906.637d1703e4756066583b89da@linux-foundation.org>
 <CAHS8izPUFQWq3PzhhRzp7u11173_-cmRkNuQWEswS51Xz6ZM0Q@mail.gmail.com> <20200219130648.83e6810848774c6fd649c445@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bk1eIitMT2MS22kRJrkHf2a6nr5vMQhVA+AkCVP3xms=;
        b=aTmzlFn5tqMffO4aaSdqSmOjwnlwPlhLBMDWmHM5hEgVohGoR95LIESWPin+FgU3m5
         6SBKmIyXfz3mR7ZJGUztrCkEqttjywHypYPY01n74LbVdLtnW3lI3mGg/tCdRKylIrWc
         Jq7asmZQKCD4pm93CxVIrFT9tn3nfGJqSSm8Vsd6HIo/Kcxe7LRKiOXtJ1R+KmDSgYri
         yOJUHQv1/vVwu32bZ3WZIRFgjHFVUSuwrRUtJOBVFSUsAgNS/5PGnC2AW02w3iZZp4zg
         Ia0U7nlOur/8FVS0Sgvy3hruRsr6xz+P5Rcb6cHozsula5vu8Q6sy6WkorjtHYEKafsR
         OD5Q==
In-Reply-To: <20200219130648.83e6810848774c6fd649c445@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, open list <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On Wed, Feb 19, 2020 at 1:06 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 19 Feb 2020 11:05:41 -0800 Mina Almasry <almasrymina@google.com> wrote:
>
> > On Tue, Feb 11, 2020 at 3:19 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > On Tue, 11 Feb 2020 13:31:20 -0800 Mina Almasry <almasrymina@google.com> wrote:
> > >
> > > > These counters will track hugetlb reservations rather than hugetlb
> > > > memory faulted in. This patch only adds the counter, following patches
> > > > add the charging and uncharging of the counter.
> > >
> > > We're still pretty thin on review here, but as it's v12 and Mike
> > > appears to be signed up to look at this work, I'll add them to -next to
> > > help move things forward.
> > >
> >
> > Hi Andrew,
> >
> > Since the patches were merged into -next there have been build fixes
> > and test fixes and some review comments. Would you like me to submit
> > *new* patches to address these, or would you like me to squash the
> > fixes into my existing patch series and submit another iteration of
> > the patch series?
>
> What you did worked OK ;)
>
> Please check the end result next time I release a kernel.

Thanks Andrew! Things definitely moved along after the patchseries got
into -next :D

By my count I think all my patches outside of the tests patch have
been acked or reviewed. When you have a chance I have a couple of
questions:

1. For the non-tests patch, anything pending on those preventing
eventual submission to linus's tree?
2. For the tests patch, I only have a Tested-by from Sandipan. Is that
good enough? If the worst comes to worst and I don't get a review on
that patch I would rather (if possible) that 'tests' patch can be
dropped while I nag folks for a review, rather than block submission
of the entire patch series. I ask because it's been out for review for
some time and it's the one I got least discussion on so I'm not sure
I'll have a review by the time it's needed.

Thanks again!
