From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH v13 0/7] cgroup-aware OOM killer
Date: Tue, 17 Jul 2018 09:55:17 +0900
Message-ID: <201807170055.w6H0tHn5075670@www262.sakura.ne.jp>
References: <0d018c7e-a3de-a23a-3996-bed8b28b1e4a@i-love.sakura.ne.jp> <20180716220918.GA3898@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180716220918.GA3898@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Roman Gushchin wrote:
> On Tue, Jul 17, 2018 at 06:13:47AM +0900, Tetsuo Handa wrote:
> > No response from Roman and David...
> > 
> > Andrew, will you once drop Roman's cgroup-aware OOM killer and David's patches?
> > Roman's series has a bug which I mentioned and which can be avoided by my patch.
> > David's patch is using MMF_UNSTABLE incorrectly such that it might start selecting
> > next OOM victim without trying to reclaim any memory.
> > 
> > Since they are not responding to my mail, I suggest once dropping from linux-next.
> 
> I was in cc, and didn't thought that you're expecting something from me.

Oops. I was waiting for your response. ;-)

  But Roman, my patch conflicts with your "mm, oom: cgroup-aware OOM killer" patch
  in linux-next. And it seems to me that your patch contains a bug which leads to
  premature memory allocation failure explained below.

  Can we apply my patch prior to your "mm, oom: cgroup-aware OOM killer" patch
  (which eliminates "delay" and "out:" from your patch) so that people can easily
  backport my patch? Or, do you want to apply a fix (which eliminates "delay" and
  "out:" from linux-next) prior to my patch?

> 
> I don't get, why it's necessary to drop the cgroup oom killer to merge your fix?
> I'm happy to help with rebasing and everything else.

Yes, I wish you rebase your series on top of OOM lockup (CVE-2016-10723) mitigation
patch ( https://marc.info/?l=linux-mm&m=153112243424285&w=4 ). It is a trivial change
and easy to cleanly backport (if applied before your series).

Also, I expect you to check whether my cleanup patch which removes "abort" path
( [PATCH 1/2] at https://marc.info/?l=linux-mm&m=153119509215026&w=4 ) helps
simplifying your series. I don't know detailed behavior of your series, but I
assume that your series do not kill threads which current thread should not wait
for MMF_OOM_SKIP.
