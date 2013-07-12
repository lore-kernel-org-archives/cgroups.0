From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: fix and clean up cgroup file creations and
 removals
Date: Fri, 12 Jul 2013 00:45:49 -0700
Message-ID: <20130712074549.GA19480@mtj.dyndns.org>
References: <1372463145-4245-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xLeK64q0Z/D+pAElDmLwL5Vl1+jbiuFXjn8JIYD0CBs=;
        b=gck2lftQ+uLUOaSjYupPbJ4pdw6g8+bLExiULiTryzyy6NMvFJ2smH/mIwK2gFE3md
         q0ibiCTIzo0jfTTpfcH9lznCCwbvYiRRmCO+iBe2aYwUWRw6J/3rdpxCLmT0WzMitaLi
         nztV+J4Wg1owl3UJpq4+F93+ti6WDgOm6PsFTZSVoxWmrVK1webJnVJDutRSm29a9haD
         aNmWgVB9VJL65Hzkb518gTdgTz6e3s6eYQYexZnZEbAc7K2jJMwPcwnNOBiNWpaqjYou
         YlNq227RbOQOZ9J7l9DM/Mo2oalbr1ju241VaS9RJSsL9FV1lH/eIPxkBTrGaTGPMA/v
         rdQA==
Content-Disposition: inline
In-Reply-To: <1372463145-4245-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 28, 2013 at 04:45:36PM -0700, Tejun Heo wrote:
> cgroup has been pretty lax about errors while creating cgroupfs files.
> In most cases, it just ignores the errors and continues - cgroups
> created or subsystems bound under heavy memory pressure could be
> missing some files.  As such low memory conditions aren't too
> frequent, this hasn't caused a lot of problems but this is lousy and
> we'll be creating and removing cgroupfs files a lot more dynamically
> with unified hierarchy.  Let's get it in proper shape.

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
