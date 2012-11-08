From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 9/9 v3] cgroup_freezer: implement proper hierarchy support
Date: Thu, 8 Nov 2012 19:08:34 +0100
Message-ID: <20121108180834.GB17415@dhcp22.suse.cz>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
	<1351931915-1701-10-git-send-email-tj@kernel.org>
	<20121108175750.GK12973@htj.dyndns.org>
	<20121108180246.GA17415@dhcp22.suse.cz>
	<20121108180417.GC9672@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=NOMEKzxeyUo+LnSc+6gIESWJpSX7CfuC4NXBajUU75k=;
	b=HK49UhhOORU3BiTXPZTAIQa2kvFnaBrRl15MDzRk8aoaHVMkYQalyoorcR3VI7M5Mh
	XR65cLprvaeK2BzKixZdNZxRF554Ak2ETgk9XeMJSIaRbDVRcpuklP0l8OCCZprrrAoG
	oN2L92EIURbSZQWPf/6svz+4Z+KJzTz3+67/mpbkDW6YOr5ydLlUksJ25u7LOhKyivmn
	v4MaLVpfugOPQNTri6xSITVz8FlNLz3XUPGcqL+gab9gLp5Bl5gCc9uA2/A+q9wEd5M1
	E3VPYSPzTF0MQopmeomvE+ufwH3EBgtzbi1Amv/6/3FYIpKpyGfT7uvIrUQYgLcyCiMJ
	LuuQ==
Content-Disposition: inline
In-Reply-To: <20121108180417.GC9672-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
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
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 08-11-12 10:04:17, Tejun Heo wrote:
> On Thu, Nov 08, 2012 at 07:02:46PM +0100, Michal Hocko wrote:
> > On Thu 08-11-12 09:57:50, Tejun Heo wrote:
> > > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > 
> > You probably meant Reviewed-by: Michal Hocko .... ;)
> 
> Hehehheheh... man, I'm too self-absolved.  Thanks for noticing
> that. :)  Updated.

Heh, btw. the doc update looks good as well.
-- 
Michal Hocko
SUSE Labs
