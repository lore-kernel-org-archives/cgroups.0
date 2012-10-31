From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] cgroup: kill
	cgroup_subsys->__DEPRECATED_clear_css_refs
Date: Wed, 31 Oct 2012 10:22:37 -0700
Message-ID: <20121031172237.GI2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
	<1351657365-25055-2-git-send-email-tj@kernel.org>
	<20121031143751.GA22809@dhcp22.suse.cz>
	<20121031164123.GD2945@htj.dyndns.org>
	<20121031164855.GI22809@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=l4fcSwXNQaVspnHUF9iy1Ha3N+iPYmR9rJq5yDVylIU=;
	b=zidFjjZlbppSKSoVwD9yoR17sgJoyhn6y8hftM+2g0elpzPxeMnc1ssyW7+J42G6PF
	bF+vf1Wvkx8kY9oqnm71mY84Qbn4G2p2Dfn4JKswldZcXgP/ghkhLxDuZl129aig7+wr
	3ZF2NRtO22T+rzI9JkS0zpjjYAFYqlmkQxu48ETLr7LNiZ1K0kZQwzSkbImY64CZzuMJ
	0ZmOlP7go+MzYFi5A+R6tJvea0g27YS8JRWruFBctwMlLP/TfAmHWrPhMlPRn8ATmslB
	XuvXly2Nv0WqrM11en8pTKF83KPqAbmnqcW7pMZ7Bxh2A7+h4R0whhvBBSwTu8jp2ELL
	2cPA==
Content-Disposition: inline
In-Reply-To: <20121031164855.GI22809-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hey, Michal.

On Wed, Oct 31, 2012 at 05:48:55PM +0100, Michal Hocko wrote:
> > The WARN_ON_ONCE() is just moved from the original
> > cgroup_call_pre_destroy().  We can add an error out there but that
> > makes future changes difficult.  It's a chicken and egg problem.  You
> > gotta break the loop somewhere.
> 
> I do not think this is that hard. You can simply change the return path
> on pre_destroy error by BUG_ON in "cgroup: deactivate CSS's and mark
> cgroup dead before invoking ->pre_destroy()". There is no chicke&egg
> problem here because once the group is marked dead and css frozen then
> the existing callbacks cannot possibly fail.
> Or am I missing your point?

I want to be able to move code verbatim in the later patch when
relocating ->pre_destroy() invocations.  Hmmm... alright, I'll make it
break out of pre_destroy() here and change it to WARN_ON_ONCE() later
on.

Thanks.

-- 
tejun
