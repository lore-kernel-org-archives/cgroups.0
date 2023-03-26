From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: Fix exception handling in
 test_memcg_oom_group_score_events()
Date: Sun, 26 Mar 2023 16:39:00 -0500
Message-ID: <20230326213900.GJ363182@maniforge>
References: <f9303bdc-b1a7-be5e-56c6-dfa8232b8b55@web.de>
 <c383bdca-6f0d-4a75-e788-e1920faa0a62@web.de>
 <fffcd98a-bb73-41cd-8545-0f2c55dd38f9@lucifer.local>
 <5b7921c9-ee5d-c372-b19b-2701bcf33148@web.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5b7921c9-ee5d-c372-b19b-2701bcf33148-S0/GAf8tV78@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Markus Elfring <Markus.Elfring-S0/GAf8tV78@public.gmane.org>
Cc: Lorenzo Stoakes <lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jay Kamat <jgkamat-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cocci-MZpvjPyXg2s@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Mar 26, 2023 at 10:15:31AM +0200, Markus Elfring wrote:

[...]

> >>
> >> Fixes: a987785dcd6c8ae2915460582aebd6481c81eb67 ("Add tests for memory.oom.group")
> >
> > Fixes what in the what now?
> 
> 1. Check repetition (which can be undesirable)
> 
> 2. Can a cg_destroy() call ever work as expected if a cg_create() call failed?

Perhaps next time you can answer your own question by spending 30
seconds actually reading the code you're "fixing":

int cg_destroy(const char *cgroup)
{
        int ret;

retry:
        ret = rmdir(cgroup);
        if (ret && errno == EBUSY) {
                cg_killall(cgroup);
                usleep(100);
                goto retry;
        }

        if (ret && errno == ENOENT) <<< that case is explicitly handled here
                ret = 0;

        return ret;
}
