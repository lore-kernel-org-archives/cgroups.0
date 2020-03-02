From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] cgroup-v1: freezer: optionally killable freezer
Date: Mon, 2 Mar 2020 08:53:30 -0800
Message-ID: <20200302165330.GA505299@carbon.DHCP.thefacebook.com>
References: <20200219183231.50985-1-balejs@google.com>
 <20200229005131.GB9813@google.com>
 <20200229184300.GA484762@carbon.DHCP.thefacebook.com>
 <20200301162003.GA186618@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=6GrNg9i1YqRPzEEyPjUgEb5cDEPYnvaI57FJcWEvnSw=;
 b=ZNgnTEB+gN/WxsS6aWcUaQ1DeaaVCAqYC1JJBRl0UrNpSVOo2OyOJt3pt0KToDulRZyx
 DS51tZBEFYMx1dC15nn7+Kz1ciKyAT1t9GlsvZDmudYX7H5IDqK3Jp8cexgedz4b4juJ
 MDkDgqpOo22kF/1euNB7CaC/14Z1s66CSD0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GrNg9i1YqRPzEEyPjUgEb5cDEPYnvaI57FJcWEvnSw=;
 b=lGZ+GZtdaGGXcII/1E3OcFE9XMze4bCJtlMv3IV2JXe+S6yruLKgSYBjY+wX7Vr0j/k7HxVXkXhRyJp4CV8l62kqs9qk4o1AA0wqTyJ3OiQmPU74lD6gwetk0L5JX2J/0jFofGgcbMoGMgR1itTaa3Z02/EkyKRjdTuSm/PotzQ=
Content-Disposition: inline
In-Reply-To: <20200301162003.GA186618-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marco Ballesio <balejs-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, minchan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Sun, Mar 01, 2020 at 08:20:03AM -0800, Marco Ballesio wrote:
> On Sat, Feb 29, 2020 at 10:43:00AM -0800, Roman Gushchin wrote:
> > On Fri, Feb 28, 2020 at 04:51:31PM -0800, Marco Ballesio wrote:
> > > Hi all,
> > > 
> > > did anyone have time to look into my proposal and, in case, are there
> > > any suggestions, ideas or comments about it?
> > 
> > Hello, Marco!
> > 
> > I'm sorry, somehow I missed the original letter.
> > 
> > In general the cgroup v1 interface is considered frozen. Are there any particular
> > reasons why you want to extend the v1 freezer rather than use the v2 version of it?
> > 
> > You don't even need to fully convert to cgroup v2 in order to do it, some v1
> > controllers can still be used.
> > 
> > Thanks!
> > 
> > Roman
> 
> Hi Roman,
> 
> When compared with backports of v2 features and their dependency chains, this
> patch would be easier to carry in Android common. The potential is to have
> killability for frozen processes on hw currently in use.

I see...

The implementation looks good to me, but I really not sure if adding new control files
to cgroup v1 is a good idea at this point. Are there any plans in the Android world
to move forward to cgroup v2? If not, why not?
If there are any specific issues/dependencies, let's discuss and resolve them.

Thanks!

Roman
