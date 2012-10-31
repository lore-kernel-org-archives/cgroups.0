From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/8] cgroup: remove CGRP_WAIT_ON_RMDIR,
	cgroup_exclude_rmdir() and cgroup_release_and_wakeup_rmdir()
Date: Wed, 31 Oct 2012 10:16:44 -0700
Message-ID: <20121031171644.GG2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
	<1351657365-25055-6-git-send-email-tj@kernel.org>
	<20121031162735.GF22809@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=M6A/xyXRvYsRVwcKonRob0lztJ8v3xMve0KXYoCnzsM=;
	b=AYyW0PfaOCvdgqkOxzQ9gJp3vwjhJUNptGM72w5vRFDQH1o/1vgLJdHEw4PhfHc2PT
	rGiHiD68wibWnFlYsxv/aN6dETnWEDuWpOjENqqpmQQwwaCwXNX47EVTihZkpUnRpuZz
	a+czwwm1XiuF1Ti+ln7XovNMfhEkKlQgnmsFyS7TcuDfWLeP/t6AoaZ4+ZtuBda6qbsj
	M/8beFfOskU/STszJaH/+PgEVDpFSycPyme1gSLSahB0wY6m9iRK1b8gUOM7ynr5d10y
	erWC0otvYZwps7EBaxdUHLRRBndmH4/q1L2I7tWtNUxw2V108hufKNdm+r4KIwMNOP4N
	ehRA==
Content-Disposition: inline
In-Reply-To: <20121031162735.GF22809-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
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
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Wed, Oct 31, 2012 at 05:27:35PM +0100, Michal Hocko wrote:
> > ---
> >  include/linux/cgroup.h | 21 ---------------------
> >  kernel/cgroup.c        | 51 --------------------------------------------------
> >  mm/memcontrol.c        | 24 +-----------------------
> >  3 files changed, 1 insertion(+), 95 deletions(-)
> 
> /me likes this

Amen, Michal.  The amount of code deleted isn't much but it was one
ugly thing.  The comment in memcg around the use of exclude_rmdir was
very depressing.

Thanks.

-- 
tejun
