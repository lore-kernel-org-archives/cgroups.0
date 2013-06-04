From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Tue, 4 Jun 2013 23:28:08 +0200
Message-ID: <20130604212808.GB13231@dhcp22.suse.cz>
References: <1370306679-13129-1-git-send-email-tj@kernel.org>
 <1370306679-13129-4-git-send-email-tj@kernel.org>
 <20130604131843.GF31242@dhcp22.suse.cz>
 <20130604205025.GG14916@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=f+xdokqpDPS5FUiblPiDcYjNosAR98wjJ+IZ9Rkqyi0=;
        b=h0YXHkfq9L6AlOjjxE9jxBU+WrxFfoy6FVnxgZRtXeqcxyriE33hmszqFKq1QnSGTe
         BSzIY08fJDALHV0CNJgx53VHYCGvDJCj64NLW6hZA7p+yRK4Hg983bqKEnDK+pnqWThn
         Ta1dreLkPrOOTvDwiq5SxYOpKvNKGt7mY8Z6sP3ejnES5HGSO9ZaRUWrQZJhGKP9BVr7
         6s/sDJCQRVbVa0eW6zYm77OgrIaiaABusRZqHeH2Dlyu1pzDtTfAujP7K/LYBlRRcg7x
         nAkw2j3OaNRn07ESeuKiJaUSmQ04wmOK+mzL+FOvoHod23APVl23MIEQM6uxNUQbtKCb
         YB5A==
Content-Disposition: inline
In-Reply-To: <20130604205025.GG14916@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: hannes@cmpxchg.org, bsingharora@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

On Tue 04-06-13 13:50:25, Tejun Heo wrote:
> Hello, Michal.
> 
> On Tue, Jun 04, 2013 at 03:18:43PM +0200, Michal Hocko wrote:
> > > +	if (memcg)
> > > +		css_get(&memcg->css);
> > 
> > This is all good and nice but it re-introduces the same problem which
> > has been fixed by (5f578161: memcg: relax memcg iter caching). You are
> > pinning memcg in memory for unbounded amount of time because css
> > reference will not let object to leave and rest.
> 
> I don't get why that is a problem.  Can you please elaborate?  css's
> now explicitly allow holding onto them.  We now have clear separation
> of "destruction" and "release" and blkcg also depends on it.  If memcg
> still doesn't distinguish the two properly, that's where the problem
> should be fixed.
> 
> > I understand your frustration about the complexity of the current
> > synchronization but we didn't come up with anything easier.
> > Originally I though that your tree walk updates which allow dropping rcu
> > would help here but then I realized that not really because the iterator
> > (resp. pos) has to be a valid pointer and there is only one possibility
> > to do that AFAICS here and that is css pinning. And is no-go.
> 
> I find the above really weird.  If css can't be pinned for position
> caching, isn't it natural to ask why it can't be and then fix it?

Well, I do not mind pinning when I know that somebody releases the
reference in a predictable future (ideally almost immediately). But the
cached iter represents time unbounded pinning because nobody can
guarantee that priority 3 at zone Normal at node 3 will be ever scanned
again and the pointer in the last_visited node will be stuck there for
eternity. Can we free memcg with only css elevated and safely check that
the cached pointer can be used without similar dances we have now?

I am open to any suggestions.

> Because that's what the whole refcnt thing is about and a usage which
> cgroup explicitly allows (e.g. blkcg also does it).  Why do you go
> from there to "this batshit crazy barrier dancing is the only
> solution"?
> 
> Can you please explain why memcg css's can't be pinned?

Because it pins memcg as well AFAIU and we just do not want to keep
those around for eternity.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
