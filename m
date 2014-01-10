From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Fri, 10 Jan 2014 17:34:20 -0500
Message-ID: <20140110223420.GE6963@cmpxchg.org>
References: <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com>
 <20131218200434.GA4161@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
 <20131219144134.GH10855@dhcp22.suse.cz>
 <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
 <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com>
 <20140109144757.e95616b4280c049b22743a15@linux-foundation.org>
 <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com>
 <20140110083025.GE9437@dhcp22.suse.cz>
 <alpine.DEB.2.02.1401101335200.21486@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=vSM/h4n0H0xtUcVlz2KcU4UMUDo6UTiqvrDF3Dou6p4=;
	b=fwz+fC+V94efIjeCiXfFoVL3FKQZfsRvMQmwdjanyr5/CemWnTncBOx2c+mhjuwg6pyH8O+lHcld+TXRKgoUfBJUgMJAJ0DIlSdK6WhEAwtpO4HWPY8ajrBnyae0fEEyVKQUOALDcrFQ1MX5Yfe+xuIEtIBcd7nmCKjlqVlbvkk=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401101335200.21486@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>

On Fri, Jan 10, 2014 at 01:38:50PM -0800, David Rientjes wrote:
> On Fri, 10 Jan 2014, Michal Hocko wrote:
> 
> > I have already explained why I have acked it. I will not repeat
> > it here again. I have also proposed an alternative solution
> > (https://lkml.org/lkml/2013/12/12/174) which IMO is more viable because
> > it handles both user/kernel memcg OOM consistently. This patch still has
> > to be discussed because of other Johannes concerns. I plan to repost it
> > in a near future.
> > 
> 
> This three ring circus has to end.  Really.
> 
> Your patch, which is partially based on my suggestion to move the 
> mem_cgroup_oom_notify() and call it from two places to support both 
> memory.oom_control == 1 and != 1, is something that I liked as you know.  
> It's based on my patch which is now removed from -mm.  So if you want to 
> rebase that patch and propose it, that's great, but this is yet another 
> occurrence of where important patches have been yanked out just before the 
> merge window when the problem they are fixing is real and we depend on 
> them.

We tried to discuss and understand the problem, yet all we got was
"it's OBVIOUS" and "Google has been using this patch ever since we
switched to memcg" and flat out repetitions of the same points about
reliable OOM notification that were already put into question.

You still have not convinced me that the problem exists as you
described it, apart from the aspects that Michal is now fixing
separately because you did not show any signs of cooperating.

None of this will change until you start working with us and actually
address feedback and inquiries instead of just repeating your talking
points over and over.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
