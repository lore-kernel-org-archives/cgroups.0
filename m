From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 0/7] Split a folio to any lower order folios
Date: Sun, 16 Apr 2023 11:45:41 -0700
Message-ID: <20230416114541.5d5a71c91bb1d04597038e00@linux-foundation.org>
References: <20230403201839.4097845-1-zi.yan@sent.com>
        <20230404144727.e613116684dbd65a4b4745c1@linux-foundation.org>
        <49ee481e-452f-61c7-2da5-28de2cf3de2@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681670742;
        bh=bkKWtC6NefsrTWOS00rB7CNAs9nNkai4VlH/PsdMTIY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TGHaQhklY+LkjT0j6HAzM2+mxOTBdYmAsbuAZ3ObzoyKMTFo1uXLTY1kit7VoLk2N
         NL7kpz6IkkV8pqUULIH2WIgB6m8ya6F1u3UehUsoNtS4io2CyDcILuXl1qntLEBKM2
         0tfJg4UOA/SwBfK2S/Xnss9lUm7hnoSLsgcAc16Y=
In-Reply-To: <49ee481e-452f-61c7-2da5-28de2cf3de2@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hugh Dickins <hughd@google.com>
Cc: Zi Yan <ziy@nvidia.com>, Zi Yan <zi.yan@sent.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yang Shi <shy828301@gmail.com>, Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ryan Roberts <ryan.roberts@arm.com>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, Zach O'Keefe <zokeefe@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org

On Sun, 16 Apr 2023 11:11:49 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> On Tue, 4 Apr 2023, Andrew Morton wrote:
> > On Mon,  3 Apr 2023 16:18:32 -0400 Zi Yan <zi.yan@sent.com> wrote:
> > 
> > > File folio supports any order and people would like to support flexible orders
> > > for anonymous folio[1] too. Currently, split_huge_page() only splits a huge
> > > page to order-0 pages, but splitting to orders higher than 0 is also useful.
> > > This patchset adds support for splitting a huge page to any lower order pages
> > > and uses it during file folio truncate operations.
> > 
> > This series (and its v1 & v2) don't appear to have much in the way of
> > detailed review.  As it's at v3 and has been fairly stable I'll queue
> > it up for some testing now, but I do ask that some reviewers go through
> > it please.
> 
> Andrew, please don't let this series drift into 6.4-rc1.

I have it still parked awaiting some reviewer input.

> I've seen a bug or two (I'll point out in response to those patches),
> but overall I don't see what the justification for the series is: done
> because it could be done, it seems to me, but liable to add surprises.
> 
> The cover letter says "splitting to orders higher than 0 is also useful",
> but it's not clear why; and the infrastructure provided seems unsuited
> to the one use provided - I'll say more on that truncation patch.

OK, I'll drop the series for this cycle.
