From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Thu, 6 Sep 2012 15:45:47 -0700
Message-ID: <CAOS58YM3cQB1ybAJ+cV9JKHbTvr5aRNDK1bJ_PgLNzk_P-3Wuw@mail.gmail.com>
References: <50470A87.1040701@parallels.com>
	<20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<50470EBF.9070109@parallels.com>
	<20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<1346835993.2600.9.camel@twins>
	<20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>
	<50471782.6060800@parallels.com>
	<1346837209.2600.14.camel@twins>
	<50471C0C.7050600@parallels.com>
	<1346840453.2461.6.camel@laptop>
	<20120906203839.GM29092@google.com>
	<50492617.8030609@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=6rNFIeD3lK6ZdrUbPEYj9C8BcynYTpJLnbTTMSl6eMc=;
        b=ViqwvjdOQLIqqdeXKXsOX0uvyM8h/kiv3z92yBFnGsi5Bddwqmjaj7uevHdGLlTWEr
         mPX3VZBLVvLLP64HGQUuaVdQA/1Ninf4MzN7/XHnBbqv8fx9tIvdoHiMxBB5L8+BFLN3
         XGU1nFPEubtmJk9Htp9HSJBaXhboTruSfuhB2JS3fZQPVTT+7m0dbbq7ebqinm/aOM09
         t/viuTiV1xnbMNmCc0ikejQhF6QeLPh6yrgJXyD7870dNCVR/wlWV1IRJRi681MMnfBE
         OQ38+4EO+D3SwXNkjjbNg2lNw5VL5y80LPKAULgpCEn6qhItohRo9fxJwYwbtu4P+RP7
         A+8w==
In-Reply-To: <50492617.8030609-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org

Hello, Glauber.

On Thu, Sep 6, 2012 at 3:39 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> Yes, please.
>
> While you rightfully claim that you explained it a couple of times, it
> all seems to be quite fuzzy. I don't blame it on you: the current state
> of the interface leads to this.

Heh, I drank two cups of coffee and two glasses of wine that evening.
Coffee won and I couldn't sleep till around 4am with splitting
headache. I'm not too confident about what I wrote that night. :)

> So another detailed explanation of what you envision at this point,
> considering the discussions we had in the previous days, would be really
> helpful,

Definitely, will do. Please give me a few days to sort through
immediately pending stuff.

Thanks.

-- 
tejun
