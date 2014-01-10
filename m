From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Fri, 10 Jan 2014 13:38:50 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401101335200.21486@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com> <20131217162342.GG28991@dhcp22.suse.cz> <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com> <20131218200434.GA4161@dhcp22.suse.cz> <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
 <20131219144134.GH10855@dhcp22.suse.cz> <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org> <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com> <20140109144757.e95616b4280c049b22743a15@linux-foundation.org>
 <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com> <20140110083025.GE9437@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=a+fjbsEdHkEWxIke86f5xIN2FnDL/j2+cfJg817mByA=;
        b=h9kViL0GObPnog0c+8zZsBIxMh5bQKZE6qCB22AEoJRNz+mjCh38TqykEe4v5Gz4F0
         UI/sKm3mbAKL20bZeD2FRDSRTeFVbx8eB4k++Y6Z/USlf+EFY0ZH+gg+yShBDAINvAlo
         gW/pJqdKeN93A0xHi1s7HGUksdzuGBgVO6nARY310ID99v4wNTrYyYekujWhetehpiei
         XWZspDF311CdLZj0Zuaf765j2sULYzUK+LF8P9HK0DxdgiEYfj6j7/4x+x5XV2MKC6mS
         J3xJLnTlRkL9bZnJIGAftz8gCTwvUsGP/blZTZ/F2m2OEDcnPdShHRN7C1Io0BcHexWq
         iMjQ==
In-Reply-To: <20140110083025.GE9437@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>

On Fri, 10 Jan 2014, Michal Hocko wrote:

> I have already explained why I have acked it. I will not repeat
> it here again. I have also proposed an alternative solution
> (https://lkml.org/lkml/2013/12/12/174) which IMO is more viable because
> it handles both user/kernel memcg OOM consistently. This patch still has
> to be discussed because of other Johannes concerns. I plan to repost it
> in a near future.
> 

This three ring circus has to end.  Really.

Your patch, which is partially based on my suggestion to move the 
mem_cgroup_oom_notify() and call it from two places to support both 
memory.oom_control == 1 and != 1, is something that I liked as you know.  
It's based on my patch which is now removed from -mm.  So if you want to 
rebase that patch and propose it, that's great, but this is yet another 
occurrence of where important patches have been yanked out just before the 
merge window when the problem they are fixing is real and we depend on 
them.

Please post your rebased patch ASAP for the 3.14 merge window.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
