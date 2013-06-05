From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.11 1/3] cgroup: mark "tasks" cgroup file as
 insane
Date: Wed, 5 Jun 2013 12:03:53 -0700
Message-ID: <20130605190353.GF10693@mtj.dyndns.org>
References: <20130604021302.GH29989@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FqnMTRwEtXxVlowi1A85gnIZxps3tfocczOr8Gp80r4=;
        b=Z5/fEUSlsjrr9eZhoi7L9Pqz9v7yl1jThg7ao18WeJAuPtQOvZwQdAGGHzSZewKUA0
         sGM/Ms0sYoR7/ugxYwQbtC9Qp8ymRkD0w50j6ZdTa/sSU4U8MLlWhKemWd2B1S5a/VfC
         WvppQ9f/236KNmSyAzczYrQaLj1zTeHsLlj1OynfdUZvpOVcoJgJ56zrIpkCcv8V9SOL
         ILofnAzWRYWiPMimFB4Tu9SRC6yB5JXmNXPDunisPjKdISyWsSBFbhVICc2KrMRhnwHn
         9xQa7+YfliLZoscJXkewG849r557O8Ndi6BM2uBWrsjyJbuw/eVV/onCP4aO/oqKGrBq
         oOcg==
Content-Disposition: inline
In-Reply-To: <20130604021302.GH29989-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kay.sievers-tD+1rO4QERM@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org

On Mon, Jun 03, 2013 at 07:13:02PM -0700, Tejun Heo wrote:
> Some resources controlled by cgroup aren't per-task and cgroup core
> allowing threads of a single thread_group to be in different cgroups
> forced memcg do explicitly find the group leader and use it.  This is
> gonna be nasty when transitioning to unified hierarchy and in general
> we don't want and won't support granularity finer than processes.
> 
> Mark "tasks" with CFTYPE_INSANE.

Applied 1-3 to cgroup/for-3.11.

Thanks.

-- 
tejun
