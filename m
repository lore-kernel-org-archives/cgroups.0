From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
Date: Fri, 30 Mar 2012 15:29:36 -0700
Message-ID: <20120330222936.GI28934@google.com>
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=bJE5aVCRqL6s4NA4J6f8FPtf6/sQm1tD2sbBn9NByrI=;
	b=UnvtsTh7OOAUpJ/2u9/JLVOhYyUMvo8Zq9gMEmsYcHha4Y9ShWijv+bcdASE7imkFg
	qI00nAZsAYZIoAvuM4xDMXU2QY92x7h8AAOJOtgMyr9OiRjKXozmHyJuHJfMVp+d5kW4
	iPNocGMrERj/pJlZ79WF75sWJceYYGCdvnobG3O+badWW7d86jGLmuyKai1cBAYXMFhb
	+WEyyx8XlCNxKsYZoi1udzv6qgTrGLzHoW9syJrzx6Y4fc5ZtpQtB/WMQ0/vpcC+gzB4
	Q4JUrXnYfFDInNf0JicuTBdpWsv/vY5WpRM3VFB/iSbP5rT9W1q6mFIKdI9fGm+hozv7
	dupg==
Content-Disposition: inline
In-Reply-To: <1332368265-21586-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
To: glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Wed, Mar 21, 2012 at 03:17:33PM -0700, Tejun Heo wrote:
> and is also available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cgroup-cftype

Branch has been refreshed on top of the current mainline and with the
updated patch.

Thanks.

-- 
tejun
