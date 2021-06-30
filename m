From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 05/18] mm/memcg: Convert memcg_check_events to take a
 node ID
Date: Wed, 30 Jun 2021 08:59:20 +0200
Message-ID: <YNwWSNjGV6/vdfHk@dhcp22.suse.cz>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-6-willy@infradead.org>
 <YNwWC8Nb3QfhMOTs@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625036361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CBX5W0P8DL2x/XCJkVNccKGv5Jq305wfaEnKjkBFQbU=;
        b=tQDnM997hmtRMIDHmNoz8iYve7UjLjIA9Xnyf1hZOU7z059jrks20PJMzWuIZ6sseJT5r0
        kZXRR5Ot0CdSeaOBAGXmyTCvnH0LuoP/CiuIrso4go+5g8N9ZBirBRb2aQSJOjj4nGmuwd
        cwOOLPE1ENmq3zIH0sLfD9BV68EIjLU=
Content-Disposition: inline
In-Reply-To: <YNwWC8Nb3QfhMOTs-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 30-06-21 08:58:20, Michal Hocko wrote:
> On Wed 30-06-21 05:00:21, Matthew Wilcox wrote:
> > memcg_check_events only uses the page's nid, so call page_to_nid in the
> > callers to make the folio conversion easier.
> 
> It will also make the interface slightly easier to follow as there
> shouldn't be any real reason to take the page for these events.
> So this is a good cleanup in general.
> 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> 
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Btw. patches 2-5 seem good enough to go to Andrew even without the rest
so that you do not have to carry them along with the rest which is quite
large I can imagine.
-- 
Michal Hocko
SUSE Labs
