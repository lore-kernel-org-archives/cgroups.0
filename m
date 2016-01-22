From: Tejun Heo <tj@kernel.org>
Subject: Re: PROBLEM: BUG when using memory.kmem.limit_in_bytes
Date: Fri, 22 Jan 2016 10:51:04 -0500
Message-ID: <20160122155104.GG32380@htj.duckdns.org>
References: <CAKB58ikDkzc8REt31WBkD99+hxNzjK4+FBmhkgS+NVrC9vjMSg@mail.gmail.com>
 <20160122135042.GF26192@esperanza>
 <20160122144854.GA14432@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IRh2oYQjVZ4i/TmFnbeu4td4k9ZP2nGs18UDX39FYY8=;
        b=bJWZ9xJpvg1KXR2izN3bj90ULraqTbJkHP/8zoBCaJf04Er3CRk2HRhrTe5GLVCiTM
         XiQhyjlim2cdGf016C8PKfdIBmPz7hGCnW68TuLyj63AiFSVmtW7n1cCWmCfOAbugFio
         iU2glLxCnTP6ustBlehWJwDSjlCq4mSh7akj6F/CjWpYyRBXXDAJqE3fCr0hpwhm0ZOG
         ErnGXRDei9HKvhvpNE00hvyIw5CyeLSZPMOKK/jEB4f5O6sl6TdMDi0ZrI+Yq25JJA+R
         JYV6ERofCMkuNH8tP6AgHhDcIMoJfwIrT3OyfSSYmOV7RokuX/0SPQyiAP3ZxCRKtWZ1
         xDsw==
Content-Disposition: inline
In-Reply-To: <20160122144854.GA14432@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>, Brian Christiansen <brian.o.christiansen@gmail.com>, Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org

On Fri, Jan 22, 2016 at 09:48:54AM -0500, Johannes Weiner wrote:
> On Fri, Jan 22, 2016 at 04:50:42PM +0300, Vladimir Davydov wrote:
> > From first glance, it looks like the bug was triggered, because
> > mem_cgroup_css_offline was run for a child cgroup earlier than for its
> > parent. This couldn't happen for sure before the cgroup was switched to
> > percpu_ref, because cgroup_destroy_wq has always had max_active == 1.
> > Now, however, it looks like this is perfectly possible for
> > css_killed_ref_fn is called from an rcu callback - see kill_css ->
> > percpu_ref_kill_and_confirm. This breaks kmemcg assumptions.
> > 
> > I'll take a look what can be done about that.
> 
> It's an acknowledged problem in the cgroup core then, and not an issue
> with kmemcg. Tejun sent a fix to correct the offlining order here:
> 
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1056544.html

Patche descriptions updated and applied to cgroup/for-4.5-fixes.

 http://lkml.kernel.org/g/20160122154503.GD32380@htj.duckdns.org
 http://lkml.kernel.org/g/20160122154552.GE32380@htj.duckdns.org

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
