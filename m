From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: Make cpuset hotplug synchronous
Date: Wed, 12 Feb 2020 17:14:27 -0500
Message-ID: <20200212221427.GK80993@mtj.thefacebook.com>
References: <1579878449-10164-1-git-send-email-prsood@codeaurora.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5wn2A1jq0XAt6mjZPfnCGuSlCgwymyCtNgjaq2MIIL0=;
        b=HxEDbSsr9BgQr15mCFJj3TWx3sPLSUD5N0qYHcOx8MwhQiP8y3Tk9tBhxRFMFAYY81
         hJSaxoCfVkUEYhuG6xPSj2HdgdvdQY7DBc3EBu0eP0Fvc7Ecv4/6RPLUqQUlMekefnnY
         1sK5x721YdF2+BxwX/kHdJrC6z4VFFECqzlEubpnCEVRrcIfvskSDtn4JHPwOyC1SdBv
         opFqzlqR0GqYEDFVbmCbWasZErcV1JHRWnaAzu97nTJ0JY10CfXNed1I7VoBTJgV8Idw
         WPzxiITJLJgL6k6pD4TmeGWYbAfK54WeGZ7hJtYoNiRLf/YRw6uLL6hsA2C8JIsOt2IE
         PYGg==
Content-Disposition: inline
In-Reply-To: <1579878449-10164-1-git-send-email-prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 24, 2020 at 08:37:29PM +0530, Prateek Sood wrote:
> Convert cpuset_hotplug_workfn() into synchronous call for cpu hotplug
> path. For memory hotplug path it still gets queued as a work item.
> 
> Since cpuset_hotplug_workfn() can be made synchronous for cpu hotplug
> path, it is not required to wait for cpuset hotplug while thawing
> processes.
> 
> Signed-off-by: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

Applied to cgroup/for-5.7.

Thanks.

-- 
tejun
