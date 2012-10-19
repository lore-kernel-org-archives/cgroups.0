From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration
 regardless of freezer state and update locking
Date: Fri, 19 Oct 2012 13:02:35 -0700
Message-ID: <20121019200235.GN13370@google.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <20121017191606.GA6223@us.ibm.com>
 <20121018211434.GI13370@google.com>
 <20121018222155.GB6223@us.ibm.com>
 <20121018223517.GQ13370@google.com>
 <20121018234726.GC6223@us.ibm.com>
 <20121019000153.GZ13370@google.com>
 <20121019012945.GD6223@us.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2/sQtcBkElsTzo1aEUSiAvpdLhZRWPn9f1Sq0d/jsFQ=;
        b=f319Y1bvT3OlQgDg2uX020zBpGMG/8d6vU/HltXQmhBQa8sixlUtLvrwbCJeLQWPmG
         gtczSQks64aPoseO8FIr0b0Cl4rUy6GQXNEskt2PhQ/6OQJ51glUE4jFXewaK/MTQ/ru
         5LPlIaUmlj0Cdqsa9IE+JvSzSDiDp4dq8eYM7VS18fzXayGU74XxvporXK5Jc48YvHfn
         0u8gQ9wY9NrsU7fb5CTp0CxjxlGaGsDFNyy51+xCmk3M9nEDsUXFfRz7bQ23sgpOzKqg
         N4pVEy5drNGSVyxr9dmaxVNqVUVcSfmDlJBSvp7vnW6sdhMh1bfc+cZwFe1RLy4ziaIR
         rLYg==
Content-Disposition: inline
In-Reply-To: <20121019012945.GD6223-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matt Helsley <matthltc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, Matt.

On Thu, Oct 18, 2012 at 06:29:45PM -0700, Matt Helsley wrote:
> Yeah, that would be a nice cleanup too. I guess the ultra-careful way to
> remove this feature would be something like:
> 
> 	Add an internal migration restriction (which may or may not be
> 		exported as a userspace interface in a subsequent
> 		patch).
> 
> 	Make the cgroup freezer use it.
> 
> 	Make the cgroup freezer WARN_ONCE() when the subsystem is first
> 		mounted. Indicates that the behavior is going to
> 		change.
> 
> 	... time passes ...
> 
> 	Remove the use of the migration "lock" from the cgroup freezer
> 		and the WARN_ONCE().
> 
> Which would also make the feature more obvious.

I don't think I'm gonna go that far for this.  I don't think we need
cgroup migration locking after all.

Thanks.

-- 
tejun
