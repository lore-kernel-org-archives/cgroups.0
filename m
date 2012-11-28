From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: avoid creating degenerate allcg_list
Date: Wed, 28 Nov 2012 10:29:11 -0800
Message-ID: <20121128182911.GA24683@htj.dyndns.org>
References: <1354127192-22153-1-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=dsPI4jkmXaelvJS56lO0BgkPkjmqBIqxlhVDoBFprIA=;
	b=tEH7G1AgKanNdSlbxsx+8wmAdqUURoV7nHOjCLzHsDHnbB9RYVx3AxK77taxJyuGqd
	Dl9NJ/5EPTt7NqeDe26T0YK+4YaxYJRMjbz+CPoD2DEPRRjFDROn4i9rFHKVA5+BzffM
	ZYpDDHlF+z7oiyBY1eWo6T37uyhD5/P8XtebQUoTjNzmvM5PG5iXIqVPpT2qV/gOpqum
	L4/Rp0aJYadmEF6uV7MZdRA0nBc82e5WwG8yiuMHLBACQHj51VwwYBwQ7tXMXlGIo4OT
	Ye6LvXGcF5i1SgTx54IkiCHrq/V8XK68WNW3K4BSEMTo7mw+HWQVl1yKRoyOE7piXdSh
	4ELw==
Content-Disposition: inline
In-Reply-To: <1354127192-22153-1-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, Greg.

On Wed, Nov 28, 2012 at 10:26:32AM -0800, Greg Thelen wrote:
> Before this patch init_cgroup_root() created a degenerate list by
> first inserting a element into allcg_list and then initializing the
> inserted list element.  The initialization reset the element's
> prev/next fields forming a degenerate list where allcg_list pointed to
> element, but element pointed to itself.  This problem was introduced
> in 2243076ad128 "cgroup: initialize cgrp->allcg_node in
> init_cgroup_housekeeping()".  CONFIG_DEBUG_LIST reported a list_add
> corruption in cgroup_mkdir() running next-20121127 (ce2931a).
> 
> This patch fixes the problem by performing element initialization
> before insertion.

You're beaten by Li Zhong by 9 hrs.  :)

 http://thread.gmane.org/gmane.linux.kernel.next/25096

-- 
tejun
