From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Fri, 14 Apr 2023 07:34:05 -1000
Message-ID: <ZDmOjeBVsIcgSLIV@slm.duckdns.org>
References: <e38f72aa-9705-cf0c-a565-fb790f16c53e@redhat.com>
 <ZDdG1K0kTETZMTCu@slm.duckdns.org>
 <cd4c3f92-4a01-e636-7390-8c6a3d0cfe6c@redhat.com>
 <ZDdNy2NAfj2_1CbW@slm.duckdns.org>
 <1b8d9128-d076-7d37-767d-11d6af314662@redhat.com>
 <ZDdYOI9LB87ra2t_@slm.duckdns.org>
 <9862da55-5f41-24c3-f3bb-4045ccf24b2e@redhat.com>
 <226cb2da-e800-6531-4e57-cbf991022477@redhat.com>
 <ZDmFLfII8EUX_ocY@slm.duckdns.org>
 <c61ca9d0-c514-fb07-c2f2-3629e8898984@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681493647; x=1684085647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dG7apmRM3yhNuDvjT8hFfLfoQEI3ny9KJqTDvMmgXGo=;
        b=AX5OheJ6KNfyM3K9opcvdfBav2CGjPcxmDkXPNcSoXNVzf/5Cr3QkXedJn1avHZ7J9
         MXCeIyUxmvqQWhNz6e/1pYgD8M0MXfnab7qPP8FOGAwbnT9GyN3U+d6S+O4rIry0Ul9Z
         AyW5Ps9Qwh0KwbKaxaJQ+E47gPxiMk7zKTddk8MSZTNefHNANE5m5/EQq5nUG5ICmfT/
         3IEUZX59/5bnSrse5aFuxFKp5Z5RN3neHIQ45Vao2oT99n0swkJ5FPNvhPFEEAJvifiA
         q2jRbLcYm9cNqCyD7X/wquvcfsSAuf8a77Ujpk47PWLTAVJeHgxE5koW1tqX6xp9uM7c
         b1yw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <c61ca9d0-c514-fb07-c2f2-3629e8898984@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>

On Fri, Apr 14, 2023 at 01:29:25PM -0400, Waiman Long wrote:
> 
> On 4/14/23 12:54, Tejun Heo wrote:
> > On Thu, Apr 13, 2023 at 09:22:19PM -0400, Waiman Long wrote:
> > > I now have a slightly different idea of how to do that. We already have an
> > > internal cpumask for partitioning - subparts_cpus. I am thinking about
> > > exposing it as cpuset.cpus.reserve. The current way of creating
> > > subpartitions will be called automatic reservation and require a direct
> > > parent/child partition relationship. But as soon as a user write anything to
> > > it, it will break automatic reservation and require manual reservation going
> > > forward.
> > > 
> > > In that way, we can keep the old behavior, but also support new use cases. I
> > > am going to work on that.
> > I'm not sure I fully understand the proposed behavior but it does sound more
> > quirky.
> 
> The idea is to use the existing subparts_cpus for cpu reservation instead of
> adding a new cpumask for that purpose. The current way of partition creation
> does cpus reservation (setting subparts_cpus) automatically with the
> constraint that the parent of a partition must be a partition root itself.
> One way to relax this constraint is to allow a new manual reservation mode
> where users can set reserve cpus manually and distribute them down the
> hierarchy before activating a partition to use those cpus.
> 
> Now the question is how to enable this new manual reservation mode. One way
> to do it is to enable it whenever the new cpuset.cpus.reserve file is
> modified. Alternatively, we may enable it by a cgroupfs mount option or a
> boot command line option.

It'd probably be best if we can keep the behavior within cgroupfs if
possible. Would you mind writing up the documentation section describing the
behavior beforehand? I think things would be clearer if we look at it from
the interface documentation side.

Thanks.

-- 
tejun
