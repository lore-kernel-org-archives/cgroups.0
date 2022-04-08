From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 1/4] memcg: introduce per-memcg reclaim interface
Date: Fri, 8 Apr 2022 13:08:26 -0700
Message-ID: <CAJD7tkbFjbGJ7CnNogpGq5enh_uhP8T5c0U+ku9PfwMoVLf2gg@mail.gmail.com>
References: <20220408045743.1432968-1-yosryahmed@google.com>
 <20220408045743.1432968-2-yosryahmed@google.com> <YlA754XNFAmWQcm6@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <YlBCeadBqbeVvALK@dhcp22.suse.cz> <YlBM/HlPyPUZew5N@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lps+VNBxsxLTQEq6nQohZpJYqrkqH9hvkhZrZvs8ibQ=;
        b=RCf6vfwHloKvazwXoXjT3SbJbG6javpXCWAOqpmzI5xWQaDqYTQcsOMEQ207Cos5B5
         qO9ltnjeXz+TlC6P6gS5antoHVMaIZrCQ11eHYBSz4eTQ/R5GGKOKUyFI3+806vxMnK1
         fbXlyPceUpjETNwwV/acg+2NG+XN7k8bQEJSHpWLS+RnyRLA9cOOAyhj2wlwHqa6fXhX
         5UzERtidt5e1I1tW46oeIC+BAKtd/hL8cz2X59EFfp/FyB0bvhoBiag+huSUtmzW0EGF
         ZloCHuXwEcJaDEAdLae+GRpT74s5Z5tB2VxWhFW/wTLF+JzkDyExAWJEJn5dCTzRM2C4
         T/4g==
In-Reply-To: <YlBM/HlPyPUZew5N@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>, Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, l

On Fri, Apr 8, 2022 at 7:55 AM Dan Schatzberg <schatzberg.dan@gmail.com> wrote:
>
> On Fri, Apr 08, 2022 at 04:11:05PM +0200, Michal Hocko wrote:
> > Regarding "max" as a possible input. I am not really sure to be honest.
> > I can imagine that it could be legit to simply reclaim all the charges
> > (e.g. before removing the memcg) which should be achieveable by
> > reclaiming the reported consumption. Or what exactly should be the
> > semantic?
>
> Yeah, it just allows you to avoid reading memory.current to just
> reclaim everything if you can specify "max" - you're still protected
> by nretries to eventually bail out. Mostly, though I just feel like
> supporting "max" makes memory.reclaim semetric with a lot of the
> cgroup memory control files which tend to support "max".

One possible approach here is to have force_empty behavior when we
write "max" to memory.reclaim. From Google's perspective we don't have
a preference, but it seems to me like logical behavior. We can do this
either by directly calling mem_cgroup_force_empty() or just draining
stock and lrus in memory_reclaim().

This actually brings up another interesting point. Do you think we
should drain lrus if try_to_free_mem_cgroup_pages() fails to reclaim
the request amount? We can do this after the first call or before the
last one. It could introduce more evictable pages for
try_to_free_mem_cgroup_pages() to free.
