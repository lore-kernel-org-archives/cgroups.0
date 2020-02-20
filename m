From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 8/9] hugetlb_cgroup: Add hugetlb_cgroup reservation tests
Date: Wed, 19 Feb 2020 16:05:40 -0800
Message-ID: <CAHS8izOumQZJw9yDLSJz8buYc8oUL8oiex8Ji62QcpTX4J6G_g@mail.gmail.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211213128.73302-8-almasrymina@google.com> <37a49c35-567f-1663-33cd-3dac150020a0@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=On4/X6XTdlAfrZHKoVhgecOTEOux4GHMdiEnySmBdt8=;
        b=VK+0jpevVkZp/UHyagl40Y2dezLtobNOAkPWNA2EFwgtAnqWXAvRKL2fUDYjIIYuOX
         5sD5qSv5bL+cr76lEQf4F46fwYdhqauQO/x/HQNTZ0vVr6HL9LZOVD6/suQ3H0O7Caep
         qwIOgwYDsQ9Dgev+b1WryYQ43HfiGsFPeyaTa2mBQ9iRyhI96dyn+5Msdo/n+suooF0w
         b+VcqixzW9m6IGvKS6k2wPw3kiwfoRYj6ynaXhaSWThUHIR+lDRULTcPDalnZsalZW69
         X6syUyxegauMHYLgPzslGiMCLpScqFt1HGn7ExxFY9FrlOAiKd+ceTkoGJ2L7dqWkMOa
         4jBQ==
In-Reply-To: <37a49c35-567f-1663-33cd-3dac150020a0-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sandipan Das <sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 12, 2020 at 12:50 AM Sandipan Das <sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org> wrote:
>
>
>
> On 12/02/20 3:01 am, Mina Almasry wrote:
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
> > Cc: sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org

Hi folks,

Sandipan provided a Tested-by but this is more or less the only patch
in the series that is awaiting review. Can someone take a look?

Shuah, you started reviewing this months ago and I addressed the
comments. Maybe you can take another look?

Thanks in advance!
