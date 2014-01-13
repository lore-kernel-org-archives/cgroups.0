From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 3/3] Send cgroup_path in SCM_CGROUP
Date: Mon, 13 Jan 2014 11:52:53 -0500
Message-ID: <20140113165253.GC29053@htj.dyndns.org>
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
	<1389600109-30739-1-git-send-email-jkaluza@redhat.com>
	<1389600109-30739-4-git-send-email-jkaluza@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=zHx1abfxwCBv6q9r+7ruvapHRKlFHgJEZZENwyfLkPY=;
	b=OsKjEZ5gLISzWE52kNDLnVWVK6WX4+/1MMPKB8/eGpxPG2r6eZYe/ubGF4Qm2Ouauu
	OYvtgD5OteMPSFUA5HnBJk+2sfXFWMtKkzJtlkxewES9J5HAU1KWFjcM+mc7qqLhqu58
	3Q9ISaF+Z8i8eTLoYCvtEYiT2L4OgTiucuXqugAHp2vvzASWK8jhdyBXAr+6Cl6fC8Dv
	xnEORwF3g9Lqr/KJK8jduKmW1IAh73CmPTPzmHYlI6O3hy3W07hGG51UiSSd+jCZ9+aj
	ENPgbyyejcGFKyxx1hXwbE1OJFe/cheMhTyM/XG5Y2j1IHLZDdvmc4IP9ihUw9CvOndL
	PTjA==
Content-Disposition: inline
In-Reply-To: <1389600109-30739-4-git-send-email-jkaluza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
To: Jan Kaluza <jkaluza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org

On Mon, Jan 13, 2014 at 09:01:49AM +0100, Jan Kaluza wrote:
> Server-like processes in many cases need credentials and other
> metadata of the peer, to decide if the calling process is allowed to
> request a specific action, or the server just wants to log away this
> type of information for auditing tasks.
> 
> The current practice to retrieve such process metadata is to look that
> information up in procfs with the $PID received over SCM_CREDENTIALS.
> This is sufficient for long-running tasks, but introduces a race which
> cannot be worked around for short-living processes; the calling
> process and all the information in /proc/$PID/ is gone before the
> receiver of the socket message can look it up.
> 
> This introduces a new SCM type called SCM_CGROUP to allow the direct
> attaching of "cgroup_path" to SCM, which is significantly more
> efficient and will reliably avoid the race with the round-trip over
> procfs.
> 
> Signed-off-by: Jan Kaluza <jkaluza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

For cgroup related part:

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
