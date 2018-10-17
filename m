From: Tejun Heo <tj@kernel.org>
Subject: Re: Cgroup v2 thread mode oddity: "domain invalid" cgroup with
 threaded controller enabled
Date: Wed, 17 Oct 2018 09:19:58 -0700
Message-ID: <20181017161958.GT270328@devbig004.ftw2.facebook.com>
References: <a4912516-8c6b-d8d3-b714-5c03bcfc5e91@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tASjEjfws3/XHl7yNeAIkgDk0U2NJ7AFE81cCChSL6E=;
        b=Y5FBr9V5kqJXG6zjHU7WZnmah4mhzBAjmOjq4fBTz40SQLAArQNoX8ddthirR5Szw+
         K/9RHEEx7wjVKNIovY3EyMwGiMn4t5r7aog9pAUShzYCVJljSIPHmYbhf/a7+3oU/r8i
         3HcYH/H2DLOBUy8uNcPqJXDgRWRc9CgOQq4b6JMV9K2CEiyJ4vzmU8lV0J6YvLCKlxom
         ZV3pOqbUe81cYw7K8rLEV4SDcNCs82mGhNCrrGZqAfUJW6XzO1gT9dT/oXyfRyT2aFDY
         6aPaSED7mtXLMfbEiPl+Nknsdp9WxxcKiVV6/p8LyKroJzdasbOWjViybDoT2kwfdVBz
         RkjQ==
Content-Disposition: inline
In-Reply-To: <a4912516-8c6b-d8d3-b714-5c03bcfc5e91@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, lkml <linux-kernel@vger.kernel.org>

Hello, Michael.

Sorry about the delay.

On Thu, Oct 04, 2018 at 09:40:57PM +0200, Michael Kerrisk (man-pages) wrote:
> This seems odd. x/y is now of "domain invalid" type with a controller
> enabled! This feels like a violation of the rules, since we can't
> in other circumstances do anything with a "domain invalid" cgroup
> except convert it to "threaded". In particular, we can't create
> child cgroups under a "domain invalid" cgroup, or add member processes
> to the cgroup, or *enable controllers in the cgroup*. In fact, when
> doing the 
> 
>     # echo threaded > x/z/cgroup.type
> 
> I had expected a write(2) error because the state of x/y should
> (I thought) not be permitted.

So, both the interim (before turning x/z into threaded) and final
(after) are completely fine - the cgroups are empty and whether
threaded controllers like pids are enabled or not don't really change
things that much.

Maybe it is a bit inconsistent to then deny enabling threaded
controllers on invalid domain cgroups.  We can lift that restriction
but I personally can't see why that'd be clearly better.

Thanks.

-- 
tejun
