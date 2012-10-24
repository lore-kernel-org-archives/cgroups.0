From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/7] cgroup_freezer: don't stall transition to FROZEN for
	PF_NOFREEZE or PF_FREEZER_SKIP tasks
Date: Wed, 24 Oct 2012 15:06:51 -0400
Message-ID: <20121024190651.GC12182@atj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
	<1350426526-14254-5-git-send-email-tj@kernel.org>
	<20121022183453.GA24687@redhat.com>
	<20121022211822.GF5951@atj.dyndns.org>
	<20121023155533.GC16201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=HffANWoRCEuwvJ/4UtmPrwHJWQTwIGEJ4Ey1X+IWgbY=;
	b=esQaWI3e8mleQJRtlTKZPFoXS8XE+21n6+enPUWCJHaxXFd2/KBZX/VzFcOc4Nup8z
	sWpc7Zp/ismbV+loKpPgVJZtMHWgwYoUVqVnYZzUNSDGIymZGsZ9jwJaW4vfcRpUpn5+
	F804yh8/dCWDayX3gzrBe/0vsXJzK+hr2p7ZUcr5nkVUpuNK6rinm6dHMlWj1E1FEHjy
	6QS9sPcgiOfhqDXnVAhR1V94v8i22herTKL/kkuvSW9dpnyG72ACKN5v/h15ZdK1OYKR
	VoA3mmzE6LFYFUrQ6FIa7Wk8xqC6E5BYQGrLZ9t8T249FMpSUBzuQvWoUy5g7xLBucf+
	3jHg==
Content-Disposition: inline
In-Reply-To: <20121023155533.GC16201-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Oleg.

On Tue, Oct 23, 2012 at 05:55:33PM +0200, Oleg Nesterov wrote:
> > Ooh, ouch, definitely.  We should clear that.  Can you please make a
> > patch?
> 
> Sure... but what do you think is better?
> 
> I'd prefer to simply clear PF_NOFREEZE (without set_freezable), but
> obviously this doesn't look exactly right from cgroup_freezer pov.

I don't think it matters all that much.  It's a pretty special case.
Maybe define PF_CLEAR_ON_EXEC_MASK or something and just include
PF_NOFREEZE in it?

Thanks.

--
tejun
