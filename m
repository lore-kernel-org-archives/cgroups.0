From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v4 1/4] mm, oom: refactor the TIF_MEMDIE usage
Date: Wed, 26 Jul 2017 16:44:08 +0200
Message-ID: <20170726144408.GU2981@dhcp22.suse.cz>
References: <20170726132718.14806-1-guro@fb.com>
 <20170726132718.14806-2-guro@fb.com>
 <20170726135622.GS2981@dhcp22.suse.cz>
 <20170726140607.GA20062@castle.DHCP.thefacebook.com>
 <20170726142434.GT2981@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170726142434.GT2981@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 26-07-17 16:24:34, Michal Hocko wrote:
[...]
> Or if you prefer I can post it separately?

I've just tried to rebase relevant parts on top of the current mmotm
tree and it needs some non-trivial updates. Would you mind if I post
those patches with you on CC? I really think that we shouldn't invent a
new throttling just to replace it later.

I will comment on the rest of the series later. I have glanced through
it and have to digest it some more before replying.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
