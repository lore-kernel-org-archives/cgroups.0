From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroups: remove calls to simple_kstrtoll
Date: Sun, 27 Oct 2013 07:39:25 -0400
Message-ID: <20131027113925.GF14934@mtj.dyndns.org>
References: <1382754793-8827-3-git-send-email-dwalker@fifo99.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VxL44EIMeX8sVQx4rlUoXt6UrQ4RC63x68Ev/wRJxII=;
        b=0MU2KA5Lz6v6lOubviCIGLMoSKJmNTJJRsG3OFJtfVUvve28l5cTVoAlvlGjqq87YY
         shD8jZ70QR7XM7FL/XH/Pn2Sc13q9cugpU3hywDNI4/L7V77oM19kkCwFMv22pPGI9NL
         sEISSGsWME4MHjmOOGfoo3lgKhlgPzvvqdukeKcWOiWJWUz+TEWt2gYNQu8XoHWMCSWf
         HoEy1QBsDoWwRKGEYZEw63qDKqQs71yAl/tPxOH3JWy2LEQSmfD8oQ8A2hdH4QVAq13M
         w4HhqNj+Ff5hDY53MejA7Dhxjm8ARQ+msadGxU7q4yeZ9TM3QtoBizfZ0nj/VZyfqB7U
         Js4g==
Content-Disposition: inline
In-Reply-To: <1382754793-8827-3-git-send-email-dwalker-zu3NM2574RrQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Walker <dwalker-zu3NM2574RrQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Oct 25, 2013 at 07:33:13PM -0700, Daniel Walker wrote:
> Signed-off-by: Daniel Walker <dwalker-zu3NM2574RrQT0dZR+AlfA@public.gmane.org>

Can you please briefly explain why this conversion is happening in the
patch description?

Thanks.

-- 
tejun
