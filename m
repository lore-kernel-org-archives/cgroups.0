From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
Date: Mon, 14 Apr 2014 17:31:33 -0400
Message-ID: <20140414213133.GB1863@htj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=uXZrE+9gSoOPssQRI1xFUacbRggwLUJOO1AuIh/wexo=;
	b=YIuLvNeTCt4MHYrcRzWeL6pGBPSmAz/8jl4VCOKMMUGPrlz+C6hafF9IOJ6/M0DJcN
	PJdPgmmZY6GFHAmdzX9mgettzr+fWNRxKXsm1fJ4xgFMEj6ADr1avNorI4mbYsrjlZ33
	9QIffEh14PpYXwAc1rLFxes+kf4/boor/DXTYxVtRFU571Xq1Guijw7vYKpKZ/pWpZED
	ZFqL+KqIMEhxdZtgtYngA5vFl+vCph0iE6cpmsg6IfTrcImN0gQ3mjyMrCmvU8/KcOJp
	vdRvNvdnLwkKhMXr+aCOntcY91V2uBDsZtcTj4TMnboMyaP2+uV55mMs1TrHMRm4wBzm
	Ut5g==
Content-Disposition: inline
In-Reply-To: <1395974461-12735-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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

On Thu, Mar 27, 2014 at 10:40:49PM -0400, Tejun Heo wrote:
> The patchset is on top of cgroup/for-3.15 01a971406177 ("cgroup: Use
> RCU_INIT_POINTER(x, NULL) in cgroup.c") and also available in the
> following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-unified

Branch renamed to review-unified-v1.

Thanks.

-- 
tejun
