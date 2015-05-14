From: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible bug - LTP failure for memcg
Date: Thu, 14 May 2015 17:27:49 +0200
Message-ID: <20150514152749.GF12884@rei>
References: <55536DC9.90200@kyup.com>
 <20150514092145.GA6799@dhcp22.suse.cz>
 <20150514103148.GA5066@rei.suse.de>
 <20150514115641.GE6799@dhcp22.suse.cz>
 <20150514120142.GG5066@rei.suse.de>
 <20150514121248.GG6799@dhcp22.suse.cz>
 <20150514123816.GC6993@rei>
 <20150514143039.GI6799@dhcp22.suse.cz>
 <20150514144420.GA12884@rei>
 <20150514144949.GJ6799@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150514144949.GJ6799-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi!
> testcase_29 and testcase_30 are no longer testing anything because
> the kernel allows to use force_empty even for memcgs with active
> tasks since f61c42a7d911 ("memcg: remove tasks/children test from
> mem_cgroup_force_empty()) kernel commit.
> 
> If we really want to test this functionality then just expect the
> success for regular mmap and expect the failure when the charged
> memory is mlocked.

Applied, thanks.

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
