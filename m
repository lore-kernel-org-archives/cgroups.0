From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch v2] mm: memcontrol: convert reclaim iterator to simple
 css refcounting
Date: Wed, 24 Sep 2014 21:29:30 -0400
Message-ID: <20140925012930.GA26745@htj.dyndns.org>
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
        bh=YZe5v45cF17CB6IYiGa+J7Zf2airs95OYML8GwRzJKI=;
        b=vIDaYL5meIEQuRMlCoE7ChvkOa/x6D60Lkuyo/nKEiEgJrlq1Uv/kTns3UocZM3D0l
         Z+6hyi7Cudk0bnCZqIP29O23kL9wkbSa1yFdbatKou1w/zpdxcdNNXEvxK+kqybmbBRr
         sapX/lLoJZjyawByhcICt0iIYRPn386PTTsQ9ArIGuYDQUUZfWXIYySP5D0D1zMHqMGW
         BwiNYlMRTodHlMMK1IBsbkfP9M+cKz0meg+qN46ZB8LcbDQzOCofiArptCxjg3wWWjVA
         jEPXDuqu1Yahukc0PNwsHf/dahj1LOUcVgqyQ60lLr5tpdGUggNitz+q0cqfCQN2j88/
         I9lA==
Content-Disposition: inline
In-Reply-To: <20140924171653.GA10082@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 24, 2014 at 01:16:53PM -0400, Johannes Weiner wrote:
> Tejun, should maybe the iterators not return css before they have
> CSS_ONLINE set?  It seems odd to have memcg reach into cgroup like
> that to check if published objects are actually fully initialized.
> Background is this patch:

So, memcontrol shouldn't be doing that but at the same time cgroup
core can't do it for any controller.  One of the requirements of the
iterations is that it shouldn't miss any css which has been onlined by
its controller; however, because each controller defines its own
locking, cgroup core has no way knowing when a css finishes
initialization.  If it includes after ->css_online() is complete, the
iteration may happen between when the controller considers the css
fully initialized and cgroup core sets CSS_ONLINE.  The only thing
cgroup core can do is including all csses which *could* be considered
online by the controller and let it filter accordingly.

IOW, the precise moment a css becomes online is not known to the
cgroup core as cgroup core locking and controller locking are
completely independent.  The current memcg implementation is broken in
that memcg iterator is testing CSS_ONLINE which is set *after*
->css_online() is complete and iterations can happen inbetween where
the online css may be omitted because it's not marked online by cgroup
core yet.  This may be okay for memcg's use of iterators but for
things like freezer, for example, this can break things horribly.

Anyways, the right thing to do is removing the CSS_ONLINE testing and
implementing memcg's own way of marking an object as fully initialized
according to its synchronization and iteration requirements.  So,
yeah, it's a glaring layering violation which should be removed.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
