From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup: status-quo and userland efforts
Date: Tue, 9 Apr 2013 12:46:40 -0700
Message-ID: <20130409194640.GK6186@mtj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
	<20130409095024.GI25576@redhat.com>
	<20130409193851.GJ6186@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=2H+M4T+JNxiNzohjtRCzkZhqOzJ8JDaCUjSAZnFAgwA=;
	b=DgIwQQwgsCwPMvQ/NWYPHRWaF86NyS3WdcbNDWUmsqKPMeHvDf6vMO/q2PUV48rh0X
	6R9/CBmTDn8Cc1C0GmJUiLSMpNG4nLQom5xeVW+4VGsJPMvE+pV6hrIWSnbUm08zOhSQ
	8fy6F2aXRQ3WCElg2pqv2nZfYK6yRmkaEO+SYCERohynHZRRryXLIkpHHCCLME7rwx38
	g4Izwy+HRG/lX/DNTa3SGQKkb3hH4O5+F0MCDj2eqvCeJ/sOiTYe/4r8pkEsQ6CN7pdn
	ps+4BrmyOE7WkJt8m/7ekJ011N2KZ6NIDJxw3H6AGoHc72nvM32B+fmA/bZNiqqX8lK0
	c1Zg==
Content-Disposition: inline
In-Reply-To: <20130409193851.GJ6186-9pTldWuhBndy/B6EtB590w@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

A bit of addition.

On Tue, Apr 09, 2013 at 12:38:51PM -0700, Tejun Heo wrote:
> > We need to make the distribute approach work in order to support
> > containers, which requiring them to have a back-channel open to
> > the host userspace. If we can do that, then we've solved the problem

Why is back-channel such a bad thing?  Even fully virtualized
environments do special things to communicate with the host (the whole
stack of virt drivers).  It is sub-optimal and pointless to make
everything completely transparent.  There's nothing wrong with the
basesystem knowing that they're inside a container or a virtualized
environment, so I don't understand why a back-channel is such a big
problem.

Thanks.

-- 
tejun
