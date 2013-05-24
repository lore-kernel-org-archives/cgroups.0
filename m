From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] cgroup: make cgroup_is_removed() static
Date: Fri, 24 May 2013 10:56:13 +0900
Message-ID: <20130524015613.GB19755@mtj.dyndns.org>
References: <1369101025-28335-1-git-send-email-tj@kernel.org>
	<1369101025-28335-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=DjLp9SkBVDHo+TSeDehWhN28GjZPGp1mdes75BcWAao=;
	b=aZ4mPucJlSQPr/AWwEWcMTSp8tPOm4vgM4LzW5q1Z4TvyaVmZUql+2NQgDnBe6uW4Q
	83BbkddvbxHBTbLa961JOADEZpZ/v8IUwllkoUDVBg2sr4G0s8eiBkNN5tZi3d/7sC/H
	Ko4VyvEnB55AtG6hsolPmoQmXmhg5e0I3nvWyVls1Ub0K3G2kmN+q8K30P/IYgcCEgBp
	Iy0CiMMVlvsnNtuzIuLkZYzoJKwvmv8nVqTj9lQssyNCpPdm39kOJJ4m6dxNspexUnHU
	fQ6gSzWf+unJUXX76VQuRGwQUeJ1B9dkFHwjSCytwtBviP5rDpOYiatX7lIgXF1Z/Msn
	2EhQ==
Content-Disposition: inline
In-Reply-To: <1369101025-28335-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 21, 2013 at 10:50:22AM +0900, Tejun Heo wrote:
> cgroup_is_removed() no longer has external users and it shouldn't grow
> any - controllers should deal with cgroup_subsys_state on/offline
> state instead of cgroup removal state.  Make it static.
> 
> While at it, make it return bool.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied 2-5 to cgroup/for-3.11.

Thanks.

-- 
tejun
