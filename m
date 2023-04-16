From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/7] Split a folio to any lower order folios
Date: Sun, 16 Apr 2023 11:11:49 -0700 (PDT)
Message-ID: <49ee481e-452f-61c7-2da5-28de2cf3de2@google.com>
References: <20230403201839.4097845-1-zi.yan@sent.com> <20230404144727.e613116684dbd65a4b4745c1@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681668719; x=1684260719;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LVJOhu0619OErP99xlPd4ihejbaRkAObRsbcnMFMEhQ=;
        b=woSRwUxuBadaYtz8Pla6HnY8OWT2Z6oLbv+IvJWJeFu7vl5IQgCqhJN9QW7j5/A8Ag
         Pnp0Moej9pT7JgW8tudH+yEzBUktIU4ioEkl0OO35HygM0IqCZWiph5WUYaiQP7GNxYE
         BcgYQV664/sYtXJroRKzXsITY7jTTPQUL/KzHaK/Iqz4JWfWRn/u4135QDVlSgHXlz1X
         X2iX0pcLJDn8kw1qlrq0JIqbpLnFN+aGhQn5GjLAP5/+v8T60MHc1c5lS46Ws3JX6Ie2
         SR26zLTEOJMJNoPwgYukr9mQU3OL5Vks7gyt1HG1/eCYMNm7+uGDuWYwkrUYT2b06rn1
         3ZmA==
In-Reply-To: <20230404144727.e613116684dbd65a4b4745c1-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>, =?ISO-8859-15?Q?Michal_Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zach O'Keefe <zokeefe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 4 Apr 2023, Andrew Morton wrote:
> On Mon,  3 Apr 2023 16:18:32 -0400 Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org> wrote:
> 
> > File folio supports any order and people would like to support flexible orders
> > for anonymous folio[1] too. Currently, split_huge_page() only splits a huge
> > page to order-0 pages, but splitting to orders higher than 0 is also useful.
> > This patchset adds support for splitting a huge page to any lower order pages
> > and uses it during file folio truncate operations.
> 
> This series (and its v1 & v2) don't appear to have much in the way of
> detailed review.  As it's at v3 and has been fairly stable I'll queue
> it up for some testing now, but I do ask that some reviewers go through
> it please.

Andrew, please don't let this series drift into 6.4-rc1.

I've seen a bug or two (I'll point out in response to those patches),
but overall I don't see what the justification for the series is: done
because it could be done, it seems to me, but liable to add surprises.

The cover letter says "splitting to orders higher than 0 is also useful",
but it's not clear why; and the infrastructure provided seems unsuited
to the one use provided - I'll say more on that truncation patch.

Thanks,
Hugh
