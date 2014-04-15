From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0.5/12] cgroup: cgroup_apply_cftypes() shouldn't skip the
	default hierarhcy
Date: Tue, 15 Apr 2014 18:05:45 -0400
Message-ID: <20140415220545.GB13099@mtj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
	<20140415220504.GA13099@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=ww/mYwNxBZz4Yq2VllQOfMWx+1r2bYz9cc4xINlEsrc=;
	b=ZS3RV2MDKNpPqhQNMcVACUSrks9RbycYCsw6aCAMUWwpkT+PME60R4CHgu4USopUG4
	qSrBDTBnhDhl4RcgrRl8lSyHHA8BNJZwbR9r4isOWoDoRS7to/3LrPh4sodl8CDQfyWD
	uG67xYl25XQCbe1kUrkX9NM7pm8TCAlXLNLkJtn5aIQLiyf8FO1J2w9GTSieuHg2BMRr
	JdPAVUtqZ2Rb5Z6wC++ukQYvHoy7RWHEf8jYhi6cOUh0AsQq+mjZoYoylnImc+usOAdL
	uKWF6eKWz7pxXCd/bGL8V2lwqXWXv0oqfug84DTJCluj/p1bCyPvAS3kma5sT1lWs79u
	eP7g==
Content-Disposition: inline
In-Reply-To: <20140415220504.GA13099-9pTldWuhBndy/B6EtB590w@public.gmane.org>
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

On Tue, Apr 15, 2014 at 06:05:04PM -0400, Tejun Heo wrote:
> From c7596b2f33e9f7a57cef6909c30fec268e921c3b Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Tue, 15 Apr 2014 18:02:12 -0400
> 
> cgroup_apply_cftypes() skip creating or removing files if the
> subsystem is attached to the default hierarchy, which led to missing
> files in the root of the default hierarchy.
> 
> Skipping made sense when the default hierarchy was dummy; however, now
> that the default hierarchy is full functional and planned to be used
> as the unified hierarchy, it shouldn't be skipped over.
> 
> Reported-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Ugh... wrong thread.  Will repost.

thanks.

-- 
tejun
