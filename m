From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 1/4] memcg: introduce per-memcg reclaim interface
Date: Thu, 14 Apr 2022 10:25:29 -0700
Message-ID: <CAJD7tkYJj2O-zaux9BZxJxG+JBjPrwRYKXPAAAh7i9GVE53VGQ@mail.gmail.com>
References: <20220408045743.1432968-1-yosryahmed@google.com>
 <20220408045743.1432968-2-yosryahmed@google.com> <YlA754XNFAmWQcm6@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <YlBCeadBqbeVvALK@dhcp22.suse.cz> <YlBM/HlPyPUZew5N@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <CAJD7tkbFjbGJ7CnNogpGq5enh_uhP8T5c0U+ku9PfwMoVLf2gg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sz07fc6I7lIWKPKMNOVSVRZPVjZ/2q5aP50+7giwSck=;
        b=dF21I7xa+PEEtOju0dwSpmZ52AgeF8q9DD0slppiVuAkzhepRjGULhGl9GSpaBaN9k
         HGkp6aPpOc9KxYswilZx68HsiWuwoTmPMmPrje77QTltrR3lFASV4DzIG9UcRcdjscvl
         ffQJoIJtZdVAFsLtEgdP6aUWUI6OZWXIZjpoHl3BRmAwNH9B7bKriI3kN7Xrrghy+8ok
         w96Q/Nfe2bAgEu0mE0P095/9Fkk+kENEDAlaKx9Spnw61TPbAyCwio9dXAHsqa2FB/20
         SpIpeNvGk1Tj/340dPGN1lPPWwoBdi2stjlFsfs5ae5cBCgS/HibP9ne/pdbI3MJwjXl
         PXkg==
In-Reply-To: <CAJD7tkbFjbGJ7CnNogpGq5enh_uhP8T5c0U+ku9PfwMoVLf2gg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Dan Schatzberg <schatzberg.dan@gmail.com>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel>

On Fri, Apr 8, 2022 at 1:08 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Fri, Apr 8, 2022 at 7:55 AM Dan Schatzberg <schatzberg.dan@gmail.com> wrote:
> >
> > On Fri, Apr 08, 2022 at 04:11:05PM +0200, Michal Hocko wrote:
> > > Regarding "max" as a possible input. I am not really sure to be honest.
> > > I can imagine that it could be legit to simply reclaim all the charges
> > > (e.g. before removing the memcg) which should be achieveable by
> > > reclaiming the reported consumption. Or what exactly should be the
> > > semantic?
> >
> > Yeah, it just allows you to avoid reading memory.current to just
> > reclaim everything if you can specify "max" - you're still protected
> > by nretries to eventually bail out. Mostly, though I just feel like
> > supporting "max" makes memory.reclaim semetric with a lot of the
> > cgroup memory control files which tend to support "max".
>
> One possible approach here is to have force_empty behavior when we
> write "max" to memory.reclaim. From Google's perspective we don't have
> a preference, but it seems to me like logical behavior. We can do this
> either by directly calling mem_cgroup_force_empty() or just draining
> stock and lrus in memory_reclaim().
>
> This actually brings up another interesting point. Do you think we
> should drain lrus if try_to_free_mem_cgroup_pages() fails to reclaim
> the request amount? We can do this after the first call or before the
> last one. It could introduce more evictable pages for
> try_to_free_mem_cgroup_pages() to free.

Hey Michal, any thoughts on this? I am looking for feedback on this
before I send out v4.
