From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v10 3/4] cgroups: allow a cgroup subsystem to reject a
 fork
Date: Thu, 14 May 2015 11:08:28 -0400
Message-ID: <20150514150828.GG11388@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-4-git-send-email-cyphar@cyphar.com>
 <20150422155445.GD10738@htj.duckdns.org>
 <CAOviyajt2MSG_N6VOOXwAM8YZ0ReCvgXyyvaj2yPYK2dztv8EA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RTkOj7Oo+bIwvoNbuRDhN6pv1B1ApaOahZMOB7tiNG0=;
        b=Gd9BbmKQcqn7E3Nk+jeSiG8vs+oiQt+1ZsyQtLivk+RaJZrf8VZvz8sM84cI699l3n
         heskJ1+pmTda/fsLUXk6AaKorNYBhex+Nbejvnn1eRZcFBNeFJr6uy6bHETvLpzxRhqW
         WMPjb1/yPAvvCyB6To+O1mkegDfqaz+OlkLgoUfsw+lnmr3jJpE7Ky8NdBWhA7KvBX26
         /17VzDHeQ9J65uDiP0H3KwGog1x+Xpw+Il7/OP+CnEivlvUKUerxpu+M/EAYUCEDw8Pz
         TBAVT6n3CLubpgVdRRO3rv7rnUIEhEBvTgfkfmGCzaWHfcE70T0BMjrEanErTGJeDAvq
         BmmQ==
Content-Disposition: inline
In-Reply-To: <CAOviyajt2MSG_N6VOOXwAM8YZ0ReCvgXyyvaj2yPYK2dztv8EA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>, richard@nod.at, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello, Aleksa.

On Thu, May 14, 2015 at 08:57:49PM +1000, Aleksa Sarai wrote:
> >> +/* Ditto for the can_fork/cancel_fork/reapply_fork callbacks. */
> >> +static int need_canfork_callback __read_mostly;
> >> +static int need_cancelfork_callback __read_mostly;
> >
> > And given that the reason we have these masks is avoiding iteration in
> > relatively hot paths.  Does cancelfork mask make sense?
> 
> Do you still want me to remove it? I only added it because it made the
> callback code more consistent for cancel_fork and can_fork.

This doesn't make much sense to me.  Why don't we have masks for other
callbacks then?  This way, we're breaking the consistency regarding
why the mask is used in the first place.

> > Maybe we want a helper callback which does
> >
> >         if (CGROUP_PREFORK_START <= ssid && ssid < CGROUP_PREFORK_END)
> >                 return &ss_state[ssid - CGROUP_PREFORK_START];
> >         return NULL;
> 
> What would be a nice name for it? I can't think of anything better
> than __get_ss_private() and __get_ss_privatep().

Do we need the double underscores?  subsys_prefork_priv()?

Thanks.

-- 
tejun
