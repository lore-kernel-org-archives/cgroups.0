From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [EXTERNAL] Re: Split process across multiple schedulers?
Date: Wed, 16 Mar 2022 07:32:32 -1000
Message-ID: <YjIfMLG5W2a/E4vX@slm.duckdns.org>
References: <b5039be462e8492085b6638df2a761ca@saabgroup.com>
 <YjIShE3mwRyNbO53@slm.duckdns.org>
 <e9cac4aba6384c5c91125a9f7d61a4e8@saabgroup.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gPiP2TEj1iJh+74qfIuMhil4PD7R84NUaohWqsH6kSA=;
        b=i0C6IyVxhui172CDcTzYtyC8+1jj4hUP1Z7WUT42kUCKeZ0sdQKeUgP2kAKqMqdDnY
         Zt9SOENS6uK7ACzOJyyXX0HxwyNOrXx2bdI0rsWLy+ae0f/dwhIax2fDr64Uljrx9WK6
         SAC26tzU6ppoXy7OvzA4SzdgE2hPUWKu3keayE5D6XG84/AFZiZ6svjQkUFNT3LKLce4
         4f4IJ+066LXeXk6wY+r36MMP0//Q9lZxbJVdl9W3PCcB8K2B50m0PeTiApom3wDonDrq
         j0CCxYELS7/d5VoefJuULsI7vCeHYTHiJCat8fw5kK/W4z2VArB2+kDqF+q0aZAsp2xm
         y7JA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e9cac4aba6384c5c91125a9f7d61a4e8-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Wed, Mar 16, 2022 at 04:49:29PM +0000, Olsson John wrote:
> By using cgroup you can delegate the authority to configure a subset
> of the hierarchy via rwx and user, group, others. By using the
> per-task interface you have to be root, right?

Yeah, deligation can be useful. However, given that the configuration would
need some automation / scripting anyway, it shouldn't be too difficult to
work around.

> Also, we want to separate the configuration of the threads from the
> application as it need to be deployed in different hardware scenarios.

The thing is, to put different threads of a process into different cgroups,
one has to know which threads are doing what, which is the same knowledge
needed to configure per-thread attributes.

> And we need to be able to easily replicate a configuration from one
> machine to another machine.

Again, I'm not sure how needing to put different threads into different
cgroups is much different.

> We also need to configure other aspects that cgroup allows us to do
> for the set of processes.

This one, I agree. There are controller features which aren't available
through regular thread interface such as bandwidth throttling.

> Since cgroup solves all of the above problems for us, why using
> something else? :)

Yeah, mostly curious from cgroup design POV. It'd be nice to support use
cases like this well but we likely don't wanna twist anything for it.

Thanks.

-- 
tejun
