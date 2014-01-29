From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/8] cgroup: remove cgroup->name
Date: Wed, 29 Jan 2014 10:25:13 -0500
Message-ID: <20140129152513.GB30842@htj.dyndns.org>
References: <1390953585-16554-1-git-send-email-tj@kernel.org>
	<1390953585-16554-7-git-send-email-tj@kernel.org>
	<20140129120907.GA22183@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=HLsSrL6oOtnlBNPMEpmoj8gOkq++xkq3zBlOGo75CdI=;
	b=YowjCoy8gUsB3Jnh3dXqiwOXU3z4YIiyPKRuSn8/8eYhTnD4wiLA41H0L6y/T9cJj2
	vg7UO3FWfwhRLKRS5aJVycAmO7/NVfXimjRz6Q9ycJFitxD8MPi0jX8F88XUt73HPULz
	aCncSVwRgOInoc/eUQOw4a2b4H2vT5MtwW3aiDkgFbEn1hoxI/PBPh6Ck6Iyd2DmaZ9C
	UPmzHp2DYCV8KHUjlPmCo29Vb9oVnmUQJiC9BSdQ/b63Eskihf7TsDMgewKoPXJ4i24L
	RSOtIDfOSLRVlia8vvLXs8qifJKLJ00zmHDf3/3Y/pVr1cSxKh0TRaLSwYEeXTPqV3mD
	FiJg==
Content-Disposition: inline
In-Reply-To: <20140129120907.GA22183-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
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
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, Jan 29, 2014 at 01:09:07PM +0100, Michal Hocko wrote:
> Btw. after this change we should drop part of the comment above
> oom_info_lock:

Updated the comment to

 /* oom_info_lock ensures that parallel ooms do not interleave */

Thanks!

-- 
tejun
