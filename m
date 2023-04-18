From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3 6/7] mm: truncate: split huge page cache page to a
 non-zero order if possible.
Date: Mon, 17 Apr 2023 18:05:51 -0700 (PDT)
Message-ID: <8dbb3c83-48d-93d-3e3-4c833b81904@google.com>
References: <20230403201839.4097845-1-zi.yan@sent.com> <20230403201839.4097845-7-zi.yan@sent.com> <9dd96da-efa2-5123-20d4-4992136ef3ad@google.com> <0AC0520E-1BD2-497E-A7ED-05394400BFC9@nvidia.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681779962; x=1684371962;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xFgQbB9ZPoIUhOcvwbaJbA/N4MM87FyHead5du+V3Ns=;
        b=NGOp6SEkLFn1PavoV21e5YSPl9r8FlBhE2wJdHQaKbBfaDw59sLesAVILF7Yc8PcrC
         GhZCeYHfw7HezwQKVOD/i0/fVMXaFnOE8aJzMBcEglKWccTsDfOtnkLtDSxTOsuFCwsk
         +n0f90t/WSsuX0iLyGGj7bd8ui+WKibLC3Olz3zYHOMIY0QXA/zPw3cAxwVd2onr+eoQ
         5dJUy3JSw/Cvnt/s/hOsx2DpdL6UWL5sCt1uEkXuwC/TJIfzIagsaMy7tV/TGozPbMBZ
         mTA6Jmd7lSEZMUx1D6KbNUfGVYKlX57NYdMyLKBqr3lXPZtt+Tq4WZcNitUYzCF3vMlE
         Y0yQ==
In-Reply-To: <0AC0520E-1BD2-497E-A7ED-05394400BFC9@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zi Yan <ziy@nvidia.com>
Cc: Hugh Dickins <hughd@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yang Shi <shy828301@gmail.com>, Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ryan Roberts <ryan.roberts@arm.com>, =?ISO-8859-15?Q?Michal_Koutn=FD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, Zach O'Keefe <zokeefe@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org

On Mon, 17 Apr 2023, Zi Yan wrote:
> 
> What do you think? If you have a better idea, I am all ears. And if you
> are willing to help me review the more complicated code changes, I am
> more than happy to implement it in the next version. :)

Sorry, no, not me.  You'll have to persuade someone else that "optimizing"
truncation is a worthwhile path to pursue (and to pursue now) - I was just
trying to illustrate that the current patchset didn't seem very useful.

But don't throw your work away.  I expect some of it can become useful
later e.g. once most of the main filesystems support large folios, and
the complication of CONFIG_READ_ONLY_THP_FOR_FS can be deleted.

I doubt my "minimizing the number of folios" approach would be worth
the effort; I think more likely that we shall settle on an intermediate
folio size (between 4K and THP: maybe 64K, but not necessarily the same
on all machines or all workloads) to aim for, and then maybe truncation
of THP would split to those units.  But it's not a job I shall get into
- I'll just continue to report and try to fix what bugs I see.

Hugh
