From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: Re: [PATCH v14 16/18] vmpressure: in-kernel notifications
Date: Fri, 20 Dec 2013 11:44:39 -0500
Message-ID: <20131220114439.23af09fc@redhat.com>
References: <cover.1387193771.git.vdavydov@parallels.com>
	<abff42910c131a9c94a7518de59b283ee0a2dcd1.1387193771.git.vdavydov@parallels.com>
	<20131220092659.0ed23cf5@redhat.com>
	<CAA6-i6pDqDemeQ+s4EorOx39qmNAtAfVYfg0Z2wtTEu-S7mY=A@mail.gmail.com>
	<20131220100332.0c5c1ad5@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20131220100332.0c5c1ad5@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Glauber Costa <glommer@gmail.com>, Vladimir Davydov <vdavydov@parallels.com>, dchinner@redhat.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Glauber Costa <glommer@openvz.org>, John Stultz <john.stultz@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

On Fri, 20 Dec 2013 10:03:32 -0500
Luiz Capitulino <lcapitulino@redhat.com> wrote:

> > The answer for all of your questions above can be summarized by noting
> > that for the lack of other users (at the time), this patch does the bare minimum
> > for memcg needs. I agree, for instance, that it would be good to pass the level
> > but since memcg won't do anything with thta, I didn't pass it.
> > 
> > That should be extended if you need to.
> 
> That works for me. That is, including this minimal version first and
> extending it when we get in-tree users.

Btw, there's something I was thinking just right now. If/when we
convert shrink functions to use this API, they will come to depend
on CONFIG_MEMCG=y. IOW, they won't work if CONFIG_MEMCG=n.

Is this acceptable (this is an honest question)? Because today, they
do work when CONFIG_MEMCG=n. Should those shrink functions use the
shrinker API as a fallback?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
