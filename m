From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v5 06/14] memcg: kmem controller infrastructure
Date: Fri, 19 Oct 2012 02:31:33 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1210190229450.26815@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-7-git-send-email-glommer@parallels.com> <20121017151214.e3d2aa3b.akpm@linux-foundation.org> <507FC8E3.8020006@parallels.com> <alpine.DEB.2.00.1210181502270.30894@chino.kir.corp.google.com>
 <50811903.9000105@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=72z53lzBMxR3uaP//qrOh5v7KwumDpnDnHW7Lc0d66M=;
        b=ie+XnTsiDdoj9Hx7RRYXdX75cSEW521NwAWVJzA7mHGws2PlHWieuSoQ10sK4utkdu
         XnhyM/DNGSsgPORAQtswY+S5bHkYPB1kw6yVujgeyIW93ifumUj1g0nwChMxJHKxwX+L
         nUROnd6WbLBy8k44/5cfwSCunjUV/akCfZDHf75j0BzHkI9enpMCiQlUrdY8KPjc/i3+
         dXDN3HhcYH3WEzTPPlPn1dP1w6jHpgwie4I7ohnNTo8AI524Jg4OZAHgq6u0pm28yRgn
         U4OiOCDuSbWv5188sjuR/9j/Ph/NGwi3kkP3SkEohPNmnb5uZtGsuGClPmT3XZJRH4PP
         KduQ==
In-Reply-To: <50811903.9000105@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, devel@openvz.org, linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Fri, 19 Oct 2012, Glauber Costa wrote:

> >>> Do we actually need to test PF_KTHREAD when current->mm == NULL? 
> >>> Perhaps because of aio threads whcih temporarily adopt a userspace mm?
> >>
> >> I believe so. I remember I discussed this in the past with David
> >> Rientjes and he advised me to test for both.
> >>
> > 
> > PF_KTHREAD can do use_mm() to assume an ->mm but hopefully they aren't 
> > allocating slab while doing so.  Have you considered actually charging 
> > current->mm->owner for that memory, though, since the kthread will have 
> > freed the memory before unuse_mm() or otherwise have charged it on behalf 
> > of a user process, i.e. only exempting PF_KTHREAD?
> > 
> I always charge current->mm->owner.
> 

Yeah, I'm asking have you considered charging current->mm->owner for the 
memory when a kthread (current) assumes the mm of a user process via 
use_mm()?  It may free the memory before calling unuse_mm(), but it's also 
allocating the memory on behalf of a user so this exemption might be 
dangerous if use_mm() becomes more popular.  I don't think there's 
anything that prevents that charge, I'm just wondering if you considered 
doing it even for kthreads with an mm.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
