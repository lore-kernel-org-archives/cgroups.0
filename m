From: Tejun Heo <tj@kernel.org>
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Date: Mon, 16 Dec 2013 12:21:43 -0500
Message-ID: <20131216172143.GJ32509@htj.dyndns.org>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
 <52AEC989.4080509@huawei.com>
 <20131216095345.GB23582@dhcp22.suse.cz>
 <20131216104042.GC23582@dhcp22.suse.cz>
 <20131216163530.GH32509@htj.dyndns.org>
 <20131216171937.GG26797@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9z3pM0d8nUflHSTQVJfvltIGHX3QWpdSjzLJA0Uu8sc=;
        b=TK6qYlpCBDD/f8+t4996ZqAwDZxR55ZIiShyYeQ9Gwxdh0PpL/Jj6YmXen8LiGGYxd
         AGETytsEEht9ba+eDxld8bJeg2g4DGAgn8binwUNbJYe+/qax3WIHQWyRs3970Brih8F
         eYDkBS/YCBRfCyCHPCe6QVCTVyrQpfORhN4aJ7XX0/u+Oocx+Kl8DsB8bsfcbIYfmPsH
         JqtPwNVB+yu+SrnxUfyyGm8c8cEJ35wYZIMvtW09jGvWIS7COP/H7irz+18xYWCEvfAp
         2+DJykSsFqLXOpco2N4JQ8wORsSElnpgc0plDuzF16CBmeS8bH1StKh0E8QReKUEp6xO
         lsGw==
Content-Disposition: inline
In-Reply-To: <20131216171937.GG26797@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hey,

On Mon, Dec 16, 2013 at 06:19:37PM +0100, Michal Hocko wrote:
> I have to think about it some more (the brain is not working anymore
> today). But what we really need is that nobody gets the same id while
> the css is alive. So css_from_id returning NULL doesn't seem to be
> enough.

Oh, I meant whether it's necessary to keep css_from_id() working
(ie. doing successful lookups) between offline and release, because
that's where lifetimes are coupled.  IOW, if it's enough for cgroup to
not recycle the ID until all css's are released && fail css_from_id()
lookup after the css is offlined, I can make a five liner quick fix.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
