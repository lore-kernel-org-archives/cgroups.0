From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC][PATCH 0/7 v2] memcg: prevent failure in pre_destroy()
Date: Sun, 29 Apr 2012 08:03:06 +0200
Message-ID: <20120429060306.GA22553@tiehlicka.suse.cz>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <20120427181642.GG26595@google.com>
 <CABEgKgrir3PBGqm_9FmYsZTiFqsZ=Cdt5iZDu5WcOHPtZuEbFg@mail.gmail.com>
 <20120428161358.GA13010@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120428161358.GA13010-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sat 28-04-12 18:13:58, Michal Hocko wrote:
> On Sat 28-04-12 08:48:18, Hiroyuki Kamezawa wrote:
> > On Sat, Apr 28, 2012 at 3:16 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > Hello,
> > >
> > > On Fri, Apr 27, 2012 at 02:45:30PM +0900, KAMEZAWA Hiroyuki wrote:
> > >> This is a v2 patch for preventing failure in memcg->pre_destroy().
> > >> With this patch, ->pre_destroy() will never return error code and
> > >> users will not see warning at rmdir(). And this work will simplify
> > >> memcg->pre_destroy(), largely.
> > >>
> > >> This patch is based on linux-next + hugetlb memory control patches.
> > >
> > > Ergh... can you please set up a git branch somewhere for review
> > > purposes?
> > >
> > I'm sorry...I can't. (To do that, I need to pass many my company's check.)
> > I'll repost all a week later, hugetlb tree will be seen in memcg-devel or
> > linux-next.
> 
> I can push it to memcg-devel tree if you want.

As a separate branch of course...

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
