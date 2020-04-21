From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 18/18] mm: memcontrol: update page->mem_cgroup stability
 rules
Date: Tue, 21 Apr 2020 10:34:35 -0400
Message-ID: <20200421143435.GB341682@cmpxchg.org>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200421091014.2180-1-hdanton@sina.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W/B7BqjKBM4LZhb4muvBIRGp0mx98vy+3KswtAICBb4=;
        b=yYEhL7H/J2T6a6KKsWtsnbqwV2cWxzG4KCkGuvV+HGGqMt695cfXAFayLf634O0D8N
         z82YE/+6dzOh9T+J54Go3udpMsHkfEiyEfpQQEFz+ni8Z3fO6HNe/+OEWnKNZGvCrQFv
         7MyV/oxIsGW5GZYEwaAvXlBxuvKYFNlzgnnPsGfdVhqH4efEsitrvCJ56KEkW1B6EH7w
         odftt7b2/bH6woOvOhVei6k0Joeaku1g3SZ20UgwSTx5fB7+fyYrg6uvz74nLee6+ml6
         5mnXx36doD8smCo0G5RTwTbK3elxGEOatUHv/n1//Z4svtrHZLE23Us6aYYi73MYJ3Ey
         vEZQ==
Content-Disposition: inline
In-Reply-To: <20200421091014.2180-1-hdanton-k+cT0dCbe1g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>
Cc: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Apr 21, 2020 at 05:10:14PM +0800, Hillf Danton wrote:
> 
> On Mon, 20 Apr 2020 18:11:26 -0400 Johannes Weiner wrote:
> > 
> > The previous patches have simplified the access rules around
> > page->mem_cgroup somewhat:
> > 
> > 1. We never change page->mem_cgroup while the page is isolated by
> >    somebody else. This was by far the biggest exception to our rules
> >    and it didn't stop at lock_page() or lock_page_memcg().
> > 
> > 2. We charge pages before they get put into page tables now, so the
> >    somewhat fishy rule about "can be in page table as long as it's
> >    still locked" is now gone and boiled down to having an exclusive
> >    reference to the page.
> > 
> > Document the new rules. Any of the following will stabilize the
> > page->mem_cgroup association:
> > 
> > - the page lock
> > - LRU isolation
> > - lock_page_memcg()
> > - exclusive access to the page
> 
> Then rule-1 makes rule-3 no longer needed in mem_cgroup_move_account()?

Well, mem_cgroup_move_account() is the write side. It's the function
that changes page->mem_cgroup. So it needs to take all these locks in
order for the readside / fastpath to be okay with any one of them.
