From: Hugh Dickins <hughd@google.com>
Subject: Re: [BUG] kernel BUG at mm/memcontrol.c:1074!
Date: Wed, 18 Jan 2012 19:41:44 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1201181932040.2287@eggly.anvils>
References: <1326949826.5016.5.camel@lappy> <20120119122354.66eb9820.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=hs8vViqV0puazSIpGRBAmzDOw+RgrIWhuCLPlnMRlFc=;
        b=I/09i7+5LlQLAbgqtg/DyApKaVQlUwuVRGjN5+PUaAaMJtNcXm/RGb1MKyhhqCB6m3
         Ne3YTvs8pzJtg1vFKPdGGt/XX/A5lI6zOOvabW9UFaS9JpvhtNCL1mlyabmDHCDYYNN3
         bD32ksYYekaOT/xqsLVeSj1U/qThVlgA4XJ6I=
In-Reply-To: <20120119122354.66eb9820.kamezawa.hiroyu@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, hannes <hannes@cmpxchg.org>, mhocko@suse.cz, bsingharora@gmail.com, Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu, 19 Jan 2012, KAMEZAWA Hiroyuki wrote:
> On Thu, 19 Jan 2012 07:10:26 +0200
> Sasha Levin <levinsasha928@gmail.com> wrote:
> 
> > Hi all,
> > 
> > During testing, I have triggered the OOM killer by mmap()ing a large block of memory. The OOM kicked in and tried to kill the process:
> > 
> 
> two questions.
> 
> 1. What is the kernel version  ?

It says 3.2.0-next-20120119-sasha #128

> 2. are you using memcg moutned ?

I notice that, unlike Linus's git, this linux-next still has
mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch in.

I think that was well capable of oopsing in mem_cgroup_lru_del_list(),
since it didn't always know which lru a page belongs to.

I'm going to be optimistic and assume that was the cause.

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
