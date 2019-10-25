From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 5/8] mm: vmscan: replace shrink_node() loop with a retry
 jump
Date: Fri, 25 Oct 2019 09:44:43 -0400
Message-ID: <20191025134443.GA385668@cmpxchg.org>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-6-hannes@cmpxchg.org>
 <20191023141857.GF17610@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GB66w5zMnO6g29s6wAcFRJIvcQvj59wk11SwJfYrvKA=;
        b=Qq1IRmOU8QQXXK5dP7qVkmSaMc2yq7Rpi0+jYuWk5ryK9uF4E/5Q5RAo6IRi5rQpYO
         MijLDpKbtbCl53iC6+V6cSZa6ckR+CG9NvnGZp30+L7k1AHj4QImzgeXM8RnK6zDGsxq
         bVKbAvbgwnymLXAiH9nIW3DslByuA/r3z+vVz91vWhYVOQeXG4OoYJsj+3h4TlAZKdJD
         jZjGj8QlSuEFEGqmfb6p9Jd2kqOSjwRtjpebArzGY1EAP86Y2gQqvnJ3LHir/ZHbMuIJ
         ZLFAs2oRcdHHpbtABfKICAgOeJspOrdnp/ZB5wjPI65JZEcHb1rljP+Du8ppywyo5RBY
         OAWQ==
Content-Disposition: inline
In-Reply-To: <20191023141857.GF17610@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Oct 23, 2019 at 04:18:57PM +0200, Michal Hocko wrote:
> On Tue 22-10-19 10:48:00, Johannes Weiner wrote:
> > Most of the function body is inside a loop, which imposes an
> > additional indentation and scoping level that makes the code a bit
> > hard to follow and modify.
> 
> I do agree!
> 
> > The looping only happens in case of reclaim-compaction, which isn't
> > the common case. So rather than adding yet another function level to
> > the reclaim path and have every reclaim invocation go through a level
> > that only exists for one specific cornercase, use a retry goto.
> 
> I would just keep the core logic in its own function and do the loop
> around it rather than a goto retry. This is certainly a matter of taste
> but I like a loop with an explicit condition much more than a if with
> goto.

Yeah, as the changelog says, I'm intentionally putting the looping
construct into the "cold path" of the code flow: we only loops in a
very specific cornercase, and having the whole body in a loop, or
creating another function nesting level for it suggests otherwise.

A goto seems like the perfect tool to have a retry for one particular
caller without muddying the code flow for the common call stack.

Matter of taste, I guess.
