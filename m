From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Fri, 25 Jul 2014 11:26:54 -0400
Message-ID: <20140725152654.GK1725@cmpxchg.org>
References: <CAJfpegt9k+YULet3vhmG3br7zSiHy-DRL+MiEE=HRzcs+mLzbw@mail.gmail.com>
 <20140719173911.GA1725@cmpxchg.org>
 <20140722150825.GA4517@dhcp22.suse.cz>
 <CAJfpegscT-ptQzq__uUV2TOn7Uvs6x4FdWGTQb9Fe9MEJr2KjA@mail.gmail.com>
 <20140723143847.GB16721@dhcp22.suse.cz>
 <20140723150608.GF1725@cmpxchg.org>
 <CAJfpegs-k5QC+42SzLKUSaHrdPxWBaT_dF+SOPqoDvg8h5p_Tw@mail.gmail.com>
 <20140723210241.GH1725@cmpxchg.org>
 <20140724084644.GA14578@dhcp22.suse.cz>
 <20140724090257.GB14578@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=u0iFqbTIGUddRsAcSYMcbGxsIZ+du0c7Eg8JotJLWgU=;
	b=ayToAOFL4ufFcy2scSSadgDyXu5GU78mTDdBqShlBgyHbd00cHGQnXMyLKyvq/ySPTr+zGSUNNhgTb/fGKb41CLNI/2SRa5vyud9rbM0Ek7I0qqPFETZK5SvTfeu5CB7Lx21+GdEN4cilec54FXGFqvU5TkEYcaBQGyBHI0BLRk=;
Content-Disposition: inline
In-Reply-To: <20140724090257.GB14578-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jul 24, 2014 at 11:02:57AM +0200, Michal Hocko wrote:
> On Thu 24-07-14 10:46:44, Michal Hocko wrote:
> > On Wed 23-07-14 17:02:41, Johannes Weiner wrote:
> [...]
> > We can reduce the lookup only to lruvec==true case, no?
> 
> Dohh
> s@can@should@
> 
> newpage shouldn't charged in all other cases and it would be bug.
> Or am I missing something?

Yeah, but I'd hate to put that assumption onto the @lrucare parameter,
it just coincides.

> > Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Thanks!
