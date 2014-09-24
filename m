From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Date: Wed, 24 Sep 2014 10:32:47 -0400
Message-ID: <20140924143247.GF16555@htj.dyndns.org>
References: <542124D3.9000007@huawei.com>
 <20140924132218.GC16555@htj.dyndns.org>
 <20140924133513.GD16555@htj.dyndns.org>
 <201409242309.HDF95877.OSVFFtQLJMOHOF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=STuRXdNkqqvM5B0vIRuTDarh5vyYpubUv2hZ2EQFtUQ=;
        b=XeTJaoo+2+SxL+/9iJwTT7deoQTBhNH6USj2uOsHFnOiqQ9nGcfrdsROrZw0jC9Noh
         q/3q+zwQZGnnWQyig1zQGlY4IrqFW4pW73H8asnFFn5IOPXednUzphGV+Ba8U8NPcRSs
         8r36Qcvc9oOUBL6Fgy5s0czJ6Tx/OXrLixpBa68PcFvagZKjD02iYPM/dBSulE7ot0bk
         ja2JaR6tVXzkFX3jn58gC3BfAcobgj0Feam7ZRM9mvUn+zbVJQfWDo0G548U9JmsN1bC
         OhXeFd4R9KXwPLIKSfINHfuCIGcIQeGKBx9xxCuW9ZFEEw8mJRgwJqOMWLjS9kBdIi91
         eB6g==
Content-Disposition: inline
In-Reply-To: <201409242309.HDF95877.OSVFFtQLJMOHOF-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Wed, Sep 24, 2014 at 11:09:25PM +0900, Tetsuo Handa wrote:
> Tejun Heo wrote:
> > > Applied 1-3 to cgroup/for-3.17-fixes w/ the typo spotted by davidr
> > > fixed.
> 
> s/happend/happened/
> 
> > 
> > Reverted due to build failure.  Will wait for a refreshed version. :(
> 
> I can build with 1-3 patches using HEAD of linux.git. What failure did you see?
> 
> $ make kernel/seccomp.o kernel/sys.o security/apparmor/domain.o kernel/cpuset.o

Got the following failure report from the build bot.

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.17-fixes
head:   ed91a06989e253cde811d492414adcf94f34eb03
commit: ed91a06989e253cde811d492414adcf94f34eb03 [8/8] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB
+should be atomic flags
config: x86_64-randconfig-hxb2-0924 (attached as .config)
reproduce:
  git checkout ed91a06989e253cde811d492414adcf94f34eb03
  # save the attached .config to linux build tree
  make ARCH=x86_64

All error/warnings:

   In file included from include/linux/linkage.h:4:0,
                    from include/linux/preempt.h:9,
                    from include/linux/spinlock.h:50,
                    from include/linux/mmzone.h:7,
                    from include/linux/gfp.h:5,
                    from include/linux/slab.h:14,
                    from mm/slab.c:89:
   mm/slab.c: In function '__do_cache_alloc':
>> mm/slab.c:3229:54: error: 'PF_SPREAD_SLAB' undeclared (first use in this function)
     if (current->mempolicy || unlikely(current->flags & PF_SPREAD_SLAB)) {
                                                         ^
   include/linux/compiler.h:131:45: note: in definition of macro 'unlikely'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                               	^
   mm/slab.c:3229:54: note: each undeclared identifier is reported only once for each function it ap
+pears in
     if (current->mempolicy || unlikely(current->flags & PF_SPREAD_SLAB)) {
                                                         ^
   include/linux/compiler.h:131:45: note: in definition of macro 'unlikely'
    #  define unlikely(x) (__builtin_constant_p(x) ? !!(x) : __branch_check__(x, 0))
                                               	^

vim +/PF_SPREAD_SLAB +3229 mm/slab.c

8c8cc2c1 Pekka Enberg   2007-02-10  3223
8c8cc2c1 Pekka Enberg   2007-02-10  3224  static __always_inline void *
8c8cc2c1 Pekka Enberg   2007-02-10  3225  __do_cache_alloc(struct kmem_cache *cache, gfp_t flags)
8c8cc2c1 Pekka Enberg   2007-02-10  3226  {
8c8cc2c1 Pekka Enberg   2007-02-10  3227        void *objp;
8c8cc2c1 Pekka Enberg   2007-02-10  3228
f0432d15 David Rientjes 2014-04-07 @3229        if (current->mempolicy || unlikely(current->flags &
+PF_SPREAD_SLAB)) {
8c8cc2c1 Pekka Enberg   2007-02-10  3230                objp = alternate_node_alloc(cache, flags);
8c8cc2c1 Pekka Enberg   2007-02-10  3231                if (objp)
8c8cc2c1 Pekka Enberg   2007-02-10  3232                        goto out;

-- 
tejun
