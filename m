From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Thu, 21 Sep 2017 01:30:45 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709210128020.10026@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com> <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz> <20170913215607.GA19259@castle> <20170914134014.wqemev2kgychv7m5@dhcp22.suse.cz> <20170914160548.GA30441@castle>
 <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz> <20170915152301.GA29379@castle> <alpine.DEB.2.10.1709151249290.76069@chino.kir.corp.google.com> <20170915210807.GA5238@castle> <20170918062045.kcfsboxvfmlg2wjo@dhcp22.suse.cz>
 <20170918150254.GA24257@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=JGk+MDIGujVkTrUDxB03ebx/nVZJwIKnG1LPx/Zc5kY=;
        b=NGbdxqkjcR5bXIkG6EeMPUxXvmo/2qLxpiayRue5WT32KrZjie2N45SY6MpmXFI99a
         id85dQnCpQPcNei9kS1TRJcJUnIxW/0SVyxN7qFhjuvOJYob4ADElkmHIcDalRD3K0f/
         Ka2teQQycBjKs1xtKxnDiJkS95E52D2ReZOjU/pms7ljJXgB30B/HTdAofBfX7o0uWYk
         tU/cw2FC75vRZoigmWBN6E35u1HZrTg9HLs4pkSPL8BW0FA3FELx7nIdyP7ZTfnOgBlq
         8hDMwu4jgFJUHSwPUASoDDEQDeBuvwxTGQDh/NCSkZEYgsamMnY7VfkU0LHT2LyGpCNe
         x1Yw==
In-Reply-To: <20170918150254.GA24257@castle.DHCP.thefacebook.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 18 Sep 2017, Roman Gushchin wrote:

> > As said in other email. We can make priorities hierarchical (in the same
> > sense as hard limit or others) so that children cannot override their
> > parent.
> 
> You mean they can set the knob to any value, but parent's value is enforced,
> if it's greater than child's value?
> 
> If so, this sounds logical to me. Then we have size-based comparison and
> priority-based comparison with similar rules, and all use cases are covered.
> 
> Ok, can we stick with this design?
> Then I'll return oom_priorities in place, and post a (hopefully) final version.
> 

I just want to make sure that we are going with your original 
implementation here: that oom_priority is only effective for compare 
sibling memory cgroups and nothing beyond that.  The value alone has no 
relationship to any ancestor.  We can't set oom_priority based on the 
priorities of any other memory cgroups other than our own siblings because 
we have no control over how those change.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
