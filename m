From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Mon, 4 Apr 2022 10:44:04 +0200
Message-ID: <Ykqv1CvGwgmF2jlT@dhcp22.suse.cz>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <YkXkA+Oh1Bx33PrU@carbon.dhcp.thefacebook.com>
 <YkcC3z5ReeQ5vdg9@dhcp22.suse.cz>
 <YkcvU2hosJV3cL8F@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649061845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X0N2SxV6GjMVBOdoERBEDYeu88UwXc3gO4jWk0FL4TE=;
        b=G27ShgYo1cdjBzpUTqcaG4sKAhfdAMb+RpuR95Gu71a11RnyRiUj34mel/G84IricAzl1X
        kyXI1UO5gR94PqCsnRxPa/AuFaQunXNCiDC9YAXhbTvnBHFk6MjUBQwrQPN3/Paj6Ur3bl
        eW8JqnJcBgsgVlF6rexeyRdjGKsJWyE=
Content-Disposition: inline
In-Reply-To: <YkcvU2hosJV3cL8F@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>

On Fri 01-04-22 09:58:59, Roman Gushchin wrote:
> On Fri, Apr 01, 2022 at 03:49:19PM +0200, Michal Hocko wrote:
> > On Thu 31-03-22 10:25:23, Roman Gushchin wrote:
> > > On Thu, Mar 31, 2022 at 08:41:51AM +0000, Yosry Ahmed wrote:
> > [...]
> > > > - A similar per-node interface can also be added to support proactive
> > > >   reclaim and reclaim-based demotion in systems without memcg.
> > > 
> > > Maybe an option to specify a timeout? That might simplify the userspace part.
> > 
> > What do you mean by timeout here? Isn't
> > timeout $N echo $RECLAIM > ....
> > 
> > enough?
> 
> It's nice and simple when it's a bash script, but when it's a complex
> application trying to do the same, it quickly becomes less simple and
> likely will require a dedicated thread to avoid blocking the main app
> for too long and a mechanism to unblock it by timer/when the need arises.
> 
> In my experience using correctly such semi-blocking interfaces (semi- because
> it's not clearly defined how much time the syscall can take and whether it
> makes sense to wait longer) is tricky.

We have the same approach to setting other limits which need to perform
the reclaim. Have we ever hit that as a limitation that would make
userspace unnecessarily too complex?
-- 
Michal Hocko
SUSE Labs
