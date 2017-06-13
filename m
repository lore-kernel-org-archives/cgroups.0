From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 07/10] cgroup: implement cgroup v2 thread support
Date: Tue, 13 Jun 2017 10:06:22 -0400
Message-ID: <20170613140622.GC28327@htj.duckdns.org>
References: <20170610140351.10703-1-tj@kernel.org>
 <20170610140351.10703-8-tj@kernel.org>
 <6351a07a-7e88-4c89-7d62-cb71021cf580@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wtmjwj4h3Ke1pYupb6aR3NO7keuymB5GHFNn538LBAQ=;
        b=aHVXRDz6pTykJ4pjt/0atGhx8Vko3kUH4pHRLSOJ8t8J2xesmCijCLvU//4fHkDDve
         W6IFx7R1LMXcFeUyOMxOLWQZxEL89AbaNbj/m5zYEZ5v7TpnHp5VRzMiDbBe2xUvudzm
         eKknDwul+nb6ljvbGpCS44yCrrIJUqw+azuj9V0ZkYnV4qkOZzhw1Bp/6sMAs/lEzkUv
         O0drvQd9hjjF+SDMOOMKdDfdE8bJQgjMApEPKGJSyPIX1Y7y4ZTSmRaHVM9vLT0os0P7
         HlNXAstZABpQ9ZpuWsQdo9vAXNFdD2dfHi14ClBwc1VxLfqKNIv9aBr+wgVdYBI1LQhP
         YSSw==
Content-Disposition: inline
In-Reply-To: <6351a07a-7e88-4c89-7d62-cb71021cf580@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org

Hello, Waiman.

On Mon, Jun 12, 2017 at 11:41:09AM -0400, Waiman Long wrote:
> > Internally, in a threaded subtree, each css_set has its ->proc_cset
> > pointing to a matching css_set which belongs to the thread root.  This
> > ensures that thread root level cgroup_subsys_state for all threaded
> > controllers are readily accessible for domain-level operations.
>
> As far as I understand, the proc_cset thing is just for cgroup.procs
> iteration purpose. They are not used for accessing cgroup_subsys_state
> for domain-level operation.  In fact, all the relevant CSSes will be
> available in the local css_set and there is no need to look elsewhere.

Because none is implementing domain resource accounting.  Once we
start doing that, we'll have to charge them against domain csses not
the thread ones.

> > +/* if threaded, would @cgrp become root of a mixed threaded subtree? */
> > +static bool cgroup_is_mixable(struct cgroup *cgrp)
> > +{
> > +	/*
> > +	 * Root isn't under domain level resource control exempting it from
> > +	 * the no-internal-process constraint, so it can serve as a thread
> > +	 * root and a parent of resource domains at the same time.
> > +	 */
> > +	return !cgroup_parent(cgrp);
> > +}
> 
> Eventually, I would like to see a container root to be regarded as
> mixable so that it will look and feel like a real root to the container.
> Yes, that will mean having to deal with internal process competition
> with resource domain controllers. If we are going to keep the no
> internal process constraint, this is the other exception that I would
> like to have. We can work around that by having, for example, special
> directory for resource domain controllers to manage their resources like
> what I have proposed in the resource domain patch. Or we can just let
> those resource domain controllers to deal with it.

Yeah, the code and semantics are structured for future expansion.
That said, such expansion has to mean something inherently useful.  Up
until now, all that have been suggested are either cosmetic or not
clearly defined and IMHO do more to obscure what's going on rather
than enable anything fundamental.  What we do with the interface
should follow the function.  If we can come up with a way to lift the
restriction on an internal node which enables some fundamental
capabilities in a clearly defined manner, let's of course do that, but
we shouldn't do that just because we feel like to.

Thanks.

-- 
tejun
