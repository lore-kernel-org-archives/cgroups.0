From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 05/17] cgroup: cgroup->dentry isn't a RCU pointer
Date: Wed, 14 Nov 2012 11:01:52 -0800
Message-ID: <20121114190152.GH21185@mtj.dyndns.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
	<1352775704-9023-6-git-send-email-tj@kernel.org>
	<50A37B0A.7010608@parallels.com>
	<20121114185504.GG21185@mtj.dyndns.org>
	<50A45ABB.3040507@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=ARl15E5LktcI/eAF2xR4nkb3cQA+s1rFj4Fh+S3cm1M=;
	b=h/hbHynq8EDmLT1SRnN6LtcqqB/DdHsFsuR1xtPDs9Jksf6255QkwA5cJ8wJ7J6OKe
	+98dWnZeR2i3pUOBMLCi5A9WfuUy2sAAHZDHyIBQGxR2MN1NDvAi+itrvl2C8EC9A/Mk
	jBalxpUkAu0aJfJsaHhEZtLgjmorITHDSxYS7jM+z3rpW3mYTND96vgJF1TKKrr8QilR
	ylkAbgh+Ij2/2TiLQ7cM+0HIS9atKcFPi4gMYUTFTVATUWclUZKDBcBvd+6CawuGHP1T
	PHcu1l92NHHDypL4pm10HLGF4w6xCkMIPaN/97Ygae2/fPNi4VBOD/A7F+mJ5l6ENBpg
	6t3w==
Content-Disposition: inline
In-Reply-To: <50A45ABB.3040507-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
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
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Glauber.

On Thu, Nov 15, 2012 at 07:00:11AM +0400, Glauber Costa wrote:
> > Ooh, yeah, hmmm... that should happen after this series gets merged.
> > I'll mark it as pending.
> > 
> Btw: I did this because there is no other facility to figure out a
> memcg's "name".
> 
> I wonder if there is anyone else using this, so we could just abstract
> that in cgroup.c?

We have cgroup_path() after all, so I don't think it's crazy to have
cgroup_name().  Please feel free to add.

Thanks.

-- 
tejun
