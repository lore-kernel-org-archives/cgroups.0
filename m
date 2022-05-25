From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH v4 10/11] mm: lru: add VM_BUG_ON_FOLIO to lru maintenance
 function
Date: Wed, 25 May 2022 19:58:16 +0800
Message-ID: <Yo4Z2KfGxGyIlmmI@FVFYT0MHHV2J.usts.net>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-11-songmuchun@bytedance.com>
 <Yo2XBdLxcJ/J6KJp@carbon>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=83P9lIf96SgEF4FIz+2NIYTMoqq/3LIlBOcpNeCCdxU=;
        b=V9H/HXtZcLAXr098dtpBDsWTnNouWEfreWbUot8dXiLuBzVLB4mCHrI6WKX6pVyZBD
         kiNUVaM5D5ayScwD40y9Txc6lXPYaCgigth5ZN7Ae3+g2nfLeqXrNFEtKPGXdutjjO3n
         XhABixH/23MX1UYyLqe8AiN6xxOLpLYfmjfZzE4eMmEaIK+3FtTAdD/h92PM9AcDNnvv
         l3sS52cpVjTlm0KWQFUHr4gAgMldcOrjQLPJSBo5dCH5wXpwJDUCn8jjooO4sCA/4QAp
         wZktZJWFJjkaF/4ebJ6wXuCrOZYssWMh3qoqUYyRbVykBTT1PCykeNLMxk3ucGph1lD3
         Oa0Q==
Content-Disposition: inline
In-Reply-To: <Yo2XBdLxcJ/J6KJp@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, shakeelb@google.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com, longman@redhat.com

On Tue, May 24, 2022 at 07:40:05PM -0700, Roman Gushchin wrote:
> On Tue, May 24, 2022 at 02:05:50PM +0800, Muchun Song wrote:
> > We need to make sure that the page is deleted from or added to the
> > correct lruvec list. So add a VM_BUG_ON_FOLIO() to catch invalid
> > users.
> > 
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> >  include/linux/mm_inline.h | 6 ++++++
> >  mm/vmscan.c               | 1 -
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index ac32125745ab..30d2393da613 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -97,6 +97,8 @@ void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
> >  {
> >  	enum lru_list lru = folio_lru_list(folio);
> >  
> > +	VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
> > +
> >  	update_lru_size(lruvec, lru, folio_zonenum(folio),
> >  			folio_nr_pages(folio));
> >  	if (lru != LRU_UNEVICTABLE)
> > @@ -114,6 +116,8 @@ void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
> >  {
> >  	enum lru_list lru = folio_lru_list(folio);
> >  
> > +	VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
> > +
> >  	update_lru_size(lruvec, lru, folio_zonenum(folio),
> >  			folio_nr_pages(folio));
> >  	/* This is not expected to be used on LRU_UNEVICTABLE */
> > @@ -131,6 +135,8 @@ void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
> >  {
> >  	enum lru_list lru = folio_lru_list(folio);
> >  
> > +	VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
> > +
> >  	if (lru != LRU_UNEVICTABLE)
> >  		list_del(&folio->lru);
> >  	update_lru_size(lruvec, lru, folio_zonenum(folio),
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 761d5e0dd78d..6c9e2eafc8f9 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2281,7 +2281,6 @@ static unsigned int move_pages_to_lru(struct list_head *list)
> >  			continue;
> >  		}
> >  
> > -		VM_BUG_ON_PAGE(!folio_matches_lruvec(folio, lruvec), page);
> 
> The commit log describes well why we need to add new BUG_ON's. Please, add
> something on why this is removed.
>

OK. Will do in v5.

Thanks. 
