From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: first step towards hierarchical controller
Date: Wed, 27 Jun 2012 09:58:41 -0700
Message-ID: <20120627165841.GH15811@google.com>
References: <1340725634-9017-1-git-send-email-glommer@parallels.com>
 <1340725634-9017-3-git-send-email-glommer@parallels.com>
 <20120626180451.GP3869@google.com>
 <20120626220809.GA4653@tiehlicka.suse.cz>
 <20120626221452.GA15811@google.com>
 <4FEAC9CB.2010800@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=WAGOVGd+ppfMT4sfRyb+Hh+UjrNnAJi+j32++o1rIyY=;
        b=joXgKC4ustL6fVWhadHcvvK2TZQMfYAAC4cIvODu6qiQtKjxaemcBiIZHa9LRTA3RY
         xJnPE05heN+MLv+nAZ9ywnK+HX5R2Z5kPVl9G2SBBYr5aBVJWIY+fakwIBK2wEUU7Uy+
         VJgc0nifk6oqtwKoiLyEjL0498XqT+Cwbd1rke0U31r6dJsWeR0AoHOMV1pYpqFydbRR
         EGVOF9w7ZC/wCnoj8c/Q5+5/RblizfEafoQd4TcbQ2+HrPumBfKx9n+VkYRJSIfJ9GIt
         krUk7zXlk3wNtoWsYXQcVQfHbVgUXL/aRePgYKXODwmJl2KVb8GeeiohN2WJT2vlvYU8
         uUWw==
Content-Disposition: inline
In-Reply-To: <4FEAC9CB.2010800-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Glauber.

On Wed, Jun 27, 2012 at 12:52:27PM +0400, Glauber Costa wrote:
> >Just disallow clearing .use_hierarchy if it was mounted with the
> >option?  We can later either make the file RO 1 for compatibility's
> >sake or remove it.
> 
> How will it buy us anything, if it is clear by default??

With the mount option specified, why would it be clear by default?

> The problem is that we may differ in what means "default behavior".
> 
> It is very clear in a system call, API, or any documented feature.
> We never made the guarantee, *ever*, that non-hierarchical might be
> the default.
> 
> I understand that users may have grown accustomed to it. But users
> grow accustomed to bugs as well! Bugs change behaviors. In fact, in
> hardware emulation - where it matters, because it is harder to
> change it - we have emulator people actually emulating bugs -
> because that is what software expects.
> 
> Is this reason for us to keep bugs around, because people grew
> accustomed to it? Hell no. Well, it might be: If we have a proven
> user base that is big and solid on top of that, it may be fair to
> say: "Well, this is unfortunate, but this is how it plays".

You're just playing with semantics now.  Hey, who guarantees anything?
I don't find anything inscribed in stone or with hundred goverment
stamps which legally forbids me from "rm -rf"ing the whole cgroup.

Gees...  If we've shipped kernel versions with certain major behavior
for years, that frigging is the guarantee we've been making to the
userland.

Of course, nothing is absolute and everything is subject to trade off,
but, come on, we're talking about major SILENT behavior switch.  No,
nobody gets away with that.

-- 
tejun
