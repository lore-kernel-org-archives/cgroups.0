From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: missing rcu read lock around task_css_set
Date: Mon, 3 Mar 2014 17:33:27 -0500
Message-ID: <20140303223327.GB26523@mtj.dyndns.org>
References: <1393729211-937-1-git-send-email-sasha.levin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=+0vhEckLgicxakARyQhhIN+521lHeyuv3uN+9xFW3Yc=;
	b=PNzH2dQnVL+ZUHysXpUOfv8BxuqqXwR/voZ4XjB54lbnHMme1EHiPijEh3Jdsy8Bs7
	RAFkTiYpVhueKfBrMGxdvF3nhrbmOMUOMTbE0j5VnI3ciIoXgw/pEEXvddVdSYzRA4Pi
	ol+1D7Nbeoh47nDF+otrZZXt47nrV6/jrHIDuSXYJLkM5G5xy/2f6qRZ958gtgiJkk0W
	xsjJ5ZNf3hHEuJuAJP8ogAQ+XR90+XbH6KEEkj+3khCMmBywdysfEpv1j/8IgCsHT1Iv
	AU+VAmDjelFoRiZ4cvaLtcZgF+UBJwGdNFMTCWr6pNt7IMVVDSkDe55XzZ9nxb7Xt0m7
	Nafw==
Content-Disposition: inline
In-Reply-To: <1393729211-937-1-git-send-email-sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
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

On Sat, Mar 01, 2014 at 10:00:11PM -0500, Sasha Levin wrote:
> rcu read lock should be held when calling and working with task_css_set.
> 
> This patch also fixes a related lockdep warning.

Hmmm... PF_EXITING should be visible at that point and cset can't
change anymore.  We prolly need to update lockdep annotation rather
than adding spurious rcu locking around it.  Against which branch is
it?  Can you please post the lockdep warning?

Thanks.

-- 
tejun
