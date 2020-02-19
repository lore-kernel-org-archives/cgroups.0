From: Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v12 1/9] hugetlb_cgroup: Add hugetlb_cgroup reservation counter
Date: Wed, 19 Feb 2020 11:05:41 -0800
Message-ID: <CAHS8izPUFQWq3PzhhRzp7u11173_-cmRkNuQWEswS51Xz6ZM0Q@mail.gmail.com>
References: <20200211213128.73302-1-almasrymina@google.com> <20200211151906.637d1703e4756066583b89da@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x3W3v+68ig6DpCsCj7cxqvrURO7RlrIPZ7rtuczBdEw=;
        b=MRO7yMzk7yDrFx6YlaBjQipExwOAAl5oZs4Uw3k4YEf0IGCO46qz9pNv7mKfRtdLmz
         PEMy+4mqqmhwK9gt+RfIID4sYXypy6kmfz1f3/bMfc/HE8wlsqQQGiSvYEAjvEeIOtHa
         S6UhvT56lMx/7KvHuGwTFmdLS+x63NJs9cvcUK6OyY4jAYlq0NtF8+Y90oLe3sYVYbZG
         Z4C1gt9hZGvCpniRgDi27fhm9UHQPo3FBAsRTSTIXvJ0SCAfmlCJZJvUqjqxhIhm85Eo
         FcWe5DtoCsHrj7vx/oU+0Nb9bnw/5FAhoH0jlTXQwKcUoHzNp9GTA2nYG/bf1Wm2UWLP
         W65w==
In-Reply-To: <20200211151906.637d1703e4756066583b89da@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On Tue, Feb 11, 2020 at 3:19 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 11 Feb 2020 13:31:20 -0800 Mina Almasry <almasrymina@google.com> wrote:
>
> > These counters will track hugetlb reservations rather than hugetlb
> > memory faulted in. This patch only adds the counter, following patches
> > add the charging and uncharging of the counter.
>
> We're still pretty thin on review here, but as it's v12 and Mike
> appears to be signed up to look at this work, I'll add them to -next to
> help move things forward.
>

Hi Andrew,

Since the patches were merged into -next there have been build fixes
and test fixes and some review comments. Would you like me to submit
*new* patches to address these, or would you like me to squash the
fixes into my existing patch series and submit another iteration of
the patch series?
