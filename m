From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Fri, 20 May 2016 12:53:26 -0400
Message-ID: <20160520165326.GE5632@htj.duckdns.org>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
 <573F23D0.2030500@suse.de>
 <20160520152244.GB5632@htj.duckdns.org>
 <1463758258.8091.3.camel@HansenPartnership.com>
 <20160520160352.GC5632@htj.duckdns.org>
 <1463760550.8091.13.camel@HansenPartnership.com>
 <20160520161759.GD5632@htj.duckdns.org>
 <1463761509.8091.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5Yhw5Dq6jGh7hVUR7TmZ7VMEgtxgUBb1ITp/ExNJzuU=;
        b=uNHEfp4zIDLgAeKYQLsYUGDU6DqjKE8vxtthdVhelQC8wm+wBkLS15ajYH2FpQUd22
         xTHOiNKLqRsq9bC84JyuDPcT1tMnugkp+JbU56msr/JOA6OVrA1O3tnU7hC6c53HPjXz
         qflOjGCBVLD1B7/hhi0z1xio9iVd6eGT9oWiKW4juihYEyqRWkfsil08DRQd7/Icyah3
         R+vpfBBAOsqVJfXFIi6tw+R2KyCmSxQBVhgxPzmTwG5+x0bJth/6HYMLkKwQm/esA6/m
         6hVWHPUD02m6DVv+hJRJe345VX1Jiu2LGNJSMO6q3dAVR21b+WLylW5owvDtHkh4kvIv
         J4GQ==
Content-Disposition: inline
In-Reply-To: <1463761509.8091.19.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Aleksa Sarai <asarai@suse.de>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Aleksa Sarai <cyphar@cyphar.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, dev@opencontainers.org

Hello,

On Fri, May 20, 2016 at 12:25:09PM -0400, James Bottomley wrote:
> OK, so is the only problem cleanup?  If so, what if I proposed that a

For generic cases, it's a much larger problem.  We'd have to change
delegation model completely so that delegations are allowed by
default, which btw can't be allowed on v1 hierarchies as some
controllers don't behave properly hierarchically in v1 and would allow
unpriv users to escape the constraints of its ancestors.

> cgroup directory could only be created by the owner of the userns
> (which would be any old unprivileged user) iff they create a cgroup ns
> and the cgroup ns would be responsible for removing it again, so the
> cgroup subdirectory would be tied to the cgroup namespace as its holder
> and we'd use release of the cgroup to remove all the directories?

Unfortunately, cgroup hierarchy isn't designed to support this sort of
automatic delegation.  Unpriv processes would be able to escape
constraints on v1 with some controllers and on v2 controllers have to
be explicitly enabled by root for delegated scope to have access to
them.  We can try to isolate these delegated subtrees and make them
work transparently, which rgroup tried to do, but that collides
directly with the vfs conventions (rgroups don't show up in cgroup
hierarchy at all so avoid this problem).

Why does an unpriv NS need to have cgroup delegated to it without
cooperation from cgroup manager?  If for resource control, I'm pretty
sure we don't want to allow that without explicit cooperation from the
enclosing scope.  Overall, it feels like this is trying to work around
an issue which should be solved from userland.

Thanks.

-- 
tejun
