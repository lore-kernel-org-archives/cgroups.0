From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2] cpuset: Add knob to make allowed masks hotplug
 invariant on legacy hierarchy
Date: Wed, 15 Apr 2015 11:48:02 -0400
Message-ID: <20150415154802.GB30337@htj.duckdns.org>
References: <20150410141118.11284.36206.stgit@preeti.in.ibm.com>
 <20150411083537.GR27490@worktop.programming.kicks-ass.net>
 <20150413070117.GX24151@twins.programming.kicks-ass.net>
 <552BB3A5.9060905@linux.vnet.ibm.com>
 <20150413144311.GF5029@twins.programming.kicks-ass.net>
 <552E4E41.3030008@linux.vnet.ibm.com>
 <20150415150302.GA25089@mail.hallyn.com>
 <20150415151926.GS23123@twins.programming.kicks-ass.net>
 <20150415153035.GA25390@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vpvDncohx2vUaufuhPe0I6iZgwOtbpdr2JQ37WCDECo=;
        b=DaOyKtC5OQ8Wg3aAdB8Y7RfhUa+kAskqO7I7ej557fOrSqKw4J+h5vgoQUWdSVH2qT
         VQkxlP8R3nndEZtXNBfWvBfrBsSq+58Au9nryU0G6QnmJ+QgYPLsx+MBFUJQf40XJW/z
         7ZyR9oz+fJTUeElNBmwTW6pWrrhq40M7DPH1gXmzA7093XZuAypHtoTSPksL16FNEoge
         DvpMZr55TpPSikp7pA9VV0ck6KGE2P6BxaA9iaZ0bc7zE4OovzT3BhMDOuOp6zhvj2+3
         aFsuR+mPHDWMlR6wEhUwYlzagJwA1bvNRWa/r1Ee0ND47FaMr1SvpC1pQl35+XTpMZOL
         1AXg==
Content-Disposition: inline
In-Reply-To: <20150415153035.GA25390-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Wed, Apr 15, 2015 at 10:30:35AM -0500, Serge E. Hallyn wrote:
> On Wed, Apr 15, 2015 at 05:19:26PM +0200, Peter Zijlstra wrote:
> > On Wed, Apr 15, 2015 at 10:03:02AM -0500, Serge E. Hallyn wrote:
> > 
> > > Peter, is the question "why can't we just use the unified hierarchy for
> > > cpusets"?
> > 
> > No, the question is why can't you use the unified hierarchy cpuset
> > semantics -- without the actual unified hierarchy stuff.
> 
> Ok - that I don't know the answer to.  Does sound like it would
> simplify things, reduce # of sets of semantics.

What'd be the reason for not using the unified hierarchy tho?  The
adaptable required isn't that big and the patchset already proposes
significant amount of behavior change.  Sure it'd be a bit more hassle
but does that really justify introducing yet another operation mode?
This is why unified hierarchy is being added in the first place.  One
can argue "but *I* just need this specific part changed" but allowing
combinations of all those little variations is gonna lead us to a
hellish place.

Thanks.

-- 
tejun
