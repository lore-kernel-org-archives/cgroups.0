From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: memcg swap doesn't work in mmotm-2014-07-09-17-08?
Date: Wed, 16 Jul 2014 17:26:11 -0400
Message-ID: <20140716212611.GD29639@cmpxchg.org>
References: <20140716181007.GA8524@nhori.redhat.com>
 <20140716183727.GB29639@cmpxchg.org>
 <20140716193129.GB8524@nhori.redhat.com>
 <20140716195721.GC29639@cmpxchg.org>
 <20140716201147.GD8524@nhori.redhat.com>
 <20140716204346.GE8524@nhori.redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=sxaLBnK9AzodYTGqlV0bwb+itZC9+wd84CCUarYoFt8=;
	b=j8ICTjlyJAgYGtyCnBx/9uH+HBqMtrph718N6o2TmonAHck5nvo7DXMOG56ZXJVaQj6HfTa3imNfO8aM2lNTHfYMikTkE1O2HjJims731xsTMikRdrxWYpKUAsUCh3VzxZaoNciUMUf7hvKm2Tn5FcPyQePUHMq1wFB571Ll/PQ=;
Content-Disposition: inline
In-Reply-To: <20140716204346.GE8524@nhori.redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, Naoya Horiguchi <nao.horiguchi@gmail.com>

On Wed, Jul 16, 2014 at 04:43:46PM -0400, Naoya Horiguchi wrote:
> On Wed, Jul 16, 2014 at 04:11:47PM -0400, Naoya Horiguchi wrote:
> ...
> > > I was running on 3.16.0-rc5-mm1-00480-gab7ca1e1e407 (latest mmots).
> > 
> > I'll try this kernel.
> > If that passes, this problem is fixed implicitly, so that's fine :)
> 
> Not reproduced in the latest mmots, so the problem is already fixed.

Thanks for making sure, Naoya-san!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
