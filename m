From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-3.10] cgroup: make cgroup_mutex outer to
 threadgroup_lock
Date: Wed, 20 Mar 2013 08:03:51 -0700
Message-ID: <20130320150351.GW3042@htj.dyndns.org>
References: <20130307172545.GA10353@redhat.com>
 <20130307180139.GD29601@htj.dyndns.org>
 <20130307180332.GE29601@htj.dyndns.org>
 <20130307191242.GA18265@redhat.com>
 <20130307193820.GB3209@htj.dyndns.org>
 <513A9A67.60909@huawei.com>
 <20130309032936.GT14556@mtj.dyndns.org>
 <513AE918.7020704@huawei.com>
 <20130319220246.GR3042@htj.dyndns.org>
 <514909A0.4030808@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=FTK+h4irUNjtDunrg0MPwnkSV7i5F58gxckYEpdjXSg=;
        b=hd+hLCRPPxoMVVpm+uqBQP6CSbB3r465Ida0i9vNy99YIukmstGqJZLz0hZu256Kpy
         k4A2hoaEaEQpuGO8oS4Pz4qvKBV8rQPW0r2CgtBgjSlvoMdUn2V8wrI6e7WDgsZrkRDO
         hFllZZBsFhsNMWNWFTUrOAXjsxwIoRr3j5A2WR++g0bCShuImBpT6OlRfkS2GuyjyG40
         qnFuTprE9QwQi/udCdUXCvoUjbfyeo4rEemS7GDZ6sVNlDnjmiBtQM2E93MuAygbYViC
         ozzVZt+whQwAfTeCgH2nPS/AjABbs6X2dHv13QX2TeAtWnVf1spPs7s9316t3wjMvvMy
         jJhQ==
Content-Disposition: inline
In-Reply-To: <514909A0.4030808@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org

On Wed, Mar 20, 2013 at 08:58:08AM +0800, Li Zefan wrote:
> On 2013/3/20 6:02, Tejun Heo wrote:
> > It doesn't make sense to nest cgroup_mutex inside threadgroup_lock
> > when it should be outer to most all locks used by all cgroup
> > controllers.  It was nested inside threadgroup_lock only because some
> > controllers were abusing cgroup_mutex inside controllers leading to
> > locking order inversion.
> > 
> > cgroup_mutex is no longer abused by controllers and can be put outer
> > to threadgroup_lock.  Reverse the locking order in
> > attach_task_by_pid().
> > 
> 
> But the code contrast to the changelog. ;)
> 
> cgroup_mutex is currently outside of threadgroup_lock, and you're making
> it nested inside threadgroup_lock in the code.

Heh heh, thanks for spotting my idiocy.  Yeah, the locking order
between the two has been swapped a couple times while writing up the
original threadgroup_lock patch and I misremembered how it was at the
end and got totally confused when writing this patch.  Sorry about
that.  So, let's leave the locking in cgroup alone.  I like
cgroup_mutex to be the outer one.

Thanks.

-- 
tejun
