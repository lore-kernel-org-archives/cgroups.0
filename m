From: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 05 Sep 2012 12:20:53 +0200
Message-ID: <1346840453.2461.6.camel@laptop>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
	 <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
	 <5047074D.1030104@parallels.com>
	 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
	 <50470A87.1040701@parallels.com>
	 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
	 <50470EBF.9070109@parallels.com>
	 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
	 <1346835993.2600.9.camel@twins>
	 <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>
	 <50471782.6060800@parallels.com> <1346837209.2600.14.camel@twins>
	 <50471C0C.7050600@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50471C0C.7050600-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org

On Wed, 2012-09-05 at 13:31 +0400, Glauber Costa wrote:
> 
> You wouldn't have to do more than one hierarchy walks for that. What
> Tejun seems to want, is the ability to not have a particular controller
> at some point in the tree. But if they exist, they are always together. 

Right, but the accounting is very much tied to the control structures, I
suppose we could change that, but my jet-leg addled brain isn't seeing
anything particularly nice atm.

But I don't really see the point though, this kind of interface would
only ever work for the non-controlling and controlling controller
combination (confused yet ;-), and I don't think we have many of those.

I would really rather see a simplification of the entire cgroup
interface space as opposed to making it more complex. And adding this
subtree 'feature' only makes it more complex.
