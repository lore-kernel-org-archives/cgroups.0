From: Tejun Heo <tj@kernel.org>
Subject: Re: [HEADSUP] conflicts between cgroup/for-3.12 and memcg
Date: Fri, 9 Aug 2013 10:19:33 -0400
Message-ID: <20130809141933.GG20515@mtj.dyndns.org>
References: <20130809003402.GC13427@mtj.dyndns.org>
 <20130809072207.GA16531@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nG95kxZGYnZJTc7+tYcFLM9sHAhan+YlWdww+wV6CBo=;
        b=JBhEgv2mKyT8hatOA6D9sjW9cmTAXxovrMg+C8o90Wj3/gYmc6TGzPjQfobKcAffw1
         dGTFQCRinCUmCPYc7GkPNO8iSXUhjcklDJ8J0Ppp6jJClhODbXc8JgwajArPD4cWdieM
         2BA3FbyJLyUQHS7vjBYLtwsq6PYmWC/Igb7rtAcl3tAKvRdxPVmZVKqbvWkRl0o2YilP
         c3nkvNySB9BvfugDZEDyg8VJtJ7e2s9i9N903LQTlIG5VjFWSdOp7OloWYBAMwy6Es+0
         KZvxKbbLxKXfTo/Opf7uZ/aNqPcfwHMzt7K03IfxCKZdMsNCteHXkdhw+YdS0zDN2zoV
         nBMQ==
Content-Disposition: inline
In-Reply-To: <20130809072207.GA16531@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, sfr@canb.auug.org.au, linux-next@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org

Hello, Michal.

On Fri, Aug 09, 2013 at 09:22:07AM +0200, Michal Hocko wrote:
> I have just tried to merge cgroups/for-3.12 into my memcg tree and there
> were some conflicts indeed. They are attached for reference. The
> resolving is trivial. I've just picked up HEAD as all the conflicts are
> for added resp. removed code in mmotm.

Oops, that's me messing up the branches.  I was trying to reset
for-next but instead reset for-3.12 so that it didn't include the API
updates.  Can you please try to rebase on top of the current for-3.12
bd8815a6d802fc16a7a106e170593aa05dc17e72 ("cgroup: make
css_for_each_descendant() and friends include the origin css in the
iteration")?  At least the iterator update wouldn't be trivial, I
think.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
