From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch v2] mm: memcontrol: convert reclaim iterator to simple
 css refcounting
Date: Thu, 25 Sep 2014 12:01:30 +0200
Message-ID: <20140925100130.GC12090@dhcp22.suse.cz>
References: <1411161059-16552-1-git-send-email-hannes@cmpxchg.org>
 <20140919212843.GA23861@cmpxchg.org>
 <20140924164739.GA15897@dhcp22.suse.cz>
 <20140924171653.GA10082@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NGxrqfIaVKUY0y5yqgGJigWLwxbvyH7wjfPIisIMgyU=;
        b=qu3PuxAUNai2Gh/lFnG/rUktBSUeFutmRqKy7/wsmfVrIceQG/qG3jisCh0lNHTUtu
         cc8fmyWpJbZYKkxBmrw2uxUzaFdt1hrfwVEdJ/eLPgWkP6McKFDNA0nfQaDhfrP6hP80
         BsiigeVAIOD3GhVq3ouA3xmRhxCpAaD0G014Z6Jzt4gtPd5IV92INK0uziK4hUfZ4eHD
         qXyn57ZqoYV0t5qEMIV+rtJNoYwSI1rip3Pq+Z8PBXQbAssrSOfiYEeF1qI5QiTFGLJ6
         5wvgTOh4o7NsTDMT8Yro2qvf2UqTrzwIHMf2WhmytxS0lBQz3WROGaQlRppsqIlVnkiY
         8mDw==
Content-Disposition: inline
In-Reply-To: <20140924171653.GA10082@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 24-09-14 13:16:53, Johannes Weiner wrote:
> On Wed, Sep 24, 2014 at 06:47:39PM +0200, Michal Hocko wrote:
> > On Fri 19-09-14 17:28:43, Johannes Weiner wrote:
[...]
> > > -		memcg = __mem_cgroup_iter_next(root, last_visited);
> > > +		do {
> > > +			pos = ACCESS_ONCE(mz->reclaim_iter[priority]);
> > > +		} while (pos && !css_tryget(&pos->css));
> > 
> > This is a bit confusing. AFAIU css_tryget fails only when the current
> > ref count is zero already. When do we keep cached memcg with zero count
> > behind? We always do css_get after cmpxchg.
> > 
> > Hmm, there is a small window between cmpxchg and css_get when we store
> > the current memcg into the reclaim_iter[priority]. If the current memcg
> > is root then we do not take any css reference before cmpxchg and so it
> > might drop down to zero in the mean time so other CPU might see zero I
> > guess. But I do not see how css_get after cmpxchg on such css works.
> > I guess I should go and check the css reference counting again.
> 
> It's not about root or the newly stored memcg, it's that you might
> read the position right before it's replaced and css_put(), at which

OK, got it

	CPU0					CPU1
pos = reclaim_iter[priority]
					cmpxchg(reclaim_iter[priority], pos, memcg)
					css_put(pos)	# -> 0
css_tryget(pos)

Thanks!
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
