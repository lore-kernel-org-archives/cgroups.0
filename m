From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/9] cgroup_freezer: make freezer->state mask of flags
Date: Thu, 8 Nov 2012 06:39:52 -0800
Message-ID: <20121108143952.GD12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
	<1351931915-1701-7-git-send-email-tj@kernel.org>
	<20121108103928.GD31821@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=SrL+qE0AbDTF1t3T1lfWRYZ2QxRb3kee9WA7JehDFHw=;
	b=1BRv74wamV/O6q98JLfYn0FpqgXWxbVUh6A9aq7qk8Q0oLuT7K0YAbtKNT9rX6aD0U
	Yl7LszDKCVxJ8MCIT15mYf0xFp4PjNAKlVW3xmmsjcwqRmWLtHF2BchjhExd65ThpvnI
	NXy0aD70BXrfHPlO5PVqesE86lSlechk73oPNcXG1o2EngLJv8Rp5Z7p+YYE2qyvqo0x
	Nsvj+ydoUIJoCd7qus9uht4SIzXfFXKjA5bPrChV5fjFmqQsdX45gdEDBejve+Q2EPB0
	EjUxgz8dos5bfqC/9Q/zRjTy3kKC3VUmrgbTF1UEyD8cZasJr4fiXuBPt5pmsXQF5bK2
	cqWg==
Content-Disposition: inline
In-Reply-To: <20121108103928.GD31821-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
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
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Michal.

On Thu, Nov 08, 2012 at 11:39:28AM +0100, Michal Hocko wrote:
> On Sat 03-11-12 01:38:32, Tejun Heo wrote:
> > freezer->state was an enum value - one of THAWED, FREEZING and FROZEN.
> > As the scheduled full hierarchy support requires more than one
> > freezing condition, switch it to mask of flags.  If FREEZING is not
> > set, it's thawed.  FREEZING is set if freezing or frozen.  If frozen,
> > both FREEZING and FROZEN are set.  Now that tasks can be attached to
> > an already frozen cgroup, this also makes freezing condition checks
> > more natural.
> > 
> > This patch doesn't introduce any behavior change.
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> I think it would be nicer to use freezer_state_flags enum rather than
> unsigned int for the state. I would even expect gcc to complain about
> that but it looks like -fstrict-enums is c++ specific (so long enum
> safety).

But if you use it as flag bits, the resulting value no longer is
inside the defined enum values.  Isn't that weird?

Thanks.

-- 
tejun
