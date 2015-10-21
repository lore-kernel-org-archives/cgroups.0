From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: vmpressure: fix scan window after SWAP_CLUSTER_MAX
 increase
Date: Wed, 21 Oct 2015 13:05:53 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.1510211303240.3467@eggly.anvils>
References: <1445278381-21033-1-git-send-email-hannes@cmpxchg.org> <20151021193852.GA13511@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=X4B1i4lJzk7TKq4jKBkyEPCXNYWrAtw1jDgkZ1LS40o=;
        b=oeo9a7+I3e1/yTj9qCdVQof5D8jKQ9/bYEVmKYXL5/3vGZXMLxnc57DfLj4GHN4crk
         szigqPZdo1BgBr4hYFjH/AoIIjSY5ZKylPQKr20yeuOq4JdQRTomrGvs2Sc/2WArETOK
         E+Y9FmSFtb+Fzsbf2r0F7OL7byr3uRXzVgK1o9Q+c/DuU+bCmhbS44xetAqJjH0lriSh
         qZ8dThl2sG7aTIN2TLWap37hfcKqvtNwJEP1uKDUQVB9wfXAcllE0Yc4fgCAl1PpPf3p
         IZhZjtK76qwrXbpAbd2r8Z98yeLRrsl+NH5yl5neZKDu0e40FcMnsjUL6AgwAeos08Iy
         t7sQ==
In-Reply-To: <20151021193852.GA13511@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 21 Oct 2015, Johannes Weiner wrote:
> On Mon, Oct 19, 2015 at 02:13:01PM -0400, Johannes Weiner wrote:
> > mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch changed
> > SWAP_CLUSTER_MAX from 32 pages to 256 pages, inadvertantly switching
> > the scan window for vmpressure detection from 2MB to 16MB. Revert.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  mm/vmpressure.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> > index c5afd57..74f206b 100644
> > --- a/mm/vmpressure.c
> > +++ b/mm/vmpressure.c
> > @@ -38,7 +38,7 @@
> >   * TODO: Make the window size depend on machine size, as we do for vmstat
> >   * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
> >   */
> > -static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
> > +static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX;
> 
> Argh, Mel's patch sets SWAP_CLUSTER_MAX to 256, so this should be
> SWAP_CLUSTER_MAX * 2 to retain the 512 pages scan window.
> 
> Andrew could you please update this fix in-place? Otherwise I'll
> resend a corrected version.
> 
> Thanks, and sorry about that.

I don't understand why "SWAP_CLUSTER_MAX * 2" is thought better than "512".
Retaining a level of obscurity, that just bit us twice, is a good thing?

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
