From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: legacy mode
Date: Thu, 27 Aug 2015 16:48:25 -0400
Message-ID: <20150827204825.GI26785@mtj.duckdns.org>
References: <20150827202137.GA4221@mail.hallyn.com>
 <20150827202722.GH26785@mtj.duckdns.org>
 <20150827204500.GA4447@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=yoLf1oSxJGMWsyL28mUjqDMJoAxw0UyZ9Pjxla1W+iY=;
        b=mZ92+JWPxn6zF4RTBAQHATTUA++MUbSWiU1IdT1KTZUol4/dfTiay0+p1tse0fGNq4
         GjnDIozHzkusgPjiwdgYFw7kfBsAEp/7usOB77igMPIa9XrxCp9PK7njDydC0lz8Lba6
         LqGV9PKrn6OpENR1/5DF7n0+2i1jflL7w4lfmGcrL927w26/6pF119NSwptunMOl1f+O
         5+dEw5pjqeQWV51Ek6YjX9u2WfqPCQC1Q8y3ShVSbVa+C6GzYy3Xa2525+04j6zHDcIM
         colc6TDwDESvZuDAYi3ZOrQToj8egh3Qj31xPyJfydhofun0XXYyCWc0Q0L8ZOhNesp2
         xwNw==
Content-Disposition: inline
In-Reply-To: <20150827204500.GA4447-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Serge.

On Thu, Aug 27, 2015 at 03:45:00PM -0500, Serge E. Hallyn wrote:
> > If the legacy userspace doesn't do any resource control, the leaf rule
> > restriction doesn't apply anyway, so nothing to worry about.
> 
> My main use case is nested lxc, presumably with systemd inside some of
> the nested containers, so this would definately be an issue.

W/o controllers in the nested environment, it should be fine.  W/
controllers, I don't think this is going to fly.  I don't think trying
to bridge the two versions is a healthy direction in the long term.

Thanks.

-- 
tejun
