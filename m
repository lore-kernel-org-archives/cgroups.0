From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [lxc-devel] [RFC PATCH] cgroup, cpuset: add cpuset.remap_cpus
Date: Thu, 31 Aug 2017 06:50:22 -0700
Message-ID: <20170831135022.GA1599492@devbig577.frc2.facebook.com>
References: <1482419271-15410-1-git-send-email-w.bumiller@proxmox.com>
 <20170830132755.tnqmuttodexc3oh6@mailbox.org>
 <20170831004131.GZ491396@devbig577.frc2.facebook.com>
 <20170831094145.mrz6daucapq5kvn7@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Fg+6v26Dd3iabh4mEBsSiaij5yltC+ZhtNOPpUQd7YU=;
        b=h7T2tsuV3hHwfjC0XZlQMClbGj2qMK5eXNLAk2aTSA7n4G0bMvWtfNMic3LFNLq9uK
         DDp4YDCsqLIeqzSbi4nsu04ujZLaFYCideeAfZ7C7F/3tT6XMJwRoRps5ONI1wx+dL5B
         kmZCuCC39cfPQFrnKwVt899qg4otqAmfTJ9kpJfFSC59MYvrFwYXntPol8kiHX0qTkta
         LgMUNGrPF+NIB14wFtTzloSfwB7j3w5qUTQQzRCSPLN/OdRKIK/t0Ci7VfkzYQUESTvJ
         kn1sSTWzvvKTPUCxs9/mZFsq8aPUaToYQn76OVA9SKNHZOMvk4Lc6poU7Rpk1BAHch6V
         5m2Q==
Content-Disposition: inline
In-Reply-To: <20170831094145.mrz6daucapq5kvn7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <christian.brauner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, w.bumiller-YTcQvvOqK21BDgjK7y7TUQ@public.gmane.org, stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org

On Thu, Aug 31, 2017 at 11:41:47AM +0200, Christian Brauner wrote:
> On Wed, Aug 30, 2017 at 05:41:31PM -0700, Tejun Heo wrote:
> > Hello,
> > 
> > On Wed, Aug 30, 2017 at 03:27:55PM +0200, Christian Brauner wrote:
> > > The following patch was sent a while back by Wolfgang Bumiller to remap cpusets
> > > for a whole subtree in a cgroup v1 cpuset hierarchy. The fact that currently
> > > this is not possible in a non-racy why is a pretty big limitation. This is
> > > especially true for nested containers. Where the nested containers often create
> > > additional subcgroups in the cpuset controller at will. The fact that you can't
> > > *easily* and in a non-racy way tighten the restriction on them after having
> > > created the parent container's cpuset cgroup seems really troubling.
> > 
> > There was a recent patch to enable v2 behavior on v1, which feels like
> > the better approach at this point.  I'm not sure about adding a whole
> > new interface for this.
> 
> Cool. If it can be done easier and less invasive I'm all for it. Did the patch
> already make it into your branch and - only if you happen to have the reference
> flying around - could you point me to it.

https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/commit/?h=for-4.14&id=b8d1b8ee93df8ffbabbeadd65d39853cfad6d698

Thanks.

-- 
tejun
