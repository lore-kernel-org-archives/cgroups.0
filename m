From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/9] cgroup_freezer: introduce
	CGROUP_FREEZING_[SELF|PARENT]
Date: Wed, 7 Nov 2012 20:45:21 -0800
Message-ID: <20121108044521.GH2660@mtj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
	<1351931915-1701-8-git-send-email-tj@kernel.org>
	<509B382E.4030707@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=zw0zfRcpe54x0w+e0VDJ7vnLfzrUJa0jHT/YGfJUjPw=;
	b=xjT/9xQiUFQglO3ndImJFigSgQuXgyauqSgfXqNbTmB85muyuPiEJ4V+6X+zVUBKQk
	OtWXqoAPvtZbb6tM4Y8szIr/lMwY96AddmVoNJzXny7T84FOt6wVtRYoo9o0MdRebH5M
	uSzz0dYVBeDqk9hQmbILJN3X9i2BQhf9ytQzEQ6fXg0wdr55kpkw34U5Vu7R+vgobJeq
	/P1qZSZZaeFj5sIOPplgKbHeWn+FFm0Fsym8tV8iEiddssm6b7hP/5OOdmQYCV/0NkMv
	CBtdvx46r6OAyOf05yElzbX1A2zaCLI58lMPuDK2gCF59SlDlVv2l3yunF87Shl8JqQY
	x04g==
Content-Disposition: inline
In-Reply-To: <509B382E.4030707-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
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
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Nov 08, 2012 at 01:42:22PM +0900, Kamezawa Hiroyuki wrote:
> (2012/11/03 17:38), Tejun Heo wrote:
> >Introduce FREEZING_SELF and FREEZING_PARENT and make FREEZING OR of
> >the two flags.  This is to prepare for full hierarchy support.
> >
> >freezer_apply_date() is updated such that it can handle setting and
> >clearing of both flags.  The two flags are also exposed to userland
> >via read-only files self_freezing and parent_freezing.
> >
> >Other than the added cgroupfs files, this patch doesn't introduce any
> >behavior change.
> >
> >Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> What is the purpose of FREEZING_SELG/PARENT, having 2 flags and
> make it visible to users ?

SELF is the configuration of the current cgroup, PARENT is freezing
state inherited from an ancestor.  If either is set, the cgroup is
freezing.  Without the two conditions visible to userland, it can get
a bit confusing as echoing "THAWED" to state may not do anything to
the cgroup.

Thanks.

-- 
tejun
