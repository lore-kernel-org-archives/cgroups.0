From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup_threadgroup_rwsem - affects scalability and
 OOM
Date: Tue, 9 Aug 2016 10:26:03 -0400
Message-ID: <20160809142603.GE4906@mtj.duckdns.org>
References: <4717ef90-ca86-4a34-c63a-94b8b4bfaaec@gmail.com>
 <20160809062900.GD4906@mtj.duckdns.org>
 <0a7ffe43-c0c6-85df-9bc2-d00fc837e284@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=C0WHAb/iJJWFN8mZxJqHYBwy4KCq7JjwdgpZz9mE4Bk=;
        b=uUGoSXcaxVFABkzp4zLBEq3hKbCbuQmkASykxDzW/CRv21kRcg4WgU+f13QejzRsL9
         4SI8j4VXBVUbUurJFyNZtYkOSt8rRyLmbmnGFAlqaMxF2DIbJlvLbxwGpZcOCZ3eZGJR
         MwAHc4I+HB9uNhQtwDD3/jymJQ8OP6I4z1kmg5nV9r95dagpjaEanTjMfVwxyC7RhaZ+
         hW7RyoWoAlePSaHkB6/CaOgs+Unu3AISVAgZZaWGeswHkWcyzPrNcJHct3YNtfnMcRiC
         DpNpverstPVTPD5K7839okkCTeoh0/+LyDq+kXiPCFuakmJ/8+l6y2D5h59joI9kgBVN
         s4vA==
Content-Disposition: inline
In-Reply-To: <0a7ffe43-c0c6-85df-9bc2-d00fc837e284-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Hello, Balbir.

On Tue, Aug 09, 2016 at 05:02:47PM +1000, Balbir Singh wrote:
> > Hmm? Where does mem_cgroup_iter grab cgroup_mutex?  cgroup_mutex nests
> > outside cgroup_threadgroup_rwsem or most other mutexes for that matter
> > and isn't exposed from cgroup core.
> > 
> 
> I based my theory on the code
> 
> mem_cgroup_iter -> css_next_descendant_pre which asserts
> 
> cgroup_assert_mutex_or_rcu_locked(), 
> 
> although you are right, we hold RCU lock while calling css_* routines.

That's "or".  The iterator can be called either with RCU lock or
cgroup_mutex.  cgroup core may use it under cgroup_mutex.  Everyone
else uses it with rcu.

Thanks.

-- 
tejun
