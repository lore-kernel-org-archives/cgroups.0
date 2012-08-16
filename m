From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
Date: Thu, 16 Aug 2012 13:00:06 -0700
Message-ID: <20120816200006.GG24861@google.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174454.087507415@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=L02sQtGqkPIMBwpu8Dwy4/BwpAbA+Iuln8mqPGyXQhA=;
        b=Ky8bJ+P0h7qqNGyNoeQ6zKoxVVkTZQAbrpxZ8bWBEvTOrkQ8JiFRuxhgscbFNuj/uM
         9hRJgFPMKH+Ov57sVkrZZmUK4dPjuhuaxCPQFLCnj52sKQ7USEpcnkXwVpdnADugZv5C
         l6pFw7rvj2yfxkxeNYHtxkjRlLM7ML3/2RxxIQN59zPC6BDCehmlzWmLfE1DpCD9E+av
         aCJFCnabT4vcD1h0PTtyF2VtCuD7D0kInbGAJixJOs2e3nl5FjfWamu/HqettwFRsQBY
         3a5oTljzhtaAg8beU0uvZvDDybnEFC8ObGwgKMxBYH3fwF6b5IwOuhNC3htRAsvl9o9Z
         wufg==
Content-Disposition: inline
In-Reply-To: <20120816174454.087507415@napanee.usersys.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>, Lennart Poettering <lpoetter@redhat.com>

On Thu, Aug 16, 2012 at 01:44:56PM -0400, aris@redhat.com wrote:
> From: Li Zefan <lizefan@huawei.com>
> 
> This is one of the items in the plumber's wish list.
> 
> For use cases:
> 
> >> What would the use case be for this?
> >
> > Attaching meta information to services, in an easily discoverable
> > way. For example, in systemd we create one cgroup for each service, and
> > could then store data like the main pid of the specific service as an
> > xattr on the cgroup itself. That way we'd have almost all service state
> > in the cgroupfs, which would make it possible to terminate systemd and
> > later restart it without losing any state information. But there's more:
> > for example, some very peculiar services cannot be terminated on
> > shutdown (i.e. fakeraid DM stuff) and it would be really nice if the
> > services in question could just mark that on their cgroup, by setting an
> > xattr. On the more desktopy side of things there are other
> > possibilities: for example there are plans defining what an application
> > is along the lines of a cgroup (i.e. an app being a collection of
> > processes). With xattrs one could then attach an icon or human readable
> > program name on the cgroup.
> >
> > The key idea is that this would allow attaching runtime meta information
> > to cgroups and everything they model (services, apps, vms), that doesn't
> > need any complex userspace infrastructure, has good access control
> > (i.e. because the file system enforces that anyway, and there's the
> > "trusted." xattr namespace), notifications (inotify), and can easily be
> > shared among applications.
> >
> > Lennart
> 
> v6:
> - remove user xattr namespace, only allow trusted and security
> v5:
> - check for capabilities before setting/removing xattrs
> v4:
> - no changes
> v3:
> - instead of config option, use mount option to enable xattr support
> 
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Hillf Danton <dhillf@gmail.com>
> Cc: Lennart Poettering <lpoetter@redhat.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

I'm not against this but unsure whether using kmem is enough for the
suggested use case.  Lennart, would this suit systemd?  How much
metadata are we talking about?

Thanks.

-- 
tejun
