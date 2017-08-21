From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: memcg Can't context between v1 and v2 because css->refcnt not
 released
Date: Mon, 21 Aug 2017 09:08:48 -0400
Message-ID: <20170821130848.GB1371@cmpxchg.org>
References: <CADK2BfzM9V=C3Kk6v714K3NVX58Q6pEaAMiHDGSyr6PakC2O=w@mail.gmail.com>
 <20170810071059.GC23863@dhcp22.suse.cz>
 <CADK2BfwC3WDGwoDPSjX1UpwP-4fDz5fSBjdENbxn5XQL8y3K3A@mail.gmail.com>
 <20170810081920.GG23863@dhcp22.suse.cz>
 <CADK2BfxJim8MvLPY497a+JAK2t9OTq+f1BY0o4qK0ihaWsoEMQ@mail.gmail.com>
 <CADK2BfzarAEQz=_Um23mywmdRvhNbe5OL_7k13XD3D5==nn0qg@mail.gmail.com>
 <CADK2Bfwxp3gSDrYXAxhgoYne2T=1_RyPXqQt_cGHz86dfWgsqg@mail.gmail.com>
 <20170810103405.GL23863@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TxNzuiZKFUW2rkDivQA87HBL5cbyDOZsvRMThx3xCVY=; b=lT/XYpJO/E9pv3LZWYENGRioiM
        Hf6mNMDHgIPsoCd0xnBPu7R0Lh/V2n6fR+FN8ISBm8uSWWBnz4yALty/ryYsPBXy5F3Yo/9Zgxn3V
        1HhY7AqcsmndXP9U8kITJoOA58Y1hhaEmm91TGNaoT8AlVggdLvjAMkgRqonxqmOrW84=;
Content-Disposition: inline
In-Reply-To: <20170810103405.GL23863-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: wang Yu <yuwang668899-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Aug 10, 2017 at 12:34:06PM +0200, Michal Hocko wrote:
> [restoring the CC list]
> 
> On Thu 10-08-17 17:57:38, wang Yu wrote:
> > 2017-08-10 17:28 GMT+08:00 wang Yu <yuwang668899-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> [...]
> > > after drop caches, memory.stat  shows not pages belong the group, but
> > > memory.usage_in_bytes not zero, so maybe other pages
> > > has wrong to belong this group
> >
> > after drop cache, there maybe have kmem pages ,e.g. slab
> > it can't free both drop cache or tasks free,
> > so back this problem, without mem_cgroup_reparent_charges,
> > cgroup v1 can't umount , and cgroup v2 can't mount
> 
> Ohh, right. It is true that there is no explicit control over kmem page
> life time. I am afraid this is something non-trivial to address though.
> I am not sure swithing between cgroup versions is a strong enough use
> case to implement something like that but you can definitely try to do
> that.

Pretty much.

The idea was being able to switch after bootup to make interaction
with the init system easier (automatic mounts etc.), not that you can
switch back and forth between using v1 and v2 controllers.

Once the controller has been used and accumulated state, switching
controller versions is no longer supported.
