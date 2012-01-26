From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memcg: fix compile warning on non-numa systems
Date: Thu, 26 Jan 2012 00:55:21 -0800
Message-ID: <20120126005521.07ac0faf.akpm@linux-foundation.org>
References: <4F13BE05.70505@cn.fujitsu.com>
	<20120116084715.GA1639@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120116084715.GA1639-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hiroyuki KAMEZAWA <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

On Mon, 16 Jan 2012 09:47:15 +0100 Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:

> On Mon 16-01-12 14:04:53, Li Zefan wrote:
> > Fix this warning:
> > 
> >   CC      mm/memcontrol.o
> > mm/memcontrol.c: In function 'memcg_check_events':
> > mm/memcontrol.c:779:22: warning: unused variable 'do_numainfo'
> 
> This has been already posted by Kirill and I didn't like the solution
> (https://lkml.org/lkml/2011/12/27/86). He then reposted with a different
> version (https://lkml.org/lkml/2012/1/6/281).
> The later one looks better but I still think this is not worth
> complicate the code just to get rid of this warning.

This?

--- a/mm/memcontrol.c~a
+++ a/mm/memcontrol.c
@@ -776,7 +776,8 @@ static void memcg_check_events(struct me
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
-		bool do_softlimit, do_numainfo;
+		bool do_softlimit;
+		bool do_numainfo __maybe_unused;
 
 		do_softlimit = mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_SOFTLIMIT);
_
