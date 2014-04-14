From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
Date: Mon, 14 Apr 2014 15:21:39 -0400
Message-ID: <20140414192139.GB16835@htj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
	<20140414154556.GA9552@redhat.com>
	<20140414175236.GB15249@htj.dyndns.org>
	<20140414181421.GC9552@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=ywM4DhHk1mxk2FrlOwBGOIKqmq4zgMTlsgEcx/t9cX0=;
	b=SUWaAtx18f1P/8djV5FtJ3+7XD/dBz9rmEl4JoeFnJjzQSqrX9NIljzZ7EGpxTh6EB
	lJe8reCoq0ARR33myBmccuIyaLerRavc/06NwP/QrvyU1/oAggUEHg+UEZEUiuMq7c1r
	3GSHaGBV0SvmUNWLAndoPGqe16ld/R8uIGOiVeVyfPKnlrMi8S9L/vNhwL5HQfKsc1e2
	F17P7KujrouuNXMfNkEgN7MEaPYvxC2PvCvavkAHN2hCPYEo0d9d7G2j0XpUPZg56jKT
	MNjXROjdVBW/ZdF9bQbGDIgSEn7v4+jpDlP5ln6kZDB6uP/mguTNPFzGMJ6hz0392XYx
	GEqw==
Content-Disposition: inline
In-Reply-To: <20140414181421.GC9552-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Apr 14, 2014 at 02:14:21PM -0400, Vivek Goyal wrote:
> So is this an intermediate mode before we move to single hiearchy *only*
> mode. AFAIK, you had mentioned that we will support legacy multiple
> hiearchy mode but single hiearchy is the new default mode.

Hmmm?  It's a separate special hierarchy which can co-exist with other
hierarchies.  There's no inherent intermediacy to it.  As long as
traditional hierarchies exist, it's gonna be like this.

> How does one figure out which one is unified hiearchy (out of multiple
> hierarchies). Is there a flag somewhere? Or sane flag will be used to
> mark unified hiearchy.

You can tell it multiple ways - from its mount options, whether
cgroup.controllers exists, but it'll most likely be mounted on a
distinctive mount point, wouldn't it?

> So task and child groups can co-exist in root *only*?

Note that the restriction doesn't apply if no controller is enabled
but yes root is the only cgroup where tasks can exist and controllers
are enabled at the same time.

Thanks.

-- 
tejun
