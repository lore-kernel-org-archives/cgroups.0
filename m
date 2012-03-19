From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/10] cgroup: convert memcg controller to the new
	cftype interface
Date: Mon, 19 Mar 2012 09:10:52 -0700
Message-ID: <20120319161052.GC11069@google.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
	<1331940963-15756-7-git-send-email-tj@kernel.org>
	<4F66B55A.8020307@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=vom38dKv+APuONg7lJE7/ztW2eTu7gbN8ZBmn+mrbVE=;
	b=G6WCq4zkiQZt59MEP9NRSMRxKprnuvf6Y1IooY8yYHYYqTsKkLKRnBIqHLaPjTvukG
	jpCy7wGXvMgWhK6pM24gUYYwyE1VCR2x0y/O4ZgmnkR6r31LaquNuQgh/XUjSXUZud3J
	Wseb4hDjBzW4BV2gRXDg+C5M8ipFxGazvFGRV/Mcq5BL4QEaBfzqrMrbCeLG2j+OxEg5
	qaoKbJW3uBE2Otq/1MMdmCp5EXLdrUVAEO1VF7DIIp3eex5aGLOEJG6n4/qWdkYh0cry
	LW4YgaESjH5fn4MBXh+PTGf92xt2hA/QaSvrh8GghJ0YxVE7oEBvlOZOjRgwtGlbIIIb
	NDyA==
Content-Disposition: inline
In-Reply-To: <4F66B55A.8020307-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
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
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Mar 19, 2012 at 01:26:02PM +0900, KAMEZAWA Hiroyuki wrote:
> > +CGROUP_SUBSYS_CFTYPES_COND(mem_cgroup_subsys, memsw_cgroup_files,
> > +			   really_do_swap_account);
> 
> 
> I'm sorry but why you use really_do_swap_account instead of do_swap_account ?

Because do_swap_account is initialized too late.
CGROUP_SUBSYS_CFTYPES() are processed via fs_initcall().  AFAICS,
do_swap_account may not have been initialized by then.  Also, if memcg
as whole is disabled, it doesn't matter whether those files are
registered or not, right?  We probably need some comment there tho.

Thanks.

-- 
tejun
