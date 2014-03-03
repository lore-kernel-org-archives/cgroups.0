From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: missing rcu read lock around task_css_set
Date: Mon, 3 Mar 2014 17:45:05 -0500
Message-ID: <20140303224505.GE26523@mtj.dyndns.org>
References: <1393729211-937-1-git-send-email-sasha.levin@oracle.com>
	<20140303223327.GB26523@mtj.dyndns.org>
	<5315057F.3030602@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=nHWq8Sug9haNbk6MBtC1+KAZEk0VO1ugtCQek9yscLo=;
	b=Z6KGRn3vBlIVl7EdDxRVIQAbG8x9THCSLx/z2GF3Yhh+ZQ8YYZZ0QihU0cUFoslZfB
	I0OaLgf+sWbFAvTp8bHTEEE1taThnI5B+wBL6j6AJBgSKrKx3cISLMb+V2Ef5VAS7fKh
	PrRr3tH664/gbZgpzfVIsdpFqFgkmssT+/jKcbDIbnmJJ5kwWJxOlNycJUujJHIqlhA7
	Lv3mRASMBVENg8yv1nbS+vhit60ptirQddXuXIZlU6/Zo7AzETfe73YQYKS7RPEkcgSg
	bIVPqsl6ZkB8XUrkV39pYV9RoRg8opkH5y0v2BBfEALMIpL0LYvfkN3Jk875VlcoLmaa
	XRQw==
Content-Disposition: inline
In-Reply-To: <5315057F.3030602-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
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
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 03, 2014 at 05:43:11PM -0500, Sasha Levin wrote:
> On 03/03/2014 05:33 PM, Tejun Heo wrote:
> >On Sat, Mar 01, 2014 at 10:00:11PM -0500, Sasha Levin wrote:
> >>rcu read lock should be held when calling and working with task_css_set.
> >>
> >>This patch also fixes a related lockdep warning.
> >
> >Hmmm... PF_EXITING should be visible at that point and cset can't
> >change anymore.  We prolly need to update lockdep annotation rather
> >than adding spurious rcu locking around it.  Against which branch is
> >it?  Can you please post the lockdep warning?
> 
> I see it on -next.

I think the right thing to do is using task_css_set_check() with
PF_EXITING check and add comment explaining that cset can no longer
change.  Can you please write up a patch?

Thanks.

-- 
tejun
