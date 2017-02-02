From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-4.11] cgroup: drop the matching uid
 requirement on migration for cgroup v2
Date: Thu, 2 Feb 2017 13:48:14 -0500
Message-ID: <20170202184814.GB7917@htj.duckdns.org>
References: <20170120162954.GA30978@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tKFUqWkJz7GUsL757xjFBdW5E7/JCMwm+5ia9jNZqxU=;
        b=J+xZvCd+eyXltunHB7C9+woagxg4+/MdjE8LYfGGin4aebs7QOgTUMPjKcxfMSaUE8
         LcaU66tXWCDvK/uf9xGFhHz+VTXLjFStaUEnYBmgKv6yLckDbfc979x4+wwiNfzwqaPS
         bw82w35piD3gNHEYWZxwUN4D4QWrMq0+I/3F7QsiZB5uoB8kxprjkf9YJU+mKMu1RZVL
         oW4vUndoiLk8yMLqvRBbdA7XKtWS8ve8GnVhdeKMJxkUt5Jf/yNq13CmsRQKN/2VIRgf
         b91PkwEhpl11fPsDJkaMWQC07+kChF4vckynXHSeSI7j1CVoPqjU0Hh7PMrSd0x+nXHd
         ZvNw==
Content-Disposition: inline
In-Reply-To: <20170120162954.GA30978@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Jan 20, 2017 at 11:29:54AM -0500, Tejun Heo wrote:
> Along with the write access to the cgroup.procs or tasks file, cgroup
> has required the writer's euid, unless root, to match [s]uid of the
> target process or task.  On cgroup v1, this is necessary because
> there's nothing preventing a delegatee from pulling in tasks or
> processes from all over the system.
> 
> If a user has a cgroup subdirectory delegated to it, the user would
> have write access to the cgroup.procs or tasks file.  If there are no
> further checks than file write access check, the user would be able to
> pull processes from all over the system into its subhierarchy which is
> clearly not the intended behavior.  The matching [s]uid requirement
> partially prevents this problem by allowing a delegatee to pull in the
> processes that belongs to it.  This isn't a sufficient protection
> however, because a user would still be able to jump processes across
> two disjoint sub-hierarchies that has been delegated to them.
> 
> cgroup v2 resolves the issue by requiring the writer to have access to
> the common ancestor of the cgroup.procs file of the source and target
> cgroups.  This confines each delegatee to their own sub-hierarchy
> proper and bases all permission decisions on the cgroup filesystem
> rather than having to pull in explicit uid matching.
> 
> cgroup v2 has still been applying the matching [s]uid requirement just
> for historical reasons.  On cgroup2, the requirement doesn't serve any
> purpose while unnecessarily complicating the permission model.  Let's
> drop it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applied to cgroup/for-4.11.

Thanks.

-- 
tejun
