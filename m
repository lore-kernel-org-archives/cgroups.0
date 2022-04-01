From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 09:58:59 -0700
Message-ID: <YkcvU2hosJV3cL8F@carbon.dhcp.thefacebook.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <YkXkA+Oh1Bx33PrU@carbon.dhcp.thefacebook.com>
 <YkcC3z5ReeQ5vdg9@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648832348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=opfMZhT1sWWFuxdmOUhDIsbcAFNmM7W5eVe4Jw4U7ZY=;
        b=GGASatQNi5+qmdKAN6sT/OaTjH+8x2+DckJQyi+9uL68dpIUK0DZxNUnLw/yu8t3k5scnA
        REFoIo1PPbilRLGJ/+iT7OlAQX+BGS5NsW0eaE67YBrb0zG3/dZOa3OiZ/up5QEd9hTrEn
        xQ54UriLGceRv5Ztvya2fXB8qCs3fxg=
Content-Disposition: inline
In-Reply-To: <YkcC3z5ReeQ5vdg9@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>

On Fri, Apr 01, 2022 at 03:49:19PM +0200, Michal Hocko wrote:
> On Thu 31-03-22 10:25:23, Roman Gushchin wrote:
> > On Thu, Mar 31, 2022 at 08:41:51AM +0000, Yosry Ahmed wrote:
> [...]
> > > - A similar per-node interface can also be added to support proactive
> > >   reclaim and reclaim-based demotion in systems without memcg.
> > 
> > Maybe an option to specify a timeout? That might simplify the userspace part.
> 
> What do you mean by timeout here? Isn't
> timeout $N echo $RECLAIM > ....
> 
> enough?

It's nice and simple when it's a bash script, but when it's a complex
application trying to do the same, it quickly becomes less simple and
likely will require a dedicated thread to avoid blocking the main app
for too long and a mechanism to unblock it by timer/when the need arises.

In my experience using correctly such semi-blocking interfaces (semi- because
it's not clearly defined how much time the syscall can take and whether it
makes sense to wait longer) is tricky.
