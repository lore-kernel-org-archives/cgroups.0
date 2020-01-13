From: Mina Almasry <almasrymina@google.com>
Subject: Re: [PATCH v9 1/8] hugetlb_cgroup: Add hugetlb_cgroup reservation counter
Date: Mon, 13 Jan 2020 14:21:33 -0800
Message-ID: <CAHS8izMT2vNASsR2H+3-4XN=+EkAEpS-LJ_UouaAa7iUfbLBhQ@mail.gmail.com>
References: <20191217231615.164161-1-almasrymina@google.com>
 <817e2c4b-4c72-09f9-22ea-bbaf97584161@oracle.com> <CAHS8izNs24KOaRuQkVUuZZUh42rvkyBXJEJYrHNf9bLFnZEXCg@mail.gmail.com>
 <a78595a8-448c-14bb-a54b-9be685f36388@oracle.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ex3UFTMAEfhKx0guG0nwsJE0zOFUmspUTiiCdQZAYOo=;
        b=AZkS3aHZwBxsqylTsn1eEWpbfT0deg5vrOTs7LiyGB8g1lnK6FH2+UfYXBWvkY6ULv
         L2AahUncm3u08u2KnFq3IkcZNVLL+0q4Df/VS2nMgtdTEfhMV6UmkKoHEo30LFduORFW
         lNtWDDlPGuB18xsIfzirjOzb5FUEr8JVFbQ9lixTPZk9w8y2vYfwtQWfryXPkGPPJmEo
         tw1PmN8C9ibxP8UQDb/8CkVIA+vS9SZrs1AqtZyUwsA44pNP5dS4Vm06VWqn+YiWccoj
         7cM9PqJcK+T1kfuzzQlB+nt4mJ/rZmLAEFfmiWh12bHooq+Vhe2YKTYhcZvmM4l2p4UK
         Lc6w==
In-Reply-To: <a78595a8-448c-14bb-a54b-9be685f36388@oracle.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Kravetz <mike.kravetz@oracle.com>
Cc: shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>

> >> On 12/17/19 3:16 PM, Mina Almasry wrote:
> >
> > The design we went with based on previous discussions is as follows:
> > hugetlb pages faulted without a prior reservation get accounted at
> > fault time, rather than reservation time, and if the fault causes the
> > counter to cross the limit, the charge fails, hence the fault fails,
> > hence the process gets sigbus'd.
>
> Ok, sorry I did not recall the design discussion.
>

No worries! It has indeed been a while since that discussion.

> > This means that one counter I'm adding here can cover both use cases:
> > if the userspace uses MAP_NORESERVE, then their memory is accounted at
> > fault time and they may get sigbus'd.
>
> Let's make sure this is clearly documented.  Someone could be surprised
> if their application not using reserves gets a SIGBUS because there is a
> reserve limit.

I have some stuff on that already in the docs patch, but I'll beef
that section up to ensure there is no confusion.

