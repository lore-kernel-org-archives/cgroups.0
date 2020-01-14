From: Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v9 2/8] hugetlb_cgroup: add interface for charge/uncharge
 hugetlb reservations
Date: Tue, 14 Jan 2020 14:55:53 -0800
Message-ID: <CAHS8izNcZnJmWOoagAkDtgKj9JfOoW0xuSuMAhO3wh3A1x2Dqw@mail.gmail.com>
References: <20191217231615.164161-1-almasrymina@google.com>
 <20191217231615.164161-2-almasrymina@google.com> <0855cae0-872e-0727-aa7c-55051d8f0871@oracle.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ipIhJjAH0mlgj9mgI3WhoNWssFh6GjBw0YOeerhZCcU=;
        b=BXtYSedeHXcXqhdhhWIbtaBy54tVxbI3e9loIGv5zhO5CDgbahYX7y+Orjx6CD4zCZ
         0VhZIf5F4aluPlRU7PpNhbbEGba3pmcWe+cL3CBi5DKya+w5q6G9eUjD6Y6LZi3IlJ3t
         DrJUFTIu5BCbGGqB1F/xwGxS7UBhnEduOl7KTKpELe4ehBWkmis+mzbELNb1lGuQU++3
         QqqpluWfbXgvT/3D7WUNnyrjmuuZFxOwFtqlIlsp5tc9+S7eipRPEcevYerqbyHWNTNb
         Hhqn87JV86nkgRWq1rMf/JsZJIoYLMVRDfzRbSZxDqafJRFy4Ttng/Rd5qCfuV8koCw1
         S2/A==
In-Reply-To: <0855cae0-872e-0727-aa7c-55051d8f0871@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>

On Mon, Jan 13, 2020 at 2:14 PM Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > +extern void hugetlb_cgroup_uncharge_counter(struct page_counter *p,
> > +                                         unsigned long nr_pages,
> > +                                         struct cgroup_subsys_state *css);
> > +
>
> Do we need a corresponding stub for the !CONFIG_CGROUP_HUGETLB case?
>

Not necessary AFAICT because the code is only called from code guarded
by CONFIG_CGROUP_HUGETLB.

Addressing comments from you and David in v10 shortly. Thanks for the review!
