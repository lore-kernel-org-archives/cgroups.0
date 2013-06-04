From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch -v4 4/8] memcg: enhance memcg iterator to support
 predicates
Date: Tue, 4 Jun 2013 12:36:19 -0700
Message-ID: <20130604193619.GA14916@htj.dyndns.org>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
 <1370254735-13012-5-git-send-email-mhocko@suse.cz>
 <20130604010737.GF29989@mtj.dyndns.org>
 <20130604134523.GH31242@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Ie7+cWk373i19bhSJu1kVycfFL4asEW8ADwjz0n2Pr0=;
        b=TpNzQfV5AZV5wFiXkCXbLz5vkka82afCIBjek1gSCBq78flHQCApiK4tBQV8uDhOjF
         yYzsXcP1kBtU25WsZaMSUFHcvHg9LvxmWBtljy53U96+xNeKw1Go/sk1PRYfXH2j/m1F
         JxNK64YeulYj9dkALX8O0jislL/tFE8LC5k2gYRKEwQ/GK3spKkJy1f4cjhlcrICmKNI
         WNvkqFF9lbBzdgRNTHH9139KtQUVvv27/XVf2JOpvRtzMab9nJPd4hwMXKPwCidMojox
         BdTYbE+nNATWgqqTikIEngg7XKVBGuhisyTD2K+w1kdRa+pO8HyEbc2ZhbGvsri/5Wsy
         epJA==
Content-Disposition: inline
In-Reply-To: <20130604134523.GH31242@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>, Glauber Costa <glommer@parallels.com>, Michel Lespinasse <walken@google.com>, Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>

Hey, Michal.

On Tue, Jun 04, 2013 at 03:45:23PM +0200, Michal Hocko wrote:
> Is this something that you find serious enough to block this series?
> I do not want to push hard but I would like to settle with something
> finally. This is taking way longer than I would like.

I really don't think memcg can afford to add more mess than there
already is.  Let's try to get things right with each change, please.
Can we please see how the other approach would look like?  I have a
suspicion that it's likely be simpler but the devils are in the
details and all...

> > The iteration only depends on the current position.  Can't you factor
> > out skipping part outside the function rather than rolling into this
> > monstery thing with predicate callback?  Just test the condition
> > outside and call a function to skip whatever is necessary?
> > 
> > Also, cgroup_rightmost_descendant() can be pretty expensive depending
> > on how your tree looks like. 
> 
> I have no problem using something else. This was just the easiest to
> use and it behaves more-or-less good for hierarchies which are more or
> less balanced. If this turns out to be a problem we can introduce a
> new cgroup_skip_subtree which would get to last->sibling or go up the
> parent chain until there is non-NULL sibling. But what would be the next
> selling point here if we made it perfect right now? ;)

Yeah, sure thing.  I was just worried because the skipping here might
not be as good as the code seems to indicate.  There will be cases,
which aren't too uncommon, where the skipping doesn't save much
compared to just continuing the pre-order walk, so....  And nobody
would really notice it unless [s]he looks really hard for it, which is
the more worrisome part for me.  Maybe just stick a comment there
explaining that we probably want something better in the future?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
