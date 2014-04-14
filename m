From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement unified hierarchy, v2
Date: Mon, 14 Apr 2014 17:45:26 -0400
Message-ID: <20140414214526.GC1863@htj.dyndns.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=OnSsEA3HJL8yuUiQ5E05haCySfWqjan+5or4X6/LIBI=;
	b=UICSOvmL8rpWQo0WsYivKpANa9FgAvxN8WMTDWLPJIiLAVQEJg/ayw4fKJ3Hvp4dbV
	YQ+EJY7DrAiqljRjpd152THOFVWaMfz6oxhQ7pwhk6igzx5Tm/LEVgEpUxDDa1oekYM+
	j1YEtfaI2KGJSjZu+rWnMsjMIOU4U4z4QPqd1ozW67cRfZz0FIbyWwty7hlOayC8hBKq
	FuswunUVp48w06vxnVM9Isb4ikdM53aBUx6xXgVGKvvj6TVpE32H8lmh5A1oQppVa/T3
	pM9Q1yH+W529N1bo+rAsPXI+8s8jLeqK+40vZm/l8+ym4zJoP9rfeFtVJAqDRnLuROW9
	yHGg==
Content-Disposition: inline
In-Reply-To: <1397511430-2673-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Apr 14, 2014 at 05:36:58PM -0400, Tejun Heo wrote:
> The patchset is on top of cgroup/for-3.15 01a971406177 ("cgroup: Use
> RCU_INIT_POINTER(x, NULL) in cgroup.c") and also available in the
> following git branch.

Oops, obviously, the patchset is on top of

 v3.15-rc1 c9eaa447e77e ("Linux 3.15-rc1")

Thanks.

-- 
tejun
