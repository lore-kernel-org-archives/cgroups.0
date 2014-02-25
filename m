From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.15] cgroup: update task migration path
Date: Tue, 25 Feb 2014 10:05:48 -0500
Message-ID: <20140225150548.GE26788@htj.dyndns.org>
References: <1392323333-18907-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=c99o2ZhPOAG+ZFcxlmC8Yq9eiuI6/qN1IrauYNRsAeg=;
	b=LR3AkaZsPW6LEJ7nMADe8ZkFZZPQ+W1QBqibJUbWx8ajU4QTirTdZqdtyCWvDhDhjs
	d9WgSFtCgR/LdIUVHTCMAvUm4c+9sV6y7z70KunFdJ1fmbEelCr/7OduKQLkVZDM5IHl
	XVcXnZGwGZN+cbCQryfDAiCxdvPEl8DIfnXt6iMiisax0fU+a2Yv12wzVcAAIiet+6l1
	4kBIk0ftpeyTTC2VO4F/npyP5JgV4bKLlFl2ERCXJpEvp/zDUSGswHGeNBVrhs6c4lh2
	/rFPn7m9NuAdDvjYkWLt1Kgh7Imwjb1UEaol80A+3pnJhiutRYuS+bGqYBVnpkCv+p2/
	saOA==
Content-Disposition: inline
In-Reply-To: <1392323333-18907-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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

On Thu, Feb 13, 2014 at 03:28:46PM -0500, Tejun Heo wrote:
> Hello,
> 
> This is v2 of update-task-migration-path patchset.  Changes from v1[L]
> are

Applied to cgroup/for-3.15.

Thanks.

-- 
tejun
