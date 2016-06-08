From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: remove BUG_ON in uncharge_list
Date: Wed, 8 Jun 2016 10:58:33 -0400
Message-ID: <20160608145833.GA6727@cmpxchg.org>
References: <1465369248-13865-1-git-send-email-roy.qing.li@gmail.com>
 <20160608072554.GD22570@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160608072554.GD22570@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, roy.qing.li@gmail.com, vdavydov@virtuozzo.com

On Wed, Jun 08, 2016 at 09:25:54AM +0200, Michal Hocko wrote:
> On Wed 08-06-16 15:00:48, roy.qing.li@gmail.com wrote:
> > From: Li RongQing <roy.qing.li@gmail.com>
> > 
> > when call uncharge_list, if a page is transparent huge, and not need to
> > BUG_ON about non-transparent huge, since nobody should be be seeing the
> > page at this stage and this page cannot be raced with a THP split up
> 
> Johannes do you remember why you have kept this bug on even after
> 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API")?

No, I just copied it over without thinking too much about it. That
patch was pretty drastic, so why not keep the sanity checks in case
one of the many assumptions it made were flawed...

But it's probably okay to drop it at this point.

> > Signed-off-by: Li RongQing <roy.qing.li@gmail.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
