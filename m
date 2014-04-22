From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] cgroup: introduce helper css_to_id()
Date: Tue, 22 Apr 2014 16:31:26 -0400
Message-ID: <20140422203126.GD2314@mtj.dyndns.org>
References: <cover.1398147734.git.nasa4836@gmail.com>
	<0414ce4418a6f0dd481586ce4059b97800bcc1ca.1398147734.git.nasa4836@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=EQwqh1nf52GkBzGCBHClkAEwHfJqYkKxKdPqhs36Cmg=;
	b=lhk5zonRz8frsn/A96hnEQ6QbRAejhYaO2+KWPfmvPkYtF9A03465pa2izMPk6wgsZ
	E+BXLMtU7zfkvVGjWhgbRXO1y3xSqAYhSNDrqbt6GF8tsIFG5EkSl8TNEqZ6ru4XcKnO
	0xrRZKWO/fGdbU0ennB39YokwOJDIh/dSWHup7IIi9djoBr5rEeKBceTKnCgMSOlJ0Oh
	3fc6TZ6X0tEROUAr0MnzlY2T0uK6ULnzozJm5gcgwanJuZ1lhRpf07wM+0PS9c60rbn3
	u1kWPKnS4S7xsBeVgv8sDC8NQEMtbVhDOvMK48hB/b0kwnCQ/LmO1YHcipIpkWVRhOyQ
	c3EA==
Content-Disposition: inline
In-Reply-To: <0414ce4418a6f0dd481586ce4059b97800bcc1ca.1398147734.git.nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
To: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 22, 2014 at 02:30:27PM +0800, Jianyu Zhan wrote:
> This is a prepared patch for converting from per-cgroup id to
> per-subsystem id.
> 
> Some subsystems dereference the per-cgrpu id directly, but this is
> implementation-specific, so it should be transparent for subsystems.

Hmm... why would cgroup ID be implementation-specific?  It's a
published field

> Use this accessor instead.

I'm not a big believer of trivial accessors.  They tend to obfuscate
things more than helping anything.  Here, we need to switch from
cgrp->id to css->id.  Wrapping cgrp->id by css_to_id() doesn't really
help anything especially because there will be cases where we'd
actually want cgroup IDs instead of css IDs too.

Thanks.

-- 
tejun
