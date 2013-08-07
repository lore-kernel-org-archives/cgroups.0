From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] memcg: Limit the number of events registered on
 oom_control
Date: Wed, 7 Aug 2013 09:11:11 -0400
Message-ID: <20130807131111.GC27006@htj.dyndns.org>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <1375874907-22013-2-git-send-email-mhocko@suse.cz>
 <20130807130836.GB27006@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eW3MXc5/uffQvCiOS28PXboZuP8Q3szEA/p3kw3NBlw=;
        b=M/buVv3SgHOT4rY8FxPZzzB2kc4x+VYXZ9ViEGYd+hegdMXtsY2kE5z1G9g+xzc7Vk
         u9vhZrhfXbvZWe8o3kW/nYW7rpanWb9IBO3dcWjjEDVDNbq/Yaku9msnyy45zcPOGTCn
         8SQX+FMpHWIbYHhUaqnALkHDUnVMaRL9XpxYttF0dGSvwidmZ+XMi1EP4Nob94Zbeb8/
         sFRS/ewHwmXg47v7YYoLmMA79WWZfFOisFaHex/JK9QvB6l+D5QgSZH6XCOvPukJdtcL
         /9UGEsX38Wh3vHJix1rEsoIO79xU7jRXeT3/b/RuCjHyhj6Hq8r9rQGK/p2nJHET4jdE
         CWZw==
Content-Disposition: inline
In-Reply-To: <20130807130836.GB27006@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Anton Vorontsov <anton.vorontsov@linaro.org>

On Wed, Aug 07, 2013 at 09:08:36AM -0400, Tejun Heo wrote:
> Hello, Michal.
> 
> On Wed, Aug 07, 2013 at 01:28:26PM +0200, Michal Hocko wrote:
> > There is no limit for the maximum number of oom_control events
> > registered per memcg. This might lead to an user triggered memory
> > depletion if a regular user is allowed to register events.
> > 
> > Let's be more strict and cap the number of events that might be
> > registered. MAX_OOM_NOTIFY_EVENTS value is more or less random. The
> > expectation is that it should be high enough to cover reasonable
> > usecases while not too high to allow excessive resources consumption.
> > 1024 events consume something like 24KB which shouldn't be a big deal
> > and it should be good enough (even 1024 oom notification events sounds
> > crazy).
> 
> I think putting restriction on usage_event makes sense as that builds
> a shared contiguous table from all events which can't be attributed
> correctly and makes it easy to trigger allocation failures due to
> large order allocation but is this necessary for oom and vmpressure,
> both of which allocate only for the listening task?  It isn't
> different from listening from epoll, for example.  If there needs to
> be kernel memory limit, shouldn't that be handled by kmemcg?

To add a bit, adding this global limit actually makes these events
prone to DoS attack regardless of kernel memory usage limit.  Given
that the whole usage model of delegating access to the file is busted,
I don't think it matters all that much but I'm not sure what this
patch is protecting against.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
