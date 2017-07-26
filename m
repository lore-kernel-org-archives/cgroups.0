From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v4 1/4] mm, oom: refactor the TIF_MEMDIE usage
Date: Wed, 26 Jul 2017 15:50:17 +0100
Message-ID: <20170726145017.GA24286@castle.DHCP.thefacebook.com>
References: <20170726132718.14806-1-guro@fb.com>
 <20170726132718.14806-2-guro@fb.com>
 <20170726135622.GS2981@dhcp22.suse.cz>
 <20170726140607.GA20062@castle.DHCP.thefacebook.com>
 <20170726142434.GT2981@dhcp22.suse.cz>
 <20170726144408.GU2981@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=uiJqbM5jVrlr4ii27VuGyfqyksM4p+Z83/5Fe9JE2dc=;
 b=QjSZ9q1uqGUdAlSS/OBu9/WfdwfyACFt4pXiIZTC6jbyJnCquJLvfptMj0pZIQGrcSNG
 SIJW7GLKrnbD07V7rBoYSpUCT1cKyq1NH9D99KGoUEQqSHTpJTuv97Rf4qS+/RYSRyCJ
 LOKjB3TBTt4cC0AofrHm+X/3bBw/JLc67qc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=uiJqbM5jVrlr4ii27VuGyfqyksM4p+Z83/5Fe9JE2dc=;
 b=LKiNBocOkq3vuGoogfMzdnsaBlcVfahtblEVs6c/ccQ0AvNkphyrc0GT0ZyIy9fN/QgUbIknD1Ual9NtF9zL3p6A8Vb5RGCP3vra1GeOzrlBh6vH/QsLlxLs96mvp1G11CjjCCrlidJbOFs6OjcTvHmR5JW/qiv9mX+wQx6Gdz0=
Content-Disposition: inline
In-Reply-To: <20170726144408.GU2981-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 26, 2017 at 04:44:08PM +0200, Michal Hocko wrote:
> On Wed 26-07-17 16:24:34, Michal Hocko wrote:
> [...]
> > Or if you prefer I can post it separately?
> 
> I've just tried to rebase relevant parts on top of the current mmotm
> tree and it needs some non-trivial updates. Would you mind if I post
> those patches with you on CC?

Sure.
Again, I'm not against your approach (and I've tried to rebase your patches,
and it worked well for me, although I didn't run any proper tests),
I just don't want to create an unnecessary dependancy here.

If your patchset will be accepted, it will be quite trivial to rebase
mine and vice-versa; they are not so dependant.

> I will comment on the rest of the series later. I have glanced through
> it and have to digest it some more before replying.

Thanks!
